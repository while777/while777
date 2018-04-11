library(forecast)
library(zoo)
library(fma)
library(expsmooth)
librart(tseries)
library(fpp)
library(sandwich)


#find
usconsumption
fit<- tslm(consumption ~ income, data=usconsumption)
plot(usconsumption, ylab="% change in consumption and income",
     plot.type="single", col=1:2, xlab="Year")
legend("topright", legend=c("Consumption","Income"),
       lty=1, col=c(1,2), cex=.9)
plot(consumption ~ income, data=usconsumption, 
     ylab="% change in consumption", xlab="% change in income")
abline(fit)
summary(fit)

res <- residuals(fit)
par(mfrow=c(1,2))
plot(res, ylab="Residuals",xlab="Year")
Acf(res, main="ACF of residuals")
#autocorreation Dubin-watson test
dwtest(fit, alt="two.sided")





