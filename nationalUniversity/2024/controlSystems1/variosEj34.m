% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
% pkg load symbolic

% variables
s   = tf('s');
% realimentacion unitaria
H   = 1
G   = zpk([-4], [0 -2], [1])

FTLA    = G*H

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
step(feedback(G,H))

psita   = .84

disp('')
disp('=======================================================================')
disp('CONTROLADOR P (Mejorar Transitorio Y Eliminar ess_p)')
disp('=======================================================================')

figure
rlocus(FTLA)
sgrid(psita, [10:10:30])

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
% Transfer function 'G' from input 'u1' to output ...
%         s + 4
%  y1:  ---------
%       s^2 + 2 s
sp      = -4.35 + 2.81j
FTLAp   = (sp + 4)/(sp^2 + 2*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Ajuste De Ganancia')
disp('=======================================================================')
k       = 6.7

figure
step(feedback(G,H), feedback(k*G,H))

disp('')
disp('======================================================================')
disp('SUCCESS')
