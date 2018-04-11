library(quantmod) 
library(TTR)
library(rpart)
library(rpart.plot)

Intial_Equity = 100000

# Pulling NSE data from Yahoo finance
symbol = "MSFT"
data = getSymbols(symbol, from ="2010-01-01",auto.assign = FALSE)
colnames(data) = c("Open","High","Low","Close","Volume","Adjusted")

data = na.omit(data)
closeprice = Cl(data)

# Computing RSI
rsi = round(RSI(closeprice, n = 14, maType="WMA"),1)
rsi = c(NA,head(rsi,-1))

# Computing SMA and LMA
SlMA = 20; LMA = 50;

sma = round(SMA(closeprice, SlMA),1)
sma = c(NA,head(sma,-1))

lma = round(SMA(closeprice, LMA),1)
lma = c(NA,head(lma,-1))

# Computing ADX 
data22 = ADX(data[,c("High","Low","Close")])
data22 = as.data.frame(data22)
adx = round(data22$ADX,1)
adx = c(NA,head(adx,-1))

# add return column
data$Return = round(dailyReturn(data$Close, type='arithmetic'),2)
colnames(data) = c("Open","High","Low","Close","Volume","Adjusted","Return")

#assign class according to return >=0 or <=0
class = character(nrow(data))
class = ifelse(coredata(data$Return) >= 0,"Up","Down")

data2 = data.frame(data,class,rsi,sma,lma,adx)


data = data.frame(class,rsi,sma,lma,adx)
data = na.omit(data)

write.csv(data,file="decision tree charting.csv")

#test  

df = read.csv("decision tree charting.csv")
df = df[,-1]
colnames(df) = c("Class","RSI","SMA","LMA","ADX")

trainingSet<-df[1:500,]
testSet<-df[501:nrow(df),]

DecisionTree<-rpart(Class~RSI+SMA+LMA+ADX,data=trainingSet, cp=.001)

#test result
plotcp(DecisionTree)
summary(DecisionTree)
prp(DecisionTree,type=2,extra=8)
table(predict(DecisionTree,testSet,type="class"),testSet[,5],dnn=list('predicted','actual'))
