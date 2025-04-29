% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('y_pp + y_p + y    == u + u_p')
disp('=======================================================================')

syms y y_p y_pp u u_p u_pp x1 x2 x1_p x2_p beta0 beta1 real;

eq1 = y_pp + y_p + y == u + u_p

comment('Asignacion, SISO, Derivadas De La Entrada')
% x1  = y - beta0 u                   -> x1_p = y_p - beta0 u_p                   = x2 + beta1 u
% x2  = (y_p - beta0 u_p) - beta1 u   -> x2_p = (y_pp - beta0 u_pp) - beta1 u_p   = (mayor orden)

comment('Relacionando Con La EDO')
y       = x1 + beta0*u
y_p     = x2 + beta1*u + beta0*u_p
y_pp    = eval(solve(eq1, y_pp))

comment('Ecuacion De Estados')
x1_p    = x2 + beta1*u
x2_p    = collect((y_pp - beta0*u_pp) - beta1*u_p, [u_p u_pp]) 

comment('Cancelando Derivadas De La Entrada:')
% x2_p = (sym) -β₀⋅u - β₀⋅uₚₚ - β₁⋅u + u + uₚ⋅(-β₀ - β₁ + 1) - x₁ - x₂
%   - β₀⋅uₚₚ            == 0
%   uₚ⋅(-β₀ - β₁ + 1)   == 0

cond1   = - beta0               == 0
cond2   = (-beta0 - beta1 + 1)  == 0
sol     = solve(cond1, cond2);
beta0   = sol.beta0
beta1   = sol.beta1

comment('Ecuacion De Estados')
x1_p    = eval(x1_p)
x2_p    = eval(x2_p)

comment('Matrices De Estado')
x       = [x1 x2];
xp      = [x1_p x2_p];
y       = [x1 + beta0*u];
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('SUCCESS')
