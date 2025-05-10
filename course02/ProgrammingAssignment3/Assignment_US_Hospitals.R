## import the provided dataset, setting column as "character"
outcome <- read.csv("./rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")

## get an idea of the data
str(outcome)

## Converting column 11 to numeric before computing data
outcome[,11] <- as.numeric(outcome[,11])

## plotting an histogram of column 11 (30-day mortality rate after Heart Attack)
hist(outcome[,11])

## we want to find the best hospital per state, considering one of three criteria:
## "heart attack", "heart failure", "pneumonia"
