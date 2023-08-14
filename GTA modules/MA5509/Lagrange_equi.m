function [P]=Lagrange_equi(f,a,b,n)
% This routine computes the Lagrange interpolating polynomial
% of degree n, given n+1 equispaced nodes in an interval [a,b]
% and a function f(x). This function should use
% the sintax .* ./ and .^
% It uses the routines polyfit and then plots the result using
% polyval
% Vector of equispaced nodes
X=linspace(a,b,n+1);
% Vector of values of the function
Y=f(X);
% Construction of the polynomial. This routine polyfit
% is more general,
% but if we ask for degree n with n+1 nodes,
% it gives the Lagrange
% interpolating polynomial
P=polyfit(X,Y,n);

% Plot of the function and the polynomial
subplot(1,2,1)
x=a:0.01:b;
plot(x,f(x),'LineWidth',1.5);
grid
hold on
plot(x,polyval(P,x),'LineWidth',1.5); %polyval(P,x)=P(x)
hold on
plot(X,Y,'r.','MarkerSize',20);
legend('f(x)','Lagrange');
hold off
% Plot of the error
subplot(1,2,2)
semilogy(x,abs(f(x)-polyval(P,x)),'LineWidth',1.5);
grid