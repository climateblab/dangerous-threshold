# First column year, second column CO2 concentration in ppm.

$blab.parseCO2Data = ->
    data = $blab.resource "CO2_data"
    return null unless data
    years = (parseInt(y) for y, c of data)
    forcing = (c for y, c of data)
    $blab.CO2 = {years, forcing}
