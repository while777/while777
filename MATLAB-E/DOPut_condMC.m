function [doput, CI , elapsedTime, p] = DOPut_condMC ...
    (S0, K, r, T, sigma, Sb, NSteps, NIterations, seed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[doput,CI,c,elapsedTime] = DOPut_condMC(S0,K,r,T,sigma,N,seed)
%Calculates Down-and-out Option Prices using a conditional MC simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
% S0:   Initial underlying asset price
% K:	Strike price
% r:	Continuously Compounded Annual Risk-free Interest Rate
% T:    Expiration
% sigma:Annualized Volatility
% Sb:   Barrier
% NSteps:    Number of steps
% NIterations:    Number of iterations
% seed: Random number seed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
% doput: Down-and-out put option price
% CI:   Confidence interval for call option price
% elapsedTime:  Elapsed time in second
% p:    A vector containing each iteration for call option price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;

rng(seed);

dt=T./NSteps; nu=r-sigma.^2./2; nudt=nu.*dt; sigmasqrtdt=sigma.*sqrt(dt);
paths=S0*exp(nudt.*cumsum(ones(NSteps,NIterations))+ ...
    sigmasqrtdt.*cumsum(randn(NSteps,NIterations)));

whether_crossed = (paths<=Sb);
crossed=any(whether_crossed);

% Calculate a down-and-in put price.

p=zeros(1,NIterations); % zero if not crossed;

if (sum(crossed,2)>0)
    paths2=paths(:,crossed(1,:)==1);
    whether_crossed2=whether_crossed(:,crossed(1,:)==1);
    for j=1:size(paths2,2)
       icrossed=find(whether_crossed2(:,j),1,'first');
       icrosseddt(1,j)=icrossed.*dt;
       disc(1,j)=exp(-r.*icrosseddt(1,j));
       S(1,j)=paths2(icrossed,j);
    end
[c p]=blsprice(S,K,r,T-icrosseddt,sigma);
p=p.*disc;

p=[p zeros(1,NIterations-size(paths2,2))]; % Pluggin in zero for the inactive paths.
end

[diput,SIGMAHAT,diput_CI,SIGMACI]=normfit(p);

% Calculate a down-and-out put price;

[call put]=blsprice(S0,K,r,T,sigma);
doput=put-diput;
CI=sort(put-diput_CI);

elapsedTime=toc;
end