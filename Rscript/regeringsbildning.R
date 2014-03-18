## Libraries
require(stringr)

## Read data

testdata <- read.table(
  file = "data/valresultat/slutligt_valresultat_valdistrikt_R.skv",
  header = TRUE,
  sep = ";",
  nrows = 10,
  fileEncoding = "ISO8859-1",
  stringsAsFactors = FALSE
)



## Define algorithm
#' FIND MANDATES
#' After an election, we want to distribute parliamentary mandates based on a vote
#' share, but after considering some election threshold. In Sweden this threshold
#' is set to 4% of the popular vote.
#' 
#' The mandates are distributed by the Sainte-Laguë method ("jämkade uddatalsmetoden")
#' using 1.4 as initial divisor.

findSeats <- function(voteList, threshold = 4, seats = 349) {
  # Result strings need to be converted from Swedish to English decimal marker
  voteList = lapply(voteList, str_replace_all, ",", ".")
  
  # Only look at percentages
  partiResultNames = names(voteList)[str_detect(names(voteList), "proc")]
  voteList = voteList[names(voteList) %in% partiResultNames]
  
  # If the party recieved less than the threshold, its votes are excluded from the 
  # seat distribution algorithm
  partiResults = sapply(voteList, function(partiResult) {
    if (as.numeric(partiResult) < threshold)
      return(0)
    else
      return(as.numeric(partiResult))
  })
  names(partiResults) = sapply(names(partiResults), str_replace_all, ".proc", "")
  
  
  # The number of seats are distributed among the remaining parties using
  # Saint-Laguë
  mandateList = list(S=0, V=0, MP=0, M=0, FP=0, KD=0, C=0, SD=0, FI=0, PP=0, SPI=0, OVR=0, BL=0, OG=0)
  count = 0
  
  for (i in 1:seats) {
    seatWinner = which.max(sapply(names(partiResults), function(parti) {
      result = partiResults[[parti]]/(1 + 2*mandateList[[parti]])
      return(result)
    }))
    mandateList[names(seatWinner)] = mandateList[[names(seatWinner)]] + 1
  }
  
  mandateList = mandateList[mandateList != 0]
  
  # Return a vector of lists
  
  mandateVector = lapply(1:length(mandateList), function(i) {
    list(party = names(mandateList[i]), seats = mandateList[i][[1]])
  })
  
  return(mandateVector)
}



#' FIND GOVERNMENT
#' The basic problem is this: Given a strength balance between political parties,
#' decide which potential party coalition might form a government.
#' 
#' The function takes a formatted list of seats in parliament and finds a government
#' by following the steps outlined below.
#' 
#' We assume the following premises:
#' * All parties have a specified list of which parties they _can_ cooperate with
#' and which parties they _can't_ cooperate with.
#' * The biggest party in a coalition "selects" its coalition partners. Thus,
#' the biggest party will go first in trying to form a coalition. It then scans
#' for potential coalition partners and decides whether they can form a coalition
#' with them.
#' * If the biggest party fails at finding a coalition, the second biggest party
#' gets to choose a coalition.
#' * If none of the two biggest parties manages to form a coalition, the 
#' coalition formation is considered to have failed.
#' * Parties stop looking for coalition partners once they have reached >50% of
#' the mandate share.

findGovernment <- function(seatList) {
  
  # We begin by implementing a naïve method by identifying potential coalitions as
  # ordered lists. Coalition preference order is determined by 
  coalitionPreferences <- list(
    S = c("MP","V","FP"),
    V = c("S","MP","M","FP"),
    MP = c("S","V","FP","M"),
    M = c("FP","KD","C","MP"),
    C = c("M","S","FP","MP"),
    KD = c("M","FP","C","S"),
    FP = c("M","C","S","MP"),
    SD = c("M","KD","C","S")
  )
  
  partyList = sapply(seatList, function(i) {
    party = i$seats
    names(party) = i$party
    return(c(party))
  })
  
  # First we need to determine the majority threshold by looking at the number of seats
  numSeats = sum(as.integer(sapply(seatList, unlist)[2,]))
  majorityThreshhold = floor(numSeats/2) + 1
  
  # The position biggest party in the seat list is located
  biggestParty = names(which.max(partyList))
  
  # The biggest party makes the first attempt at forming a coalition as determined by
  # its coalition preferences
  coalition = list()
  
  for (partner in c(biggestParty, coalitionPreferences[[biggestParty]])) {
    party = list(unlist(lapply(seatList, function(i) {
      if (i$party == partner) {
        return(i$seats)
      }
    })))
    names(party) = partner
    coalition = append(coalition, party)
    coalitionSeats = sum(unlist(coalition))
    if (coalitionSeats >= majorityThreshhold)
      break
  }
  
  
  
  # If there is a successful coalition, we have a winner!
  # Otherwise, repeat the procedure for the second biggest party.
  if (coalitionSeats >= majorityThreshhold) {
    return(coalition)
  } else {
    
    secondParty = names(which.max(partyList[names(partyList) != biggestParty]))
    
    coalition = list()
    
    for (partner in c(secondParty, coalitionPreferences[[secondParty]])) {
      party = list(unlist(lapply(seatList, function(i) {
        if (i$party == partner) {
          return(i$seats)
        }
      })))
      names(party) = partner
      coalition = append(coalition, party)
      coalitionSeats = sum(unlist(coalition))
      if (coalitionSeats >= majorityThreshhold)
        break
    }
  }
  
  # If the two biggest parties have both failed at forming a majority coalition,
  # the coalition formation process is considered to have failed. (This should not
  # be possible in the naïve implementation.)
  if (coalitionSeats >= majorityThreshhold) {
    return(coalition)
  } else {
    message("Could not find a successful government coalition. Forming fascist government.")
    uglyCoalitionParties = c("M","FP","C","KD","SD")
    
    coalition = list()
    for (partner in uglyCoalitionParties) {
      party = list(unlist(lapply(seatList, function(i) {
        if (i$party == partner) {
          return(i$seats)
        }
      })))
      names(party) = partner
      coalition = append(coalition, party)
    }
    return(coalition)
  }
}

