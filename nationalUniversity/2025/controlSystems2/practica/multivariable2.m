% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('y1_pp + y1_p + y2 == u1 + u2_p')
disp('y2_p              == y1 + u1_p')
disp('=======================================================================')

syms y1 y1_p y1_pp y2 y2_p u1 u1_p u1_pp u2 u2_p u2_pp real;

eq1 = y1_pp + y1_p + y2 == u1 + u2_p
eq2 = y2_p              == y1 + u1_p

comment('Asignacion, MIMO, Derivadas De La Entrada')
disp('x1    = y1 - beta0 u1 - alpha0 u2                                 ->  x1_p = y1_p - beta0 u1_p - alpha0 u2_p                                  = x2 + beta1 u1 + alpha1 u2')
disp('x2    = (y1_p - beta0 u1_p - alpha0 u2_p) - beta1 u1 - alpha1 u2  ->  x2_p = (y1_pp - beta0 u1_pp - alpha0 u2_pp) - beta1 u1_p - alpha1 u2_p  = (mayor orden y1)')
disp('x3    = y2 - beta2 u1 - alpha2 u2                                 ->  x3_p = y2_p - beta2 u1_p - alpha2 u2_p                                  = (mayor orden y2)')

syms x1 x2 x3 x1_p x2_p x3_p beta0 beta1 beta2 alpha0 alpha1 alpha2 real;
comment('Relacionando Con La EDO')
y1      = x1 + beta0*u1 + alpha0*u2;
y2      = x3 + beta2*u1 + alpha2*u2;
y1_p    = x2 + beta1*u1 + alpha1*u2 + beta0*u1_p + alpha0*u2_p;
y1_pp   = eval(solve(eq1, y1_pp));
y2_p    = eval(solve(eq2, y2_p));

comment('Ecuacion De Estados')
x1_p    = x2 + beta1*u1 + alpha1*u2
x2_p    = collect((y1_pp - beta0*u1_pp - alpha0*u2_pp) - beta1*u1_p - alpha1*u2_p, [u1_p u1_pp u2_p u2_pp])
x3_p    = collect(y2_p - beta2*u1_p - alpha2*u2_p, [u1_p u1_pp u2_p u2_pp]) 

comment('Cancelando Derivadas De La Entrada:')
% x2_p = (sym) -α₀⋅u₂ ₚₚ - α₁⋅u₂ - α₂⋅u₂ - β₀⋅u₁ ₚₚ - β₁⋅u₁ - β₂⋅u₁ + u₁ + u₁ ₚ⋅(-β₀ - β₁) + u₂ ₚ⋅(-α₀ - α₁ + 1) - x₂ - x₃
% x3_p = (sym) α₀⋅u₂ - α₂⋅u₂ ₚ + β₀⋅u₁ + u₁ ₚ⋅(1 - β₂) + x₁
%   -α₀⋅u₂ ₚₚ           == 0 
%   - β₀⋅u₁ ₚₚ          == 0 
%   u₁ ₚ⋅(-β₀ - β₁)     == 0 
%   u₂ ₚ⋅(-α₀ - α₁ + 1) == 0
%   - α₂⋅u₂ ₚ           == 0 
%   u₁ ₚ⋅(1 - β₂)       == 0

cond1   = -alpha0                   == 0 
cond2   = - beta0                   == 0 
cond3   = (-beta0 - beta1)          == 0 
cond4   = (-alpha0 - alpha1 + 1)    == 0
cond5   = - alpha2                  == 0 
cond6   = (1 - beta2)               == 0
sol     = solve(cond1, cond2, cond3, cond4, cond5, cond6);
beta0   = sol.beta0;
beta1   = sol.beta1;
beta2   = sol.beta2;
alpha0  = sol.alpha0;
alpha1  = sol.alpha1;
alpha2  = sol.alpha2;

comment('Ecuacion De Estados')
x1_p    = eval(x1_p)
x2_p    = eval(x2_p)
x3_p    = eval(x3_p)

comment('Matrices De Estado')
x       = [x1 x2 x3];
xp      = [x1_p x2_p x3_p];
y       = [x1 + beta0*u1 + alpha0*u2 x3 + beta2*u1 + alpha2*u2];
u       = [u1 u2];
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('SUCCESS')
