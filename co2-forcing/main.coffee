# CO2 concentration data
fig = figure
    xlabel: "Year"
    ylabel: "CO2 forcing"

{years, forcing} = $blab.parseCO2Data()#;
plot years, forcing, fig: fig


