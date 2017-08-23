
%% European put
%% First we set up the basic common praramters for our examples.
inp.timeDim.timeVector = 1/52: 1/52: 1/2; 
inp.assetParam.initPrice = 20; 
inp.assetParam.interest = 0.01; 
inp.assetParam.volatility = 0.25;
inp.payoffParam.strike = 20;
inp.priceParam.absTol = 0.01;
inp.payoffParam.putCallType = {'put'};
inp.priceParam.relTol = 0; 
EuroPut = optPrice(inp);
[price,out] = genOptPrice(inp);
[EuroPutPrice,out] = genOptPrice(EuroPut);
%% Note that the default is a European put option.  Its exact price is coded in

disp(['The price of this European put option is $' num2str(EuroPut.exactPrice)])
disp(['The price of the European put option is $' num2str(EuroPutPrice) ...
   ' +/- $' num2str(max(EuroPut.priceParam.absTol, ...
   EuroPut.priceParam.relTol*EuroPutPrice)) ])

%% Barrier Options
%% |optPrice| object can price such options using adaptive Monte Carlo.

BarrierUpInCall = optPrice(EuroCall); %make a copy
BarrierUpInCall.payoffParam.barrier = 18; 
BarrierUpInCall.payoffParam.optType = {'upin'}; 
[BarrierUpInCallPrice,out] = genOptPrice(BarrierUpInCall); 

disp(['The price of this barrier up and in call option is $' ...
   num2str(BarrierUpInCallPrice) ...
   ' +/- $' num2str(max(BarrierUpInCall.priceParam.absTol, ...
   BarrierUpInCall.priceParam.relTol*BarrierUpInCallPrice)) ])
disp(['   and it took ' num2str(out.time) ' seconds to compute']) %display results nicely


