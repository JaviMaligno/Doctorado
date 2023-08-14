function [root,n]=bisec(f,a,b,tol)

% Comments: bisection method on [a,b]
% Input: function f, initial interval [a,b], error tolerance tol
% Output: approximate root and number of iterations

if f(a)*f(b)>0 
    error('There is no change of sign of f(x) in this interval!');
end

n=1;

while abs(b-a)>tol
    x1=(a+b)/2;  % Compute midpoint
    if f(a)*f(x1)<0 
        b=x1;    % Keep left half: [a,x1] 
    else a=x1;   % Keep right half: [x1,b]
    end
    n=n+1;
end

root=(a+b)/2;  % Output is the midpoint of the last computed interval

