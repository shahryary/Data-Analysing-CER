# PLEASE JUST RUN ONCE AFTER SPLIT.R SCRIPT 

# IF THIS RESULT CREATED FILE "FinalSample_01.CSV" THEN NEXT TIME DO NOT RUN THIS SCRIPT


# This file creating and reformating raw data to main data frame and save it to csv file to reuse again 
#

# clear the workspace
rm(list=ls())
# change the working directory to where you put the data
# setwd("<where you put the data>")
# In my case:
setwd("/Volumes/DISK_IN/Projects/")
print(paste0("Working directory is: ", getwd()))

# Reading Sample Files in Directory 
# Load the data by looping over months and years
# YOu created this files in Split.R
# be careful your Directory PATH is correct
months <- c("October", "December")
years <- c("2009", "2010")
for (m in months) {
  for (y in years) {
    print(paste0("Reading in ",m,"_",y,"_DataSample.csv"))
    # need to set this table name according to values of m and y
    # why is this soooo hard in R? It must be a common need
    name <- paste0(m,"_",y,"_DataSample")
    assign(name, as.data.table(
      read.csv(paste0(m,"_",y,"_DataSample.csv"))))
  }
}

# what's here?
tables()


# combine the data into one big table in long format
# more use for summaries etc
# if you created more Samples just put name in list below like samle I commented.
l = list(October_2009_DataSample,December_2010_DataSample)#December_2009_DataSample,October_2010_DataSample,
mainData <- as.data.table(rbindlist(l))
# delete old tables to save memory
resCER_October_2009_DT <- NULL
resCER_December_2009_DT <- NULL
resCER_October_2010_DT <- NULL
resCER_December_2010_DT <- NULL

#L: We can create a date vector using R's date conversion functions
#mainData$l_datetime<-as.POSIXct(mainData$datetime_start,tz = "", "%Y-%m-%d %H:%M:%S")


names(mainData)[3]<-"l_datetime"
head(mainData, n=10)
tail(mainData, n=10)
typeof(mainData$l_datetime)
# now remove old datetime to save memory
mainData$datetime_start <- NULL


# extract:
# year
# month
# date
# hour of the day variable (24 hour format)
# relies on the POSIXct time having a regular structure so that the hour is ALWAYS character 12 & 13
mainData$year <- as.numeric(substr(mainData$l_datetime, 1, 4))
mainData$month <- as.numeric(substr(mainData$l_datetime, 6, 7))
mainData$date <- as.POSIXct(substr(mainData$l_datetime, 1, 10))
mainData$hour <- as.numeric(substr(mainData$l_datetime, 12, 13))
mainData$Day<-weekdays(ttt<-strptime(mainData$l_datetime, "%Y-%m-%d %H:%M:%S"))
ttt<-NULL
#---------------------------------------------
#  saving file to re-use again
#---------------------------------------------
# save sample file to use it latter
# CHANGE PATH 
outpath<-"/Volumes/DISK_IN/Projects"
outfile <- paste0(outpath,"/","FinalSample_01",".csv")

print(paste0("Saving: ", outfile))
write.csv(mainData,row.names = FALSE,file = outfile)
#------------------------------------------------------
# mainData is Main Data-set which you can use in all time
