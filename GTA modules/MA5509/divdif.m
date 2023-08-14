function DD=divdif(X,Y)
% This routine returns a matrix DD with the divided 
% differences
% INPUT: a set of nodes X, given as a ROW vector, 
% and a set of values Y
n=length(X)-1;
DD=zeros(n+1,n+2);
DD(:,1)=X';
DD(:,2)=Y';

for j=2:n+1
    for k=3:j+1
        DD(j,k)=(DD(j,k-1)-DD(j-1,k-1))/(DD(j,1)-DD(j-k+2,1));
    end
end
% Extract the coefficients
an=diag(DD,1);
% Vector where we are going to evaluate P_n(x)
x=X(1):0.01:X(n+1);
% Horner algorithm

for j=1:length(x)
    q=zeros(n+1,1);
    q(n+1,1)=an(n+1,1);

    for i=1:n
        q(n-i+1,1)=q(n-i+2,1)*(x(j)-X(n-i+1))+an(n-i+1,1);
    end
    P(1,j)=q(1,1);
end
% Plot
%subplot(1,2,1)
%plot(x,f(x),'LineWidth',2);
%hold on
plot(x,P,'LineWidth',2);
hold on
plot(X,Y,'r.','MarkerSize',20);
legend('f(x)','Lagrange');
hold off
% Plot of the error
%subplot(1,2,2)
%semilogy(x,abs(f(x)-P),'LineWidth',2);
%grid