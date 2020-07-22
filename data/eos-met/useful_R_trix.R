
# useful R script tricks

#remove all vars ####
rm(list = ls())

# get file names and set to var #####
list.files()

file1 <- "RTC_MET_20191120-20191227.txt"   
file2 <- "RTC_MET_20191227-20200515.txt"

# pull header from text file separated by commas ####
header <- read.table(file1, as.is = T, skip = 1,nrows = 1, header = F, sep = ",")


# read in data from text file separated by comma and set header ####

# option sep is separator, as.is = T keeps the strings as strings and not factors
df1 <- read.table(file1, sep = ",", as.is = T, skip = 5, header = F)

# assigns columns names pulled from header "file"
colnames(df1) <- header[1,]



# change all character columns to numeric ####
library(magrittr)

df1 %<>% mutate_if(is.character,as.numeric)


# put one variable in front of data frame while including everything else ####

df <- select(df, datetime, everything())




