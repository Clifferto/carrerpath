% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control

% variables
s   = tf('s');

disp('SISTEMA')
disp('=======================================================================')
disp('')

% realimentacion unitaria
H       = 1
G1      = 1/(s*(s^2 + 4*s + 5))
psita   = .66

rlocus(G1*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp1 = -.74 + .84j 
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
Gp1 = 1/(sp1*(sp1^2 + 4*sp1 + 5))
Hp1 = 1;
k   = 1/(abs(Gp1*Hp1))
disp('')

disp('======================================================================')
disp('SUCCESS')
