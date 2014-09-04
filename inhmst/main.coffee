# Instrumental N. Hemispheric Mean Surface Temp
fig = figure
    xlabel: "Year"
    ylabel: "Temp (deg. C)"

{years, temp} = $blab.parseInhmstData()#;
plot years, temp, fig: fig


