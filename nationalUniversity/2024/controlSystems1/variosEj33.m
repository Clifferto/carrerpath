% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
% pkg load symbolic

% variables
s   = tf('s');
% realimentacion unitaria
H   = 1
G   = zpk([], [0 -25], [2500])

FTLA    = G*H

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
step(feedback(G,H))

mp      = .05
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))

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
% Transfer function 'FTLA' from input 'u1' to output ...
%          2500
%  y1:  ----------
%       s^2 + 25 s
sp      = -12.5 + 13j
FTLAp   = 2500/(sp^2 + 25*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Ajuste De Ganancia')
disp('=======================================================================')
k       = .13

figure
step(feedback(G,H), feedback(k*G,H))

disp('')
disp('======================================================================')
disp('SUCCESS')
