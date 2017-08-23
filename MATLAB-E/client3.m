function client3(S1, S2, S3, S4,  r, r0, T, sigma1, sigma2, sigma3, sigma4, rho12, rho13, rho23, rho14, rho24, rho34, N, seed)
%assume the investor takes half of initial investment capital to invest in
%diversification portfolio(commodity)
rng(seed);
nu1 = r-sigma1.^2./2 ; nu2=r-sigma2.^2./2; nu3=r-sigma3.^2./2; nu4=r0-sigma4.^2./2;
nu1T=nu1.*T; nu2T=nu2.*T; nu3T=nu3.*T; nu4T=nu4.*T;
sigma1sqrtT=sigma1.*sqrt(T);
sigma2sqrtT=sigma2.*sqrt(T);
sigma3sqrtT=sigma3.*sqrt(T);
sigma4sqrtT=sigma4.*sqrt(T);
%
Z=randn(4,N); 
L=chol([1 rho12 rho13 rho14; ...
         rho12 1 rho23 rho24; ...
         rho13 rho23 1 rho34;
         rho14 rho24 rho34 1])';
X=L*Z; 
S1T = S1* exp(nu1T+sigma1sqrtT.*X(1,:));
S2T = S2* exp(nu2T+sigma2sqrtT.*X(2,:));
S3T = S3* exp(nu3T+sigma3sqrtT.*X(3,:));
S4T = S4* exp(nu4T+sigma4sqrtT.*X(4,:));

a = 800000;
c1 = a * max( 1/3 * min((S1T/S1), 1.25) + 1/3 .* min((S2T/S2), 1.25) + 1/3 .* min((S3T/S3), 1.25)    , 1.2);
c2 =  (1000000-a) .*(S4T/S4);
c = c1 + c2;

%
Meanreturntoinvestment = mean( c/1000000 -1) 

Meanexcessreturn = mean( c/1000000  - r * T -1 ) 

SDofexcessreturn = std( c/1000000 - r * T  -1) 

sharpratio = Meanexcessreturn./SDofexcessreturn

Var = prctile( max(c1 - a, 0) + c2 - 1000000 + a, 5 )

end
