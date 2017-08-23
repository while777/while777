function [uni] = uniform(n)
uni = sum((2 * rand(n,2)-1).^2,2)<=1;
% uni = 2 * rand(n,2)-1
% Y1 = uni.^2;
% Y2 = sum(Y1,2);
% for i=1:n
% if Y2(i)<=1;
%    Y2(i)=1;
% else
%    Y2(i)=0;
% end
% Y2=Y2<=1;
end



