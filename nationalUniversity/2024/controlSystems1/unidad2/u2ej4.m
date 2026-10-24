% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

% MOTOR CC REALIMENTADO
% ==========================================================================

% variables
s   = tf('s');
ka  = .042; 
kb  = .042;
L1  = 1E-6; 
R1  = 2;
J1  = 10E-6;
B1  = .3E-5;

kp  = 1000

G1 = 1/(L1*s + R1)
G2 = 1/(J1*s + B1)

% TL = 0
% ==========================================================================
% G     == G1 ka G2
% H     == kb
% ! kp  == GANANCIA ANTES DEL COMPARADOR
G3__TL0 = kp*feedback(G1*ka*G2,kb)

% G     == G3__TL0
% H     == 1
% ! 1   == GANANCIA ANTES DEL COMPARADOR
W_vs_Wr__TL0 = feedback(G3__TL0,1)

t = linspace(0,100E-6,10000);

figure
lsim(W_vs_Wr__TL0, 300*heaviside(t), t)

% Wr = 0
% ==========================================================================
% ! 1 - COMO Wr = 0, EL PRIMER COMPARADOR SE CAMBIA POR UNA GANANCIA -1
% ! 2 - SI TRASLADAMOS LAS GANANCIAS DE LOS COMPARADORES A -kp Y -kb, EL SEGUNDO COMPARADOR FORMA UNA SUMA DE TF
% ! 3 - LA SUMA DE TF SE SIMPLIFICA A (- kp - kb) = -(kp + kb)
% ! 4 - SIMPLIFICANDO EL SEGUNDO COMPARADOR DESAPARECE, Y LA ENTRADA DE G1 ES -(kp+kb)*W
% G     == G2
% H     == -(kp+kb) G1 ka
% ! -1  == GANANCIA ANTES DEL COMPARADOR
W_vs_TL__Wr0    = -1*feedback(G2,-(kp+kb)*G1*ka,'+')

t = linspace(1.99,(2+50E-6),10000);

figure
lsim(W_vs_TL__Wr0, .01*heaviside(t-2), t)

% ! ==========================================================================
% ! DENOMINADORES IGUALES SIEMPRE
% ! ==========================================================================

disp("======================================================================")
disp("SUCCESS");

return
