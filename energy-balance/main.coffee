stFig = (params) ->
    figure
        xlabel: "Year"
        ylabel: params.ylabel
        height: params.height ? 300
        grid: {color: "white", backgroundColor: "black"}
        legend: {position: "nw"}
        series: {lines: {lineWidth: 2}, shadowSize: 0}
            
            
surfTempFig = stFig
        ylabel: "Surface Temperature"













surfTempStabilizeFig = stFig
        ylabel: "Surface Temperature (Stabilized)"













nhModelFig = stFig
    ylabel: "NH Model"













nhModelStabilizeFig = stFig
    ylabel: "NH Model"













nhModelCurrent = stFig
    ylabel: "NH Model"













nhModelStabilizeCurrent = stFig
    ylabel: "NH Model"







curve = (ylabel) -> #;
    figure
        xlabel: "Year"
        ylabel: ylabel
        height: 120

hadCRUFig = curve "hadCRU"





error = curve "log10(error)"





plotData = ->
            
    model = new $blab.ClimateModel


    # Specify equilibrium 2XCO2 sensitivity for EBM.
    # Standard value is mid-range IPCC sensitivity of 3C/2xCO2.    
    sens = [4.5, 3.0, 2.5, 2.0, 1.5]
    colors = ["#f83836", "#fc8037", "#ffce46", "#fdef51", "#fde6af"]
    labels = ["4.5", "3.0", "2.5", "2.0", "1.5"]  
    # ZZZ auto conv to string?
    stPlot = (years, st, fig) ->
        series = ({
                data: [years, st[i]].T
                label: labels[i]
                color: colors[i]
            } for s, i in sens)
        plotSeries series, fig: fig
        
    allYears = model.allYears
    
    # Surface temperature - projections (mean unaligned with instrument record)
    st = (model.surfaceTemperature(s) for s in sens)
    surfTemp = (s.unaligned for s in st)
    stPlot allYears, surfTemp, surfTempFig
    
    # Surface temperature - stabilized (mean unaligned with instrument record)
    stStabilize = (model.surfaceTemperature(s, "forcingStabilize") for s in sens)
    surfTempStabilize = (s.unaligned for s in stStabilize)
    stPlot allYears, surfTempStabilize, surfTempStabilizeFig
        
    # Compare simulated and observed NH series over historical era.
    nhModel = (s.aligned for s in st)
    nhModelStabilize = (s.aligned for s in stStabilize)
    stPlot allYears, nhModel, nhModelFig
    stPlot allYears, nhModelStabilize, nhModelStabilizeFig
    
    # Recent and future years
    n = 120  # Number of years to plot
    nh = (m[-n..] for m in nhModel)
    stPlot allYears[-n..], nh, nhModelCurrent
    nhS = (m[-n..] for m in nhModelStabilize)
    stPlot allYears[-n..], nhS, nhModelStabilizeCurrent
    
    # Historical data
    yearHadCRU = model.yearHadCRU
    nhHadCRU = model.nhHadCRU
    plot yearHadCRU, nhHadCRU, fig: hadCRUFig
    
    # Errors compared with Mann results (for sens=3.0).
    surftemp1 = $blab.resource "mann_data" #;
    #e = log10(abs([surfTemp[1] - $blab.mann.surftemp1]))
    e = log10(abs([surfTemp[1] - surftemp1]))
    plot allYears, e, fig: error


{mean, std, log10} = $blab.math
plotData()


