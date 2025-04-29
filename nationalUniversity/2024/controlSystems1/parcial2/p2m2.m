% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control

% variables
s   = tf('s');
G   = tf([66 2904], [1 30 183 154])
% realimentacion unitaria
H   = 1

% Transfer function 'G' from input 'u1' to output ...
%              66 s + 2904
%  y1:  --------------------------
%       s^3 + 30 s^2 + 183 s + 154

disp('')
disp('=======================================================================')
disp('CARACTERIZACION DE LA PLANTA')
disp('=======================================================================')
FTLA    = G*H;

damp(G)
rlocus(FTLA)

disp('')
disp('=======================================================================')
disp('CONTROLADOR PI (Mejorar Transitorio Y Eliminar ess_p)')
disp('=======================================================================')
% SIN SOBREPICO Y TIEMPO DE ESTABLECIMIENTO MINIMO
psita   = 1

k       = 1;
p_dom   = -max(pole(G*H))
PI      = k*(s + p_dom)/s;

FTLA    = minreal(PI*G*H)
% Transfer function 'FTLA' from input 'u1' to output ...
%           66 s + 2904
%  y1:  --------------------
%       s^3 + 29 s^2 + 154 s

rlocus(FTLA)
sgrid(psita, [25:25:100])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -3.32

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = (66*sp + 2904)/(sp^3 + 29*sp^2 + 154*sp);
k       = 1/(abs(FTLAp))
Ti      = abs(1/p_dom)

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

figure
step(feedback(G,H), feedback(PI*G,H))

% ==========================================================================
close all

disp('')
disp('=======================================================================')
disp('CONTROLADOR PI (Mejorar Transitorio Y Eliminar ess_p)')
disp('=======================================================================')
% SOBREPICO MENOR AL 4% Y TIEMPO DE ESTABLECIMIENTO MINIMO

% ! BUENA APROXIMACION:
% ! ==========================================================================
% ! psita   = 0.707 --> mp  <= 4 %  --> alpha   = 45 grados
% ! ==========================================================================
psita   = .707

k   = 1
PI  = k*(s + p_dom)/s;

FTLA    = minreal(PI*G*H)
% Transfer function 'FTLA' from input 'u1' to output ...
%           66 s + 2904
%  y1:  --------------------
%       s^3 + 29 s^2 + 154 s

rlocus(FTLA)
sgrid(psita, [25:25:100])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -3.18 + 3.23j

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = (66*sp + 2904)/(sp^3 + 29*sp^2 + 154*sp);
k       = 1/(abs(FTLAp))
Ti      = abs(1/p_dom)


disp('')
disp('Ajuste De Ganancia')
disp('=======================================================================')
k   = .155

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

figure
step(feedback(G,H), feedback(PI*G,H))

disp('')
disp('=======================================================================')
disp('SUCCESS')
