
# Preparing to data-frame 

# Depend on your system it may be use long time
# use system.time(X) to get reading time

# Importing multi txt files into R ( Reading txt directory  
# and import all of them as a data frame )
# BEFORE IMPORT files DO THIS command IN YOUR CONSOLE 
# DO this using "cat File1.txt File2.txt File3.txt File4.txt File5.txt File6.txt > catFiles.txt"

setwd("/Directory_of_your_files/")
getwd()
list.files()

# catFiles.txt is large file(All records)- so we want to create our columns and reformating 
# our data then we can export by as we want!
temp = list.files(pattern="catFiles.txt")
# loading catFiles.txt (more than gigbyte) to dataframe (mainData) 
system.time(for (i in 1:length(temp)) assign("mainData", fread(temp[i] )))
# renaming and sorting DF
names(mainData)[1]<-"ID"
names(mainData)[2]<-"timestamp"
names(mainData)[3]<-"kWh"
mainData <- mainData[with(mainData, order(ID, timestamp)),]
setkeyv(mainData, "ID")
head(mainData, n=10)


# create real date/time variables ----
# For some reason the supplied timestamp is:
# Day code: digits 1-3 (day 1 = 1 January 2009)
#           digits 4-5 (half hour 1 - 48) 1= 00:00:00 – 00:29:59

mainData$day <- as.numeric(substr(mainData$timestamp, 1, 3))
mainData$halfhour <- as.numeric(substr(mainData$timestamp, 4, 5))
mainData$datetime_z <- as.POSIXct("01/01/2009 00:00:00", tz = , "", "%d/%m/%Y %H:%M:%S")
mainData$datetime_start <- mainData$datetime_z + # start with date zero
  (mainData$day*24*60*60) + # add number of days
  ((mainData$halfhour-1)*30*60) # add halfhours but subtract 1 as first needs to be '0'

# remove unwanted variables to save memory
mainData$timestamp <- NULL
mainData$day <- NULL
mainData$halfhour <- NULL
mainData$datetime_z <- NULL

outpath <- "/Volumes/DISK_IN/Projects"
# save the subsamples, do not save the whole file as it will be very large
# use a pair of loops to prevent typing errors!

# this lines will be create sample like this Datasample form 2009-10-01 to 2009-10-31
# So, if you want speacial month and year just put in "years" 

# We are saving results in csv file to use it latter-
# re-run this script for every time it is not good idea( spending more time to calculate and etc.)
# for that reason we just excuting once time this script then saving into csv files
# and after that just read csv files

years <- c("2009","2010")
samples <- c("DataSample")

for (y in years) {
  for (s in samples) {
    print(paste0("Saving ", s, " in ", y))
### October samples
    dateSt <- paste0(y,"-10-01")  # 
    dateEn <- paste0(y,"-10-31")
    date_start<-as.POSIXct(dateSt,tz="")
    date_end<-as.POSIXct(dateEn,tz="")
    outfile <- paste0(outpath,"/","October_",y,"_",s,".csv")
    print(paste0("Saving: ", outfile))
    write.csv(
      mainData[
        mainData$datetime_start %in% date_start:date_end],
      row.names = FALSE,
      file = outfile)
    
### December samples
    dateSt <- paste0(y,"-12-01")  #
    dateEn <- paste0(y,"-12-31")
    date_start<-as.POSIXct(dateSt,tz="")
    date_end<-as.POSIXct(dateEn,tz="")
    outfile <- paste0(outpath,"/","December_",y,"_",s,".csv")
    print(paste0("Saving: ", outfile))
    write.csv(
      mainData[
        mainData$datetime_start %in% date_start:date_end],
      row.names = FALSE,
      file = outfile)
  }
}


