% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control

% variables
s   = tf('s');

disp('SISTEMAS')
disp('=======================================================================')
disp('')

% realimentacion unitaria
H   = 1

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================

psita   = .707

G1  = 100/(s*(s + 5))

rlocus(G1*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp1 = -2.5 + 2.5j 
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
Gp1 = 100/(sp1*(sp1 + 5))
Hp1 = 1;
k   = 1/(abs(Gp1*Hp1))
disp('')

G2  = 100*(s^2 + 40*s + 800)/((s + 80)*(s + 50))

rlocus(G2*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, LA GANANCIA DEBERIA SER INFINITA')
disp('=======================================================================')

G3  = 100/((s + 80)*(s + 50)*(s - 10))

rlocus(G3*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp3 = -12.5 + 12.5j 
disp('')

disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
Gp3 = 100/((sp3 + 80)*(sp3 + 50)*(sp3 - 10))
Hp3 = 1;
k   = 1/(abs(Gp3*Hp3))
disp('')

G4  = 100*(s + 40)/((s + 5)*(s^2 + 20*s + 1700))

rlocus(G4*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, NO EXISTE UN PUNTO PARA CUMPLIR ESPECIFICACIONES')
disp('=======================================================================')

G5  = 100*(s + 40)/((s - 5)*(s^2 + 20*s + 1700))

rlocus(G5*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, NO EXISTE UN PUNTO PARA CUMPLIR ESPECIFICACIONES')
disp('=======================================================================')

G6  = 100*(s - 40)/((s + 25)*(s^2 + 20*s + 1700))

rlocus(G6*H)
sgrid(psita, 10)

disp('Por Inspeccion Del LR, NO EXISTE UN PUNTO PARA CUMPLIR ESPECIFICACIONES')
disp('=======================================================================')

disp('======================================================================')
disp('SUCCESS')
