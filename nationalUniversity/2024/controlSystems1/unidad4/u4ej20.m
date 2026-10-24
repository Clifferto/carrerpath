% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic
pkg load control

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================

% variables
s   = tf('s');

disp('SISTEMAS')
disp('==========================================================================')
disp('')

% realimentacion unitaria
H   = 1

G1  = 100/(s*(s + 5))

% rlocusx(G1*H)

disp('Por Inspeccion Del LR, NO PUEDE OSCILAR')
disp('==========================================================================')

G2  = 100*(s^2 + 40*s + 800)/((s + 80)*(s + 50))

rlocus(G2*H)

disp('Por Inspeccion Del LR, NO PUEDE OSCILAR')
disp('==========================================================================')

G3  = 100/((s + 80)*(s + 50)*(s - 10))

rlocus(G3*H)

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('==========================================================================')
sp3 = 52j 
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('==========================================================================')
Gp3 = 100/((sp3 + 80)*(sp3 + 50)*(sp3 - 10))
Hp3 = 1;
k   = 1/(abs(Gp3*Hp3))
disp('')

G4  = 100*(s + 40)/((s + 5)*(s^2 + 20*s + 1700))

rlocus(G4*H)

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('==========================================================================')
sp4 = 65j
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('==========================================================================')
Gp4 = 100*(sp4 + 40)/((sp4 + 5)*(sp4^2 + 20*sp4 + 1700))
Hp4 = 1;
k   = 1/(abs(Gp4*Hp4))
disp('')

G5  = 100*(s + 40)/((s - 5)*(s^2 + 20*s + 1700))

rlocus(G5*H)

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('==========================================================================')
sp5 = 54j
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('==========================================================================')
Gp5  = 100*(sp5 + 40)/((sp5 - 5)*(sp5^2 + 20*sp5 + 1700))
Hp5 = 1;
k   = 1/(abs(Gp5*Hp5))
disp('')

G6  = 100*(s - 40)/((s + 25)*(s^2 + 20*s + 1700))

rlocus(G6*H)

disp('Por Inspeccion Del LR, NO PUEDE OSCILAR')
disp('==========================================================================')

disp('======================================================================')
disp('SUCCESS')
