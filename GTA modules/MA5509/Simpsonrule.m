function Qn=Simpsonrule(f,a,b,n)

% Composite Simpson's rule to approximate the integral 
% of f(x) on [a,b], with n subintervals
% Observation: n must be even here!

h=(b-a)/n;
x=a:h:b;    % Vector of nodes %linspace(a,b,n+1)
y=f(x);     % Vector of values of the function

Qn=0;
for k=2:length(y)-1
	if mod(k,2)==0
	   	Qn=Qn+4*y(k);
	else
		Qn=Qn+2*y(k);
	end
end

Qn=h/3*(Qn+y(1)+y(n+1)); 