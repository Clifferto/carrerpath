% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% MOTOR DC
% ==========================================================================

disp('Teorema Del Valor Final')
disp('==========================================================================')
disp('lim y     ==  lim (s Y)')
disp('t -> inf      s -> 0')
disp('==========================================================================')

syms s real

% G == W/V
G = 3000/(s^2 + 156.25*s + 1837.5)
% v = 10*u
W   = G*10/s

disp('Con eval(): s = 0')
disp('==========================================================================')
disp('')

factor(s*W, s)
s       = 0;
w_ss    = eval(ans)

disp('Con limit(): s -> 0')
disp('==========================================================================')
disp('')

syms s real

w_ss = double(limit(s*W, s, 0))

clear all;

disp('Con dcgain(minreal(Y)): s -> 0')
disp('==========================================================================')
disp('')

s   = tf('s')
G   = 3000/(s^2 + 156.25*s + 1837.5)

W       = G*10/s
w_ss    = dcgain(minreal(W*s))

disp('Con step(): val para t muy grande')
disp('==========================================================================')
disp('')

% ! UNIT step response, but V has amplitude 10v
step(G, tfinal=5)
w_ss    = 10*1.633

disp('Con lsim(): val para t muy grande')
disp('==========================================================================')
disp('')

t = linspace(0,5,1000);
lsim(G, 10*heaviside(t), tfinal=5)
w_ss    = 16.33

close all;

disp('==========================================================================')
disp('Second Order System')
disp('==========================================================================')
disp('')

disp('ganancia, frecuencia natural, psita y tss')
disp('==========================================================================')
disp('')

s   = tf('s');
a   = 3000;
b   = 156.25;
c   = 1837.5;
G   = a/(s^2 + b*s + c);

%           k0 * wn^2                     a           
%   -------------------------   ==  -------------   
%   s^2 + 2 psita wn s + wn^2       s^2 + b s + c   

wn      = sqrt(c)
k0      = a/wn^2
psita   = b/(2*wn)
% ! tss ~ 4/(psita wn)
tss     = 4/(psita*wn)

disp('SISTEMA SOBRE-AMORTIGUADO')

disp('step response')
disp('==========================================================================')
disp('')

figure
step(G)
% hold on
% plot(k0*.98)
k0*.98

disp('zero-pole map')
disp('==========================================================================')
disp('')

figure
pzmap(G)
title('Zero-Pole Map')
% xlim([-1 1])
% ylim([-1 1])

disp("======================================================================")
disp("SUCCESS");
