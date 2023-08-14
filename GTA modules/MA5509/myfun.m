function [fx] = myfun(x)
f=inline('x^2+7*x-3');
fx=f(x);
