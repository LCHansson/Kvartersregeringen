## Munging script for inserting government formation data into our geoJSON file of electoral districts
#' The task at hand is as follows. For each electoral district:
#' - Calculate government formation based on election results in that district
#' - Write results to the geoJSON file (a list in geoData$features[[i]]$properties)

## Libraries
require(stringr)
require(rgdal)
require(RJSONIO)
require(data.table)


## Read data
system.time({
  geoData = fromJSON("app/data/valdistrikt2010.geojson")
})
# geoDataBk <- copy(geoData)
# geoData <- copy(geoDataBk)

## TEmporary workaround: Subset file
# geoData$features <- geoData$features[109]

electionData <- data.table(read.table(
  file = "data/valresultat/slutligt_valresultat_valdistrikt_R.skv",
  header = TRUE,
  sep = ";",
  fileEncoding = "ISO8859-1",
  stringsAsFactors = FALSE
))

# Clean election data
electionVarNames = c("LAN","KOM","VALDIST", names(electionData)[str_detect(names(electionData), ".proc")])
electionData = electionData[,c(electionVarNames), with=FALSE]

# Create "valdistrikt" code ('VDNAMN'; character, eight figures)
electionData[,VDNAMN := paste0(
  formatC(LAN, digits=2, width=2, flag="0"),
  formatC(KOM, digits=2, width=2, flag="0"),
  formatC(VALDIST, digits=4, width=4, flag="0")
)]
setkey(electionData, "VDNAMN")


## Fill up the geoJSON object with government formation
system.time({
  for (i in 1:length(geoData$features)) {
    #   for (i in 1:2) {
    
    # Find government
    voteList = electionData[VDNAMN == geoData$features[[i]]$properties[[1]]]
    seats = findSeats(voteList)
    govt = findGovernment(seats)
    if (is.null(govt))
      next()
    
    ministers = findMinisters(govt)
    
    # Write government as tuples to geoData
    geoData$features[[i]]$properties = append(
      geoData$features[[i]]$properties,
      c(government = list(ministers))
    )
  }
})

## Write back to the geoJSON file
# cat(toJSON(geoData, digits = 7))

system.time(
  writeLines(toJSON(geoData, digits = 7), "app/data/govt_valdistrikt2010.geojson")
)


# toJSON(geoData)
