% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% SISTEMA SUSPENSION
% ==========================================================================

disp('Diagrama De Cuerpo Libre')
disp('==========================================================================')
disp('Coord hacia arriba, camino tira hacia abajo, ma tambien baja')
disp('==========================================================================')
disp('')

disp('Modelo')
disp('==========================================================================')
disp('Suspension:   -kc(xs-w) + ks(xa-xs) + bs(xa_p-xs_p)   == ms xs_pp')
disp('Auto      :   -ks(xa-xs) - bs(xa_p-xs_p)              == ma xa_pp')
disp('==========================================================================')
disp('')

% variables
syms ma ms kc ks bs W Xs Xa s real

eq1 = -kc*(Xs-W) + ks*(Xa-Xs) + s*bs*(Xa-Xs) == ms*Xs*s^2
eq2 = -ks*(Xa-Xs) - s*bs*(Xa-Xs) == ma*Xa*s^2

disp('G == Xa/W')
disp('==========================================================================')
disp('')

Xs  = solve(eq2,Xs)
Xa  = solve(eval(eq1),Xa)

Xa_vs_W = factor(Xa/W, s)

% Xa_vs_W = (sym)
%                                kc⋅(bs⋅s + ks)
%   ─────────────────────────────────────────────────────────────────────────
%                 3                            4    2
%      bs⋅kc⋅s + bs⋅s ⋅(ma + ms) + kc⋅ks + ma⋅ms⋅s  + s ⋅(kc⋅ma + ks⋅ma + ks⋅ms)

s = tf('s')
ma  = 500;
ms  = 50;
ks  = 10;
kc  = 50;
bs  = 80;

Xa_vs_W = minreal(tf([kc*bs kc*ks], [(ma*ms) bs*(ma+ms) (kc*ma + ks*ma + ks*ms) bs*kc kc*ks]))

disp('G == Xa/W')
disp('==========================================================================')
disp('')

step(Xa_vs_W)
title('Step Response')

disp("======================================================================")
disp("SUCCESS");
