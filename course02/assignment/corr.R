corr <- function (directory="./", threshold=0){
  corrVec <- c()
  
  stationList <- list.files(directory)
  
  for (station in stationList) {
    df <- read.csv(paste0(directory, '/', station))
    
    completeCases <- !is.na(complete.cases(df))
    isValid <- sum(completeCases) > threshold && sum(completeCases) > 0
    if (isValid) {
      stationCorr <- cor(df$sulfate, df$nitrate, use="pairwise.complete.obs")
      corrVec <- append(corrVec, stationCorr)
    }
                   
  }
  if (length(corrVec) > 0) {
    return (corrVec)
  } else
    return (0)
}