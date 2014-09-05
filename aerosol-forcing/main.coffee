# Aerosol forcing

figForcing = figure
    xlabel: "Year"
    ylabel: "Forcing"





figUncertainty = figure
    xlabel: "Year"
    ylabel: "Uncertainty"

aerosol_data = $blab.resource "aerosol_data"#;
{years, forcing, uncertainty} = $blab.parseAerosolData(aerosol_data)#;
plot years, forcing, fig: figForcing
plot years, uncertainty, fig: figUncertainty



