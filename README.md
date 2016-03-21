# Data-Analysing-CER
Data Analysing "CER Smart Metering Project" in R language
Plesae Read this file.

# mergin files into one file
# DO this using "cat File1.txt File2.txt File3.txt File4.txt File5.txt File6.txt > catFiles.txt"

To Run Scripts please follow  this steps:

1- Run "Packages.R" - This file will be install required package 

2- Split.R- will do split all data file to csv file according to the your input 
  - you have run this file JUST ONE TIME - if you want to special date-time you can re-excute this script.

3- ReFormatingData.R - will be transform all data into readable format ( data-time,...)
  - you have run this file JUST ONE TIME - more additional information commented.

# Note: just remmber you have done step 1,2,3 then you can run another scripts  

# AnalyseData_01.R is giving overview about over data, also:

- in this file we can calculate mean kWh consumption for evening peak 16:00 - 19:00 (or your peak time)
- run acf test for selected house.
- run pacf test for selected house.

# in AnalyseData_02.R we just ploting mean Kwh consumption for 24h for all our data

# in script Time_Series_forcasting.R, we are doing Automatic ARIMA forecasts and Forecasting with STL
- the script forecast.R & plotForecastResult.R is external script which we used in our script

# RandomForest.R contents this methods:
- EVTREE (Evoluationary Learning)
- using varSelRF package to calculate RF
- CoreModel by using CORElearn


Then you have run either this R script file ( you can run which one you want)
, , Kmeans.R, forecast.R, cluster.R  