using Serialization

get(file) = Serialization.deserialize(file)

test1_pos = get("true_pos.dat")
test1_neg = get("false_pos.dat")
test2_pos = get("test_true_pos.dat")
test2_neg = get("test_false_pos.dat")

function percent_greater_than(x, pos, neg)
  pos_len = length(filter(e -> e > x, pos)) + 1e-30 # prevent divide by 0
  neg_len = length(filter(e -> e > x, neg))
  return pos_len / (pos_len + neg_len)
end

function kl(pos1, neg1, pos2, neg2)
  sum = 0
  for i in 1:10
    for _score in 1:100
      score = _score / 10
      p = percent_greater_than(score, pos1[i], neg1[i])
      q = percent_greater_than(score, pos2[i], neg2[i]) + 1e-30 # prevent divide by 0

      kl = p * log(p/q)
      sum += kl
    end
  end
  return sum
end

function ks(pos1, neg1, pos2, neg2)
  ks_result = []
  for i in 1:10
    ks = 0
    for _score in 1:100
      score = _score / 10
      p = percent_greater_than(score, pos1[i], neg1[i])
      q = percent_greater_than(score, pos2[i], neg2[i])
      ks = max(abs(p - q), ks)
    end
    push!(ks_result, ks)
  end
  return ks_result
end

function main()
  dxy = kl(test1_pos, test1_neg, test2_pos, test2_neg)
  @show dxy # -4.141558947348085
  dyx = kl(test2_pos, test2_neg, test1_pos, test1_neg)
  @show dyx # 4.315494163156585
  ks_values = ks(test1_pos, test1_neg, test2_pos, test2_neg)
  @show ks_values # [0.006854177124148708, 0.0378050482320722, 0.014692124412983176, 0.012686104218362249, 0.018075259418633305, 0.021458405847546103, 0.018821473623260254, 0.015511943701060571, 0.01123827153453727, 0.01750482967210676]
end

main()
