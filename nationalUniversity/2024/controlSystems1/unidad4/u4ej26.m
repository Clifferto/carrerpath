% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control

% variables
s       = tf('s');
% realimentacion unitaria
H       = 1
psita   = 1

disp('')
disp('=======================================================================')
disp('SISTEMA 1')
disp('=======================================================================')
G1      = 10/((s + 10)*(s + 100))
FTLA    = G1*H;

figure
rlocus(FTLA)

p_dom   = -max(pole(FTLA))
PI      = (s + p_dom)/s;
FTLA    = minreal(PI*G1*H)

figure
rlocus(FTLA)
sgrid(psita, [25:25:100])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -50

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
% Transfer function 'FTLA' from input 'u1' to output ...
%           10
%  y1:  -----------
%       s^2 + 100 s
FTLAp   = 10/(sp^2 + 100*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

% ==========================================================================
close all;

disp('')
disp('=======================================================================')
disp('SISTEMA 2')
disp('=======================================================================')
G2      = 0.8/((0.1*s + 1)*(0.05*s + 1))
FTLA    = G2*H;

figure
rlocus(FTLA)

p_dom   = -max(pole(FTLA))
PI      = (s + p_dom)/s;
FTLA    = minreal(PI*G2*H)

figure
rlocus(FTLA)
sgrid(psita, [5:5:15])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -10

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
% Transfer function 'FTLA' from input 'u1' to output ...
%          160
%  y1:  ----------
%       s^2 + 20 s
FTLAp   = 160/(sp^2 + 20*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

% ==========================================================================
close all;

disp('')
disp('=======================================================================')
disp('SISTEMA 3')
disp('=======================================================================')
G3      = tf([125], [1 33 200])
FTLA    = G3*H;

figure
rlocus(FTLA)

p_dom   = -max(pole(FTLA))
PI      = (s + p_dom)/s;
FTLA    = minreal(PI*G3*H)

% Transfer function 'FTLA' from input 'u1' to output ...
%          125
%  y1:  ----------
%       s^2 + 25 s

figure
rlocus(FTLA)
sgrid(psita, [5:5:20])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -12.5

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = 125/(sp^2 + 25*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

% ==========================================================================
close all;

disp('')
disp('=======================================================================')
disp('SISTEMA 4')
disp('=======================================================================')
G4      = zpk([], [-1 -1 -1], [1.24])
FTLA    = G4*H;

figure
rlocus(FTLA, .01, 0 , 10)

p_dom   = -max(pole(FTLA))
PI      = (s + p_dom)/s;
FTLA    = minreal(PI*G4*H)

% Transfer function 'FTLA' from input 'u1' to output ...
%             1.24
%  y1:  -----------------
%       s^3 + 2 s^2 + 1 s

figure
rlocus(FTLA, .01, 0 , 10)
sgrid(psita, [.5:.5:2])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -1/3

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = 1.24/(sp^3 + 2*sp^2 + sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

% ==========================================================================
close all;

disp('')
disp('=======================================================================')
disp('SISTEMA 5')
disp('=======================================================================')
G5      = zpk([-60], [-10 -20], [20])
FTLA    = G5*H;

figure
rlocus(FTLA)

p_dom   = -max(pole(FTLA))
PI      = (s + p_dom)/s;
FTLA    = minreal(PI*G5*H)

% Transfer function 'FTLA' from input 'u1' to output ...
%       20 s + 1200
%  y1:  -----------
%       s^2 + 20 s

figure
rlocus(FTLA)
sgrid(psita, [10:10:40])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -11

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = (20*sp + 1200)/(sp^2 + 20*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

% ==========================================================================
close all;

disp('')
disp('=======================================================================')
disp('SISTEMA 6')
disp('=======================================================================')
G6      = tf([800 320E3], [1 330 29E3 600E3])
FTLA    = G6*H;

figure
rlocus(FTLA)

p_dom   = -max(pole(FTLA))
PI      = (s + p_dom)/s;
FTLA    = minreal(PI*G6*H)

% Transfer function 'FTLA' from input 'u1' to output ...
%           800 s + 3.2e+05
%  y1:  -----------------------
%       s^3 + 300 s^2 + 2e+04 s

figure
rlocus(FTLA)
sgrid(psita, [250:250:1000])

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -45.5

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
FTLAp   = (800*sp + 3.2e+05)/(sp^3 + 300*sp^2 + 2e+04*sp)
k       = 1/(abs(FTLAp))

disp('')
disp('Controlador PI Final')
disp('=======================================================================')
PI  = k*(s + p_dom)/s

disp('')
disp('======================================================================')
disp('SUCCESS')
