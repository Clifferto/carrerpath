% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% ==========================================================================
% MOTOR CC
% ==========================================================================
syms s ka kb L1 R1 J1 B1

G1 = 1/(L1*s + R1);
G2 = 1/(J1*s + B1);

% MASON
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = G1*ka*G2

% numero de lazos = 2
% ganancias de los lazos
l1  = -G1*ka*G2*kb;

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - l1 + 0

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;

% TL = 0
% ==========================================================================

% FTLC = sum(Pi Di)/D
W_vs_E__TL0 = factor(p1*D1/D,s)

p1  = G1

% FTLC = sum(Pi Di)/D
I_vs_E__TL0 = factor(p1*D1/D,s)

% E = 0
% ==========================================================================

p1  = -G2

% FTLC = sum(Pi Di)/D
W_vs_TL__E0 = factor(p1*D1/D,s)

p1  = G2*kb*G1

% FTLC = sum(Pi Di)/D
I_vs_TL__E0 = factor(p1*D1/D,s)

% W_vs_E__TL0 = (sym)
%                        ka
%   ────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + s⋅(B₁⋅L₁ + J₁⋅R₁)

% I_vs_E__TL0 = (sym)
%                    B₁ + J₁⋅s
%   ────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + s⋅(B₁⋅L₁ + J₁⋅R₁)

% W_vs_TL__E0 = (sym)
%                  -(L₁⋅s + R₁)
%   ────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + s⋅(B₁⋅L₁ + J₁⋅R₁)

% I_vs_TL__E0 = (sym)
%                        kb
%   ────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + s⋅(B₁⋅L₁ + J₁⋅R₁)

% variables
ka = .042;  kb = .042;
L1 = 1E-6;  R1 = 2;
J1 = 10E-6; B1 = .3E-5;

FTLC_den = [J1*L1, (B1*L1 + J1*R1), B1*R1 + ka*kb]

W_vs_E__TL0 = tf([ka], FTLC_den)
I_vs_E__TL0 = tf([J1, B1], FTLC_den)

W_vs_TL__E0 = tf([-L1, -R1], FTLC_den)
I_vs_TL__E0 = tf([kb], FTLC_den)

t = linspace(0,.1,50E3);

figure
lsim(W_vs_E__TL0, 24*heaviside(t), t)
figure
lsim(I_vs_E__TL0, 24*heaviside(t), t)

t = linspace(1.5,2.5,50E3);

figure
lsim(W_vs_TL__E0, .01*heaviside(t-2), t)
figure
lsim(I_vs_TL__E0, .01*heaviside(t-2), t)

% ==========================================================================
clear all; close all; clc;

% ==========================================================================
% MOTOR CC REALIMENTADO
% ==========================================================================
syms s kp kb ka R1 L1 J1 B1 real

G1  = 1/(L1*s + R1);
G2  = 1/(J1*s + B1);

% MASON
% ==========================================================================
% numero de lazos = 2
% ganancias de los lazos
l1  = -kb*G1*ka*G2;
l2  = -kp*G1*ka*G2;

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2) + 0

% W/Wr, con TL = 0
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = kp*G1*ka*G2;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;

% FTLC = sum(Pi Di)/D
W_vs_Wr__TL0 = factor(p1*D1/D,s)

% I/Wr, con TL = 0
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = kp*G1;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;

% FTLC = sum(Pi Di)/D
I_vs_Wr__TL0 = factor(p1*D1/D,s)

% W/TL, con Wr = 0
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1 = -G2;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1 = 1 - 0;

% FTLC = sum(Pi Di)/D
W_vs_TL__Wr0 = factor(p1*D1/D,s)

% I/TL, con Wr = 0
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = G2*kb*G1;
p2  = G2*kp*G1;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

% FTLC = sum(Pi Di)/D
I_vs_TL__Wr0 = factor((p1*D1 + p2*D2)/D,s)

% W_vs_Wr__TL0 = (sym)
%                          ka⋅kp
%   ────────────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + ka⋅kp + s⋅(B₁⋅L₁ + J₁⋅R₁)

% I_vs_Wr__TL0 = (sym)
%                      kp⋅(B₁ + J₁⋅s)
%   ────────────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + ka⋅kp + s⋅(B₁⋅L₁ + J₁⋅R₁)

% W_vs_TL__Wr0 = (sym)
%                      -(L₁⋅s + R₁)
%   ────────────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + ka⋅kp + s⋅(B₁⋅L₁ + J₁⋅R₁)

% I_vs_TL__Wr0 = (sym)
%                         kb + kp
%   ────────────────────────────────────────────────────
%                  2
%   B₁⋅R₁ + J₁⋅L₁⋅s  + ka⋅kb + ka⋅kp + s⋅(B₁⋅L₁ + J₁⋅R₁)

% variables
ka = .042;  kb = .042;
L1 = 1E-6;  R1 = 2;
J1 = 10E-6; B1 = .3E-5;
kp = 1

FTLC_den = [J1*L1, (B1*L1 + J1*R1), (ka*kb + ka*kp + B1*R1)]

W_vs_Wr__TL0 = tf([ka*kp], FTLC_den)
I_vs_Wr__TL0 = tf([kp*J1, kp*B1], FTLC_den)
W_vs_TL__Wr0 = tf([-L1, -R1], FTLC_den)
I_vs_TL__Wr0 = tf([kb + kp], FTLC_den)

t = linspace(0,.01,50E3);

figure
lsim(W_vs_Wr__TL0, 300*heaviside(t), t)
figure
lsim(I_vs_Wr__TL0, 300*heaviside(t), t)

t = linspace(1.9,2.1,50E3);

figure
lsim(W_vs_TL__Wr0, .01*heaviside(t-2), t)
figure
lsim(I_vs_TL__Wr0, .01*heaviside(t-2), t)

t = linspace(0,2.1,50E3);

figure
lsim((W_vs_Wr__TL0 + W_vs_TL__Wr0), (300*heaviside(t) - 300*heaviside(t-2) + .01*heaviside(t-2)), t)
return
figure
lsim(W_vs_TL__Wr0, .01*heaviside(t-2), t)

disp("======================================================================")
disp("SUCCESS");
