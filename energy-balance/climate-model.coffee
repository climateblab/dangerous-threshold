class ClimateModel

    # TODO: safer indexing, based on years lookup.
    # TODO: methods to set forcing params
    # TODO: perhaps set co2forcing via method?

    allYears: [850..2100]

    constructor: ->
        # Forcing data and extrapolations (imported).
        # TODO: check allYears consistent
        # TODO: link to forcings blab.

        spec = {}
        spec.allYears = [850..2100] #allYears
        spec.co2_data = $blab.resource "co2_data"
        spec.aerosol_data = $blab.resource "aerosol_data"
        spec.solar_data = $blab.resource "solar_data"
        spec.volcanic_data = $blab.resource "volcanic_data"
        {@co2, @aerosol, @solar, @volcanic} = $blab.forcing(spec)
        #@aerosol.calcForcing 0  # Hold constant
        #@co2.c0 = 450
        #@co2.calcForcing()
        {@yearHadCRU, @nhHadCRU} = $blab.temperatureRecord()
        
    surfaceTemperature: (sens, co2ForcingType="forcingExtrap") ->
        # sens: equilibrium 2XCO2 sensitivity for EBM.
        # Standard value is mid-range IPCC sensitivity of 3C/2xCO2.   
        # co2ForcingType: "forcingExtrap" or "forcingStabilize"
        st = EBM(
            @volcanic.forcing,
            @solar.anom,
            @aerosol.forcing,
            @co2[co2ForcingType],
            sens)
        # Align model simulations to have same mean as instrumental record
        # over overlap period of 1850-2012.
        aligned = st - mean(st[1000..1162]) + mean(@nhHadCRU[0..162])
        unaligned = st
        {aligned, unaligned}
        
EBM = (volc, solar, aer, forcingcotwo, sens) ->
    
    S0 = 1370  # solar constant in $W/m^2$ 
    cp = 2.08e+08  # $J/m^2$ dec C
    dt0 = 0.1  # years
    dt = dt0*365.25*24*3600 # seconds
    
    A0 = 0.3  # Default albedo
    
    # Use linearized form of the energy balance
    # $C_p dT/dt = (1-A_0)*S/4 - \sigma T^4$
    
    # Choose graybody parameter approx:
    # $\sigma T^4 = A + B (T-T_0)$ where $T_0=0 C$.
    # default Gray Body Parameters
    
    # $A = 221.3 W/m^2$
    # Constant term for realistic global mean temperature.
    A = 221.3
    
    # $B = 1.236 W/m^2 K$
    # Corresponds to mid-range IPCC sensitivity of 3C for 2xCO2 forcing
    B = 5.35*log(2)/sens
    
    # Relaxation time constant
    taus = cp/B  # seconds
    tau = taus/(365.25*24*3600)  # years
    
    # Total forcing 
    longwave = forcingcotwo
    shortwave = aer + volc + (1-A0)*(S0+solar)/4.0
    
    # Impose combined shortwave + longwave forcing 
    # as an effective increase in downward shortwave radiation.
    forcingrad = shortwave + longwave
    forcingtot = forcingrad
    
    # Length and resolution of time integration
    ntot = forcingrad.length
    nspace = round(1/dt0)
    ntot0 = ntot * nspace
    
    # Define initial temperature as equilibrium
    # for initial instantaneous forcing
    surftemp0 = (forcingrad[0]-A)/B
    
    # Interpolate annual forcing to appropriate temporal resolution.
    # Unused:
    # for i in [1..ntot0]
    #   yearinterp = 850.0 + [1..ntot0]*dt0
    istart = floor([1..ntot0-1]*dt0)
    istart.push end(istart) # repeat last value
    forcinterp = (forcingtot[i] for i in istart)
        
    # Integrate the EBM forward (sub-annual time step)
    # form annually averaged EBM NH series
    T = surftemp0
    s = 0
    surftemp = []
    for i in [0..ntot0-1]
        T += (1/cp)*(forcinterp[i]-A-B*T)*dt
        s += T
        if (i+1) % nspace is 0
            surftemp.push s/nspace
            s = 0
    
    surftemp

        
{zeros, rep, end} = $blab.array
{mean, std, log10} = $blab.math


$blab.ClimateModel = ClimateModel  # Export

