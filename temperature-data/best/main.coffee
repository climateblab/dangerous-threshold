# BEST temperature record

fig = figure
    xlabel: "Year"
    ylabel: "Temp (deg C)"
    
best_data = $blab.resource "best_data"#;
{year, tempC} = $blab.parseBestData(best_data)#;
plot year, tempC, fig: fig
