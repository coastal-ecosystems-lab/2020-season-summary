
#alkalinity processing script updated 2020-02-11

#processing data from alkalinity method test on Jan 27th 2019

#CRM info ####

#goal for CRM from batch 162:
# S = 33.312
# TA 2403.72± 0.55 umol·kg-1

#goal for CRM from batch 130 from Stillman:
# S = 33.661
# TA 2238.04± 0.53 umol·kg-1


#goal for CRM from batch 186:
# S = 33.525
# TA 2212.00± 0.53 umol·kg-1


library(seacarb)
library(dplyr)

rm(list = ls())

#setwd("C:/Users/915712257/Box Sync/Nielsen Lab/RTC CeNCOOS/Seawater Chemistry/Data/TA/processed/20feb2020")

setwd("C:/Users/rrkad/Box Sync/Nielsen Lab/RTC CeNCOOS/Seawater Chemistry/Data/TA/processed/20feb2020")


results_filename <- "20200220-alk.titration.results"



list.files()

# [7] "AMB-2-1.csv"                              "AMB-2-2.csv"                             
# [9] "AMB-2-3.csv"                              "AMB-4-1.csv"                             
# [11] "AMB-4-2.csv"                              "AMB-4-3.csv"                             
# [13] "AMB-6-1.csv"                              "AMB-6-2.csv"                             
# [15] "AMB-6-3.csv"                              "BAYSTD1-02202020-1.csv"                  
# [17] "BAYSTD1-02202020-2.csv"                   "BAYSTD1-02202020-3.csv"                  
# [19] "BAYSTD1-02202020-4.csv"                   "BAYSTD1-02202020-5.csv"                  
# [21] "BAYSTD1-02202020-6.csv"                   "CRM186-02202020-1.csv"                   
# [23] "CRM186-02202020-2.csv"                    "CRM186-02202020-3.csv"                   
# [25] "SACRIFICE.csv"                           

#get character vector of samples ------------------------------------------------------

df_env = read.csv("20200220 sample metadata.csv",
                  header=T, stringsAsFactors=F, sep=",")

sample_list <- df_env$sample.id

len_loop <- length(sample_list)

results_list <- paste(sample_list, "results", sep = "-")

#read titration data into R -----------------------------------------------------------

for (i in 1:len_loop) {
#enter your csv file title below

filename <- sample_list[i]

df <- read.csv(paste0(filename,".csv"), header=T, stringsAsFactors=F, sep=",")

assign(sample_list[i], df)

}


#Titrant batch A1 density to molarity/normality calculation ----------------------------------
#parameters provided in batch documentation

#concentration = 0.100362 mol/kg +- 0.000009
#density = 1.02881 - ((1.061* 10^-4) * temperature) - ((4.10 * 10^-6) * temperature^2) grams/cm3
#density = 1.02449 at 22degC 
#HCl = 36.548 grams/mol

#temperature <- mean(data$temperature)

temperature_25_degC <- 25
 
density = 1.02881 - ((1.061* 10^-4) * temperature_25_degC) - ((4.10 * 10^-6) * temperature_25_degC^2) 
density <- signif(density,6)
print(density)
#1.02518

HCl_conc <- 0.100362

HCl_norm <- HCl_conc * (density / 1000) # mol/kg *(grams/cm3 * 1kg/1000grams) ends with units mol/cm3

HCl_norm <- HCl_norm * 1000 # (mol/cm3 * 1000cm3/L) ends with mol/L which is one to one for normality

C <- signif(HCl_norm,6)



#used to check values are what they should be
# S = data$S[1]
# print(S)
# 
# temperature = data$temperature 
# print(temperature)
# 
# pHTris = data$pHTris[1]
# print(pHTris)
# class(pHTris)
# 
# ETris=data$ETris[1]
# print(ETris)
# 
# E=data$E
# print(E)
# 
# weight=data$weight[1]
# print(weight)
# 
# volume=data$volume
# print(volume)

#calculate alkalinity -----------------------------------------------------------------------

# found data appending trick to use in a for loop here: https://stackoverflow.com/questions/29402528/append-data-frames-together-in-a-for-loop/29419402

datalist = list()

#ignore tibble warning in following loop. Yes tibbles are typically better yadda yadda yadda

for (i in 1:len_loop) {
  
data <- get(sample_list[i])


AT.25degC <- at(S=data$S[1], T=temperature_25_degC, pHTris=data$pHTris[1], d = density, C = C,
         ETris=data$ETris[1], E=data$E, weight=data$weight[1], volume=data$volume)

AT.lab.temp <- at(S=data$S[1], T=data$temperature, pHTris=data$pHTris[1], d = density, C = C,
         ETris=data$ETris[1], E=data$E, weight=data$weight[1], volume=data$volume)

AT.insitu.temp <- at(S=data$S[1], T=data$in.situ.temperature[1], pHTris=data$pHTris[1], d = density, C = C,
                ETris=data$ETris[1], E=data$E, weight=data$weight[1], volume=data$volume)

AT.25degC <- AT.25degC * 10^6

AT.lab.temp <- AT.lab.temp * 10^6

AT.insitu.temp <- AT.insitu.temp * 10^6

calculations <- data_frame(sample_list[i], AT.25degC, AT.lab.temp, AT.insitu.temp)

datalist[[i]] <- calculations # data appending trick: add it to your list

}

