% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('G == (b0 s^3 + b1 s^2 + b2 s + b3) / (s^3 + a1 s^2 + a2 s + a3)')
disp('=======================================================================')

syms s a1 a2 a3 b0 b1 b2 b3 real;

G           = (b0*s^3 + b1*s^2 + b2*s + b3) / (s^3 + a1*s^2 + a2*s + a3)
[num den]   = numden(G);

comment('Relacionar G == Y1/U1, Aislar Y1')
syms Y1 U1 real;

eq1 = den*Y1 == num*U1
eq1 = expand(lhs(eq1) - (a1*s^2 + a2*s + a3)*Y1) == expand(rhs(eq1) - (a1*s^2 + a2*s + a3)*Y1);
eq1 = collect(expand(lhs(eq1)/s^3), s)          == collect(expand(rhs(eq1)/s^3), s);

OUT = rhs(eq1)
% OUT = (sym)
%          U1⋅b₁ - Y1⋅a₁   U1⋅b₂ - Y1⋅a₂   U1⋅b₃ - Y1⋅a₃
%   U1⋅b₀ + ─────────── + ─────────── + ───────────
%               s             2             3
%                            s             s

comment('Asignacion, SISO, Metodo Asignacion Anidada:')
disp('X3    = Y1(terminos de potencia negativa) ->  s X3 = (bi U1 - ai Y1) + X2 ->  x3_p = (bi u - ai y) + x2')
disp('X2    = X3(terminos de potencia negativa) ->  s X2 = (bi U1 - ai Y1) + X1 ->  x2_p = (bi u - ai y) + x1')
disp('...')
disp('Y1     = X3 + b0 U1                       ->  y = x3 + b0 u ')
disp('=======================================================================')
syms x1 x2 x3 u1 y1 real;

X3      = OUT - b0*U1
X3_s    = collect(expand(X3*s), s)
% X3_s = (sym)
%                 U1⋅b₂ - Y1⋅a₂   U1⋅b₃ - Y1⋅a₃
%   U1⋅b₁ - Y1⋅a₁ + ─────────── + ───────────
%                      s             2
%                                   s
X2      = X3_s - (b1*U1 - a1*Y1)
x3_p    = (b1*u1 - a1*y1) + x2;

X2_s    = collect(expand(X2*s), s)
% X2_s = (sym)
%                 U1⋅b₃ - Y1⋅a₃
%   U1⋅b₂ - Y1⋅a₂ + ───────────
%                      s
X1      = X2_s - (b2*U1 - a2*Y1)
x2_p    = (b2*u1 - a2*y1) + x1

X1_s    = collect(expand(X1*s), s)
% X1_s = (sym) U1⋅b₃ - Y1⋅a₃
x1_p    = (b3*u1 - a3*y1);

comment('Ecuacion De Salida:')
% ! Y1 = X3 + b0*U1
y1     = b0*u1 + x3

comment('Ecuacion De Estados:')
x1_p    = collect(expand(eval(x1_p)), u1)
x2_p    = collect(expand(eval(x2_p)), u1)
x3_p    = collect(expand(eval(x3_p)), u1)

comment('Forma Canonica Observable')
x       = [x1 x2 x3];
xp      = [x1_p x2_p x3_p];
y       = [y1];
u       = [u1];
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('A = Traspuesta De Controlable, B = [ai b0 + bi] (i == Elementos De La Ultima Columna De A), C = [0 0.. 1], D = [b0]')

comment('SUCCESS')
