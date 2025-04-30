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

% relacionar con Y y U la G
syms Y U X real;

eq1 = den*Y == num*U

% despejar derivada de mayor orden
% eq1 = (sym)
%     ⎛    2               3⎞    ⎛    3       2           ⎞
%   Y⋅⎝a₁⋅s  + a₂⋅s + a₃ + s ⎠ = U⋅⎝b₀⋅s  + b₁⋅s  + b₂⋅s + b₃⎠


% Y s^3   = (b0 s^3 + b1 s^2 + b2 s + b3) U - (a1 s^2 + a2 s + a3) Y

% dejando solo Y

% Y     = (b0 + b1/s + b2/s^2 + b3/s^3) U - (a1/s + a2/s^2 + a3/s^3) Y
% Y     = b0 U + (b1/s + b2/s^2 + b3/s^3) U - (a1/s + a2/s^2 + a3/s^3) Y
% Y     = b0 U + (b1 U - a1 Y)/s + (b2 U - a2 Y)/s^2 + (b3 U - a3 Y)/s^3)
% X3    = (b1 U - a1 Y)/s + (b2 U - a2 Y)/s^2 + (b3 U - a3 Y)/s^3
% y     = b0 u + x3

% asignar variable de estado
% X3    = (b1 U - a1 Y)/s + (b2 U - a2 Y)/s^2 + (b3 U - a3 Y)/s^3
% X3 s  = (b1 U - a1 Y) + (b2 U - a2 Y)/s + (b3 U - a3 Y)/s^2
% X2    = (b2 U - a2 Y)/s + (b3 U - a3 Y)/s^2

% X3 s  = (b1 U - a1 Y) + X2
% x3_p  = (b1 u - a1 y) + x2
% x3_p  = (b1 u - a1 (b0 u + x3)) + x2
% x3_p  = - a1 x3 + x2 + (-a1 b0 + b1) u

% X2    = (b2 U - a2 Y)/s + (b3 U - a3 Y)/s^2
% X2 s  = (b2 U - a2 Y) + (b3 U - a3 Y)/s
% X1    = (b3 U - a3 Y)/s

% X2 s  = (b2 U - a2 Y) + X1
% x2_p  = (b2 u - a2 y) + x1
% x2_p  = -a2 x3 + x1 + (-a2 b0 + b2) u

% X1    = (b3 U - a3 Y)/s
% X1 s  = (b3 U - a3 Y)
% x1_p  = (b3 u - a3 y)
% x1_p  = - a3 x3 + (-a3 b0 + b3) u

% ecuaciones de estados/salida
% x3_p  = -a1 x3    + x2    + (-a1 b0 + b1) u
% x2_p  = -a2 x3    + x1    + (-a2 b0 + b2) u
% x1_p  = -a3 x3            + (-a3 b0 + b3) u
% y     = x3 + b0 u

comment('A = Traspuesta De Controlable, B = [ai b0 + bi] (i == Elementos De La Ultima Columna De A), C = [0 0.. 1], D = [b0]')


return
