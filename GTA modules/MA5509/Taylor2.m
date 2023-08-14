function y=Taylor2(f,dfx,dfy,a,b,y0,n)

% Taylor method of order 2 to solve y'(x)=f(x,y(x)) on [a,b], 
% with y(a)=y0 and h=(b-a)/n
% NOTE: the derivatives df/dx and df/dy have to be passed as inputs

h=(b-a)/n;
x=a:h:b;

y(1)=y0;

for k=1:n
    y(k+1)=y(k)+h*f(x(k),y(k))+h^2/2*(dfx(x(k),y(k))+f(x(k),y(k))*dfy(x(k),y(k)));
end