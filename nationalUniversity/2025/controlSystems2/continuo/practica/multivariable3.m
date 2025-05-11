% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('y1_ppp + a1 y1_pp + a2 y1_p + a3 y1   == b0 u1_ppp + b1 u1_pp + b2 u1_p + b3 u1')
disp('=======================================================================')

syms y1 y1_p y1_pp y1_ppp u1 u1_p u1_pp u1_ppp a1 a2 a3 b0 b1 b2 b3 real;

eq1 = y1_ppp + a1*y1_pp + a2*y1_p + a3*y1   == b0*u1_ppp + b1*u1_pp + b2*u1_p + b3*u1

comment('Asignacion, SISO, Derivadas De La Entrada')
disp('x1    = y1 - beta0 u1                                 ->  x1_p = y1_p - beta0 u1_p                                    = x2 + beta1 u1')
disp('x2    = (y1_p - beta0 u1_p) - beta1 u1                ->  x2_p = (y1_pp - beta0 u1_pp) - beta1 u1_p                   = x3 + beta2 u1')
disp('x3    = (y1_pp - beta0 u1_pp - beta1 u1_p) - beta2 u1 ->  x3_p = (y1_ppp - beta0 u1_ppp - beta1 u1_pp) - beta2 u1_p   = (mayor orden)')

syms x1 x2 x3 x1_p x2_p x3_p beta0 beta1 beta2 real;
comment('Relacionando Con La EDO')
y1      = x1 + beta0*u1;
y1_p    = x2 + beta1*u1 + beta0*u1_p;
y1_pp   = x3 + beta2*u1 + beta1*u1_p + beta0*u1_pp;
y1_ppp  = eval(solve(eq1, y1_ppp));

comment('Ecuacion De Estados')
x1_p    = x2 + beta1*u1
x2_p    = x3 + beta2*u1
x3_p    = collect(expand((y1_ppp - beta0*u1_ppp - beta1*u1_pp) - beta2*u1_p), [u1 u1_p u1_pp u1_ppp]) 

comment('Cancelando Derivadas De La Entrada:')
% x3_p = (sym) -a₁⋅x₃ - a₂⋅x₂ - a₃⋅x₁ + u₁⋅(-a₁⋅β₂ - a₂⋅β₁ - a₃⋅β₀ + b₃) + u₁ ₚ⋅(-a₁⋅β₁ - a₂⋅β₀ + b₂ - β₂) + u₁ ₚₚ⋅(-a₁⋅β₀ + b₁ - β₁) + u₁ ₚₚₚ⋅(b₀ - β₀)
%   u₁ ₚ⋅(-a₁⋅β₁ - a₂⋅β₀ + b₂ - β₂) == 0
%   u₁ ₚₚ⋅(-a₁⋅β₀ + b₁ - β₁)        == 0
%   u₁ ₚₚₚ⋅(b₀ - β₀)                == 0

cond3   = (-a1*beta1 - a2*beta0 + b2 - beta2)   == 0
cond2   = (-a1*beta0 + b1 - beta1)              == 0
cond1   = (b0 - beta0)                          == 0
sol     = solve(cond1, cond2, cond3, beta0, beta1, beta2);
beta0   = sol.beta0
beta1   = sol.beta1
beta2   = sol.beta2

comment('Ecuacion De Estados')
x1_p    = eval(x1_p)
x2_p    = eval(x2_p)
x3_p    = eval(x3_p)

comment('Matrices De Estado')
x       = [x1 x2 x3];
xp      = [x1_p x2_p x3_p];
y       = [x1 + beta0*u1];
u       = [u1];
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('SUCCESS')
