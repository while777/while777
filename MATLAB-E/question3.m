X=[ 2 9 12 15 17 25 30]; 
Y=[72,69,66,64,66,69,68];
plot(X,Y,'ob')
axis ([0 30 60 75]);
title('No interpolation');
hold on
Xq=[1:1:5];%Xq=[1:1:5;8:1:12;15:1:19;22:1:26;29:1:30];
Yq=interp1(X,Y,Xq,'linear');
plot(Xq,Yq,'-r') 
axis ([0 30 60 75]);
title('Linear interpolation');
hold on
Xq=[8:1:12];%Xq=[1:1:5;8:1:12;15:1:19;22:1:26;29:1:30];
Yq=interp1(X,Y,Xq,'linear');
plot(Xq,Yq,'-r') 
axis ([0 30 60 75]);
title('Linear interpolation');
hold on
Xq=[15:1:19];%Xq=[1:1:5;8:1:12;15:1:19;22:1:26;29:1:30];
Yq=interp1(X,Y,Xq,'linear');
plot(Xq,Yq,'-r') 
axis ([0 30 60 75]);
title('Linear interpolation');
hold on
Xq=[22:1:26];%Xq=[1:1:5;8:1:12;15:1:19;22:1:26;29:1:30];
Yq=interp1(X,Y,Xq,'linear');
plot(Xq,Yq,'-r') 
axis ([0 30 60 75]);
title('Linear interpolation');
hold on
Xq=[29:1:30];%Xq=[1:1:5;8:1:12;15:1:19;22:1:26;29:1:30];
Yq=interp1(X,Y,Xq,'linear');
plot(Xq,Yq,'-r') 
axis ([0 30 60 75]);
title('Linear interpolation');