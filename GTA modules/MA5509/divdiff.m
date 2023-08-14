function DD=divdiff(f,X)
% This routine returns a matrix DD with the divided differences
% of the function f.
% INPUT: a set of nodes X, given as a ROW vector, and a function f(x)
n=length(X)-1;
DD=zeros(n+1,n+2);
DD(:,1)=X';
DD(:,2)=f(X)';
%f[x0,...,xn]=(f[x1,...,xn]-f[x0,...,xn-1])/(xn-x0)
for j=2:n+1
for k=3:j+1
DD(j,k)=(DD(j,k-1)-DD(j-1,k-1))/(DD(j,1)-DD(j-k+2,1)); %for example DD(2,3)=(f(x1)-f(x0))/(x1-x0)
end
end
% Extract the coefficients %the upper diagonal has the coefficients of the
% Lagrange polynomial
an=diag(DD,1); %not  a0+a1x+..+anx^n
% Vector where we are going to evaluate P_n(x)
x=X(1):0.01:X(n+1);
% Horner algorithm %to evaluate the polynomial
%p(x)=a0+x(a1+x(a2+x(....(a_{n-1}+anx))) %start evaluating the inner term
%in this case we have a0+(x-x0)(a1+(x-x1)(...a_{n-1}+(x-xn)a_n)))

for j=1:length(x) %
    q=zeros(n+1,1);
    q(n+1,1)=an(n+1,1);

    for i=1:n
        q(n-i+1,1)=q(n-i+2,1)*(x(j)-X(n-i+1))+an(n-i+1,1); %j is fixed because we evaluate at xj
    end
    P(1,j)=q(1,1);
end
% Plot
subplot(1,2,1)
plot(x,f(x),'LineWidth',2);
hold on
plot(x,P,'LineWidth',2);
hold on
plot(X,f(X),'r.','MarkerSize',20);
legend('f(x)','Lagrange');
hold off
% Plot of the error
subplot(1,2,2)
semilogy(x,abs(f(x)-P),'LineWidth',2);
grid