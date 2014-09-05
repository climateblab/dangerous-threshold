# First column year, second column CO2 concentration in ppm.
$blab.parseCO2Data = (data) ->
    return null unless data
    years = (parseInt(y) for y, c of data)
    co2 = (c for y, c of data)
    {years, co2}