results_final <- bind_rows(datalist) #final data!!!


#saves a csv file with results

write.csv(results_final, file = paste0(results_filename,".csv"), row.names = FALSE) 

















#goal for CRM from batch 130 from Stillman:
# S = 33.661
# TA 2238.04± 0.53 umol·kg-1

#sample alkcrm1_batch130 @ 25degC
#[1] 2242.69878
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample alkcrm2_batch130 @ 25degC
#[1] 2247.53637
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample alkcrm3_batch130 @ 25degC
#[1] 2230.10362
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"



#sample BI-0075-P1-1 @ 25degC
#[1] 2114.14819
#sample BI-0075-P1-1 @ lab temperature
#[1] 2134.65584
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample BI-0075-P1-2 @ 25degC
#[1] 2138.91935
#sample BI-0075-P1-2 @ lab temperature
#[1] 2159.66724
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample BI-0075-P1-3 @ 25degC
#[1] 2142.24109
#sample BI-0075-P1-3 @ lab temperature
#[1] 2161.99787
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"


#sample BI-0075-P2-1 @ 25degC
#[1] 2135.23897
#sample BI-0075-P2-1 @ lab temperature
#[1] 2155.45803
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample BI-0075-P2-2 @ 25degC
#[1] 2133.48756
#sample BI-0075-P2-2 @ lab temperature
#[1] 2154.28233
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample BI-0075-P2-3 @ 25degC
#[1] 2129.4654
#sample BI-0075-P2-3 @ lab temperature
#[1] 2151.32432
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"



#sample BI-0075-P3-1 @ 25degC
#[1] 2124.93609
#sample BI-0075-P3-1 @ lab temperature
#[1] 2147.77061
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample BI-0075-P3-2 @ 25degC
#[1] 2132.39217
#sample BI-0075-P3-2 @ lab temperature
#[1] 2148.8173
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample BI-0075-P3-3 @ 25degC
#[1] 2126.4715
#sample BI-0075-P3-3 @ lab temperature
#[1] 2144.72115
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"


#goal for CRM from batch 130 from Stillman:
# S = 33.661
# TA 2238.04± 0.53 umol·kg-1

#sample alkcrm4_batch130 @ 25degC
#[1] 2249.35083
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample alkcrm5_batch130 @ 25degC
#[1] 2250.29156
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"

#sample alkcrm6_batch130 @ 25degC
#[1] 2272.6196
# attr(,"unit")
# [1] "umol/kg-soln"
# attr(,"name")
# [1] "Total Alkalinity"














#help info ####
# From ?at documentation

# example code from ?at documentation
# data(alkalinity)
# data <- alkalinity
# AT <- at(S=data$S[1], T=data$temperature, C=data$normality[1], pHTris=data$pHTris[1],
#          ETris=data$ETris[1], E=data$E, weight=data$weight[1], volume=data$volume)



#general usage
#at(S=35, T=25, C=0.1, d=1, pHTris=NULL, ETris=NULL, weight, E, volume)

# 
# S	Salinity, default is 35. S must be a single value, not a vector.
# 
# T	Temperature in degrees Celsius, default is 25oC, can be given as a vector or as a single value.
# 
# C	Normality of the acid, default is 0.1. C must be a single value, not a vector.
# 
# d	Density of the acid, default is 1. d must be a single value, not a vector.
# 
# pHTris pH used for the calibration of the electrode with the TRIS buffer. pHTris must be a single value, not a vector.
# 
# ETris	Potential used for the calibration of the electrode in mV. ETris must be a single value, not a vector.
# 
# weight Weight of the sample in g. weight must be a single value, not a vector.
# 
# E	Potential measured during the titration in mV. E must be a vector.
# 
# volume Volume of acid added to the sample in ml. volume must be a vector.










#scrapped ---------------------------



# 
# 
# #removes everything except for wanted data
# rm(list=setdiff(ls(), results_list))
# 
# files <- mget(ls())
# 
# df_env = read.csv("20200127 sample metadata.csv",
#                   header=T, stringsAsFactors=F, sep=",")
# 
# sample_list <- df_env$sample.id
# 
# len_loop <- length(sample_list)
# 
# results_list <- paste(sample_list, "results", sep = "-")
# 
# len_results <- length(results_list)
# 
# titration_run_results <- data_frame(get(results_list[1:len_results]))
# 
# final_results <- Reduce(rbind, results_list)
# 
# bind_rows(lapply(results_list, as.data.frame.list))
