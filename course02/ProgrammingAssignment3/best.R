## best is a function that returns the best hospital for the given criteria; in case
## of a tie, the first hospital by alphabetical order is returned.
##
## Requires "dplyr" from the "tidyverse"
best <- function(state, outcome) {
  ## read outcome and hospital data into two data frames
  outcome_data <- read.csv("./ProgrammingAssignment3/rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv")
  hospital_data <- read.csv("./ProgrammingAssignment3/rprog_data_ProgAssignment3-data/hospital-data.csv")
  
  ## convert the three columns of data to a numeric format
  outcome_data[, 11] <- as.numeric(outcome_data[, 11])
  outcome_data[, 17] <- as.numeric(outcome_data[, 17])
  outcome_data[, 23] <- as.numeric(outcome_data[, 23])
 
  ## validate state and outcome
  state_list <- unique(hospital_data$State)
  allowed_outcomes <- c("heart attack", "heart failure", "pneumonia")
  
  validation_errors <- c()
  state <- toupper(state)
  outcome <- tolower(outcome)
  
  if (!state %in% state_list) {
    validation_errors <- append(validation_errors, "invalid state")
  }
  
  if (!outcome %in% allowed_outcomes) {
    validation_errors <- append(validation_errors, "invalid outcome")
  }
  
  if (length(validation_errors) != 0) {
    stop(paste(validation_errors, collapse = " and "))
  }
  
  ## Work on data table
  # col 11 -> 30-day Mortality Rate for Heart Attack
  # col 17 -> 30-day Mortality Rate for Heart Failure
  # col 23 -> 30-day Mortality Rate for Pneumonia
  column_name <- NULL
  column_name <- switch(outcome,
                          "heart attack" = "heart_attack",
                          "heart failure" = "heart_failure",
                          "pneumonia" = "pneumonia"
  )
  
  # rename data from the outcome dataset and only keep needed columns
  outcome_data_cleaned <- outcome_data |>
    rename(provider_id = colnames(outcome_data)[1]) |>
    rename(heart_attack = colnames(outcome_data)[11]) |>
    rename(heart_failure = colnames(outcome_data)[17]) |>
    rename(pneumonia = colnames(outcome_data)[23]) |>
    select(provider_id, heart_attack, heart_failure, pneumonia)
  
  # rename data from the hospital dataset and only keep needed columns
  hospital_data_cleaned <- hospital_data |>
    rename(provider_id = colnames(hospital_data)[1]) |>
    rename(hospital_name = colnames(hospital_data)[2]) |>
    rename(hospital_state = colnames(hospital_data)[7]) |>
    select(provider_id, hospital_name, hospital_state)
  
  # create a new data frame by merging the two data sets
  full_data <- inner_join(outcome_data_cleaned, hospital_data_cleaned, by="provider_id")
  
  # get the best hospital by desired outcome
  best <- full_data |>
    filter(hospital_state == state) |>
    arrange(column_name, hospital_name)|>
    slice(1) |>
    select(hospital_name)
    
  return (best)
}
