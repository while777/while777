function price=AmMaxLattice(S10,S20,r,T,sigma1,sigma2,rho, q1, q2, N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%price=AmMaxLattice(S10,S20,r,T,sigma1,sigma2,rho, q1, q2, N)
%Calculates an American MaximumOption Price using a Lattice.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
% S10: Initial underlying asset 1 price
% S20: Initial underlying asset 1 price
% r: Continuously Compounded Annual Risk-free Interest Rate
% sigma1: Annualized Volatility of Asset 1
% sigma2: Annualized Volatility of Asset 2
% rho: Correlation between Asset 1 and Asset 2
% q1: div yield or convenience yield of asset 1
% q2: div yield or convenience yield of asset 2
% N: Number of steps in a binomial lattice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
% price: call option price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precompute invariant quantities.

deltaT=T./N;
nu1=r-q1-0.5*sigma1^2;
nu2=r-q2-0.5*sigma2^2;
u1=exp(sigma1.*sqrt(deltaT));
d1=1./u1;
u2=exp(sigma2.*sqrt(deltaT));
d2=1./u2;
discount=exp(-r*deltaT);
p_uu=discount*0.25*(1+sqrt(deltaT)*(+nu1/sigma1+nu2/sigma2)+rho);
p_ud=discount*0.25*(1+sqrt(deltaT)*(+nu1/sigma1-nu2/sigma2)-rho);
p_du=discount*0.25*(1+sqrt(deltaT)*(-nu1/sigma1+nu2/sigma2)-rho);
p_dd=discount*0.25*(1+sqrt(deltaT)*(-nu1/sigma1-nu2/sigma2)+rho);

% Set up S values. (Note that you need both S1Vals and S2Vals)

S1Vals=zeros(2*N+1,1);
S2Vals=zeros(2*N+1,1);
S1Vals(1)=S10*d1.^N;
S2Vals(1)=S20*d2.^N;
for i=2:2*N+1
    S1Vals(i)=u1*S1Vals(i-1);
    S2Vals(i)=u2*S2Vals(i-1);
end

% Set up terminal CALL values. (Note that CVals is 2 dimensinoal.)

CVals=zeros(2*N+1,2*N+1);
for i=1:2:2*N+1 % Only odd elements are used
    for j=1:2:2*N+1 % Only odd elements are used
        CVals(i,j)=max(S1Vals(i),S2Vals(j));
    end
end

% Work backwards

for tau=1:N 
    for i=(tau+1):2:(2*N+1-tau) %When tau is odd, even elements are used.
                                %When tau is even, odd elements are used.
        for j=(tau+1):2:(2*N+1-tau)
            cont_value= p_uu*CVals(i+1,j+1)+ ...
                        p_ud*CVals(i+1,j-1)+ ...
                        p_du*CVals(i-1,j+1)+ ...
                        p_dd*CVals(i-1,j-1);
            CVals(i,j)=max(cont_value,max(S1Vals(i),S2Vals(j)));
        end
    end
end
price=CVals(N+1,N+1);
end