
function [root,n]=Newton1(f,df,x0,tol)

% Routine to implement the Newton method
% INPUT: function f, derivative df, initial value x_0 and tolerance for the error
% OUTPUT: computed root and number of iterations

% Maximum number of iterations, in case of divergence
nmax=50;

x(1)=x0-f(x0)/df(x0);
x(2)=x(1)-f(x(1))/df(x(1));

n=2;

% Iterate until absolute error<tol

while abs(x(n)-x(n-1))>tol&(n<nmax) 
    x(n+1)=x(n)-f(x(n))/df(x(n));
    n=n+1;
end

root=x(n);
