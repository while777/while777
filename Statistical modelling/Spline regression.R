library(splines)
sinh = function(x)
  {
  y = (exp(x)-exp(-x))*0.5
}

x = seq(0, 5, by=0.01)
y = sinh(x)
plot(x,y)


for (k in 15)
{
    x1<-matrix( 0, nrow =length(x), ncol = k)
    x1[, 1]<-matrix(1, nrow=length(x), ncol=1)
    x1[, 2]<-x
    theta <- NULL
    
  
    for (q in 1: k)
    {
          theta[q]<-((x[length(x)]-x[1])/(k+1))*q
    }
    
    
    for (j in 3:k)
    {
        
        for (i in 1:length(x)) 
        {
                  
        x1[i, j]<-(max(x[i]-theta[j-2],0)^3-max(x[i]-theta[length(theta)], 0)^3)/(theta[length(theta)]-theta[j-2])-
          (max(x[i]-theta[length(theta)-1],0)^3-max(x[i]-theta[length(theta)], 0)^3)/(theta[length(theta)]-theta[length(theta)-1])
                
        }
        
    }
    
}


fit1 <- lm(y~x1)
values1 <- predict(fit1, interval="prediction", level = 0.95)
lines(x, values1[,1], col="red", lwd=2)


F5 <- ns(x, df=5)
fit1 <- lm(y~F5)
values1 <- predict(fit1, interval="prediction", level = 0.95)
lines(x, values1[,1], col="green", lwd=1)

F10 <- ns(x, df=10)
fit2 <- lm(y~F10)
values2 <- predict(fit2, interval="prediction", level = 0.95)
lines(x, values2[,1], col="blue", lwd=1)

F15 <- ns(x,df=15)
fit3 <- lm(y~F15)
values3 <- predict(fit3,interval="prediction", level = 0.95)
lines(x, values3[,1], col="red", lwd=1)

legend('topleft', legend=c("K=5", "K=10","K=15"), col=c("green","blue","red"), lwd=2)

