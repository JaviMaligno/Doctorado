% Comparison of finite difference schemes.
clear, clc, clf
MS = 'MarkerSize';
ms = 15;

f = @(x) exp(x); % the given function %could be introduced as an input of a function
fprime = @(x) exp(x); % the derivative
x = 0; % test point
H = 10.^-(1:10); % various sizes of h %(f(x)-f(x+h))/h

n=length(H);
err_fd = zeros(n, 1);
err_bd = zeros(n, 1);
err_cd = zeros(n, 1);

for k = 1:n
    
    h = H(k);
    
    D_fd = (f(x+h)-f(x))/h; % forward difference
    D_bd = (f(x)-f(x-h))/h; % backward difference
    D_cd = (f(x+h)-f(x-h))/(2*h); % center difference
    
    err_fd(k) = abs(D_fd-fprime(x));
    err_bd(k) = abs(D_bd-fprime(x));
    err_cd(k) = abs(D_cd-fprime(x));
    
end

subplot(1,3,1)
loglog(H.', err_fd, '.-k', MS, ms);
legend('forward difference (first order)');
xlabel('stepsize h')
ylabel('error at point x')

subplot(1,3,2)
loglog(H.', err_bd, '.-r', MS, ms);
legend('backward difference (first order)');
xlabel('stepsize h')
ylabel('error at point x')

subplot(1,3,3)
loglog(H.', err_cd, '.-b', MS, ms);
legend('centred difference (second order)');
xlabel('stepsize h')
ylabel('error at point x')

