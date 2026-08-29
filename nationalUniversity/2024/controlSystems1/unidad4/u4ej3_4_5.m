% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic

% variables
syms k kt s real positive;

disp('==========================================================================')
disp('SISTEMA')
disp('==========================================================================')

G1  = 100/(.2*s+1);
G2  = 1/(20*s);

G3  = G1/(1+G1*kt);
G   = simplify(k*G3*G2)

disp('Constantes De Error')
disp('==========================================================================')

kp  = limit(G, s, 0)
kv  = limit(s*G, s, 0)
ka  = limit(s^2*G, s, 0)

disp('Simulacion')
disp('==========================================================================')

t   = linspace(0,20,1000);
u   = t;
k   = 50
kt  = 5

[num,den]   = numden(eval(G));
num         = double(coeffs(num, s, 'all'));
den         = double(coeffs(den, s, 'all'));

G = tf(num,den)

y = lsim(feedback(G,1), u, t);
lsim(feedback(G,1), u, t);

disp('Errores En Estado Estable')
disp('==========================================================================')

ess_p   = eval(1/(1+kp))
ess_v   = eval(1/kv)
ess_a   = eval(1/ka)

u(length(u)) - y(length(y))

disp('======================================================================')
disp('SUCCESS')
