function [simpleopt, Std, CI] = simpleMC(S1,S2,S3,q1,q2,q3, r,T,sigma1,sigma2,sigma3,rho12,rho23,rho13,N,seed)
tic
rng(seed);
nu1=r-q1-sigma1.^2./2; nu2=r-q2-sigma2.^2./2; nu3=r-q3-sigma3.^2./2;
nu1T=nu1.*T; nu2T=nu2.*T; nu3T=nu3.*T;
sigma1sqrtT=sigma1.*sqrt(T);
sigma2sqrtT=sigma2.*sqrt(T);
sigma3sqrtT=sigma3.*sqrt(T);
%
Z=randn(3,N); 
CHOICE_OF_APPROACH=1; 
%
if CHOICE_OF_APPROACH==1 
 L11=1;
 L21=rho12;
 L22=sqrt(1-rho12.^2);
 L31=rho13;
 L32=(rho23-rho12.*rho13)./sqrt(1-rho12.^2);
 L33=sqrt(1-L31.^2-L32.^2);
 L=[L11 0 0; L21 L22 0; L31 L32 L33];
 
elseif CHOICE_OF_APPROACH==2 
 L=chol([1 rho12 rho13; ...
         rho12 1 rho23; ...
         rho13 rho23 1])';
end
X=L*Z; 
S1T=S1* exp(nu1T+sigma1sqrtT.*X(1,:));
S2T=S2* exp(nu2T+sigma2sqrtT.*X(2,:));
S3T=S3* exp(nu3T+sigma3sqrtT.*X(3,:));

c = exp(-r.*T).* 100 * max(1/3 * min(S1T/S1, 1.25) + 1/3 * min(S2T/S2, 1.25) + 1/3 * min(S3T/S3, 1.25)   ,1);
simpleopt=mean(c)
Std = std(c)
%
[MUHAT,SIGMAHAT,MUCI,SIGMACI]=normfit(c);
CI= (MUCI(2)-MUCI(1))/2
toc
end
