% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('y_ppp + a1 y_pp + a2 y_p + a3 y == u')
disp('=======================================================================')

syms y y_p y_pp y_ppp a1 a2 a3 u x1 x2 x3 x1_p x2_p x3_p real;

eq1 = y_ppp + a1*y_pp + a2*y_p + a3*y == u

comment('Asignacion, SISO, Sin Derivadas De La Entrada')
disp('x1    = y     ->  x1_p    = y_p   = x2')
disp('x2    = x1_p  ->  x2_p    = y_pp  = x3')
disp('x3    = x2_p  ->  x3_p    = y_ppp = (mayor orden)')

comment('Relacionando Con La EDO')
y       = x1
y_p     = x2
y_pp    = x3
y_ppp   = eval(solve(eq1, y_ppp))

comment('Ecuacion De Estados')
x1_p    = x2
x2_p    = x3
x3_p    = y_ppp

x   = [x1 x2 x3];
xp  = [x1_p x2_p x3_p];
y   = [x1];

comment('Matrices De Estado')
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('SUCCESS')
