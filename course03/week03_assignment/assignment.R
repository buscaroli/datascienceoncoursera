#### Install and load libraries
library(tidyverse)
library(data.table)

## install and load the 'readJPEG' package
install.packages('readJPEG')
library(readJPEG)

#### Exercise 01
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


#### Exercise 02
## download file
pictUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
pictDest <- "./data/pic.jpg"

## download file
download.file(url=pictUrl, destfile = pictDest)

## Using the jpeg package read in the following picture of your instructor
## into R, using the option NATIVE = TRUE.
pictData <- readJPEG(pictDest, native = TRUE)

## What are the 30th and 80th quantiles of the resulting data? (some Linux 
## systems may produce an answer 638 different for the 30th quantile)
quantile(pictData, c(0.3, 0.8))

#### Exercise 03
## download and load data
GDPUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
GDPDestination <- "./data/GDP.csv"
GDPPdfUrl <- "https://datacatalogfiles.worldbank.org/ddh-published/0038130/9/DR0046441/GDP.pdf"
GDPPdfDestination <- "./data/GDP.pdf"
educationalDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
educationalDataDestination <- "./data/educData.csv"


download.file(url = GDPUrl, destfile = GDPDestination)
download.file(url = GDPPdfUrl, destfile = GDPPdfDestination)
download.file(url = educationalDataUrl, destfile = educationalDataDestination)

## load data
gdp <- fread(GDPDestination, skip = 5, nrows = 190)
setnames(gdp, old = c("V1", "V2", "V4", "V5"), new = c("CountryCode", "Ranking", "CountryName", "GDP"))
gdp_dt <- data.table(gdp)

# convert type from default "char" to "numeric" for sorting
gdp_dt$GDP <- as.numeric(gdp_dt$GDP)
gdp_dt$Ranking <- as.numeric(gdp_dt$Ranking)

educ <- fread(educationalDataDestination)
educ_dt <- data.table(educ)

str(gdp_dt)
str(educ_dt)

## Load the Gross Domestic Product data for the 190 ranked countries 
## in this data set.
## Match the data based on the country shortcode. How many of the IDs match? 
## Sort the data frame in descending order by GDP rank (so United States is 
## last). What is the 13th country in the resulting data frame?
joint_dt <- merge(gdp_dt, educ_dt, by = "CountryCode")
joint_dt <- gdp_dt %>% inner_join(educ_dt, by = "CountryCode") %>% arrange(desc(Ranking)) %>% select(CountryCode, CountryName, `Income Group`, Ranking, GDP)

## How many of the IDs match?
print(nrow(joint_dt))
## What is the 13th country in the resulting data frame?
print(joint_dt %>% select(CountryName) %>% slice(13))

#### Exercise 04
## What is the average GDP ranking for the 
## - "High income: OECD"
## - "High income: nonOECD" 
## group?

OECD_avg <- joint_dt %>% filter(`Income Group` == "High income: OECD") %>% summarise(OECD_HI_avg = mean(Ranking, na.rm = TRUE))
print(OECD_avg)

nonOECD_avg <- joint_dt %>% filter(`Income Group` == "High income: nonOECD") %>% summarise(nonOECD_HI_avg = mean(Ranking, na.rm = TRUE))
print(nonOECD_avg)

#### Exercise 05
## Cut the GDP ranking into 5 separate quantile groups. 
## Make a table versus Income.Group. 
## How many countries are Lower middle income
## but among the 38 nations with highest GDP?

quants = quantile(joint_dt$Ranking, probs = seq(0, 1, 0.20), na.rm = TRUE)

joint_dt$quantGDP <- cut(joint_dt[, Ranking], breaks = quants)
cross_table <- table(joint_dt$quantGDP, joint_dt$`Income Group`)
print(cross_table)
