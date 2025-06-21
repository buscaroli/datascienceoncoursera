library(tidyverse)
library(data.table)

## download files
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
destination <- "./data/idaho_housing_2006.csv"
download.file(url= fileUrl, destfile = destination)

docUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
docDestination <- "./data/idaho_doc.pdf"
download.file(url=docUrl, dest=docDestination)

## load data
housing <- read.csv(destination)
dt <- data.table(housing)

## Create a logical vector that identifies the households on 
## greater than 10 acres who sold more than $10,000 worth of 
## agriculture products. Assign that logical vector to the
## variable agricultureLogical. 
## Apply the which() function like this to identify the rows
## of the data frame where the logical vector is TRUE. 
agricultureLogical <- dt$ACR == 3 & dt$AGS == 6

## What are the first 3 values that result?
head(which(agricultureLogical), 3)

