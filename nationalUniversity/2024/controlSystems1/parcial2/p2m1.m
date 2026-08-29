% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control

% Un sistema está caracterizado por la siguiente función de transferencia de lazo
% abierto:
% 𝐺(𝑠) = 100
%       𝑠(𝑠 + 5)(𝑠 + 10)
% Diseñar un compensador de manera tal que la respuesta al escalón unitario en lazo
% cerrado tenga un coeficiente de amortiguamiento relativo de 0.707 y una frecuencia
% natural no amortiguada de 7.28.

% variables
s       = tf('s');
FTLA    = zpk([], [0 -5 -10], [100])

% Transfer function 'FTLA' from input 'u1' to output ...
%               100
%  y1:  -------------------
%       s^3 + 15 s^2 + 50 s

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================
psita   = .707

figure
rlocus(FTLA)
sgrid(psita, [5, 10])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -1.91 + 1.91j

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = 100/(sp^3 + 15*sp^2 + 50*sp)
k       = 1/(abs(FTLAp))

figure
rlocusx(k*FTLA)

disp('')
disp('Se Puede Ajustar k Hasta: .98')
disp('=======================================================================')
k   = .98

disp('')
disp('FTLA Compensada')
disp('=======================================================================')
FTLA    = k*FTLA

disp('')
disp('======================================================================')
disp('SUCCESS')
