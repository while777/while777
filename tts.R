library(MASS)
library(strucchange)
library(zoo)
library(vars)
library(quantmod)

#multivariate time series regression
getSymbols('MSFT', from='2004-01-02', to='2014-03-31')
getSymbols('SNP', from='2004-01-02', to='2014-03-31')
getSymbols('DTB3', src='FRED')
DTB3.sub <- DTB3['2004-01-02/2014-03-31']
#to achieve stationarity, make series does not depend on time(remove seasonality)
MSFT.ret <- diff(log(Ad(MSFT)))
SNP.ret <- diff(log(Ad(SNP)))
#Cl(MSFT) 　收盘价
#Op(MSFT) 　开盘价
#Hi(MSFT) 　当日最高价
#Lo(MSFT) 　当日最低价
#ClCl(MSFT) 收盘价对收盘价的日收益率
#Ad(MSFT) 　当日调整收盘价
#
dataDaily <- na.omit(merge(SNP.ret,MSFT.ret,DTB3.sub), join='inner')

#capture linesr interindependency between variables
var1 <- VAR(dataDaily, lag.max=10, type="both")
summary(var1)
residuals(var1)　#list of residuals (of the corresponding ～lm)

acf(residuals(var1)[,1])

