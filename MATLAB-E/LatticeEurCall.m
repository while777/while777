function [price] = LatticeEurCall(S0,K,r,T,sigma,N, q)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[price, lattice] = LatticeEurCall(S0,K,r,T,sigma,N)
%Calculates European Option Prices using a Lattice.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
% S0: Initial underlying asset price
% K: Strike price
% r: Continuously Compounded Annual Risk-free Interest Rate
% sigma: Annualized Volatility
% N: Number of steps in a binomial lattice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
% price: call option price
% lattices: a N-by-N matrix containing lattice 
%      where column i represents (i-1)th time and
%            row j represents (j-1)th state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaT=T./N;
u=exp(sigma.*sqrt(deltaT));
d=1./u;
p=(exp( (r-q).*deltaT)-d)./(u-d);
lattice=zeros(N+1,N+1);

% Calculates payoffs at time T

for i=0:N
    lattice(i+1,N+1)=max(0,S0.*(u.^i).*(d.^(N-i))-K);
end

% Backward Calculation

for j=N-1:-1:0
    for i=0:j
        lattice(i+1,j+1)=exp(-r.*deltaT) .* ...
            (p.*lattice(i+2,j+2)+(1-p).*lattice(i+1,j+2));
    end
end

price=lattice(0+1,0+1);
end

