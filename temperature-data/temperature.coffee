{mean, std, log10} = $blab.math

$blab.temperatureRecord = ->
    
    # Instrumental record (NH mean temp). 
    # Use HadCRUT4 from AD 1850-2012.
    inhmst_data = $blab.resource "inhmst_data"#;
    HadCRUT4_annual_nh = $blab.parseInhmstData(inhmst_data)
    yearHadCRU = HadCRUT4_annual_nh.years
    nhHadCRU = HadCRUT4_annual_nh.temp

    # Use Berkeley Earth (BEST) temperature record
    # to establish pre-industrial (AD 1750-1849) mean.
    best_data = $blab.resource "best_data"#;
    BEST_annual_nh = $blab.parseBestData(best_data)#;
    yearBEST = BEST_annual_nh.year
    nhBEST = BEST_annual_nh.tempC

    # Variance adjustment to account for land bias in BEST 
    # (use overlap period of 1850-2011).
    stdBEST = std(nhBEST[100..261])
    stdHadCRU = std(nhHadCRU[0..161])
    nhBEST = (stdHadCRU/stdBEST)*nhBEST

    # Pre-industrial baseline based on mean of (BEST) NH mean
    # temperature series from AD 1750-1849.
    baselinepre = mean(nhBEST[0..99]) # AD 1750-1849
    nhBEST = nhBEST - baselinepre
    
    # Realign HADCRUT3 NH mean record to have same mean as BEST
    # during common (1961-1990) overlap period.
    ModMeanBEST = mean(nhBEST[211..240]) # AD 1961-1990
    ModMeanHadCRU = mean(nhHadCRU[111..140])  # AD 1961-1990
    nhHadCRU = nhHadCRU + ModMeanBEST - ModMeanHadCRU
    {yearHadCRU, nhHadCRU}

