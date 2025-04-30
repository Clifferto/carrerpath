% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('G == (b0 s^3 + b1 s^2 + b2 s + b3) / (s^3 + a1 s^2 + a2 s + a3)')
disp('=======================================================================')

syms s a1 a2 a3 b0 b1 b2 b3 real;

G           = (b0*s^3 + b1*s^2 + b2*s + b3) / (s^3 + a1*s^2 + a2*s + a3)
[num den]   = numden(G);

% multiplica num, den por variable auxiliar
syms Y U X real;

Y   = collect(num .* X, s)
U   = collect(den .* X, s)

% antitransforma salida/entrada
syms x x_p x_pp x_ppp y1 u1 u1_p u1_pp u1_ppp real;

% Y = (sym)
%         3         2
%   X⋅b₀⋅s  + X⋅b₁⋅s  + X⋅b₂⋅s + X⋅b₃

% U = (sym)
%         2                      3
%   X⋅a₁⋅s  + X⋅a₂⋅s + X⋅a₃ + X⋅s

eq1 = y1    == b0*x_ppp + b1*x_pp + b2*x_p + b3*x
eq2 = u1    == x_ppp + a1*x_pp + a2*x_p + a3*x

comment('Asignacion, SISO, Metodo Variable Auxiliar')
disp('x1    = x     ->  x1_p = x_p      = x2')
disp('x2    = x_p   ->  x2_p = x_pp     = x3')
disp('x3    = x_pp  ->  x3_p = x_ppp    = (mayor orden)')

comment('Relacionando Con La EDO')
syms x1 x2 x3 x1_p x2_p x3_p real;

x       = x1
x_p     = x2
x_pp    = x3
x_ppp   = eval(solve(eq2, x_ppp))
y1      = eval(rhs(eq1));

comment('Ecuacion De Estados')
x1_p    = x2
x2_p    = x3
x3_p    = x_ppp 

comment('Forma Canonica Controlable')
x       = [x1 x2 x3];
xp      = [x1_p x2_p x3_p];
y       = [y1];
u       = [u1];
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('A = Forma Canonica, B = [0 0.. 1], C = [ai b0 + bi] (i == Elementos De La Ultima Fila De A), D = [b0]')

comment('SUCCESS')
