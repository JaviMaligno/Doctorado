function [root,n]=fixpt(g,x0,tol)

% Routine to implement the fixed point method
% INPUT: function g, initial value x_0 and tolerance for the error
% OUTPUT: computed root and number of iterations

% We add a maximum number of iterations to stop in case of divergence
Nmax=50;

% First iteration and error
x(1)=g(x0);
x(2)=g(x(1));
n=2;

% Iterate until error<tol or until we reach Nmax
while (abs(x(n)-x(n-1))>tol)&(n<Nmax)
    x(n+1)=g(x(n));
    n=n+1;
end

root=x(n);