## Munging script for socioeconomic variables for the electoral districts
#' The task is to construct a data set containing socioeconomic variables
#' and geographic identities ("KMN", "valdistrikt") for each district.
#' 
#' The data we want are available as TSV files at SCB.se, but are split up
#' into regional files for some reason. We thus parse the 25 regional files
#' and combine them into a national database containing all electoral districts.

## Libraries
require(stringr)
require(httr)
require(data.table)


## Download and munge data
baseUrl = "http://www.scb.se/grupp/eXplorer/valstatistik2010/data/landstingsvalet/REGION/REGION.txt"

for (i in 1:25) {
  regionUrl = str_replace_all(baseUrl, "REGION", formatC(i, width=2, digits=2, flag="0"))
  
  regionData <- try (
    data.table(read.table(regionUrl, sep="\t", header = TRUE, stringsAsFactors = FALSE), key="CODE"),
    silent = TRUE
  )
  
  ## If there is no file, do not add it to the data base
  if (attr(regionData, "class") == "try-error")
    next()
  
  ## Clean data from metadata crap
  regionData = regionData[META == ""]
  
  if (!exists("valdistDB"))
    valdistDB = copy(regionData)
  else
    valdistDB = rbindlist(list(valdistDB, regionData))
}