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
disp('m1 x1_pp  == b1 (u_p - x1_p) + k1 (u - x1) + k2 (x2 - x1)')
disp('m2 x2_pp  == k2 (x1 - x2)')
disp('')

% variables
syms m1 m2 b1 k1 k2 U X1 X2 s real

eq1 = m1*X1*s^2 == b1*(U*s - X1*s) + k1*(U - X1) + k2*(X2 - X1)
eq2 = m2*X2*s^2 == k2*(X1 - X2)

sol = solve(eq1,eq2,X1,X2)

X1_vs_U = factor(sol.X1/U, 's')
X2_vs_U = factor(sol.X2/U, 's')

disp("======================================================================")
disp("SUCCESS");
