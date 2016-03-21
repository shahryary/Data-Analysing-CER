toRun = quote( .(MeankWh = mean(kWh)))
hourlykWh <- mainData[, 
                       eval(toRun),
                       by=.(hour,month,year)] # mean per half hour by month &  year

# Automatic ARIMA forecasts
fit <- auto.arima(hourlykWh$MeankWh)
plot(forecast(fit, h=20))
x=hourlykWh$hour
y=auto.arima(hourlykWh$MeankWh)
plot(forecast(y,h=20) )
points(1:length(x),fitted(y), type="l",col="green")

tail(hourlykWh,n=10)
#------------------------------------------------ 

toRun = quote( .(MeankWh = mean(kWh)))
test_kWh <- mainData[, 
                    eval(toRun),
                    by=.(date)] # mean per half hour by month &  year
tail(test_kWh,n=10)
test_kWh$date <- as.Date(as.character(test_kWh$date),  format="%Y-%m-%d")
range(test_kWh$date)

rates_Kwh <- test_kWh[order(test_kWh$date), ]

plot(rates_Kwh$date, rates_Kwh$MeankWh, type = "l",col=c(1:2))

years <- format(rates_Kwh$date, "%Y")

tab <-table(years)
tab
mean(tab[1:(length(tab) - 1)])
source("forecast.R")  ## see code file in section 5
result.arima <- forecastArima(rates_Kwh, n.ahead = 30)
source("plotForecastResult.R")  ## see code file in section 5
png("pic01.png", 1280, 800)
plotForecastResult(result.arima, title = " Mean forecasting with ARIMA")
dev.off()
#--------------------------------------------------------------------------------
# Forecasting with STL
#--------------------------------------------------------------------------------
result.stl <- forecastStl(rates_Kwh, n.ahead = 30)
plotForecastResult(result.stl, title = "Exchange rate forecasting with STL")
## exchange rate in 2014
result <- subset(result.stl, date >= "2010-10-01")
plotForecastResult(result, title = "Exchange rate forecasting with STL (2014)")

