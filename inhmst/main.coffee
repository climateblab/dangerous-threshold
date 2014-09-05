# Instrumental N. Hemispheric Mean Surface Temp
fig = figure
    xlabel: "Year"
    ylabel: "Temp (deg. C)"

inhmst_data = $blab.resource "inhmst_data"#;
{years, temp} = $blab.parseInhmstData(inhmst_data)#;
plot years, temp, fig: fig


