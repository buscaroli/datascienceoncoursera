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

padAndString <- function(number, padSize=3) {
  gap <- padSize - nchar(number)
  
  if (gap <= 0) { 
    return (as.character(number))
  } else {
      padding <- strrep("0", gap)
      return (paste0(padding, number))
  }
}
