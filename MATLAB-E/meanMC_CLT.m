
function [hmu, out_param] = meanMC_CLT(Yrand, absTol, relTol, alpha, nSig, inflate)
if nargin < 6
    inflate = 1.2;
    if nargin < 5
        nSig = 1e3;
        if nargin < 4
            alpha = 0.01;
            if  nargin < 3
                relTol = 0.005;
                if nargin < 2
                    absTol = 1e-2;
                    if nargin < 1
                        Yrand = @(n)rand(n,1);
                    end
                end
            end
        end
    end
end
nMax=1e8;
out_param.alpha = alpha;
out_param.inflate=inflate;
out_param.nSig = nSig;
out_param.absTol = absTol;
out_param.relTol = relTol;
Yval = Yrand(nSig);
out_param.var = var(Yval);
sig0 = sqrt(out_param.var); 
sig0up = out_param.inflate.* sig0;
hmu0 = mean(Yval);
nmu = max(1,ceil((-norminv(alpha/2)*sig0up/max(absTol,relTol*abs(hmu0))).^2)); 
  
if nmu > nMax 
   warning(['The algorithm wants to use nmu = ' int2str(nmu) ...
      ', which is too big. Using ' int2str(nMax) ' instead.']) 
   nmu = nMax;
end
hmu = mean(Yrand(nmu))
out_param.ntot = nSig+nmu 
end


        

    
    
    
