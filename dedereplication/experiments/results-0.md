# Experiment 0 / Setup

An autoencoder setup was adapted from the Julia model zoo. [Code](../autoencoder.jl)

## How many hidden values?

64 hiddens, 0.007 error:
![Images sampled from the 64 hidden neuron model](images/sample_2layer_ae-64_0.007.png)

32 hiddens, 0.013 error:
![Images sampled from the 32 hidden neuron model](images/sample_2layer_ae-32_0.013.png)

16 hiddens, 0.022 error:
![Images sampled from the 16 hidden neuron model](images/sample_2layer_ae-16_0.022.png)

8 hiddens, 0.034 error:
![Images sampled from the 8 hidden neuron model](images/sample_2layer_ae-8_0.034.png)

4 hiddens, 0.047 error:
![Images sampled from the 4 hidden neuron model](images/sample_2layer_ae-4_0.047.png)

2 hiddens, 0.056 error:
![Images sampled from the 2 hidden neuron model](images/sample_2layer_ae-2_0.056.png)


... which makes 32 seem reasonable?
