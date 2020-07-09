using DataFrames
using Gadfly
using Serialization

import Cairo, Fontconfig

true_pos = Serialization.deserialize("true_pos.dat")
false_pos = Serialization.deserialize("false_pos.dat")

plots = Array{Plot,1}()

for i=1:10
  values = DataFrames.DataFrame(score = [], type = [])
  for e = true_pos[i]
    push!(values, [e, "true positive"])
  end
  for e = false_pos[i]
    push!(values, [e, "false positive"])
  end

  push!(plots, plot(values, Guide.title("Digit '$(i-1)'"), x=:score, color=:type,
                    Geom.histogram(maxbincount=50),
                    Scale.x_continuous(minvalue=0, maxvalue=10.0)))
end

set_default_plot_size(6inch, 40inch)
vstack(plots) |> PDF("true-false_positives.pdf")
