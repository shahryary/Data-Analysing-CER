# introduce large scale time series data
# introduce data tables
# introduce sub-setting 
# introduce zoo package for manipulating time series
# introduce autocorrelation


# CHANGE PATH 
# Reading csv file into data frame by "fread" this method faster to read huge data
mainData <- fread("/PATH-YOUR-FILE/FinalSample_01.csv")                                



# Plots ----
# . is a synonym for list
# we can quote functions and then eval them
toRun = quote( .(MeankWh = mean(kWh)))
hourlykWh <- mainData[, 
                      eval(toRun),
                      by=.(hour,month,year)] # mean per half hour by month &  year

# overview
qplot(hourlykWh$hour ,MeankWh , data = hourlykWh, colour = as.factor(hourlykWh$month), geom = "line")

# use min/max to set limits of plot correctly
minkwh <- min(hourlykWh$MeankWh)
maxkwh <- max(hourlykWh$MeankWh)
# PLOTING ACCORDING TO THE YEAR AND MONTH
plot(hourlykWh$MeankWh[hourlykWh$year == 2009 & hourlykWh$month == 10],
     ylim = c(minkwh,maxkwh),
     col = "1",
     ylab = "Mean kWh",
     lab = c(12,8,2),
     xlab = "Hour",
     pch=0,
     type="l")
# familiar daily profile?
#par(new = TRUE)
lines(hourlykWh$MeankWh[hourlykWh$year == 2010 & hourlykWh$month == 10],
     ylim = c(minkwh,maxkwh),
     col = "2",
     lab = c(12,8,2),
     xlab = "",
     ylab = "",
     pch=1,
     type="l")
#par(new = TRUE)
lines(hourlykWh$MeankWh[hourlykWh$year == 2009 & hourlykWh$month == 12],
     ylim = c(minkwh,maxkwh),
     col = "3",
     lab = c(12,8,2),
     xlab = "",
     ylab = "",
     pch=2,
     type="l")
#par(new = TRUE)
lines(hourlykWh$MeankWh[hourlykWh$year == 2010 & hourlykWh$month == 12],
     ylim = c(minkwh,maxkwh),
     col = "4",
     lab = c(12,8,2),
     xlab = "",
     ylab = "",
     
     type="l")

legend("topleft", 
       col=c(1:4),
       lty=(1:4),
       box.lty=0,
       cex = 0.6,
       title="Years",
       legend=c("October 2009","October 2010","December 2009","December 2010")
)

# calculate mean kWh consumption for evening peak 16:00 - 19:00 
# October 2009 (pre trial)
base_Oct2009kWhDT <- as.data.table(mainData[mainData$hour > 15 & mainData$hour < 20 &
                                              mainData$year == 2009 &
                                              mainData$month == 10])

m <- mean(base_Oct2009kWhDT$kWh)

# how skewed is that?
summary(base_Oct2009kWhDT$kWh)

# sd
s <- sd(base_Oct2009kWhDT$kWh)
# sample size calculation
# see ?power.t.test
# let us assume we see a 10% change in the mean due to higher evening prices
# we want to test for a reduction (1 sided) 
# for now assume this is a two sample test
power.t.test(delta = 0.1*m, sd = s, power = 0.8, type = "two.sample",
             alternative = "one.sided")


# Time series analysis ----
# create a subset for the first household only
hh_1002 <-subset(mainData, mainData$ID == 7443)

# select just October - you'll see why in a minute
##hh_1024oct <- subset(hh_1024, hh_1024$oct == 1)
#L: we can select data from the dataframe by date range

date_start<-as.POSIXct("2010-10-01",tz="")
date_end<-as.POSIXct("2010-10-31",tz="")
hh_1002oct <- hh_1002[as.POSIXct(hh_1002$l_datetime) %in% date_start:date_end]

# need to check is sorted by datetime (always increasing) and evenly spaced
# create zoo (time series) object to do this
hh_1002oct_z=zoo(hh_1002oct,order.by=hh_1002oct$l_datetime)


# plot data
plot(hh_1002oct$kWh)

# run acf with the first household only up to just over 48 hours (96 half hours)
acf(hh_1002oct$kWh, lag.max = 100)
# what do we conclude from that?

# let's find the *partial autocorrelation function* (pacf)
# this is the effect of successive lags with the effect of previous lags removed
# It shows more clearly how the random variation depends on the previous lags
# see https://www.youtube.com/watch?v=R-oWTWdS1Jg
pacf(hh_1002oct$kWh, lag.max = 100)


