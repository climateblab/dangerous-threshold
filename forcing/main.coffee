# Long-term forcing


curve = (ylabel) ->
    figure
        xlabel: "Year"
        ylabel: ylabel
        height: 120
    

co2ppm = curve "CO2 (ppm)"





co2Forcing = curve "CO2 forcing"
    
    
    
    
    
co2Extrap = curve "CO2 forcing"





co2Stabilize = curve "CO2 forcing"





aeroForcingData = curve "Aerosol forcing data"





aeroForcing = curve "Aerosol forcing"





solarAnom = curve "Solar anomaly"





volcanicForcing = curve "Volcanic forcing"





error = curve "log10(error)"


plotData = ->

    allYears = [850..2100] #;
    
    # Forcing
    spec = {}
    spec.allYears = allYears
    spec.co2_data = $blab.resource "co2_data"
    spec.aerosol_data = $blab.resource "aerosol_data"
    spec.solar_data = $blab.resource "solar_data"
    spec.volcanic_data = $blab.resource "volcanic_data"
    {co2, aerosol, solar, volcanic} = $blab.forcing(spec)

    # CO2
    plot co2.yearsData, co2.ppm, fig: co2ppm
    plot co2.yearsData, co2.forcingData, fig: co2Forcing
    plot allYears, co2.forcingExtrap, fig: co2Extrap
    plot allYears, co2.forcingStabilize, fig: co2Stabilize

    # Aerosol
    plot aerosol.yearsData, aerosol.forcingData, fig: aeroForcingData
    plot allYears, aerosol.forcing, fig: aeroForcing
    
    # Solar
    plot allYears, solar.anom, fig: solarAnom
    
    # Volcanic
    plot allYears, volcanic.forcing, fig: volcanicForcing

    ###
    # Errors compared with <a href="/m/b00gw">Mann results</a>.
    e = log10(abs([
        co2.forcingExtrap - $blab.mann.forcingcotwo
        aerosol.forcing - $blab.mann.aer
        solar.anom - $blab.mann.solar
        volcanic.forcing - $blab.mann.volc
    ]))
    plot allYears, e, fig: error
    ###

plotData()






