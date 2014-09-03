# CO2 concentration data
fig = figure
    xlabel: "Year"
    ylabel: "CO2 (ppm)"

plotXY = (data) -> #;
    X = (parseInt(x) for x, y of data)
    Y = (y for x, y of data)
    plot X, Y, fig: fig

plotXY $blab.resources.getJSON "data.json"
