
#combining data from text files

setwd("C:/Users/Ryan/Desktop/2020 season summary/data/cma-pier")

rm(list = ls())

library(dplyr)
library(lubridate)

# ====================================================================================================================================
#   Date     Time  Temp SpCond   Cond  Resist   TDS    Sal   Press   Depth    pH      pH   Chl   Chl Turbid+ ODOsat    ODO Battery
# y/m/d hh:mm:ss     C  uS/cm  uS/cm  Ohm*cm   g/L    ppt    psia  meters            mV  ug/L   RFU     NTU      %   mg/L   volts
# ------------------------------------------------------------------------------------------------------------------------------------


list.files()

# [1] "CMA_YSI_20191108-20191210.csv"    "CMA_YSI_20191210-20200103.csv"    "CMA_YSI_20200103-2020117.csv"    
# [4] "CMA_YSI_20200117-20200206.csv"    "CMA_YSI_20200117.csv"             "CMA_YSI_20200206-20200221.csv"   
# [7] "CMA_YSI_20200221-20200402.csv"    "CMA_YSI_20200403-20200514.csv"  "CMA_YSI_20200514-20200710.csv"


#read data files and match var names ######################################

df1 = read.csv("CMA_YSI_20191108-20191210.csv",
               header=T, stringsAsFactors=F, sep=",")
df1 <- df1[-1,]


df2 = read.csv("CMA_YSI_20191210-20200103.csv",
               header=T, stringsAsFactors=F, sep=",")
df2 <- df2[-1,]


df3 = read.csv("CMA_YSI_20200103-2020117.csv",
               header=T, stringsAsFactors=F, sep=",")
df3 <- df3[-1,]


df4 = read.csv("CMA_YSI_20200117-20200206.csv",
               header=T, stringsAsFactors=F, sep=",")
df4 <- df4[-1,]


df5 = read.csv("CMA_YSI_20200117.csv",
               header=T, stringsAsFactors=F, sep=",")
df5 <- df5[-1,]


df6 = read.csv("CMA_YSI_20200206-20200221.csv",
               header=T, stringsAsFactors=F, sep=",")
df6 <- df6[-1,]


df7 = read.csv("CMA_YSI_20200221-20200402.csv",
               header=T, stringsAsFactors=F, sep=",")
df7 <- df7[-1,]


df8 = read.csv("CMA_YSI_20200403-20200514.csv",
               header=T, stringsAsFactors=F, sep=",")
df8 <- df8[-1,]


df9 = read.csv("CMA_YSI_20200514-20200710.csv",
               header=T, stringsAsFactors=F, sep=",")
df9 <- df9[-1,]


df <- bind_rows(df1, df2, df3, df4, df5, df6, df7, df8, df9, .id= NULL)

rm(list=setdiff(ls(), c("df")))


df <- df %>%                     
  rename(sst = Temp, 
         sss = Sal,
         o2_mg_l = ODO,
         o2_sat = ODOsat,
         pH_mv = pH.1,
         chl_ugl = Chl,
         chl_rfu = Chl.1,
         Turb = Turbid.)



df <- df %>%
  mutate(datetime =  paste(df$Date,df$Time))

str(df)

df$datetime <- as.POSIXct(df$datetime, format = "%Y/%m/%d %H:%M:%S", tz = "GMT")



df <- df %>%
  arrange(datetime)


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


str(df)



cma_2020 <- select(df, datetime, everything())


save(cma_2020, file = "CMA_YSI_20191108-20200710.RData")

rm(list=ls())

load(file = "CMA_YSI_20191108-20200710.RData")

str(cma_2020)

write.csv(cma_2020, file = "CMA_YSI_20191108-20200710.csv", row.names = F)


