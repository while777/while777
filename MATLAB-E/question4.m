tic
n = 1e4;
I = rand(n, 1);
J = I.^(1/3 );
figure, hist(J);
toc

tic
a = betarnd(3,1,1e4,1);
figure, hist(a);
toc