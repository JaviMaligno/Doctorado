function [y]=Euler_for(f,y0,a,b,n) %output name changed from yk to y
% Forward Euler method for the initial value problem
% y'(x)=f(x,y(x)), with y(a)=y_0
h=(b-a)/n;
x=a:h:b;
y(1)=y0;
for k=1:n
y(k+1)=y(k)+h*f(x(k),y(k));
end
% Plot of the function
plot(x,y);
grid