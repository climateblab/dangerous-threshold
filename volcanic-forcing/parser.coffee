# First column year, second column volcanic forcing.
$blab.parseVolcanicData = (data) ->
    return null unless data
    years = (parseInt(y) for y, c of data)
    forcing = (c for y, c of data)
    {years, forcing}
