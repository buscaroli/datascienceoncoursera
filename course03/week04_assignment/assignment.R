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

setnames(gdp_dt, "V5", "GDP") ## rename column 5
setnames(gdp_dt, "V1", "CountryCode") ## rename column 1
## remove commas before converting to numeric to avoid getting "NA"
gdp_dt$GDP <- as.numeric(gsub(",", "", gdp_dt$GDP))
gdp_avg <- gdp_dt %>% summarise(avg_gdp = mean(GDP, na.rm = TRUE))

# Ex 03
## In the data set from Question 2 what is a regular expression that would 
## allow you to count the number of countries whose name begins with 
## "United"? 
## How many countries begin with United? 
print(length(grep("^United", gdp_dt$V4)))

# Ex 04
## Using the data set from Question #2, and the educational data from 
## "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", 
## match the data based on the country shortcode. 
## Of the countries for which the end of the fiscal year is available, 
## how many end in June?
educUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
educDest <- "./data/educ.csv"

## download and import data
download.file(url = educUrl, destfile = educDest)

educ <- fread(educDest)
educ_dt <- data.table(educ)

## joining the two data tables by "CountryCode"
joint_dt <- merge(gdp_dt, educ_dt, by = "CountryCode")

## The column "Special Notes" contains a string that may include the following:
## "Fiscal year end: June" ...; which is going to be the target substring
## Note: for this exercise it wasn't really necessary to merge the two datasets
## as the data needed was all in the educational dataset.
print(length(grep("^Fiscal year end: June", joint_dt$`Special Notes`)))

# Ex 05
## You can use the quantmod (http://www.quantmod.com/) package to get 
## historical stock prices for publicly traded companies 
## on the NASDAQ and NYSE. Use the following code to download data on 
## Amazon's stock price and get the times the data was sampled.
## Use the folloiwng code:
install.packages("quantmod")
library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

## converting the data into lubridate's date format
dates <- ymd(sampleTimes)

## How many values were collected in 2012? 
print(sum(year(dates) == 2012))

## How many values were collected on Mondays in 2012?
print(sum(year(dates) == 2012 & wday(dates) == 2)) # 1 = Sun, 2 = Mon etc.