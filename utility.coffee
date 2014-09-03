# Zero vector
zeros = (n) -> (0 for i in [1..n])

# Vector with repeated value
rep = (x, n) -> (x for i in [1..n])

# Last value of vector
end = (v) -> v[-1..][0]

# Mean value of vector
mean = (v) ->
    s = 0
    s += x for x in v
    s/v.length

# Standard deviation of vector
std = (v) ->
    s = 0
    m = mean v
    s += (x-m).pow(2) for x in v
    sqrt(s/v.length)

# Logarithm (base 10) of vector or scalar.
log10 = (v) -> log(v)/log(10)

$blab.util = {zeros, rep, end, mean, std, log10}  # Export