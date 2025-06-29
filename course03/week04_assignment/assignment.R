## Install libraries
install.packages("tidyverse")
install.packages("lubridate")
install.packages("data.table")

library(lubridate)
library(tidyverse)
library(data.table)

# Ex 01 
## The American Community Survey distributes downloadable data about 
## United States communities. Download the 2006 microdata survey about housing 
## for the state of Idaho using download.file() from here
idahoUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
idahoDest <- "./data/idaho.csv"
codebookUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
codebookDest <- "./data/codebook.pdf"

## download data
download.file(url = idahoUrl, destfile = idahoDest)
download.file(url = codebookUrl, destfile = codebookDest)

## import data
idaho <- read.csv(idahoDest)
idaho_dt <- data.table(idaho)

## Apply strsplit() to split all the names of the data frame on the characters 
## "wgtp". What is the value of the 123 element of the resulting list?
strsplit(colnames(idaho_dt), "wgtp")[123]

# Ex 02
## Load the Gross Domestic Product data for the 190 ranked countries in
## the data set. 
## Remove the commas from the GDP numbers in millions of dollars and average 
## them. What is the average? 

## download and import data
gdpUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdpDest <- "./data/gdp.csv"

download.file(url = gdpUrl, destfile = gdpDest)

## the first 5 rows have no data
## the rows after 190 contain summarised data (eg. data by region) 
gdp <- fread(gdpDest, skip = 5, nrows = 190)
gdp_dt <- data.table(gdp)

## Remove the commas from the GDP numbers in millions of dollars and 
## average them. 
## What is the average? 

setnames(gdp_dt, "V5", "GDP") ## rename column

## remove commas before converting to numeric to avoid getting "NA"
gdp_dt$GDP <- as.numeric(gsub(",", "", gdp_dt$GDP))

gdp_avg <- gdp_dt %>% summarise(avg_gdp = mean(GDP, na.rm = TRUE))

