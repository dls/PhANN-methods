using Serialization

get(file) = Serialization.deserialize(file)

test1_pos = get("true_pos.dat")
test1_neg = get("false_pos.dat")
test2_pos = get("test_true_pos.dat")
test2_neg = get("test_false_pos.dat")

function percent_greater_than(x, pos, neg)
  pos_len = length(filter(e -> e > x, pos))
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
      if !isnan(kl)
        sum += kl
      end
    end
  end
  return sum
end

function main()
  dxy = kl(test1_pos, test1_neg, test2_pos, test2_neg)
  @show dxy # -4.141558947348085
  dyx = kl(test2_pos, test2_neg, test1_pos, test1_neg)
  @show dyx # 4.315494163156585
end

main()
