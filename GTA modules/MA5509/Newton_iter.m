
function [root]=Newton_iter(f,df,x0,N)

% Routine to implement the Newton method
% INPUT: function f, derivative df, initial value x_0 and tolerance for the error
% OUTPUT: computed root and number of iterations

% Maximum number of iterations, in case of divergence
nmax=50;

% First iteration and error (both difference between iterations and value
% of f)

x(1)=x0-f(x0)/df(x0);
errabs(1)=abs(x0-x(1));
errf(1)=abs(f(x(1)));
err(1)=max(errabs(1),errf(1));

% Iterate until error<tol

for n=1:N
    x(n+1)=x(n)-f(x(n))/df(x(n));
    errabs(n+1)=abs(x(n)-x(n+1));
    errf(n+1)=abs(f(x(n+1)));
    err(n+1)=max(errabs(n+1),errf(n+1));
end

root=x(n);
%plot([1:n],err);
