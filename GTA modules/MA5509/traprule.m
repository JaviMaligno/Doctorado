function Qn=traprule(f,a,b,n)

% Composite Trapezium rule to approximate the integral 
% of f(x) on [a,b], with n subintervals

h=(b-a)/n;
x=a:h:b;    % Vector of nodes %linspace(a,b,n+1)
y=f(x);     % Vector of values of the function

Qn=h/2*(2*sum(y)-y(1)-y(n+1));  %2*y(1) -y(1) 