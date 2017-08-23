absTol = 0;
relTol = 0.001;
tic
[muhat, out] = meanMC_CLT(@(n)uniform(n), absTol, relTol);
toc
disp(['PI = $' num2str(muhat * 4,'%5.4f') ...
   ' +/- $' num2str(out.relTol * 4,'%5.4f')])
