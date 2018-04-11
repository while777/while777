library(MASS)
library(e1071)
library(grid)
library(vcd)

######1)
train<-read.table('geno_train.txt', sep=",", header=TRUE)
test<-read.table('geno_test.txt', sep=",", header=TRUE)
sort<- train[with(train, order(population)), ]
#plot
x<-nrow(subset(train, train$population=="Hispanic"))
y<-nrow(subset(train, train$population=="Caucasian"))
z<-nrow(subset(train, train$population=="African American"))
par(mfrow=c(3,5))
for (i in 1:15)
{ 
   plot(density(sort[(1:x),i]),col="red")
   lines(density(sort[(x+1):(x+y),i]),col="green")
   lines(density(sort[(x+y+1):(x+y+z),i]),col="black")
}

######2)
#lda
geno<-lda(train$population~.,data=train)
plda<-predict(object = geno, newdata = test)
output = test$population
n<-table(plda$class, output)
nn<-prop.table(n)
#svm
set.seed(100)
Xdat = as.matrix(train[,1:15])
Species = as.factor(train$population)
model = svm(Xdat, Species, probability = TRUE) 
pred = predict(model, as.matrix(test[,1:15]), probability = TRUE)
output = test$population
m<-table(pred, output)
mm<-prop.table(m)

#######3)
pca = prcomp(train[,-16],scale. = T) 
test.data <- predict(pca, newdata = test[,-16])
train.data <- data.frame(pca$x)
svmnewtestdata<-test.data[,1:3]
svmnewtraindata<-train.data[,1:3]
ldanewtraindata<-data.frame(train.data[,1:3],train$population)
ldanewtestdata<-data.frame(test.data[,1:3],test$population)
#lda
geno<-lda(ldanewtraindata$train.population~.,data=ldanewtraindata)
plda <- predict(object = geno, newdata = ldanewtestdata)
rate = test$population
q<-table(plda$class, rate)
qq<-prop.table(n)
#svm
set.seed(100)
model = svm(svmnewtraindata, train$population, probability = TRUE) 
pred = predict(model, svmnewtestdata, probability = TRUE)
rate = test$population
p<-table(pred, rate)
pp<-prop.table(m)