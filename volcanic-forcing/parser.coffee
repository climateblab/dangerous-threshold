# First column year, second column volcanic forcing.

$blab.parseVolcanicData = ->
    data = $blab.resource "volcanic_data"
    return null unless data
    years = (parseInt(y) for y, c of data)
    forcing = (c for y, c of data)
    $blab.volcanic = {years, forcing}
