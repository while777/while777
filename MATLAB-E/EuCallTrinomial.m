function price = EuCallTrinomial(S0,K,r,T,sigma,N,deltaX)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%price = EuCallTrinomial(S0,K,r,T,sigma,N,deltaX)
%Calculates European Option Prices using a Trinomial Lattice.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
% S0: Initial underlying asset price
% K: Strike price
% r: Continuously Compounded Annual Risk-free Interest Rate
% sigma: Annualized Volatility
% N: Number of steps in a binomial lattice
% deltaX: the amount of up and down movement in log scale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
% price: call option price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precompute invariant quantities.

deltaT=T./N;
nu=r-0.5*sigma^2;
discount=exp(-r.*deltaT);
p_u=discount*0.5*((sigma^2*deltaT+nu^2*deltaT^2)/deltaX^2+nu*deltaT/deltaX);
p_d=discount*0.5*((sigma^2*deltaT+nu^2*deltaT^2)/deltaX^2-nu*deltaT/deltaX);
p_m=discount-p_u-p_d;
exp_dX=exp(+deltaX);

% Set up S values

SVals=zeros(2*N+1,1);
SVals(1)=S0*exp(-N*deltaX);
for i=2:2*N+1
    SVals(i)=exp_dX*SVals(i-1);
end

% Set up terminal CALL values

CVals=zeros(2*N+1,1);
k=mod(N,2)+1; %Even N ==> k=1; Odd N ==> k=2.
for i=1:2*N+1 % Only odd elements are used
    CVals(i,k)=max(SVals(i)-K,0);
end

% Work backwards
for j=N-1:-1:0
    know=mod(j,2)+1; %Even j ==> k=1; Odd j ==> k=2.
    knext=mod(j+1,2)+1; %Even j+1 ==> k=1; Odd j+1 ==> k=2. 
    for i=N+1-j:N+1+j
        CVals(i,know)=p_d*CVals(i-1,knext)+ ...
                        p_m*CVals(i,knext)+ ...
                        p_u*CVals(i+1,knext);
    end
end
price=CVals(N+1,1); % Remember that 
end