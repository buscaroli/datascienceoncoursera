## Print an histogram of the 30 day death rate for heart attack from the outcomes data set.
## Needs importing "dplyr" and "ggplot2" from the tidyverse
histogram_heart_attack <- function() {
  # import the dataset
  df <- read_csv("./ProgrammingAssignment3/rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv")
  
  print(head(df))
  # rename the column related to the mortality from heart attack
  # convert the type of the desired column to numeric
  df <- df |> rename(heart_attack = colnames(df)[11])
  df$heart_attack <- as.numeric(df$heart_attack)

  # plot the histogram
  ggplot(df, aes(x = heart_attack)) +
    geom_histogram(binwidth = 0.5, fill="#DD0000", color="#000000") +
    labs(
      title = "Mortality Rate for Heart Attack",
      subtitle = "USA, from Medicare claims and enrollment data",
      x = "Risk-adjusted rate (%)",
      y = "Count"
    )
  
}
