% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
% pkg load symbolic

% variables
s   = tf('s');

Jm  = 0.01
B   = 0.1
K   = 0.01
R   = 1
L   = 5E-3
% realimentacion unitaria
H   = 1
G   = K/((Jm*s + B)*(L*s + R) + K^2)

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
step(feedback(G,H))
ess_p   = 1/(1 + dcgain(G))

FTLA    = G*H;

disp('')
disp('=======================================================================')
disp('CONTROLADOR PI (Mejorar Transitorio Y Eliminar ess_p)')
disp('=======================================================================')
mp      = .05
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))

k       = 1;
p_dom   = -max(pole(FTLA))
PI      = k*(s + p_dom)/s;

FTLA    = minreal(PI*G*H)

figure
rlocus(FTLA)
sgrid(psita, [50:50:200])

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
% Transfer function 'FTLA' from input 'u1' to output ...
%           200
%  y1:  -----------
%       s^2 + 200 s
sp      = -99.8 + 104.8j
FTLAp   = 200/(sp^2 + 200*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

figure
step(feedback(G,H), feedback(PI*G,H))

disp('')
disp('======================================================================')
disp('SUCCESS')
