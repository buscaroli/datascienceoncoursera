# DataScience - John Hopkins University

## Course 03 - Getting and Cleaning Data - Project

## Project
The purpose of this project is to demonstrate your ability to collect, 
work with, and clean a data set. The goal is to prepare tidy data that can be 
used for later analysis. 
You will be graded by your peers on a series of yes/no questions related 
to the project. 
You will be required to submit: 
1. a tidy data set as described below
2. a link to a Github repository with your script for performing the analysis
3. a code book that describes the variables, the data, and any transformations 
  or work that you performed to clean up the data called CodeBook.md. 

You should also include a README.md in the repo with your scripts. 

## Task 
You should create one R script called run_analysis.R that does the following:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each 
  measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with 
  the average of each variable for each activity and each subject.


## Scripts
If downloading the whole repo and using RStudio to run the script, please
be sure to change the "working directory" to "course03/week04_Project/"

The only script used for the task is called "run_analysis.R".

## Files
The original data is stored in the "data" subfolder, together with the files
produces by the original authors of the experiment that collected the data in 
the first place [1].

I have also attached a file called "CodeBook.md" with a description of the data.

## Libraries
- tidyverse: contains all the necessary libraries for data processing, in 
  particular dplyr
- data.table: a high performance dataframe

## Online Data Repository


## Copyright
### Original work reference:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and 
Jorge L. Reyes-Ortiz. 
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly 
Support Vector Machine. 
International Workshop of Ambient Assisted Living (IWAAL 2012). 
Vitoria-Gasteiz, Spain. Dec 2012
[Original data available online](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)