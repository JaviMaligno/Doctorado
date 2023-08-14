f=@(x,y) x.^2+y;
dfx=@(x,y) 2*x;
dfy=@(x,y) 1;

a=0;
b=1;
y0=1;

for k=1:4
    subplot(2,2,k);
    h=(b-a)/2^k;
    x=a:h:b;
    y=Taylor2(f,dfx,dfy,a,b,y0,2^k);
    xx=a:0.01:b;
    exact=3*exp(xx)-xx.^2-2*xx-2;
    plot(xx,exact,x,y,'Linewidth',2); hold on
    plot(x,y,'.-r','MarkerSize',20); 
    xlabel('x');
    ylabel('y(x)');
    grid; hold off
end