# Volcanic forcing data

fig = figure
    xlabel: "Year"
    ylabel: "Volcanic forcing"

volcanic_data = $blab.resource "volcanic_data"#;
{years, forcing} = $blab.parseVolcanicData(volcanic_data)#;
plot years, forcing, fig: fig

