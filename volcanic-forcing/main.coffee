# Volcanic forcing data
fig = figure
    xlabel: "Year"
    ylabel: "Volcanic forcing"

plotXY = (data) -> #;
    X = (parseInt(x) for x, y of data)
    Y = (y for x, y of data)
    plot X, Y, fig: fig

# Import data.
# Col1=Year, Col2=forcing (units?).
plotXY $blab.resource "volcanicForcing"
