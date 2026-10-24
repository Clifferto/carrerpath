% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% BRAZO ROBOT
% ==========================================================================

disp('==========================================================================')
disp('Modelo')
disp('==========================================================================')
disp('M o_pp + C o_p + G o  == tm')
disp('R i + L i_p + kb om_p == v')
disp('ka i - B om_p         == J om_pp')
disp('ka i                  == tm')
disp('')

% variables
syms M C G R L kb ka B J O I Om V Tm s real

eq1 = M*O*s^2 + C*O*s + G*O == Tm
eq2 = R*I + L*I*s + kb*Om*s == V
eq3 = ka*I - B*Om*s         == J*Om*s^2

Tm  = ka*I
eq1 = eval(eq1)

Om  = solve(eq3,Om)
I   = solve(eval(eq2),I)
O   = solve(eval(eq1),O)

O_vs_V  = collect(simplify(O/V),s)

disp("======================================================================")
disp("SUCCESS");
