# Volcanic forcing data

fig = figure
    xlabel: "Year"
    ylabel: "Volcanic forcing"

{years, forcing} = $blab.parseVolcanicData()#;
plot years, forcing, fig: fig
