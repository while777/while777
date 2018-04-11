#Download Data Files:
#data.csv:  http://thinktostart.com/data/data.csv
#names.csv:  http://thinktostart.com/data/names.csv

#Load the two files into R:
dataset <- read.csv("date1.csv",header=FALSE,sep=" ")
names <- read.csv("name1.csv",header=FALSE,sep=" ")

#Set the names of the dataset dataframe:
names(dataset) <- sapply((1:nrow(names)),function(i) toString(names[i,1]))

#make column y a factor variable for binary classification (spam or non-spam)
dataset$y <- as.factor(dataset$y)


#get a sample of 1000 rows
sample <- dataset[sample(nrow(dataset), 1000),]


#Set up the packages:
require(caret)
library(kernlab)
library(doSNOW)
library(parallel)
library(doParallel)
require(pls)

#Split the data in dataTrain and dataTest
trainIndex <- createDataPartition(sample$y, p = .9, list = FALSE, times = 1)
dataTrain <- sample[ trainIndex,]
dataTest  <- sample[-trainIndex,]

training = dataTrain[, 58]


pcr_model <- pcr(dataTrain[, 58]~.  , ncomp = 57, data = dataTrain,  validation = "CV")
pcr_pred <- predict(pcr_model, dataTrain, ncomp = 40)

a <- as.numeric(as.character(pcr_pred))

b <- as.numeric(as.character(training))

c <- (a - b)



#x <- train(y ~ .,
           #data = dataTrain,
           #method = "pls",
           #preProc = c("center", "scale") )

#Evaluate the model
#pred <- predict(x,dataTest)
#predacc <- confusionMatrix(pred,dataTest$y)
