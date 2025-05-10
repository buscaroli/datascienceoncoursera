## rankHospital returns a list of hospitals ranked by state and by a user
## selected outcome.
##
## The possible outcomes are:
## - heart attack
## - heart failure
## - pneumonia
##
## The function also takes into consideration possible ties.

library(tidyverse)

rankhospital <- function(state, outcome, num = "best") {
  ## read outcome and hospital data into two data frames
  outcome_data <- read.csv("./course02/ProgrammingAssignment3/rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
  hospital_data <- read.csv("./course02/ProgrammingAssignment3/rprog_data_ProgAssignment3-data/hospital-data.csv", colClasses = "character")
  
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
  
  # get the n top scores
  best_scores <- full_data |> 
    filter(hospital_state == state) |> 
    select(all_of(column_name)) |> 
    distinct()
  best_scores <- sort(best_scores[,column_name])
  best_scores <- best_scores[1:num]
  
  # get the maximum allowed score to be in the top num list
  max_outcome <- max(best_scores)
  
  # get the top "num" hospitals, considering ties
  top_hospitals <- full_data %>%
    filter(!!sym(column_name) <= max_outcome) %>% 
    arrange(!!sym(column_name), hospital_name) %>%
    select(provider_id, hospital_name, !!sym(column_name)) %>%
    slice(1:num)
    
  print(top_hospitals)
}
rankhospital("MD", "heart failure", 10)
