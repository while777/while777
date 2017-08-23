
Z = @(u) (u>0&u<0.5).*log(2.*u) + (u<1&u>=0.5).*(-log(2*(1-u)));

FtimesPho = @(x) (cos(sqrt(sum(x.^2,2))).*exp(-sum(x.^2,2))).*exp(sum(abs(x),2))./(0.5^size(x,2));

f = @(u) FtimesPho(Z(u));
abstol = 0;
reltol = 0.01;
dev = 1:5;
tic
for d = dev
 IMCvec(d) = meanMC_g(@(n) f(rand(n,d)),abstol,reltol);
end
toc
