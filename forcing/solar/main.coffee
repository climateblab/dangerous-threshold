# Solar forcing

fig = figure
    xlabel: "Year"
    ylabel: "Solar forcing"

solar_data = $blab.resource "solar_data"#;
{years, forcing} = $blab.parseSolarData(solar_data)#;
plot years, forcing, fig: fig

