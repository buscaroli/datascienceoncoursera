pollutantmean <- function(directory="./", pollutant="nitrate", id=1){
  totalSum <- 0
  totalObservations <- 0
  
  for (station in id) {
    stationId <- padAndString(station)
    stationData <- read.csv(paste0(directory, "/", stationId, ".csv"))
    stationSum <- sum(stationData[,pollutant], na.rm = TRUE)
    stationObservations <- sum(!is.na(stationData[,pollutant]))
    
    totalSum <- totalSum + stationSum
    totalObservations <- totalObservations + stationObservations 
  }
  return (totalSum/totalObservations)
}

complete <- function(directory, id=1) {
  ids <- c()
  nobs <- c()
  
  for (station in id) {
    stationId <- padAndString(station)
    stationData <- read.csv(paste0(directory, "/", stationId, ".csv"))
    completeEntriesNum <- sum(complete.cases(stationData))
    ids <- append(ids, station)
    nobs <- append(nobs, completeEntriesNum)
  }
  return (data.frame(id=ids, nobs=nobs))
}

padAndString <- function(number, padSize=3) {
  gap <- padSize - nchar(number)
  
  if (gap <= 0) { 
    return (as.character(number))
  } else {
      padding <- strrep("0", gap)
      return (paste0(padding, number))
  }
}
