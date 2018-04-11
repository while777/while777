library(timeDate)
library(forecast)
library(zoo)

#1
air <- AirPassengers
acf(air, lag.max=30)
x<-decompose(air)
plot(x)
plot(x$seasonal)
#to achieve stationarity, could take away seasonality
air.fit <- arima(air,order=c(0,1,1), seasonal=list(order=c(0,1,1), period=12))
#show no significant autocorrelation
tsdiag(air.fit)
acf(air.fit$residuals)
qqnorm(air.fit$residuals)
qqline(air.fit$residuals)
#values are normal, go ahead forcast
air.forecast <- forecast(air.fit,12)
plot.forecast(air.forecast)

#2
library(zoo)
library(xts)
library(timeDate)
library(forecast)
url <- "http://ichart.finance.yahoo.com/table.csv?s=IBM&a=00&b=2&c=1962&d=05&e=26&f=2013&g=d&ignore=.csv"
IBM.df <- read.table(url,header=TRUE,sep=",")
head(IBM.df)							# Look at the first few lines
IBM <- xts(IBM.df$Close,as.Date(IBM.df$Date))			# Make a time series object
plot(IBM)							# Plot the time series
IBM.1982 <- window(IBM,start="1982-01-01", end="2013-01-23")	# Select at a subset
fit <- auto.arima(IBM.1982)					# Auto fit an ARIMA model