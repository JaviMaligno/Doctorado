function [sum, mean] = summean(v)
n=length(v);
sum=0;
for k=1:n
    sum=sum+v(1,k);
end
mean=sum/n;