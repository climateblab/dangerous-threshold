# First column year.
# Second column forcing in $W_m^{-2}$.
# Third column  $2\sigma$ uncertainty.

$blab.parseAerosolData = (data) ->
    return null unless data
    col = (c) -> (d[c] for d in data)
    years = col 0
    forcing = col 1 
    uncertainty = col 2
    {years, forcing, uncertainty}

