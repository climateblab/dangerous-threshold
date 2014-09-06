# Mann temperatures

fig = figure
    xlabel: "Year"
    ylabel: "Temp (deg C)"

allYears = [850..2100] #;
mann_data = $blab.resource "mann_data" #;
plot allYears, mann_data, fig: fig



