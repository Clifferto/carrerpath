% ====================================================================================================================
close all; clear all; clc;

% % carga pkgs
% pkg load control

addpath('../../lib');
mylib

% EQUIS D WINDOWS
% EQUIS D WINDOWS
% EQUIS D WINDOWS
% EQUIS D WINDOWS
function comment(msg)
    disp('')
    disp(msg)
    disp('=======================================================================')
    disp('')
end

% ====================================================================================================================
% ====================================================================================================================
comment('Datos Asignados:');
disp('Nombre        Apellido(s) polo1   polo2   cero    ganancia    Sobrepaso   tiempo2%    error   periodo');
disp('Domingo Jesus FERRARIS    0       -2      -10     5           10          3           0       0,09');
disp('');
Mp  = .1;
tss = 3;
Ts  = .09;

% ====================================================================================================================
comment('Parametros De La Respuesta Deseada:');
psita = -log(Mp)/sqrt(pi^2 + log(Mp)^2)

% ! sub-amortiguado: tss(2%) == 4/(psita*wn)
wn  = 4/(psita*tss)
wd  = wn*sqrt(1 - psita^2)

comment('Sub-Amortiguado, Comprobar 10 O Mas Muestras Por Ciclo')
ws  = 2*pi/Ts;
m   = ws/wd

comment('Punto De Trabajo Necesario')
disp('z == e ** (-psita wn Ts +/- j wd Ts)')
disp('   |z|     == e ** (-psita wn Ts)')
disp('   fase(z) == wd Ts')
disp('')
zp  = exp(-psita*wn*Ts + j*wd*Ts)
r   = abs(zp)
f   = rad2deg(angle(zp))

comment('Funcion De Transferencia (Continuo/Discreto):');
G   = zpk([-10], [0 -2], [5])
Gz  = c2d(G, Ts, 'zoh')

figure;
pzmap(Gz); grid;

% ====================================================================================================================
comment('Diseño Con SISOTOOL:');

sisotool(Gz)

% el sistema ya tiene accion integradora, tipo1 por tanto error de regulacion nulo
% no alcanza con proporcional, se tiene que curvar en adelanto

% primer opcion un PD, agrega polo en 0, y un cero variable

% PD =
%   0.16948 (z-0.4247)
%   ------------------
%           z


% ====================================================================================================================
% segunda opcion, compensador en adelanto, mejorar el tema del polo a la izq
% agrega un par polo/cero, el polo cancela al polo dominante de la planta, el cero lo dejamos libre


comment("SUCCESS")
