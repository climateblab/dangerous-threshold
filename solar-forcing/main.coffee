# Solar forcing

fig = figure
    xlabel: "Year"
    ylabel: "Solar forcing"

{years, forcing} = $blab.parseSolarData()#;
plot years, forcing, fig: fig

