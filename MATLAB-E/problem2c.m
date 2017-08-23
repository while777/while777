gail.InitializeWorkspaceDisplay
load stockPriceHistory -ascii 

S0 = stockPriceHistory(end); 
Delta = 1/250; 
timeBefore = (-249:0) * Delta; 

diffLogStockPrice = diff(log(stockPriceHistory)); 
scDrift = mean(diffLogStockPrice); 
drift=scDrift/Delta; 
scVolatility = std(diffLogStockPrice);
volatility=scVolatility/sqrt(Delta); 
interest = drift + volatility^2/2; 

n=1e4;

tic
d = 25; 
delta1=1/25;
timeAfter = (1:d) * delta1; 
timeFinal = timeAfter(end); 
Sval = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   volatility * sqrt(delta1) * cumsum(randn(n,d),2)));
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);
muhat = mean(Yval) 
toc

tic
d = 75; 
delta2=1/75;
timeAfter = (1:d) * delta2; 
timeFinal = timeAfter(end); 
Sval = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   volatility * sqrt(delta2) * cumsum(randn(n,d),2)));
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);
muhat = mean(Yval) 
toc

tic
d = 125; 
delta3=1/125;
timeAfter = (1:d) * delta3; 
timeFinal = timeAfter(end); 
Sval = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   volatility * sqrt(delta3) * cumsum(randn(n,d),2)));
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);
muhat = mean(Yval)
toc






