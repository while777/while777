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
#1)
trainn<-as.matrix(datT[,-1])
testt<-as.matrix(datt[,-1])
trainResponse<-as.matrix(datT[,1]^(1/3))
testResponse<-as.matrix(datt[,1]^(1/3))
bestsubset<-regsubsets(x=trainn,y=trainResponse,nbest=1,nvmax=10)
Cp<-coefficients(bestsubset,1:9)
subset<-leaps(x=trainn,y=trainResponse)
#plot
plot(x=subset$size,y=subset$Cp)
#plot
Bestsubset.summary <- summary(bestsubset)
plot(Bestsubset.summary$cp, xlab="degree", ylab="CP")

#2)
trainerror<-numeric()
testerror<-numeric()
for(i in 1:9)
{
  content<-rep(0,9)
  names(content)<-c("vh","wind","humidity","temp","ibh","dpg","ibt","vis","doy")
  content[names(Cp[[i]][-1])]<-Cp[[i]][-1]
  testerror[i]<-mean((testResponse-Cp[[i]][1]-
                                  testt%*%as.vector(content))^2)
  trainerror[i]<-mean((trainResponse-Cp[[i]][1]-
                                      trainn%*%as.vector(content))^2)
}
plot(1:9,ylim=c(0,max(testerror,trainerror)),type="n",
     xlab="Dimension",ylab="Error",main="Best subset test and training errors")
points(1:9,testerror,type="b",col="red")
points(1:9,trainerror,type="b",col="blue")

#####b)
lasso<-glmnet(trainn,trainResponse,family="gaussian",alpha=1,standardize=TRUE)
lacoff<-t(as.matrix(coef(lasso)))
lassorange<-lasso$lambda
Tserror<-numeric()
Trerror<-numeric()
for(i in 1:length(lassorange))
{
  Tserror[i]<-mean((testResponse-lacoff[i,1]-
                             testt%*%lacoff[i,-1])^2)
  Trerror[i]<-mean((trainResponse-lacoff[i,1]-
                                 trainn%*%lacoff[i,-1])^2)
}
plot(lassorange,lassorange,
     ylim=c(0,max(Tserror,Trerror)),type="n",
     xlab="Lambda",ylab="Error",main="LASSO test and training errors")
points(lassorange,Tserror,type="b",col="green",lwd=2)
points(lassorange,Trerror,type="b",col="red",lwd=2)


#####c)
ridgerange<-seq(0,220*3,by=0.1)
datT[,1]<-datT[,1]^(1/3)
LAridge<-lm.ridge(datT[,1] ~ .,data=datT,lambda=ridgerange)
rcoff<-t(as.matrix(coef(LAridge)))
Tserror<-list()
trerror<-list()
for(i in 1:length(ridgerange))
{
  Tserror[i]<-mean((testResponse-rcoff[i,1]-
                             testt%*%(rcoff[i,-1]))^2)
  trerror[i]<-mean((trainResponse-rcoff[i,1]-
                                 trainn%*%(rcoff[i,-1]))^2)
}
plot(ridgerange,ridgerange,
     ylim=c(0,max(Tserror,trerror)),type="n",
     xlab="Lambda",ylab="Error",main="Ridge test and training errors")
points(ridgerange,Tserror,col="red",lwd=1)
points(ridgerange,trerror,col="blue",lwd=1)

