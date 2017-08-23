function price = AmPutLattice(S0,K,r,T,sigma,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%price = AmPutLattice(S0,K,r,T,sigma,N)
%Calculates American Put Option Prices using a Lattice.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
% S0: Initial underlying asset price
% K: Strike price
% r: Continuously Compounded Annual Risk-free Interest Rate
% sigma: Annualized Volatility
% N: Number of steps in a binomial lattice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
% price: American Put call option price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precompute invariant quantities.

deltaT=T./N;
u=exp(sigma.*sqrt(deltaT));
d=1./u;
p=(exp(r.*deltaT)-d)./(u-d);
discount=exp(-r.*deltaT);
p_u=discount*p;
p_d=discount.*(1-p);

% Set up S values

SVals=zeros(2*N+1,1);
SVals(1)=S0*d.^N;
for i=2:2*N+1
    SVals(i)=u*SVals(i-1);
end

% Set up terminal PUT values

PVals=zeros(2*N+1,1);
for i=1:2:2*N+1 % Only odd elements are used
    PVals(i)=max(K-SVals(i),0);
end

% Work backwards

for tau=1:N 
    for i=(tau+1):2:(2*N+1-tau) %When tau is odd, even elements are used.
                                %When tau is even, odd elements are used.
        cont_val=p_u.*PVals(i+1)+p_d.*PVals(i-1);
        exer_val=K-SVals(i);
        PVals(i)=max(cont_val,exer_val);
    end
end
price=PVals(N+1);
end