# modified from https://github.com/FluxML/model-zoo/blob/master/vision/mnist/mlp.jl

using Flux, Statistics
using Flux.Data: DataLoader
using Flux: onehotbatch, onecold, logitcrossentropy, throttle, @epochs
using Base.Iterators: repeated
using Parameters: @with_kw
using CUDAapi
using MLDatasets
using Serialization

if has_cuda()		# Check if CUDA is available
  @info "CUDA is on"
  import CuArrays		# If CUDA is available, import CuArrays
  CuArrays.allowscalar(false)
end

@with_kw mutable struct Args3
  η::Float64 = 3e-4       # learning rate
  segment = 0             # 0-9
  batchsize::Int = 1024   # batch size
  epochs::Int = 10        # number of epochs
  device::Function = gpu  # set as gpu, if gpu available
  throttle::Int = 1		    # Throttle timeout
end

function getdata(args)
  # Loading Dataset
  xtrain_, ytrain_ = MLDatasets.MNIST.traindata(Float32)
  xtest, ytest = MLDatasets.MNIST.testdata(Float32)

  # Phanny-style segmentation
  segment_size = 6_000
  segment_start = args.segment * segment_size
  segment_end = segment_start + segment_size

  static_shuffle = Serialization.deserialize("shuffled_train_idxs.dat")

  xtrain, ytrain = zeros(Float32, (28, 28, 54_000)), zeros(Float32, 54_000)
  i = 1
  offset = 0
  for i=1:54_000
    if i == segment_start
      offset = segment_size
    end

    xtrain[:,:,i] = xtrain_[:,:,static_shuffle[i + offset]]
    ytrain[i] = ytrain_[static_shuffle[i + offset]]
  end

  # Reshape Data for flatten the each image into linear array
  xtrain = Flux.flatten(xtrain)
  xtest = Flux.flatten(xtest)

  # One-hot-encode the labels
  ytrain, ytest = onehotbatch(ytrain, 0:9), onehotbatch(ytest, 0:9)

  # Batching
  train_data = DataLoader(xtrain, ytrain, batchsize=args.batchsize, shuffle=true)
  test_data = DataLoader(xtest, ytest, batchsize=args.batchsize)

  return train_data, test_data
end

function build_model(; imgsize=(28,28,1), nclasses=10)
  return Chain(
 	  Dense(prod(imgsize), 32, relu),
    Dense(32, nclasses),
    softmax)
end

function loss_all(dataloader, model)
  l = 0f0
  for (x,y) in dataloader
    l += logitcrossentropy(model(x), y)
  end
  l/length(dataloader)
end

function accuracy(data_loader, model)
  acc = 0
  for (x,y) in data_loader
    acc += sum(onecold(cpu(model(x))) .== onecold(cpu(y)))*1 / size(x,2)
  end
  acc/length(data_loader)
end

function train(args)
  # Load Data
  train_data,test_data = getdata(args)

  # Construct model
  m = build_model()
  train_data = args.device.(train_data)
  test_data = args.device.(train_data)
  m = args.device(m)
  loss(x,y) = logitcrossentropy(m(x), y)

  ## Training
  # evalcb = () -> @show(loss_all(train_data, m))
  evalcb = throttle(() -> @show(loss_all(train_data, m)), args.throttle)
  opt = ADAM(args.η)

  @epochs args.epochs Flux.train!(loss, params(m), train_data, opt, cb = evalcb)
  @show accuracy(train_data, m)
  @show accuracy(test_data, m)

  m
end

function prepare_results(models)
  args = Args3()

  _,test_data = getdata(args)

  true_pos  = [[], [], [], [], [], [], [], [], [], []]
  false_pos = [[], [], [], [], [], [], [], [], [], []]

  for (x, y) in test_data
    res = zeros(size(y))
    for m in models
      res .+= m(x)
    end

    colded = onecold(y)
    for i=1:size(res, 2)
      (score, idx) = findmax(res[:,i])
      if idx == colded[i]
        push!(true_pos[idx], score)
      else
        push!(false_pos[idx], score)
      end
    end
  end

  return true_pos, false_pos
end

function train_models(; kws...)
  # Initializing Model parameters
  args = Args3(; kws...)

  models = []
  for i=0:9
    args.segment = i
    push!(models, train(args))
  end

  println("Done training!")

  true_pos, false_pos = prepare_results(models)

  models, true_pos, false_pos
end

cd(@__DIR__)
models, true_pos, false_pos = train_models()

Serialization.serialize("models.dat", models)
Serialization.serialize("true_pos.dat", true_pos)
Serialization.serialize("false_pos.dat", false_pos)
