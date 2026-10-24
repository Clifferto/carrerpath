% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

% variables
s       = tf('s');
% realimentacion unitaria
H1  = 1
H2  = 1

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================
psita   = .707

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
G1  = tf([100], [1 100])
G2  = tf([2340], [1 212.8])
G   = feedback(G1*G2, H1)
% step(G)

damp(G)
ess_p   = 1/(1 + dcgain(G1*G2))

FTLA    = G1*G2*H1

disp('')
disp('=======================================================================')
disp('CONTROLADOR PID (Mejorar Transitorio Y Eliminar ess_P)')
disp('=======================================================================')
syms s kp Ti Td real

PID = factor(kp*(1 + 1/(Ti*s) + Td*s))

disp('')
disp('Por Igualacion De Las FT De La Planta Y El PID')
disp('=======================================================================')
% Transfer function 'G' from input 'u1' to output ...
%               2.34e+05
%  y1:  -------------------------
%       s^2 + 312.8 s + 2.553e+05

% PID = (sym)
%      ⎛       2           ⎞
%   kp⋅⎝Td⋅Ti⋅s  + Ti⋅s + 1⎠
%   ────────────────────────
%             Ti⋅s
kp  = 1
Ti  = 312.8/2.553e+05
Td  = 1/(2.553e+05*Ti)

s   = tf('s')
PID = kp*(1 + 1/(Ti*s) + Td*s)

disp('')
disp('Ajuste De Ganancia')
disp('=======================================================================')
Gn      = tf([2.34e+05]/2.553e+05, [1 312.8 2.553e+05]/2.553e+05)
FTLA    = minreal(PID*Gn*H2)

disp('')
disp('=======================================================================')
disp('CONTROLADOR PID FINAL')
disp('=======================================================================')
PID

disp('')
disp('======================================================================')
disp('SUCCESS')
