toRun = quote( .(MeankWh = mean(kWh)))
test_ <- mainData[, 
                   eval(toRun),
                   by=.(date)] # mean per half hour by month &  year
datetxt <- as.Date(test_$date)

RM_kWh <- data.frame(date = datetxt,
                 year = as.numeric(format(datetxt, format = "%Y")),
                 month = as.numeric(format(datetxt, format = "%m")),
                 day = as.numeric(format(datetxt, format = "%d")))
RM_kWh$MeankWh<- test_$MeankWh
RM_kWh$date<-NULL
fit<-randomForest(formula = MeankWh ~ year+month+day, data = RM_kWh, ntree = 100)

frmla<-MeankWh ~.


############### 
## EVTREE (Evoluationary Learning)

ev.raw = evtree(frmla, data=RM_kWh)
ev.raw
plot(ev.raw)
table(predict(ev.raw), RM_kWh$MeankWh )
1-mean(predict(ev.raw) == RM_kWh$month)

################## 
## randomForest
fit.rf = randomForest(frmla, data=RM_kWh)
print(fit.rf)
importance(fit.rf)
plot(fit.rf)
plot( importance(fit.rf), lty=2, pch=16)
lines(importance(fit.rf))
imp = importance(fit.rf)
impvar = rownames(imp)[order(imp[, 1], decreasing=TRUE)]
op = par(mfrow=c(1, 3))
for (i in seq_along(impvar)) {
  partialPlot(fit.rf, RM_kWh, impvar[i], xlab=impvar[i],
              main=paste("Partial Dependence on", impvar[i]),
              ylim=c(0, 1))
}


##################
## varSelRF package

## Example of importance function show that forcing x1 to be the most important
## while create secondary variables that is related to x1.


y=RM_kWh$month+RM_kWh$year+RM_kWh$day
rf1 = randomForest(y~., data=RM_kWh, mtry=2, ntree=50, importance=TRUE)
importance(rf1)
cor(RM_kWh)
plot(cor(RM_kWh))
###############

##################
## CORElearn

## Random Forests
fit.rand.forest = CoreModel(frmla, data=RM_kWh, model="rf", selectionEstimator="MDL", minNodeWeightRF=5, rfNoTrees=100)
plot(fit.rand.forest)

## decision tree with naive Bayes in the leaves
fit.dt = CoreModel(frmla, RM_kWh, model="tree", modelType=4)
plot(fit.dt, RM_kWh)

my.sub = subset(RM_kWh, !is.na(RM_kWh$day))
my.sub
fit.rt = CoreModel(frmla, my.sub, model="regTree", modelTypeReg=1)
summary(fit.rt)
pred = predict(fit.rt, my.sub)
print(pred)
plot(pred)

##################
