using DataFrames
using Gadfly
using Serialization

import Cairo, Fontconfig

true_pos_ = Serialization.deserialize("true_pos.dat")
false_pos_ = Serialization.deserialize("false_pos.dat")

sampled_values = DataFrames.DataFrame(delta = [], min_n = [], mse = [], me = [])

function find_delta()
  true_pos = true_pos_
  false_pos = false_pos_

  function check_plus_minus(score, delta, cat)
    tsum, fsum = 0, 0

    for e = true_pos[cat]
      if abs(score - e) <= delta
        tsum += 1
      end
    end

    for e = false_pos[cat]
      if abs(score - e) <= delta
        fsum += 1
      end
    end

    return (tsum, fsum)
  end

  function check_minus(score, delta, cat)
    tsum, fsum = 0, 0

    for e = true_pos[cat]
      if e < score && abs(score - e) <= delta
        tsum += 1
      end
    end

    for e = false_pos[cat]
      if e < score && abs(score - e) <= delta
        fsum += 1
      end
    end

    return (tsum, fsum)
  end

  function check(score, delta, cat, min_n)
    while true
      tsum, fsum = check_minus(score, delta, cat)
      if tsum + fsum >= min_n
        return tsum / (tsum + fsum)
      else
        delta *= 1.05
        if delta > 10
          return tsum / (tsum + fsum + 1)
          # return -1
        end
      end
    end
  end

  function check_all(delta, min_n)
    serr = 0.0
    err = 0.0
    total = 0
    for cat = 1:10
      for e = true_pos[cat]
        val = check(e, delta, cat, min_n)
        if val == -1
          @show "ERRORED", (e, delta, cat, min_n)
          continue
        else
          total += 1
          err += 1 - val
          serr += (1 - val)^2
        end
      end

      for e = false_pos[cat]
        val = check(e, delta, cat, min_n)
        if val == -1
          @show "ERRORED", (e, delta, cat, min_n)
          continue
        else
          total += 1
          err += val
          serr += val^2
        end
      end
    end

    return (serr, err, total)
  end

  shorten(x) = round(x * 1_000_000.0) / 1_000_000.0

  function pretty_check(delta, min_n)
    (serr, err, total) = check_all(delta, min_n)
    push!(sampled_values, [delta, min_n, serr/total, err/total])
    println("Checked $delta $min_n, found $(shorten(serr/total)) mse, $(shorten(err/total)) me")
  end

  for i=1:1000
    delta = rand(1:1_000_000)/1_000_00.0
    min_n = rand(1:100)
    pretty_check(delta, min_n)
  end
end

function figure()
  set_default_plot_size(6inch, 6inch)
  vstack([plot(sampled_values, Theme(highlight_width=0mm), x=:delta, y=:min_n, color=:mse, Geom.point),
          plot(sampled_values, Theme(highlight_width=0mm), x=:delta, y=:min_n, color=:me,  Geom.point)]) |> PDF("minus-binning.pdf")
end

find_delta()
figure()
