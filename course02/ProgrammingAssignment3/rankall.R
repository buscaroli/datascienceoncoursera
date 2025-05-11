## rankall is a function that takes an outcome and a 'best' or 'worst' 
## criteria and returns a data frame with all the best or worst hospitals in
## each USA state.
##
## Requires:
##  - dplyr from the tidyverse
rankall <- function(outcome, num="best") {
  outcome_data <- read.csv("./course02/ProgrammingAssignment3/rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character") 
  hospital_data <- read.csv("./course02/ProgrammingAssignment3/rprog_data_ProgAssignment3-data/hospital-data.csv", colClasses = "character")
  
  # get a vector with each state from the dataset
  states <- hospital_data %>%
    select(State) %>%
    distinct(State) %>%
    arrange(State)
  states <- states[["State"]]
  
  ## convert the three columns of data to a numeric format
  outcome_data[, 11] <- as.numeric(outcome_data[, 11])
  outcome_data[, 17] <- as.numeric(outcome_data[, 17])
  outcome_data[, 23] <- as.numeric(outcome_data[, 23])
  
  ## validate outcome
  allowed_outcomes <- c("heart attack", "heart failure", "pneumonia")
  
  validation_errors <- c()
  outcome <- tolower(outcome)
  
  if (!outcome %in% allowed_outcomes) {
    validation_errors <- append(validation_errors, "invalid outcome")
  }
  
  if (length(validation_errors) != 0) {
    stop(paste(validation_errors, collapse = " and "))
  }
  
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
  full_data <- full_data %>%
    select(hospital_name, hospital_state, heart_attack, heart_failure, pneumonia)
    
  
  ## map the 'outcome' input to a R-compliant column name
  # col 11 -> 30-day Mortality Rate for Heart Attack
  # col 17 -> 30-day Mortality Rate for Heart Failure
  # col 23 -> 30-day Mortality Rate for Pneumonia
  column_name <- NULL
  column_name <- switch(outcome,
                        "heart attack" = "heart_attack",
                        "heart failure" = "heart_failure",
                        "pneumonia" = "pneumonia"
  )
  
  # create an empty data frame where to store the results
  ranked_data <- tibble()
  
  ## create a new column called 'Rank' with a numerical series restarting at
  ## each new State
  if (is.numeric(num)) {
    ranked_data <- full_data %>%
      group_by(hospital_state) %>%
      arrange(hospital_state, !!sym(column_name)) %>%
      mutate(Rank = row_number())
    
    # filter the observations based on the given paramenters
    ranked_data <- ranked_data %>%
      filter(Rank == num) %>%
      arrange(hospital_state, !!sym(column_name)) %>%
      select(hospital_state, hospital_name)
  }
  
  if (!is.numeric(num)) {
    if (num == "best") {
      ranked_data <- full_data %>%
        group_by(hospital_state) %>%
        arrange(hospital_state, !!sym(column_name)) %>%
        mutate(Rank = row_number())
      
      # filter the observations based on the given paramenters
      ranked_data <- ranked_data %>%
        filter(Rank == 1) %>%
        arrange(hospital_state, !!sym(column_name)) %>%
        select(hospital_state, hospital_name)
    } 
    
    if (num == "worst") {
      ranked_data <- full_data %>%
        group_by(hospital_state) %>%
        arrange(hospital_state, desc(!!sym(column_name))) %>%
        mutate(Rank = row_number())
      
      # filter the observations based on the given paramenters
      ranked_data <- ranked_data %>%
        filter(Rank == 1) %>%
        arrange(hospital_state, desc(!!sym(column_name))) %>%
        select(hospital_state, hospital_name)
    }
  }
 
  # return the hospital data
  return (ranked_data) 
}

## head(rankall("heart attack", 20), 10)
## tail(rankall("pneumonia", "worst"), 3)
## tail(rankall("heart failure"), 10)