function Lagrange1(X,Y)
%X=[0 1 2 4];
%Y=[2 4 3 -1];
n=length(X)-1;
P = polyfit(X,Y,n);

x=X(1):0.01:X(n+1);
plot(x,polyval(P,x),'LineWidth',2)
hold on
plot(X,Y,'r.','MarkerSize',20);
hold off