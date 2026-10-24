% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load control
pkg load symbolic

% MOTOR CC
% ==========================================================================

% variables
s   = tf('s');
ka  = .042; 
kb  = .042;
L1  = 1E-6; 
R1  = 2;
J1  = 10E-6;
B1  = .3E-5;

G1 = 1/(L1*s + R1)
G2 = 1/(J1*s + B1)

% TL = 0
% ==========================================================================
% G == G1 ka G2
% H == kb
W_vs_E__TL0 = feedback(G1*ka*G2,kb)

% G == G1
% H == ka G2 kb
I_vs_E__TL0 = feedback(G1,ka*G2*kb)

% E = 0
% ==========================================================================
% G     == G2
% H     == kb (-1) G1 ka
% ! -1  == GANANCIA ANTES DEL COMPARADOR
W_vs_TL__E0 = -1*feedback(G2,-kb*G1*ka,'+')

% G     == G2 kb (-1) G1
% H     == ka
% ! -1  == GANANCIA ANTES DEL COMPARADOR
I_vs_TL__E0 = -1*feedback(G2*(-kb)*G1,ka,'+')

return
% ! ==========================================================================
% ! DENOMINADORES IGUALES SIEMPRE
% ! ==========================================================================

t = linspace(0,5,1000);

figure
lsim(W_vs_E__TL0, 24*heaviside(t), t)
figure
lsim(I_vs_E__TL0, 24*heaviside(t), t)

t = linspace(0,3,10000);

figure
lsim(W_vs_TL__E0, .01*heaviside(t-2), t)
figure
lsim(I_vs_TL__E0, .01*heaviside(t-2), t)

disp("======================================================================")
disp("SUCCESS");

return
