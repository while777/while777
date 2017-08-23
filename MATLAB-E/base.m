load stockPriceHistory -ascii 
S0 = stockPriceHistory(end); 
Delta = 1/250; 

diffLogStockPrice = diff(log(stockPriceHistory)); 
scDrift = mean(diffLogStockPrice);
drift = scDrift/Delta; 
scVolatility = std(diffLogStockPrice); 
volatility = scVolatility/sqrt(Delta); 

d = 125; 
delta = 1/125;
timeAfter = (1:d) * delta; 
timeFinal = timeAfter(end);

tic
n = 1e4;
interest = drift + volatility^2/2 
SVal = S0*exp(bsxfun(@plus, ... 
   drift*timeAfter, ... 
   scVolatility * cumsum(randn(n,d),2))); 
Yval = (max(S0*ones(n,1),max(Sval,[],2))-Sval(:,end))* exp(-interest * timeFinal);euroCallPrice = mean(Yval); 
CLTCIwidth = 2.58*std(Yval)/sqrt(n); 
disp(['The option price = $' num2str(euroCallPrice,'%6.3f') ...
   ' +/- $' num2str(CLTCIwidth,'%6.3f')])
toc