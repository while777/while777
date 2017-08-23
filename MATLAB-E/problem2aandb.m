gail.InitializeWorkspaceDisplay
load stockPriceHistory -ascii 

S0 = stockPriceHistory(end)
Delta = 1/250; 
timeBefore = (-249:0) * Delta; 

diffLogStockPrice = diff(log(stockPriceHistory)); 
scDrift = mean(diffLogStockPrice); 
drift=scDrift/Delta
scVolatility = std(diffLogStockPrice)
volatility=scVolatility/sqrt(Delta); 
interest = drift + volatility^2/2

d = 125;
delta=1/125;
timeAfter = (1:d) * (delta); 
timeFinal = timeAfter(end); 

tic
n =1e3;
Sval = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   scVolatility * cumsum(randn(n,d),2)));
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);
muhat = mean(Yval) 
s=std(Yval)
error=std(Yval)/sqrt(n)
toc

tic
n =1e4;
Sval = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   scVolatility * cumsum(randn(n,d),2)));
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);
muhat = mean(Yval) 
s=std(Yval)
error=std(Yval)/sqrt(n)
toc

tic
n =1e5;
Sval = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   scVolatility * cumsum(randn(n,d),2)));
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);
muhat = mean(Yval) 
s=std(Yval)
error=std(Yval)/sqrt(n)
toc





