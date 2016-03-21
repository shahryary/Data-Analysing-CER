# Plots ----
# . is a synonym for list
# we can quote functions and then eval them

toRun = quote( .(MeankWh = mean(kWh)))
weekly_kWh <- mainData[, 
                      eval(toRun),
                      by=.(hour,Day,month,year)] # mean per half hour by Day,month &  year

# giving information according to the mean per half hour by Day,month & year  
minkwh <- min(weekly_kWh$MeankWh)
maxkwh <- max(weekly_kWh$MeankWh)
plot(weekly_kWh$MeankWh[weekly_kWh$year == 2009 & weekly_kWh$month == 10 & weekly_kWh$Day == "Monday"],
     axes=FALSE,
     ylim = c(minkwh,maxkwh),
     col = "1",
     ylab = "Mean kWh",
     lab = c(12,8,2),
     xlab = "Hour",
     pch=0,
     type="l")

axis(1, at=2*1:12, lab=c("00:00","02:00","04:00","08:00","10:00","12:00","14:00","16:00",
                         "18:00","20:00","22:00","24:00"),las=1)
axis(2, at = seq(0, 2, by = 0.1), las=1)
box()

lines(weekly_kWh$MeankWh[weekly_kWh$year == 2010 & weekly_kWh$month == 10 & weekly_kWh$Day == "Tuesday"],
      col = "2",
      pch=1,
      lty=2,
      lab = c(12,8,2),
      xlab = "",
      ylab = "",
      type="l")

lines(weekly_kWh$MeankWh[weekly_kWh$year == 2009 & weekly_kWh$month == 10 & weekly_kWh$Day == "Wednesday"],
      col = "3",
      pch=2,
      lty=3,
      lab = c(12,8,2),
      xlab = "",
      ylab = "",
      type="l")
lines(weekly_kWh$MeankWh[weekly_kWh$year == 2009 & weekly_kWh$month == 10 & weekly_kWh$Day == "Thursday"],
      col = "4",
      pch=3,
      lty=4,
      lab = c(12,8,2),
      xlab = "",
      ylab = "",
      type="l")
lines(weekly_kWh$MeankWh[weekly_kWh$year == 2009 & weekly_kWh$month == 10 & weekly_kWh$Day == "Friday"],
      col = "5",
      pch=4,
      lty=5,
      lab = c(12,8,2),
      xlab = "",
      ylab = "",
      type="l")
lines(weekly_kWh$MeankWh[weekly_kWh$year == 2009 & weekly_kWh$month == 10 & weekly_kWh$Day == "Saturday"],
      col = "6",
      pch=10,
      lty=6,
      lab = c(12,8,2),
      xlab = "",
      ylab = "",
      type="l")
lines(weekly_kWh$MeankWh[weekly_kWh$year == 2009 & weekly_kWh$month == 10 & weekly_kWh$Day == "Sunday"],
      col = "7",
      pch=13,
      lty=7,
      lab = c(12,8,2),
      xlab = "",
      ylab = "",
      type="l")
legend("topleft", 
       col=c(1:7),
       lty=1:7,
       box.lty=0,
       cex = 0.6,
       pch=c(0,1,2,3,4,10,13),
       title="Days: ",
       legend=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
)


