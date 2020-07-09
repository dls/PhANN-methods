using Serialization

true_pos_ = Serialization.deserialize("true_pos.dat")
false_pos_ = Serialization.deserialize("false_pos.dat")

function find_delta()
  true_pos = true_pos_
  false_pos = false_pos_

  function select_bounded(score, cat, lower_bound, upper_bound)
    tsum, fsum = 0, 0

    for e = true_pos[cat]
      if lower_bound <= e <= upper_bound
        tsum += 1
      end
    end

    for e = false_pos[cat]
      if lower_bound <= e <= upper_bound
        fsum += 1
      end
    end

    return (tsum, fsum)
  end

  function check(score, delta, cat, min_n)
    while true
      tsum, fsum = select_bounded(score, cat, score - delta, score + delta)
      if (tsum + fsum) >= min_n
        return (tsum + 0.1) / (tsum + fsum + 0.2) # weak prior at 50% accuracy
        # return tsum / (tsum + fsum)
      else
        if delta > 10 # ie we don't have enough sample values ...
          return (tsum + 0.1) / (tsum + fsum + 0.2)
        else
          delta *= 1.05
        end
      end
    end
  end

  function check_all(delta, min_n)
    err, serr = 0.0, 0.0
    total = 0

    for cat = 1:10
      for e = true_pos[cat]
        total += 1
        val = check(e, delta, cat, min_n)
        err += 1 - val
        serr += (1 - val)^2
      end

      for e = false_pos[cat]
        total += 1
        val = check(e, delta, cat, min_n)
        err += val
        serr += val^2
      end
    end

    return (err/total, serr/total)
  end

  function check_gt()
    err, serr = 0.0, 0.0
    total = 0

    function select_gt(score, cat)
      tsum, fsum = select_bounded(score, cat, score, 11.0)
      (tsum + 0.1) / (tsum + fsum + 0.2)
    end

    for cat = 1:10
      for e = true_pos[cat]
        total += 1
        val = select_gt(e, cat)
        err += 1 - val
        serr += (1 - val)^2
      end

      for e = false_pos[cat]
        total += 1
        val = select_gt(e, cat)
        err += val
        serr += val^2
      end
    end

    return (err/total, serr/total)
  end

  display(x) = round(x * 1_000_000.0) / 1_000_000.0

  function pretty_check(delta, min_n)
    err, serr = check_all(delta, min_n)
    # err, serr = check_gt()
    # push!(sampled_values, [delta, min_n, serr, err])
    println("Checked $delta $min_n, found $(display(serr)) mse, $(display(err)) me")
  end

  function pretty_gt()
    err, serr = check_gt()
    println("Checked greater than, found $(display(serr)) mse, $(display(err)) me")
  end

  for i=1:50
    pretty_check(0.1, i)
  end

  pretty_gt()
end

find_delta()
