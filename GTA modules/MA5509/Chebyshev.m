function T=Chebyshev(n)

% Routine to calculate the first n Chebyshev polynomials

x=[-1:0.01:1]';

T=zeros(length(x),n+1);

T(:,1)=ones(length(x),1);
T(:,2)=x;

for k=3:n+1
    T(:,k)=2*x.*T(:,k-1)-T(:,k-2);
end

plot(x,T,'Linewidth',3);
grid