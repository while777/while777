%% Plot historical hata
load stockPriceHistory -ascii 
S0 = stockPriceHistory(end); 
Delta = 1/250; 
%% Estimate drift and volatility
diffLogStockPrice = diff(log(stockPriceHistory)); 
scDrift = mean(diffLogStockPrice);
drift = scDrift/Delta; 
scVolatility = std(diffLogStockPrice); 
volatility = scVolatility/sqrt(Delta);
interest = drift + volatility^2/2;
%% Simulating lookback option payoffs
d = 125;
delta = 1/250;
timeAfter = (1:d) * (delta); 
timeFinal = 0.5;
n=1e4;
Sval = S0 * exp(bsxfun(@plus, ... 
   drift * timeAfter, ... 
   scVolatility * cumsum(randn(n,d),2)));
%% This function generates \(n\) discounted payoffs
Payoff = @(n)(max(S0 * ones(size(Sval),1),max(Sval,[],2))-Sval(:,end)) * exp(-interest * timeFinal);
%% Computing the European call option price to a desired accuracy
absTol = 1e-1;
relTol = 0;
tic
[Price,out] = meanMC_CL(Payoff,absTol,relTol);
toc
disp(['The approximate lookback option price = ' ...
   num2str(Price,'%6.3f') ' +/- ' num2str(out.absTol,'%4.3f') ])




