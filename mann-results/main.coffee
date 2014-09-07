# Mann forcing

figAer = figure
    xlabel: "Year"
    ylabel: "AER"





figVolc = figure
    xlabel: "Year"
    ylabel: "Volcanic"





figSolar = figure
    xlabel: "Year"
    ylabel: "Solar"





figCo2 = figure
    xlabel: "Year"
    ylabel: "CO2"

m = $blab.resource "mann_results"#;
years = [850..2100] #;
plot years, m.aer, fig: figAer
plot years, m.volc, fig: figVolc
plot years, m.solar, fig: figSolar
plot years, m.forcingcotwo, fig: figCo2




