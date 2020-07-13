# Experiment 3

We hypothesized (quite understandably I might add), that perhaps data
dredging was happening in [experiment 2](results3.md) -- how would the
results change if we used never before seen data when calculating
score-accuracy-estimators?

[Code](experiment3.jl)

## Overall results

Quite similar, though more trustworthy given the dredging removal.

## What kind of performance does a pure greater than sample have?

`Checked greater than, found 0.087059 mean squared error, 0.105067 mean error`

## What kind of performance does the use of all data in a category have?

`Checked use of all data, found 0.087544 mean squared error, 0.180311 mean error`

## How does error change as we increase min_n?

| Minimum sample size | Mean Squared Error | Mean Error |
|---------------------|:------------------:|-----------:|
| 1                   | 0.065311           |   0.119835 |
| 2                   | 0.06519            |   0.119798 |
| 3                   | 0.064811           |   0.119847 |
| 4                   | 0.064538           |   0.120019 |
| 5                   | 0.063832           |   0.119737 |
| 6                   | 0.063738           |   0.119937 |
| 7                   | 0.063285           |   0.119725 |
| 8                   | 0.062901           |   0.119697 |
| 9                   | 0.062828           |   0.119717 |
| 10                  | 0.062583           |    0.11972 |
| 11                  | 0.062394           |   0.119697 |
| 12                  | 0.062098           |   0.119583 |
| 13                  | 0.061827           |    0.11957 |
| 14                  | 0.061817           |   0.119822 |
| 15                  | 0.061757           |   0.119861 |
| 16                  | 0.061604           |   0.119891 |
| 17                  | 0.061411           |   0.119884 |
| 18                  | 0.061182           |   0.119833 |
| 19                  | 0.061049           |   0.119823 |
| 20                  | 0.060818           |   0.119821 |
| 21                  | 0.060906           |   0.120044 |
| 22                  | 0.060788           |   0.119999 |
| 23                  | 0.060752           |   0.120064 |
| 24                  | 0.060915           |   0.120243 |
| 25                  | 0.060752           |   0.120117 |
| 26                  | 0.06075            |   0.120213 |
| 27                  | 0.06067            |   0.120247 |
| 28                  | 0.0605             |   0.120188 |
| 29                  | 0.060426           |   0.120168 |
| 30                  | 0.060375           |   0.120147 |
| 31                  | 0.060333           |   0.120226 |
| 32                  | 0.060203           |   0.120137 |
| 33                  | 0.060132           |   0.120032 |
| 34                  | 0.06               |   0.119923 |
| 35                  | 0.060004           |   0.119956 |
| 36                  | 0.059985           |   0.119989 |
| 37                  | 0.059865           |    0.11986 |
| 38                  | 0.059851           |   0.119825 |
| 39                  | 0.059847           |   0.119918 |
| 40                  | 0.059866           |   0.119995 |
| 41                  | 0.05983            |   0.120012 |
| 42                  | 0.059911           |     0.1201 |
| 43                  | 0.059876           |   0.120096 |
| 44                  | 0.059902           |   0.120128 |
| 45                  | 0.05989            |   0.120135 |
| 46                  | 0.059821           |    0.12006 |
| 47                  | 0.059771           |   0.119992 |
| 48                  | 0.059781           |   0.120009 |
| 49                  | 0.059779           |   0.120007 |
| 50                  | 0.059796           |   0.120027 |
