## Fetch images for Riksdagsledamöter

# Libraries
require(httr)

# get data (requires list from regeringsbildning.R)
persons <- unique(unlist(potentialMinisters))

GET()