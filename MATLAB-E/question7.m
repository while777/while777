%%
n = 1e4;
Z1 = randn(n ,1);
S0 = 5000;
r = 0.06;
mu = r + 0.03;
sigma = 0.08;
T = 1;
ST = S0 * exp( mu * T + sigma * sqrt(T) * Z1  );
payoff = max(ST, S0);
%%
Meanreturntoinvestment = mean(ST./S0-1)
Meanreturntoinvestment1 = mean(payoff./S0-1)
Meanexcessreturn = mean(ST./S0 - r * T -1 )
Meanexcessreturn1 = mean( payoff./S0 - r * T -1 )
SDofexcessreturn = std(ST./S0 - r * T -1)
SDofexcessreturn1 = std(payoff./S0 - r * T -1)
sharpratio = Meanexcessreturn./SDofexcessreturn
sharpratio1 = Meanexcessreturn1./SDofexcessreturn1
Var = prctile(ST-S0,5)
Var1 = prctile(payoff - S0, 5)


