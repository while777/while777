source('kNN.R')

train<-read.table('training.txt',sep=',',header=F)
test<-read.table('test.txt',sep=',',header=F)

predy.k5<-kNN(train[,-3],train[,3],test,5)
predy.k10<-kNN(train[,-3],train[,3],test,10)
predy.k15<-kNN(train[,-3],train[,3],test,15)

plot(test[predy.k5==1,1],test[predy.k5==1,2],col='blue',xlim=c(min(test[,1]), max(test[,1])),ylim=c(min(test[,2]), max(test[,2])), xlab='x1',ylab='x2',main='k=5')
points(test[predy.k5==0,1],test[predy.k5==0,2],col='red')

plot(test[predy.k10==1,1],test[predy.k10==1,2],col='blue',xlim=c(min(test[,1]), max(test[,1])),ylim=c(min(test[,2]), max(test[,2])), xlab='x1',ylab='x2',main='k=10')
points(test[predy.k10==0,1],test[predy.k10==0,2],col='red')

plot(test[predy.k15==1,1],test[predy.k15==1,2],col='blue',xlim=c(min(test[,1]), max(test[,1])),ylim=c(min(test[,2]), max(test[,2])), xlab='x1',ylab='x2',main='k=15')
points(test[predy.k15==0,1],test[predy.k15==0,2],col='red')