% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% MOTOR DC
% ==========================================================================

disp('==========================================================================')
disp('Malla Electrica: Tension aplicada == Caidas de tension')
disp('==========================================================================')
disp('v     == R i + L i_p + kb w')
disp('')
disp('==========================================================================')
disp('Ley de Newton para la rotacion: Sumatoria de momentos == Momento de inercia por la aceleracion angular')
disp('==========================================================================')
disp('J w_p == ki i - b w - tl')
disp('==========================================================================')

% variables
syms R L kb I V J ki b TL W s real

eq1 = V     == R*I + L*I*s + kb*W
eq2 = J*W*s == ki*I - b*W - TL

% TL == 0
TL  = 0
eq2 = eval(eq2)

I   = solve(eq2, I);
W   = solve(eval(eq1), W);
% W/V, con TL == 0
W_vs_V__TL0 = factor(W/V, s)
% P/V, con TL == 0
P_vs_V__TL0 = factor(1/s*W_vs_V__TL0, s)

syms W I real
W   = solve(eq2, W);
I   = solve(eval(eq1), I);
% T/V, con TL == 0
T_vs_V__TL0 = factor((I/V)*ki, s)

% simulaciones
% ==========================================================================

% W_vs_V__TL0 = (sym)
%                    ki
%   ────────────────────────────────────
%        2
%   J⋅L⋅s  + R⋅b + kb⋅ki + s⋅(J⋅R + L⋅b)

% P_vs_V__TL0 = (sym)
%                      ki
%   ────────────────────────────────────────
%    ⎛     2                           ⎞
%   s⋅⎝J⋅L⋅s  + R⋅b + kb⋅ki + s⋅(J⋅R + L⋅b)⎠

% T_vs_V__TL0 = (sym)
%               ki⋅(J⋅s + b)
%   ────────────────────────────────────
%        2
%   J⋅L⋅s  + R⋅b + kb⋅ki + s⋅(J⋅R + L⋅b)

s = tf('s');
R   = 10;       L = 10E-3;
kb  = 24E-3;    J = 10E-6; ki = 24E-3;  b = 10E-5;

W_vs_V__TL0 = ki/(J*L*s^2 + R*b + kb*ki + s*(J*R + L*b))
P_vs_V__TL0 = ki/(s*(J*L*s^2 + R*b + kb*ki + s*(J*R + L*b)))
T_vs_V__TL0 = ki*(J*s + b)/(J*L*s^2 + R*b + kb*ki + s*(J*R + L*b))

t = linspace(0,20,1E3);

figure
lsim(W_vs_V__TL0, 24*heaviside(t), t)

disp('Velocidad w_ss')
disp('==========================================================================')
disp('')
w_ss = 365.5

figure
lsim(P_vs_V__TL0, 24*heaviside(t), t)

disp('Revoluciones a los 10s')
disp('==========================================================================')
disp('')
rev = 3628.2 / (2*pi)

disp("======================================================================")
disp("SUCCESS");
