% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

% PID PARA SISTEMA DE SUSPENSION
% ==========================================================================

% Xa_vs_W = (sym)
%                                kc⋅(bs⋅s + ks)
%   ─────────────────────────────────────────────────────────────────────────
%                 3                            4    2
%      bs⋅kc⋅s + bs⋅s ⋅(ma + ms) + kc⋅ks + ma⋅ms⋅s  + s ⋅(kc⋅ma + ks⋅ma + ks⋅ms)

% variables
s = tf('s');
ma  = 350;
ms  = 20;
ks  = 100;
kc  = 300;
bs  = 500;

Xa_vs_W = minreal(tf([kc*bs kc*ks], [(ma*ms) bs*(ma+ms) (kc*ma + ks*ma + ks*ms) bs*kc kc*ks]))

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
figure
step(feedback(Xa_vs_W,1))

damp(Xa_vs_W)
ess_p = 1/(1 + dcgain(Xa_vs_W))

FTLA    = Xa_vs_W*1

[z, p ,k] = zpkdata(FTLA, 'v')
% z = -0.2000
% p =
%   -25.6706 +       0i
%    -0.2605 +  0.7981i
%    -0.2605 -  0.7981i
%    -0.2369 +       0i
% k = 21.429

% FTLA = (sym)
%                                21.429*(s + 0.2000)
%   ─────────────────────────────────────────────────────────────────────────
%                                            2
%               (s + 25.6706)*(s + 0.2369)*(s + 0.5210*s + 0.7048)   

disp('')
disp('=======================================================================')
disp('CONTROLADOR PID (Mejorar Transitorio Y Eliminar ess_P)')
disp('=======================================================================')
syms s kp ki kd real

PID = factor(kp*(1 + ki/s + kd*s))

disp('')
disp('Por Igualacion De Las FTLA Y El PID:')
disp('=======================================================================')
disp('Cancelamos los polos complejos conjugados (par de polos mas dominantes)')
disp('=======================================================================')
% !   2
% ! (s + 0.5210*s + 0.7048)   
% ! ───────────────────────
% !         0.5210
% PID = (sym)
%     ⎛    2         ⎞
%   kp⋅⎝kd⋅s  + ki + s⎠
%   ───────────────────
%            s
kp  = 1
kd  = 1/0.5210
ki  = 0.7048/0.5210

s   = tf('s')
PID = kp*(1 + ki/s + kd*s)

disp('')
disp('FTLA Compensada')
disp('=======================================================================')
FTLA    = minreal(PID*Xa_vs_W*1);
zpk([-0.2000], [-25.6706 -0.2369 0], [21.429])

disp('')
disp('Ajuste De Ganancia')
disp('=======================================================================')
figure;
rlocusx(FTLA)
kp  = 4

disp('')
disp('=======================================================================')
disp('CONTROLADOR PID FINAL')
disp('=======================================================================')
PID = kp*(1 + ki/s + kd*s)

disp('')
disp('======================================================================')
disp('SUCCESS')