## FIND MINISTERS
#' Once the coalition formation has been determined, it is time to elect ministers.
#' 
#' Seats in the government are distributed the same way as seats in parliament;
#' by using Saint-Laguë.
#' 
#' Once the number of seats by party have been determined, we appoint certain persons
#' for key minister offices. The rest of the seats are assigned to a party but
#' we do not appoint specific persons to the offices.
findMinisters <- function(govt, seats = 20) {
  
  # Define potential persons to be appointed to each minister
  potentialMinisters = list(
    "Statsminister" = list(
      M = "Fredrik Reinfeldt",
      FP = "Jan Björklund",
      KD = "Göran Hägglund",
      C = "Annie Lööf",
      S = "Stefan Löfven",
      V = "Jonas Sjöstedt",
      MP = "Gustav Fridolin",
      SD = "Jimmie Åkesson"
    ),
    "Utrikesminister" = list(
      M = "Carl Bildt",
      FP = "Cecilia Wikström",
      KD = "Göran Hägglund",
      C = "Fredrick Federley",
      S = "Jan Eliasson",
      V = "Hans Linde",
      MP = "Bodil Ceballos",
      SD = "Kent Ekeroth"
    ),
    "Finansminister" = list(
      M = "Anders Borg",
      FP = "Birgitta Olsson",
      KD = "Anders Wijkman",
      C = "Martin Ådahl",
      S = "Magdalena Andersson",
      V = "Ulla Andersson",
      MP = "Åsa Romson",
      SD = "Björn Söder"
    ),
    "Utbildningsminister" = list(
      M = "Tomas Tobé",
      FP = "Jan Björklund",
      KD = "Göran Hägglund",
      C = "Ulrika Carlsson",
      S = "Ibrahim Baylan",
      V = "Rossana Dinamarca",
      MP = "Mats Pertoft",
      SD = "Richard Jomshof"
    )
  )  
  
  # The distribution of government seats is determined by Saint-Laguë.
  seatList = list(S=0, V=0, MP=0, M=0, FP=0, KD=0, C=0, SD=0)
  
  for (i in 1:seats) {
    seatWinner = which.max(sapply(names(govt), function(parti) {
      result = govt[[parti]]/(1 + 2 * seatList[[parti]])
      return(result)
    }))
    seatList[names(seatWinner)] = seatList[[names(seatWinner)]] + 1
  }
  
  seatList = seatList[seatList != 0]
  
  # Appoint ministers by party order
  appointmentOrder = order(sapply(seatList, function(i) return(i)), decreasing = TRUE)
  appointmentOrder = rep(appointmentOrder, 20)
  
  ministerList = list()
  count = 0
  
  # Appoint named ministers
  #   for (office in names(potentialMinisters)) {
  #     count = count + 1
  #   appointmentParty = names(seatList[appointmentOrder[count]])
  
  ministerList = append(
    ministerList,
    list(namedMinisters = lapply(names(potentialMinisters), function(seatName) {
      count <<- count + 1
      appointmentParty = names(seatList[appointmentOrder[count]])
      
      list(
        name = potentialMinisters[[seatName]][[appointmentParty]],
        party = appointmentParty,
        title = seatName
      )
    })
    ))
  #   }
  
  # Assign remaining cabinet seats to a party
  appointedSeats = as.list(table(
    sapply(ministerList$namedMinisters, function(i) return(i$party))
  ))
  
  seatList = seatList[names(seatList) %in% names(appointedSeats)]
  ministerList = append(
    ministerList,
    list(unnamedMinisters = lapply(names(seatList), function(i) {
      value = list(seatList[[i]] - appointedSeats[[i]])
      names(value) = i
      
      return(value)
    }))
  )
  
#   for (seat in 1:(seats-length(potentialMinisters))) {
#     count = count + 1
#     
#     appointmentParty = names(seatList[appointmentOrder[count]])
#     ministerList = append(
#       ministerList,
#       list(list(party = appointmentParty))
#     )
#   }
  
  return(ministerList)
}



#' EXAMPLES
#' 
#' # Get election results from a template CSV file.
#' testdata <- read.table(
#'  file = "data/valresultat/slutligt_valresultat_valdistrikt_R.skv",
#'  header = TRUE,
#'  sep = ";",
#'  nrows = 10,
#'  fileEncoding = "ISO8859-1",
#'  stringsAsFactors = FALSE
#' )
#' 
#' # Pick an election district (in the CSV file, each row is an election district)
#' voteList = testdata[1,]
#' seatsInParliament = findSeats(voteList)
#' 
#' government = findGovernment(seatsInParliament)

