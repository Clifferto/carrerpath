% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% ESTABILIDAD Y RESPUESTA AL ESCALON
% ==========================================================================

disp('==========================================================================')
disp('SISTEMAS Y POLOS')
disp('==========================================================================')

% variables
s = tf('s');

G1 = (50*s + 8)/(s^3 + 11*s^2 + 23*s - 8)
pole(G1)

G2 = (50*s + 8)/(s^3 + 11*s^2 + 23*s + 8)
pole(G2)

G3 = (50*s - 8)/(s^3 + 11*s^2 + 23*s + 8)
pole(G3)

G4 = (50*s + 8)/(s^3 + 23*s + 8)
pole(G4)

G5 = (s - 4)/(s^5 + s^4 + 3*s^3 +9*s^2 + 16*s + 10)
pole(G5)

G6 = (s + 8)/(s^4 + s^3 + 2*s^2 + 2*s + 3)
pole(G6)

G7 = (s^2 + 3*s + 8)/(s^5 + 4*s^4 + 8*s^3 +8*s^2 + 7*s + 4)
pole(G7)

G8 = s/(2*s^5 + s^4 + 2*s^3 + 4*s^2 + s + 6)
pole(G8)

G9 = 54/(s^3 + 13*s^2 + 55*s + 75)
pole(G9)

disp('==========================================================================')
disp('DIAGRAMAS POLOS-CEROS')
disp('==========================================================================')

figure
pzmap(G1)

figure
pzmap(G2)

figure
pzmap(G3)

figure
pzmap(G4)

figure
pzmap(G5)

figure
pzmap(G6)

figure
pzmap(G7)

figure
pzmap(G8)

figure
pzmap(G9)

disp('==========================================================================')
disp('ESTABILIDAD...')
disp('==========================================================================')

close all;

disp('==========================================================================')
disp('RESPUESTA AL ESCALON')
disp('==========================================================================')

figure
step(G1)

figure
step(G2)

figure
step(G3)

figure
step(G4)

figure
step(G5)

figure
step(G6)

figure
step(G7)

figure
step(G8)

figure
step(G9)

disp('======================================================================')
disp('SUCCESS')
