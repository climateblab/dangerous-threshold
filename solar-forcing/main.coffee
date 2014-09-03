# CO2 concentration data
fig = figure
    xlabel: "Year"
    ylabel: "Solar forcing"

plotXY = (data) -> #;
    X = (parseInt(x) for x, y of data)
    Y = (y for x, y of data)
    plot X, Y, fig: fig

# Import data.
# Col1=Year, Col2=solar constant ($W_m^{-2}$).
data = $blab.resources.getJSON "data.json" #;

plotXY data
