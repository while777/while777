n=1e6;
uniform=2 * rand(n,2)-1;
Y1=uniform.^2;
Y2=sum(Y1,2);

for i=1:1e6
if Y2(i)<=1;
   Y2(i)=1;
else
   Y2(i)=0;
end
end

muhat=mean(Y2)

CLTCIwidth=2.58*sqrt(muhat*(1-muhat))/sqrt(n);

disp(['PI = $' num2str(muhat*4,'%5.4f') ...
   ' +/- $' num2str(CLTCIwidth*4,'%5.4f')])
