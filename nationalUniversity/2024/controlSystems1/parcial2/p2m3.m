% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control

% variables
s   = tf('s');
G   = zpk([], [0 -10], [1])
% realimentacion unitaria
H   = 1

% Transfer function 'G' from input 'u1' to output ...
%           1
%  y1:  ----------
%       s^2 + 10 s

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
FTLA    = G*H;

disp('')
disp('=======================================================================')
disp('CONTROLADOR P (Criticamente Amortiguada)')
disp('=======================================================================')

rlocus(FTLA)

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -5

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = 1/(sp^2 + 10*sp);
k       = 1/(abs(FTLAp))

figure
step(feedback(G,H), feedback(k*G,H))

disp('')
disp('=======================================================================')
disp('SUCCESS')
