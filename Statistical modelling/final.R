require(leaps)  
require(MASS)   
require(lars)
library(foreach)
require(ggplot2)
library(glmnet)


#a)
LA<-read.table('LAozone.txt', sep=",", header=T)
n<-length(LA[,1])*(2/3)
index <- sample(1:nrow(LA),n)
datT <- LA[index,]
datt<-LA[!(1:nrow(LA) %in% index),]

#2)
#trainerror
option <- list()
Testerror<-list()
Trainerror<-list()
Trainerror[1] <- sum(scale(datT[,1]^(1/3),scale=FALSE)^2)
Testerror[1] <-  sum((datt[,1]^(1/3) - mean(datT[,1]^(1/3)))^2)
for(i in 1:9)
{
  option[[i]] <- lm(datT$ozone^(1/3)~.,data=datT[,c(TRUE,summ[i,])])
  Trainerror[i+1]<- sum(option[[i]]$residuals^2)
  pred <- predict(option[[i]],datt)
  Testerror[i+1] <- sum((pred - (datt[,1])^(1/3))^2)
}
Trainerror <- as.numeric(Trainerror)/n
Testerror <- as.numeric(Testerror)/(length(LA[,1])-n)
#plot
qplot(x=k,y=Trainerror,data=data.frame(k=1:9,Trainerror=Trainerror[2:10]),xlab="k", ylab="trainerror")
qplot(x=k,y=Testerror,data=data.frame(k=1:9,Testerror=Testerror[2:10]),xlab="k", ylab="testerror")

#b)
#plot
lasso <- lars(as.matrix(datT[,2:10]),as.matrix(datT[,1])^(1/3), type = "lasso")
plot(lasso)
#
s <- seq(1,9,by=0.01)
predlasso <- predict.lars(lasso, as.matrix(datT[,-1]), s=s,type="fit")
trainlasso <- as.data.frame(apply(predlasso$fit,2,"-",y=(datT[,1,drop=FALSE])^(1/3)))
Trainerrorlasso <- apply(trainlasso^2,2,mean)

predlasso <- predict(lasso,as.matrix(datt[,-1]),s=s, type = "fit")
testlasso <- as.data.frame(apply(predlasso$fit,2,"-",y=(datt[,1,drop=FALSE])^(1/3)))
TestErrorsLasso <- apply(testlasso^2,2,mean)

qplot(x=s,y=trainlasso,data=data.frame(s=s,trainlasso = Trainerrorlasso),xlab="s", ylab="trainlasso")
qplot(x=s,y=testlasso,data=data.frame(s=s,testlasso=TestErrorsLasso),xlab="s", ylab="testlasso")

#c)
lambda <- seq(0,n*3,by=0.1)
ridge <- lm.ridge(datT$ozone^(1/3)~.,data=datT,lambda=lambda)

RC <- ridge$coef/ridge$scales
Intercept <-  ridge$ym -  apply(ridge$xm*RC,2,sum)
predT <- t(t(as.matrix(datT[,-1]) %*% RC) + Intercept)
trainridge<- as.data.frame(apply(predT,2,"-",y=(datT[,1,drop=FALSE])^(1/3)))
TrainE <- apply(trainridge^2,2,mean)

predt <- t(t(as.matrix(datt[,-1]) %*% RC) + Intercept)
testridge <- as.data.frame(apply(predt,2,"-",y=(datt[,1,drop=FALSE])^(1/3)))
TestE <- apply(testridge^2,2,mean)

qplot(x=apply(ridge$coef^2,2,sum),y=TrainE,xlab="L", ylab="testerror")
qplot(x=apply(ridge$coef^2,2,sum),y=TestE,xlab="L", ylab="testerror")


