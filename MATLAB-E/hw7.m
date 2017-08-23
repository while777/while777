%% gail.InitializeWorkspaceDisplay %initialize the workspace and the display parameters
inp.timeDim.timeVector = 1/52:1/52:1/4; 
inp.assetParam.initPrice = 100; 
inp.assetParam.interest = 0.01; 
inp.assetParam.volatility = 0.5; 
inp.payoffParam.strike = 100; 
inp.payoffParam.optType = {'look'}; 
inp.payoffParam.putCallType = {'call'}; 
inp.priceParam.absTol = 0;
inp.priceParam.relTol = 0.01; 
%% The Asian arithmetic mean put without antithetic variates
LBCall = optPrice(inp); 
[LBCallPrice,Aout] = genOptPrice(LBCall);
disp(['The price of the Asian arithmetic mean put option is $' ...
   num2str(LBCallPrice,'%5.2f')])
disp(['   and this took ' num2str(Aout.time) ' seconds'])
%%
[LBPriceAnti, AAntiout] = meanMC_g(@(n) YlookoptPrice_Anti(AMeanPut,n), ...
   inp.priceParam.absTol, inp.priceParam.relTol);
disp(['The price of the Asian arithmetic mean put option is $' ...
   num2str(LBPriceAnti,'%5.2f')])
disp(['   and this took ' num2str(AAntiout.time) ' seconds,'])
disp(['   which is ' num2str(AAntiout.time/Aout.time) ...
   ' of the time without importance sampling'])
