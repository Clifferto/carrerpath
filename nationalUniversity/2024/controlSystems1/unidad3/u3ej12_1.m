% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% CIRCUITO RLC
% ==========================================================================

disp('==========================================================================')
disp('Modelo')
disp('==========================================================================')
disp('Jm Om_pp + b Om_p + k(Om - Ol)    == tm')
disp('k(Om - Ol)                        == Jl O_pp')
disp('')

% variables
syms Jm Jl b k Om Ol Tm s real

eq1 = Jm*Om*s^2 + b*Om*s + k*(Om - Ol)  == Tm
eq2 = k*(Om - Ol)                       == Jl*Ol*s^2

sol = solve(eq1,eq2,Om,Ol)

Om_vs_Tm    = collect(simplify(sol.Om/Tm),s)
Ol_vs_Tm    = collect(simplify(sol.Ol/Tm),s)

disp("======================================================================")
disp("SUCCESS");
