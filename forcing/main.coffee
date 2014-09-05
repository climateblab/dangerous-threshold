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


allYears = [850..2100] #;

plotData = ->
            
    {co2, aerosol, solar, volcanic} = $blab.forcing()

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

class Forcing
    
    # General forcing class

    constructor: ->
        @yearsData = @data.years
        @extrapYears @yearsData
        @calcForcing()  # Defined in subclass
        
    extrapYears: (years) ->
        # Years for extrapolation
        a0 = allYears[0]
        y0 = years[0]
        startY = if y0>a0 then [a0..y0-1] else []
        startY = [allYears[0]..years[0]-1]
        extrapY = [(end(years)+1)..end(allYears)]
        @nYearsStart = startY.length
        @nYearsExtrap = extrapY.length

class CO2 extends Forcing

    constructor: (@data) ->
        @c0 = 450  # Stabilization threshold; asymptotic CO2 level (ppm)
        super()

    calcForcing: ->
        
        # CO2 ppm data
        @ppm = @data.co2
        
        # CO2 forcing
        @forcingData = @forcing(@ppm)
        fd = @forcingData

        n = 10
        slope = (end(fd)-fd[-n..-n][0])/n
        
        ne = @nYearsExtrap 
        
        @forcingExtrap = fd.concat @linear(end(fd), slope, ne)
        
        co2Stab = @ppm.concat @decay(end(@ppm), ne)
        @forcingStabilize = @forcing co2Stab              
            
    # Linear extrapolation based on trend.
    linear: (x, slope, n) -> x + slope*[1..n]
    
    # CO2 asymptotically approaches threshold. 
    decay: (x, n) ->
        tau = 20  # Decay constant
        #c0 = 450  # Stabilization threshold; asymptotic CO2 level (ppm)
        v = exp(-[1..n]/tau)
        x*v + @c0*(1-v)
        
    forcing: (co2) ->
        co20 = 280.0  # ZZZ base on data?
        
        # Scale up to get co2Equiv ghg forcing from CO2 only.
        # Assume an enhancement of 20% by non-CO2 GHGs.
        co2Equiv = co20 + 1.2*(co2-co20)
            
        # Calculate associated radiative forcing
        # using approx relationship.
        5.35 * log(co2Equiv/co20)

class Aerosol extends Forcing

    
    # Aerosol scenarios:  
    # 1. Mann iaero=0: keep aerosol burden constant at current level.
    # 2. Mann iaero=1: assume exponential decay of aerosol forcing 
    #    during 21st century (ramp down aerosols over next century 
    #    with specified e-folding).
    
    # Default: scenario 2 (iaero=1).
    
    constructor: (@data) ->
        super()
        
    calcForcing: (iaero=1) ->
        @forcingData = @data.forcing
        endFd = end(@forcingData)
        extrap = (x, n) =>
            if iaero is 0 then rep(x, n) else @decay(x, n)
        @forcing = zeros(@nYearsStart)
            .concat(@forcingData)
            .concat(extrap(endFd, @nYearsExtrap))
    
    decay: (x, n) ->
        tau = 60  # Decay constant
        x * exp(-([1..n])/tau)

class Solar extends Forcing

    constructor: (@data) ->
        super()

    calcForcing: ->
        @forcing = @data.forcing
        @anom = @forcing - mean(@forcing)
        
        # Solar scaling.
        # Assume 0.1% Maunder Min-Present change in solar output
        # (Mann's isolar=0).
        # Alternative: 0.25% (Mann's isolar=1)
        @anom = (0.1/0.25)*@anom

        # Use persistence (of decadal mean anomaly)
        # to extend solar forcing.
        # Mann uses last 11 data points.
        @anom = @anom.concat rep(mean(@anom[-11..]) , @nYearsExtrap)

class Volcanic extends Forcing

    # AJSBT07 volcanic forcing
    
    # Not modeled here (options in place of AJSBT07):
    #   Gao et al'08 IVI series (Mann ioption=1)
    #   Crowley '00 volcanic forcing series (Mann ioption=2)
    
    # Volcanic optical depth scaling:
    # Assume 2/3 power law scaling (Mann iscaling=1)
    # Alternative: optical depth scales linearly with loading
    # (Mann iscaling=0)
    
    constructor: (@data) ->
        super()

    calcForcing: ->
        @forcingData = @data.forcing
        fd = @forcingData
        fd[-1..] = [0]  # 1999 value to zero (Mann).
        @forcing = @powerLawScaling fd
        @forcing = @forcing.concat zeros(@nYearsExtrap)
        
    # Power law scaling of Pinto et al (1989)/Hyde and Crowley (2000)
    # forcing = $\Delta F_k (M/M_k)^{2/3}$ where $M_k$ 
    # is optical thickness corresponding
    # to forcing $\Delta F_k = -3.7 W/m^2$ 
    # (originally based on Sato et al, 1993 estimate for Krakatoa)
    # Mann uses 0.6667 for 2/3.
    powerLawScaling: (v) -> -3.7*(v/-3.7).pow(0.6667)


{zeros, rep, end, mean, log10} = $blab.util  # Import

CO2_data = $blab.resource "CO2_data"
aerosol_data = $blab.resource "aerosol_data"
solar_data = $blab.resource "solar_data"
volcanic_data = $blab.resource "volcanic_data"

# Export
$blab.forcing = ->

    co2 = $blab.parseCO2Data($blab.resource "CO2_data")
    aerosol = $blab.parseAerosolData($blab.resource "aerosol_data") 
    solar = $blab.parseSolarData($blab.resource "solar_data")
    volcanic = $blab.parseVolcanicData($blab.resource "volcanic_data")
    
    allYears: allYears
    co2: new CO2 co2
    aerosol: new Aerosol aerosol
    solar: new Solar solar
    volcanic: new Volcanic volcanic

$blab.forcing()

plotData()






