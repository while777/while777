function passive(S1, r0, T, sigma1, N, seed)

rng(seed);
nu1 = r0-0.5*sigma1^2; 
nu1T = nu1.*T; 
sigma1sqrtT = sigma1.*sqrt(T);
X = randn(1, N);
S1T = S1 * exp( nu1T + sigma1sqrtT.* X);
ratio = 1000000/S1;

%
Meanreturntoinvestment = mean( S1T/S1 - 1 ) 

Meanexcessreturn = mean(S1T/S1 - r0 * T -1 ) 

SDofexcessreturn = std(S1T/S1 - r0 * T -1 ) 

sharpratio = Meanexcessreturn./SDofexcessreturn

Var = -prctile( (S1T - S1) * ratio, 5 ) 

end
