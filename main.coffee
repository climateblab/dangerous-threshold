# Simulation settings
settings =
    startYear: 1850
    tempChangeRange: [-2, 5]
    initialECS: 2.0  # Animates to 2.5 then 3.0 after this initial value
    dangerTemp: 2.0

# Imported utility functions
{zeros, rep, end} = $blab.array
{mean, std, log10} = $blab.math

# Climate model
model = {}
iaero = 1
initializeModel = ->
    model = new $blab.ClimateModel
    model.aerosol.calcForcing iaero  #;

# Simulate model for specified ECS.
simulate = (sens) ->
    st = (s, type="forcingExtrap") ->
        model.surfaceTemperature(s, type).aligned
    surfTemp: st(sens)
    surfTempStabilize: st(sens, "forcingStabilize")

# Plot results
plotResults = ->
    
    #return unless browserOk()
    
    initializeModel()

    graph = new EBMGraph

    sens = settings.initialECS
    dangerTemp = settings.dangerTemp
    
    allYears = model.allYears
    yearHadCRU = model.yearHadCRU
    nhHadCRU = model.nhHadCRU
    
    spec = {
        allYears
        sens
        dangerTemp
        yearHadCRU
        nhHadCRU
        # Simulation results in plotCurves
    }
    
    dangerYear = (year, temp) ->
        for t, idx in temp
            return year[idx] if t>dangerTemp
        null
    
    plotCurves = (s) ->
        sens = s
        {surfTemp, surfTempStabilize} = simulate(sens)
        spec.surfTemp = surfTemp
        spec.surfTempStabilize = surfTempStabilize
        spec.dangerYearTemp = dangerYear allYears, surfTemp
        spec.dangerYearTempStabilize = dangerYear allYears, surfTempStabilize
        graph.plot(spec)
    
    $("#loading").remove()
    plotCurves(sens)
    graph.setBrush [settings.startYear, end(allYears)]
    $blab.setBrush = (x1, x2) -> graph.setBrush [x1, x2]
    
    slider = (sel, params) ->
        $(sel).slider("destroy") if $(sel).children().length
        $(sel).slider(params)
        
    slider "#sensSlider",
        orientation: "vertical"
        range: "min"
        min: 1.5
        max: 4.5
        step: 0.1
        value: sens
        slide: (e, ui) -> setSensText ui.value
        change: (e, ui) ->
            v = ui.value
            setSensText v
            plotCurves v
    setSens = (s) -> $("#sensSlider").slider("value", s)
    setSensText = (v) -> $("#sensText").html "ECS = "+v
    setSensText sens
    
    slider "#co2Slider",
        orientation: "vertical"
        range: "min"
        min: 350
        max: 500
        step: 1
        value: model.co2.c0
        slide: (e, ui) -> setCo2Text ui.value
        change: (e, ui) ->
            model.co2.c0 = parseFloat(ui.value)
            model.co2.calcForcing()
            plotCurves(sens)
    setCo2Text = (v) -> $("#co2Text").html "CO<sub>2</sub> = #{v}ppm"
    setCo2Text model.co2.c0

    aerosol = $ "<input>",
        type: "checkbox"
        change: (e) ->
            model.aerosol.calcForcing(if e.target.checked then 1 else 0)
            plotCurves(sens)
    aerosol.attr "checked", "checked" if iaero is 1
    $("#aerosol").empty()
    $("#aerosol").append(aerosol).append " Aerosols drop"
    
    setTimeout (-> setSens 2.5), 4000
    setTimeout (-> setSens 3.0), 6000


# Zoomable graph
class EBMGraph

    colors:
        historical: "white"
        projection: "#fc8037"
        stabilized: "#fde6af"
        danger: "red"
    
    constructor: ->
        
        allYears = model.allYears
        @firstYear = allYears[0]
        @lastYear = end(allYears)
        [@minTemp, @maxTemp]= settings.tempChangeRange
        
        @graph = new $blab.GraphZoom
            id: "ebm"
            xf: (d) -> d.year
            yf: (d) -> d.temp
            limits: [
                {year: @firstYear, temp: @minTemp}
                {year: @lastYear, temp: @maxTemp}
            ]
            ylabel: "Surface Temperature Change (deg C)"
            
    plot: (@spec) ->
        
        historical =
            data: @series @spec.yearHadCRU, @spec.nhHadCRU
            label: "Historical data"
            color: @colors.historical
            width: 1.5
            
        projection =
            data: @series @spec.allYears, @spec.surfTemp
            label: "Projection"
            color: @colors.projection
            width: 4
        
        stabilized =
            data: @series @spec.allYears, @spec.surfTempStabilize
            label: "Stabilized"
            color: @colors.stabilized
            width: 2
            
        dangerTemp = @spec.dangerTemp
        dp = (y) => {year: y, temp: dangerTemp} 
        danger =
            data: [dp(@firstYear), dp(@lastYear)]
            label: "Danger threshold"
            color: @colors.danger
            width: 1.5
            contextWidth: 1
        
        @graph.lines [historical, projection, stabilized, danger]
        
        dangerText = 
            pos:
                year: @spec.dangerYearTemp
                temp: dangerTemp
            text: @spec.dangerYearTemp
            dx: "-4.3ex"
            dy: "-0.4em"
            color: @colors.projection
            
        dangerTextStabilize =
            pos:
                year: @spec.dangerYearTempStabilize
                temp: dangerTemp
            text: @spec.dangerYearTempStabilize
            dx: "0.5ex"
            dy: "1em"
            color: @colors.stabilized
        
        @graph.text [dangerText, dangerTextStabilize]
        
    series: (years, temps) ->
        (year: year, temp: temps[idx] for year, idx in years)
        
    setBrush: (extent) -> @graph.setBrush extent

browserOk = ->
    return true if $.browser.chrome or $.browser.safari
    $("#loading").html "Graphics requires Chrome or Safari"
    false

plotResults()

