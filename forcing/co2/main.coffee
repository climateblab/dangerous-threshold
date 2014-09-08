# CO2 concentration data
fig = figure
    xlabel: "Year"
    ylabel: "CO2 forcing"

CO2_data = $blab.resource "CO2_data" #;
{years, co2} = $blab.parseCO2Data(CO2_data)#;
plot years, co2, fig: fig


