% ==========================================================================
clear all; close all; clc;

% Carga del paquete utilizado
pkg load control
pkg load symbolic

% SISTEMA G1:
% ==========================================================================
G1  = tf(5,[1 2])
step(G1); grid

% valor final
a = 5/(s+2);
limit(a,s,0)

% SISTEMA G2:
% ==========================================================================
G2  = zpk([],[-2 -3],1)
step(G2);grid

% valor final
a = 1/((s+2)*(s+3));
limit(a,s,0)

% SISTEMA G3:
% ==========================================================================

% 'imputdelay' no esta implementada en Octave. Si bien el grafico de la 
% respuesta comienza en 0, deberia ser a los 10 seg. 
% Ademas esto no deberia afecta al valor final.
G3 = tf(2,[1 2]) 
step(G3); grid

% valor final
a = (2*e^(-10*s))/(s+2);
limit(a,s,0)

% SISTEMA G4:
% ==========================================================================
G4=5*tf([1 1],[1 1 2])
step(G4);grid

% valor final
a = (5*(s+1))/(s^2+s+2);
limit(a,s,0)

% SISTEMA G5:
% ==========================================================================
G5=zpk([-2],[-3 -4],5)
step(G5);grid

% valor final
a = (5*(s+2))/((s+3)*(s+4));
limit(a,s,0)

% SISTEMA G6:
% ==========================================================================
G6 = tf(5,[1 0])
step(G6); grid

% valor final
a = 5/s;
limit(a,s,0)

% SISTEMA G7:
% ==========================================================================
G7 = zpk([-2],[0 -4],12)
step(G7); grid

% valor final
a = (12*(s+2))/(s*(s+4));
limit(a,s,0)

% SISTEMA G8:
% ==========================================================================
G8 = zpk([0],[-40],1)
step(G8); grid

% valor final
a = s/(s+40);
limit(a,s,0)

disp("======================================================================")
disp("SUCCESS");

return
