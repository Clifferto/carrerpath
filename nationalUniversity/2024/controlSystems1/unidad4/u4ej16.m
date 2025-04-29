% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% ! ==========================================================================
% ! CRITERIO DE ROUTH-HURWITZ   -> DEN DE FdTLC == POLINOMIO CARACTERISTICO
% ! LUGAR DE RAICES             -> FdTLA
% ! RESPUESTA AL ESCALON        -> FdTLC
% ! ==========================================================================

% variables
s   = tf('s');

G1  = 10/(s^2+10)
figure
rlocusx(G1); % Inestable para todo valor de K
figure
step(feedback(1*G1,1), TFINAL=10)
hold;
step(feedback(5*G1,1), '-r', TFINAL=10)

G2  = (10*s+20)/(s^2+120*s+10)
figure
rlocusx(G2); % Estable para K>0

G3  = 45/(s^3+12*s^2+10*s+45)
figure
rlocusx(G3); % Estable para K<1.67

G4  = ((s+10)*(s+20))/((s+1)*(s+5))
figure
rlocusx(G4); % Estable para K>0

G5  = ((s+10)*(s+20))/((s-1)*(s+5))
figure
rlocusx(G5); % Estable para K>0.026

G6  = 1/(s+10)*s/(s^2+s+1)
figure
rlocusx(G6) % Estable para K>0

disp('======================================================================')
disp('SUCCESS')
