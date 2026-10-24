% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% BRAZO ROBOT CON HERRAMIENTA
% ==========================================================================

disp('==========================================================================')
disp('Modelo')
disp('==========================================================================')
disp('o_ppp + 5 o_pp + 4 o_p    == 2 i')
disp('i_p + i                   == v3_p')
disp('r - v1 - v2               == v3')
disp('k1 o                      == v1')
disp('k2 o_p                    == v2')
disp('')

% variables
syms k1 k2 O I V1 V2 V3 R s real
V1  = k1*O
V2  = k2*O*s

eq1 = O*s^3 + 5*O*s^2 + 4*O*s   == 2*I
eq2 = I*s + I                   == V3*s
eq3 = R - V1 - V2               == V3

sol = solve(eq2,I);
sol = solve(subs(eq1,I,sol),V3);
sol = solve(subs(eq3,V3,sol),O);

O_vs_R = collect(sol/R,s)

disp('Comprobacion por algebra de bloques')
disp('==========================================================================')

% variables
syms G1 G2 H1 H2 real
G1  = s/(s+1);
G2  = 2/(s^3 + 5*s^2 + 4*s);
H1  = k2*s;
H2  = k1;

A   = G1*G2/(1+G1*G2*H1);
G   = collect(factor(A/(1+A*H2),s),s)

G == O_vs_R

disp('======================================================================')
disp('SUCCESS')
