% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% SISTEMA DE MASAS
% ==========================================================================

disp('==========================================================================')
disp('Modelo')
disp('==========================================================================')
disp('I o_pp + m l^2 o_pp   == m g l o + m l x_pp')
disp('(M + m) x_pp          == f - b x_p + m l o_pp')
disp('')

% variables
syms M m I l g b X O F s real

eq1 = I*O*s^2 + m*l^2*O*s^2 == m*g*l*O + m*l*X*s^2
eq2 = (M + m)*X*s^2         == F - b*X*s + m*l*O*s^2

X   = solve(eq1,X);
O   = solve(eval(eq2), O);

O_vs_F  = factor(O/F, s)

M=1; m=1; I=1; l=1; g=9; b=1;

[num, den] = numden(eval(O_vs_F))
num = double(coeffs(num,s,'all'))
den = double(coeffs(den,s,'all'))

O_vs_F = tf(num, den)

pzmap(O_vs_F)
title('Zero-Pole map')
grid on;

disp("======================================================================")
disp("SUCCESS");
