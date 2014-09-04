# First column year
# Second column solar constant in $W_m^{-2}$.

$blab.parseSolarData = ->
    data = $blab.resource "solar_data"
    return null unless data
    years = (parseInt(y) for y, c of data)
    forcing = (c for y, c of data)
    $blab.solar = {years, forcing}
