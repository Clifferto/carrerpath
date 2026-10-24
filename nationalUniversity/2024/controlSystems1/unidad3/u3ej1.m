% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% variables
syms X Y s real;

% MODELO
% ==========================================================================

% tiempo
% 5y_pp + 2y_p + 3y == x + 5x_p

% laplace
eq1 = 5*Y*s^2 + 2*Y*s + 3*Y == X + 5*X*s

sol = solve(eq1, Y)

G1 = factor(sol/X, s)

% G1 = (sym)

%      5⋅s + 1
%   ──────────────
%      2
%   5⋅s  + 2⋅s + 3

s   = tf('s');
G1  = tf([5 1],[5 2 3])

figure
pzmap(G1)
title('Zero-Pole Map')
xlim([-1 1])
ylim([-1 1])

disp("======================================================================")
disp('estable, parte real de los polos negativa')

figure
step(G1)
title('Step Response')

disp("======================================================================")
disp("SUCCESS")
