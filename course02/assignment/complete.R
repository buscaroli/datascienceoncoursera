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
