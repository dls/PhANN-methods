using Serialization
using MAT

get(file) = map(sort!, Serialization.deserialize(file))

test1_pos = get("true_pos.dat")
test1_neg = get("false_pos.dat")
test2_pos = get("test_true_pos.dat")
test2_neg = get("test_false_pos.dat")

matwrite("score_dists.mat", Dict("test1_pos" => test1_pos,
                                 "test1_neg" => test1_neg,
                                 "test2_pos" => test2_pos,
                                 "test2_neg" => test2_neg))
