# First column year
# Second column temperature (deg. C).
$blab.parseInhmstData = (data) ->
    return null unless data
    years = (parseInt(y) for y, c of data)
    temp = (c for y, c of data)
    {years, temp}
