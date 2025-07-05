## Install and load libraries
install.packages("tidyverse")
install.packages("data.table")

library(tidyverse)
library(data.table)

## check if the data directory already exists, if not, download and extract data
originalDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataFilename <- "./dataset.zip"

if (!file.exists("./data")) {
download.file(url = originalDataUrl, destfile = dataFilename, method = "curl")
unzip(zipfile = dataFilename)

## remove downloaded zipfile and rename directory for convenience
file.remove(dataFilename)
file.rename(from = "UCI HAR Dataset", to = "data")
}

## read all available data into data.table

#### features will be used to assign column names to the test and train data
features <- read.table("./data/features.txt", col.names = c("n", "features"))
print(dim(features)) # 561 features listed

##### activitiesLabels associates a number 1-6 to a specific activity 
activities <- read.table("./data/activity_labels.txt", col.names = c("enum", "activity"))
print(dim(activities)) # 6 activities listed

### 30 people were involved in the experiment
#### 30% were assigned to the test group
subjectTest <- read.table("./data/test/subject_test.txt", col.names = "subject")
testX <- read.table("./data/test/X_test.txt", col.names = features$features)
testY <- read.table("./data/test/y_test.txt", col.names = "activityEnum")

#### 70% were assigned to the train group
subjectTrain <- read.table("./data/train/subject_train.txt", col.names = "subject")
trainX <- read.table("./data/train/X_train.txt", col.names = features$features)
trainY <- read.table("./data/train/y_train.txt", col.names = "activityEnum")

### exploring the data
print(dim(trainX)) # 561 columns, one for each feature in features$features
print(dim(testX)) # 561 columns, one for each feature in features$features

print(distinct(trainY)) # 6 distinct values 1-6, one for each activities$enum
print(distinct(testY)) # 6 distinct values 1-6, one for each activities$enum

print(dim(subjectTrain)) # 7352 observations mapping to a subject (70% of total)
print(dim(subjectTest)) # 2947 observations mapping to a subject (30% of total)

# vertically merging (binding) data
### subjects contains the subject id for each observation
### dataY contains the activityEnum for each observation
### dataX contains the actual sensor datapoint for each feature
subjects <- bind_rows(subjectTrain, subjectTest)
dataY <- bind_rows(trainY, testY)
dataX <- bind_rows(trainX, testX)

# horizontally merging the data sets
### no need to specify the position as they have the same length (10299 rows)
completeData <- cbind(subjects, dataX, dataY)

## extract a subset of the data that includes only the mean and std deviation
meanStdData <- completeData %>% select(subject, activityEnum, contains(c("avg", "std")))

## replace the numerical values of the activityEnum column with the labels from
## the activities dataset
meanStdData$activityEnum <- activities[meanStdData$activityEnum, 2]

## rename the columns to have clear names
meanStdData <- meanStdData %>% rename(SubjectID = subject)
meanStdData <- meanStdData %>% rename(Activity = activityEnum)

names(meanStdData) <- gsub("tBody", "TBody", names(meanStdData))
names(meanStdData) <- gsub("tGravity", "TGravity", names(meanStdData))
names(meanStdData) <- gsub("Acc", "Acceleration", names(meanStdData))
names(meanStdData) <- gsub("Gyro", "Gyroscope", names(meanStdData))
names(meanStdData) <- gsub("Mag", "Magnitude", names(meanStdData))
names(meanStdData) <- gsub("fBody", "FBody", names(meanStdData))
names(meanStdData) <- gsub("BodyBody", "Body", names(meanStdData))

## creating a summary dataset from the previous one
summaryDT <- meanStdData %>%
  group_by(SubjectID, Activity) %>%
  summarise(across(everything(), mean, .names = "mean_{.col}"))

## save the summary dataset to a file
write.table(summaryDT, "SummaryDT.txt", row.names = FALSE)