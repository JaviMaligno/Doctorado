function [sum2,k] = function_sum(tol)
sum2=1;
k=1;
while sum2<2-tol
sum2=sum2+1/2^k;
k=k+1;
end
