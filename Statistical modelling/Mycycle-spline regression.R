library(MASS)
data("mcycle")

plot(accel~times,data=mcycle)
mcycle.spline <- with(mcycle,smooth.spline(times,accel))
lambda <- mcycle.spline$lambda
lines(mcycle.spline)


plot(accel~times,data=mcycle)
mcycle.spline.5 <- with(mcycle,smooth.spline(times,accel,df=5))
mcycle.spline.10 <- with(mcycle,smooth.spline(times,accel,df=10))
mcycle.spline.15 <- with(mcycle,smooth.spline(times,accel,df=15))
lines(mcycle.spline.5,col="blue")
lines(mcycle.spline.10,col="green")
lines(mcycle.spline.15,col="red")
legend(44.5,-40,legend=c("df=5", "df=10","df=15"),col=c("blue","green","red"),lwd=2)


cv<- numeric(31)
df<-seq(5,20,l=31)
for(i in 1:31) cv[i] <- smooth.spline(mcycle$times,mcycle$accel,df=df[i])$cv.crit
plot(df, cv)
