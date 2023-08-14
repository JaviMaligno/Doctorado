function root=bisec_iter(f,a,b,N)

% Comments: bisection method on [a,b]
% Input: function f, initial interval [a,b], number of iterations
% Output: approximate root

if f(a)*f(b)>0 
    error('There may be no change of sign of f(x) in this interval!');
end

for n=1:N-1
    x=(a+b)/2;  % Compute midpoint
    if f(a)*f(x)<0 
        b=x;    % Keep left half
    else
        a=x;   % Keep right half
    end
end

root=(a+b)/2;  % Output is the midpoint of the last computed interval

