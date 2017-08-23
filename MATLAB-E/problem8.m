%% Evaluating the integral using |meanMC_g|
lambda = 1;
Inverse = @(x) 1/lambda * log(2*x).*(x<=0.5 & x>0) - 1/lambda * log(2 - 2 * x).*(x>0.5 & x<=1);

norm = @(t) sum(t.*t,2); 
sum = @(t) sum(abs(t),2);

f1 = @(normt, sumt, d) (cos(sqrt(normt)).* exp(-normt)/((lambda/2).^d)) ./ exp(-lambda * sumt);
f = @(t, d) f1(norm(t),sum(t),d);

%% Call meanMC_g
abstol = 0;
reltol = 0.01; 
dvec = 1:5; 
IMCvec = zeros(size(dvec)); 
tic
for d = dvec
   IMCvec(d) = meanMC_g(@(n)f(Inverse(rand(n,d)), d), abstol,reltol);
end
toc
IMCvec
%% Checking the real error
[~,Ivec] = Keistertrue(dvec(end));
relErrMC = abs(Ivec-IMCvec)./abs(Ivec);
relErrMC

   