# plot time series forecasting result, incl. trend, forecast and bounds
# Yadi
# 
# March 2016


plotForecastResult <- function(x, title=NULL) {
  x <- x[order(x$date),]
  max.val <- max(c(x$actual, x$upper), na.rm=T)
  min.val <- min(c(x$actual, x$lower), na.rm=T)
  plot(x$date, x$actual, type="l", col="grey", main=title,
       xlab="Date", ylab="Mean KWh",
       xlim=range(x$date), ylim=c(min.val, max.val))
  grid()
  lines(x$date, x$trend, col="yellowgreen")
  lines(x$date, x$pred, col="green")
  lines(x$date, x$lower, col="blue")
  lines(x$date, x$upper, col="blue")
  
  legend("bottomleft", col=c("grey", "yellowgreen", "green", "blue"), bty = "n",
         inset=.05,horiz=FALSE,cex = 0.75,lwd=2, xjust=1, seg.len=1.2, lty=2,
         c("Actual", "Trend", "Forecast", "Lower/Upper Bound"))
}