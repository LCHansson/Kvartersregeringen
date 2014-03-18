## Munging script for inserting government formation data into our geoJSON file of electoral districts
#' The task at hand is as follows. For each electoral district:
#' - Calculate government formation based on election results in that district
#' - Add lists of seats in parliament and government and appointed ministers to the geoJSON data
#' - Write results to the geoJSON file (a list in geoData$features[[i]]$properties)
#' 
#' The code in this script depends on the methods defined in 'regeringsbildning.R'.


## Libraries
require(stringr)
require(rgdal)
require(RJSONIO)
require(data.table)


## debug?
DEBUG = FALSE
subsetRange = 1:10


## Read data
system.time({
  geoData = fromJSON("app/data/valdistrikt2010.geojson")
})
# geoDataBk <- copy(geoData)
# geoData <- copy(geoDataBk)

electionData <- data.table(read.table(
  file = "data/valresultat/slutligt_valresultat_valdistrikt_R.skv",
  header = TRUE,
  sep = ";",
  fileEncoding = "ISO8859-1",
  stringsAsFactors = FALSE
))

# For debugging purposes only:: Subset file
if (DEBUG)
  geoData$features <- geoData$features[subsetRange]


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


## Fill up the geoJSON object with government formation and seats in parliament
if (DEBUG) {
  loopRange = subsetRange
} else {
  loopRange = 1:length(geoData$features)
}

system.time({
  for (i in loopRange) {
    
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
      c(
        government = list(ministers),
        seatsInParliament = list(seats)
      )
    )
  }
})

## Write back to the geoJSON file
if (DEBUG)
  cat(toJSON(geoData, digits = 7))

system.time(
if (DEBUG)
  writeLines(toJSON(geoData, digits = 7), "app/data/sample_govt_valdistrikt2010.geojson")
else
  writeLines(toJSON(geoData, digits = 7), "app/data/govt_valdistrikt2010.geojson")
)
