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

%a) Polo en 0, cero en -8.
% figure
rlocusx(zpk([-8],[0],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0')
disp('==========================================================================')
disp('')

%b) Polos en 0,-2, cero en -4
% figure
rlocusx(zpk([-4],[0 -2],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0')
disp('==========================================================================')
disp('')

%c) Polos en -1,-1,-1
% figure
rlocusx(zpk([],[-1 -1 -1],1), .01, 0, 10); sgrid

disp('Lugar de Raices: ESTABLE para k < 8')
disp('==========================================================================')
disp('')

%d) Polos en 0,-1, ceros en -4, -6
% figure
rlocusx(zpk([-4 -6],[0 -1],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0')
disp('==========================================================================')
disp('')

%e) Polos en -3, -5, ceros en 4,-1
% figure
rlocusx(zpk([4 -1],[-3 -5],1)); sgrid

disp('Lugar de Raices: ESTABLE para k < 2.67')
disp('==========================================================================')
disp('')

%f) Polos en 3, -4, ceros en -8,-10
% figure
rlocusx(zpk([-8 -10 ],[3 -4],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0.15')
disp('==========================================================================')
disp('')

%g) Polos en 0, -1, -3, -4
% figure
rlocusx(zpk([],[0 -1 -3 -4],1)); sgrid

disp('Lugar de Raices: ESTABLE para k < 26.2')
disp('==========================================================================')
disp('')

%h) Polos en -2+j,-2-j
% figure
rlocusx(zpk([],[-2+j -2-j],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0')
disp('==========================================================================')
disp('')

%i) Polos en -2+j.-2-j,-10
% figure
rlocusx(zpk([],[-2+j -2-j -10],1)); sgrid

disp('Lugar de Raices: ESTABLE para k < 580')
disp('==========================================================================')
disp('')

%j) Polos en -2+j.-2-j,-1
% figure
rlocusx(zpk([],[-2+j -2-j -1],1), .1, 0, 50); sgrid

disp('Lugar de Raices: ESTABLE para k < 40')
disp('==========================================================================')
disp('')

%k) Polos en -2+j.-2-j, cero en -10
% figure
rlocusx(zpk([-10],[-2+j -2-j],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0')
disp('==========================================================================')
disp('')

%l) Polos en -2+j.-2-j, ceros en -1,-4
% figure
rlocusx(zpk([-1 -4],[-2+j -2-j],1)); sgrid

disp('Lugar de Raices: ESTABLE para k > 0')
disp('==========================================================================')
disp('')

%m) Polos en -2+j.-2-j, ceros en 1,-4
% figure
rlocusx(zpk([1 -4],[-2+j -2-j],1)); sgrid

disp('Lugar de Raices: ESTABLE para k < 1.25')
disp('==========================================================================')
disp('')

%n) Polos en -8+j.-8-j, ceros en 1+3j,1-3j
% figure
rlocusx(zpk([1+3j 1-3j],[-8+j -8-j],1)); sgrid

disp('Lugar de Raices: ESTABLE para k < 8')
disp('==========================================================================')
disp('')

%o) Polos en -8. 1, ceros en 1+3j,1-3j
% figure
rlocusx(zpk([1+3j 1-3j],[-8 1],1)); sgrid

disp('Lugar de Raices: ESTABLE para  0.8 < k < 3.5')
disp('==========================================================================')
disp('')

disp('======================================================================')
disp('SUCCESS')
