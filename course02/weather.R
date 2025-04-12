datafile <- "./hw1_data.csv"
# import data
df <- read.csv(datafile, header=T)

# print the head to get to know your data
head(df)

# print the description of the data
str(df)

# when extracting info you can use df[x] or df[[x]]: 
# - the former returns the same type as original container (in this case a list containing the elements of the first column)
# - the latter the content of the container (in this case the elements of the first column, of type integer)
typeof(df[1])
typeof(df[[1]])

# lets perform some operations on the elements of the first column ignoring the NA values
col1 <- df[[1]]

sum(col1, na.rm=T)
mean(col1, na.rm=T)
median(col1, na.rm=T)
min(col1, na.rm=T)
max(col1, na.rm=T)

# lets fins out which values of the first column are NA
col1_is_na <- is.na(col1)

# lets remove the rows that have a NA value
df_clean <- df[complete.cases(df),]

# lets remove the rows where the first column has a NA entry but keep the NAs from other columns
valid_ozone_rows <- !is.na(df$Ozone)
df_clean_ozone <- df[valid_ozone_rows,]

# lets get all rows where ozone is !NA and where Temp is over 90
subset(df[valid_ozone_rows,], Temp > 90)
