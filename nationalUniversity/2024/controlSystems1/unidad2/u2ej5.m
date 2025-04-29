% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic

% FT EQUIVALENTE
% ==========================================================================

% variables
syms G1 H1 G a b s real
G1 = 1/(s + a)
H1 = 1/(s + b)

eq1 = G1/(1 + G1*H1) == G/(1 + G)
G   = factor(solve(eq1,G),s)

disp("======================================================================")
disp("SUCCESS");

return
