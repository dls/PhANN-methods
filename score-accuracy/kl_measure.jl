using Serialization

get(file) = map(sort!, Serialization.deserialize(file))

test1_pos = get("true_pos.dat")
test1_neg = get("false_pos.dat")
test2_pos = get("test_true_pos.dat")
test2_neg = get("test_false_pos.dat")

function gt_pct(x, pos, neg)
  pos_len = length(filter(e -> e > x, pos))
  neg_len = length(filter(e -> e > x, neg))
  return pos_len / (pos_len + neg_len)
end

sample_test1(x, i) = gt_pct(x, test1_pos[i], test1_neg[i])
sample_test2(x, i) = gt_pct(x, test2_pos[i], test2_neg[i])

function kl_i(x, i)
  p = sample_test1(x, i)
  q = sample_test2(x, i) + 1e-30
  return p * log(p/q)
end

function main()
  kl = 0
  for i in 1:10
    for _x in 1:100
      kl += kl_i(_x/100, i)
    end
  end

  @show kl # -6.6149230736255715
end

main()
