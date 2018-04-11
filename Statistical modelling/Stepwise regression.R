grocery<-read.table("grocery.txt", header = F, sep="")
names(grocery) <- c("Y", "X1", "X2", "X3" )


fit1<-lm(Y~X1+X2+X3,data=grocery)
summary(fit1)

fit0<-lm(Y~1,data=grocery)
fit.forward<-step(fit0,scope=list(lower=Y~1, upper=Y~X1+X2+X3),direction='forward')
summary(fit.forward)
fit.backward<-step(fit1,scope=list(lower=Y~1, upper=Y~X1 +X2+X3),direction='backward')
summary(fit.backward)

#subset<-leaps(x<-grocery[,1:3],y<-grocery[,4])
#plot(x=subset$size, y=subset$Cp, xlab='size',ylab='Cp')

var.test(fit1, fit.forward,alternative = "greater", con.level = "0.05")

