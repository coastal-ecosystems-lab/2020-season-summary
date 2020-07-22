

#combining data from text files

setwd("C:/Users/Ryan/Desktop/2020 season summary/data/eos-pier")

rm(list = ls())

library(dplyr)
library(lubridate)

# ====================================================================================================================================
#   Date     Time  Temp SpCond   Cond  Resist   TDS    Sal   Press   Depth    pH      pH   Chl   Chl Turbid+ ODOsat    ODO Battery
# y/m/d hh:mm:ss     C  uS/cm  uS/cm  Ohm*cm   g/L    ppt    psia  meters            mV  ug/L   RFU     NTU      %   mg/L   volts
# ------------------------------------------------------------------------------------------------------------------------------------


list.files()

#assign file names

file1 <- "YSI_RTC_20191120-20191219.txt"
file1.1 <- "YSI_RTC_20191120-20191219.csv"
file2 <- "YSI_RTC_20191220-20191226.txt"    
file3 <- "YSI_RTC_20191227-20200206.csv"    
file4 <- "YSI_RTC_20200207-20200317.csv"   
file5 <- "YSI_RTC_20200317-20200403.csv"   
file6 <- "YSI_RTC_20200403-20200515.csv"    
file7 <- "YSI_RTC_20200515.csv" 

header <- read.table(file2, as.is = T, skip = 1,nrows = 1, header = F)
header$V12 <- "pH.1"
header$V14 <- "Chl.1"

#read data files and match var names ######################################

# dropped this file since pressure data was missing after translating 
# in ecowatch. Even though it is the wrong pressure value
# # option as.is = T keeps the strings as strings and not factors
# df1 <- read.table(file1, as.is = T, skip = 5, header = F)
# 
# # assigns columns names pulled from header "file"
# colnames(df1) <- header[1,]

df1 = read.csv(file1.1,
               header=T, stringsAsFactors=F, sep=",")
df1 <- df1[-1,]


# option as.is = T keeps the strings as strings and not factors
df2 <- read.table(file2, as.is = T, skip = 5, header = F)

# assigns columns names pulled from header "file"
colnames(df2) <- header[1,]


# still need to read in .csv files
# need to replace all cma with rtc
# need to rewrite read.csv below with "file2.... filen"


df3 = read.csv(file3,
               header=T, stringsAsFactors=F, sep=",")
df3 <- df3[-1,]


df4 = read.csv(file4,
               header=T, stringsAsFactors=F, sep=",")
df4 <- df4[-1,]


df5 = read.csv(file5,
               header=T, stringsAsFactors=F, sep=",")
df5 <- df5[-1,]


df6 = read.csv(file6,
               header=T, stringsAsFactors=F, sep=",")
df6 <- df6[-1,]


df7 = read.csv(file7,
               header=T, stringsAsFactors=F, sep=",")
df7 <- df7[-1,]


df <- bind_rows(df1, df3, df4, df5, df6, df7, .id= NULL)



df <- df %>%                     
  rename(sst = Temp, 
         sss = Sal,
         o2_mg_l = ODO,
         o2_sat = ODOsat,
         pH_mv = pH.1,
         chl_ugl = Chl,
         chl_rfu = Chl.1,
         Turb = Turbid.)


df2 <- df2 %>%                     
  rename(sst = Temp, 
         sss = Sal,
         o2_mg_l = ODO,
         o2_sat = ODOsat,
         pH_mv = pH.1,
         chl_ugl = Chl,
         chl_rfu = Chl.1,
         Turb = "Turbid+")




df$sst <- as.numeric(df$sst)
df$SpCond <- as.numeric(df$SpCond)
df$Cond <- as.numeric(df$Cond)
df$Resist <- as.numeric(df$Resist)
df$TDS <- as.numeric(df$TDS)
df$sss <- as.numeric(df$sss)
df$Press <- as.numeric(df$Press)
df$Depth <- as.numeric(df$Depth)
df$pH <- as.numeric(df$pH)
df$pH_mv <- as.numeric(df$pH_mv)
df$chl_ugl <- as.numeric(df$chl_ugl)
df$chl_rfu <- as.numeric(df$chl_rfu)
df$Turb <- as.numeric(df$Turb)
df$o2_sat <- as.numeric(df$o2_sat)
df$o2_mg_l <- as.numeric(df$o2_mg_l)
df$Battery <- as.numeric(df$Battery)


df <- bind_rows(df, df2, .id= NULL)

str(df)


rm(list=setdiff(ls(), c("df")))



df <- df %>%
  mutate(datetime =  paste(df$Date,df$Time))

df$datetime <- as.POSIXct(df$datetime, format = "%Y/%m/%d %H:%M:%S", tz = "GMT")

str(df)

df <- df %>%
  arrange(datetime)


eos_pier_2020 <- select(df, datetime, everything())


save(eos_pier_2020, file = "EOS_YSI_20191201-20200515.RData")

rm(list = ls())

load(file = "EOS_YSI_20191201-20200515.RData")

str(eos_pier_2020)

rm(list = ls())



