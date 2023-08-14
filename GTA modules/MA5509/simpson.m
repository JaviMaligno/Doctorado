function Q2=simpson(f,a,b)
c=(a+b)/2;
Q2=(b-a)*(f(a)+4*f(c)+f(b))/6;