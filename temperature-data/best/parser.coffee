# First column is year.
# Second column is temperature anomaly in degrees C.
$blab.parseBestData = (data) ->
    return null unless data
    col = (c) -> (d[c] for d in data)
    year = col 0
    tempC = col 1 
    {year, tempC}

