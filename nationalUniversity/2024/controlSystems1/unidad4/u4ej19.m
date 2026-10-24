% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% variables
s   = tf('s');
G   = 100*(s + 40)/((s + 1)*(s + 5))

disp('REALIMENTACION UNITARIA')
disp('==========================================================================')
disp('')

H1  = 1

disp('REALIMENTACION NO UNITARIA')
disp('==========================================================================')
disp('')

H2  = 1/(s + 20)
% rlocusx(G*H2)

% sobre-pico maximo
mp      = .04
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================

psita   = .707

rlocus(G*H1)
sgrid(psita, [5,10,15])

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('==========================================================================')
sp1 = -36.8 + 36.8j 
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('==========================================================================')
Gp1 = 100*(sp1 + 40)/((sp1 + 1)*(sp1 + 5));
Hp1 = 1;
k   = 1/(abs(Gp1*Hp1))
disp('')

% rlocusx(G*H1)

rlocus(G*H2, .01, 0, 100)
sgrid(psita, [5,10,15])

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('==========================================================================')
sp2 = -2.81 + 2.84j 
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('==========================================================================')
Gp2 = 100*(sp2 + 40)/((sp2 + 1)*(sp2 + 5));
Hp2 = 1/(sp2 + 20);
k   = 1/(abs(Gp2*Hp2))
disp('')

rlocusx(G*H2, .001, 0, .1)

mp  = (.67 - .65)/.65

disp('======================================================================')
disp('SUCCESS')
