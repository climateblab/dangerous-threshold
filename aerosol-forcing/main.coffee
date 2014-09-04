# Aerosol forcing

figForcing = figure
    xlabel: "Year"
    ylabel: "Forcing"





figUncertainty = figure
    xlabel: "Year"
    ylabel: "Uncertainty"

{years, forcing, uncertainty} = $blab.parseAerosolData()#;
plot years, forcing, fig: figForcing
plot years, uncertainty, fig: figUncertainty



