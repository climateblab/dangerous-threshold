# Aerosol forcing

figForcing = figure
    xlabel: "Year"
    ylabel: "Forcing"




figUncertainty = figure
    xlabel: "Year"
    ylabel: "Uncertainty"


data=$blab.resources.getJSON "data.json" #;

col = (c) -> (d[c] for d in data) #;
years = col 0 #; year
forcing = col 1 #; forcing in $W_m^{-2}$
uncertainty = col 2 #; $2\sigma$ uncertainty

plot years, forcing, fig: figForcing
plot years, uncertainty, fig: figUncertainty



