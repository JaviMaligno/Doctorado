function S=cubicsplines(X,Y)

% Natural cubic splines
% Input: vectors X and Y of length n
% Output: a matrix $S$ of size 4*(n-1), whose rows contain the
% coefficients of the splines, in decreasing order

n=length(X)-1;

H=diff(X); %h_k=x_{k+1}-x_k
D=diff(Y)./H;
U=6*diff(D); %we eliminate the 6 on the denominator; A*m=U

A=zeros(n-1,n-1); %define the matrix in page 59 %a_k, b_k

A(1,1)=2*(H(1)+H(2));%b_1 %for that reason we get multiplication by 2
A(1,2)=H(2); %a_1
A(n-1,n-1)=2*(H(n-1)+H(n)); %b_n
A(n-1,n-2)=H(n-1); %a_n

for k=2:n-2 
    A(k,k-1)=H(k); %a_k below the diagonal
    A(k,k)=2*(H(k)+H(k+1));%b_k in the diagonal
    A(k,k+1)=H(k+1); %a_k above the diagonal
end

M=A\U';%for each k, m_k=S_k''(x_k) and m_{k+1}=S_k''(x_{k+1})
M=[0;M;0]; %we add m_0=m_n=0 (free spline)

for k=1:n %apply the formula in page 60
    S(k,1)=(M(k+1)-M(k))/(6*H(k));
    S(k,2)=M(k)/2;
    S(k,3)=D(k)-H(k)*(2*M(k)+M(k+1))/6;
    S(k,4)=Y(k);
end
%S each row is a cubic spline (its coefficients)
% Plot

for k=1:n
    h=(X(k+1)-X(k))/100; %h=0.01
    x1=X(k):h:X(k+1);
    y1=polyval(S(k,:),x1-X(k));
    plot(x1,y1,'Linewidth',2);
    hold on
end

grid
hold off
