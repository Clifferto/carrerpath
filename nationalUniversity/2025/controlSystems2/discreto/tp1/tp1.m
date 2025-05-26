% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

% ====================================================================================================================
comment('Datos Asignados:');

disp('Nombre        Apellido(s) polo1   polo2   cero    ganancia    Sobrepaso   tiempo2%    error   periodo');
disp('Domingo Jesus FERRARIS    0       -2      -10     5           10          3           0       0,09');
disp('');
Mp  = .1
tss = 3
Ts  = .09

% ====================================================================================================================
comment('Funcion De Transferencia (Continuo):');
G   = zpk([-10], [0 -2], [5])

comment('Funcion De Transferencia (Discreto):');
Gz  = c2d(G, Ts, 'zoh')

% ====================================================================================================================
comment('Mapa De Polos Y Ceros:');
figure;
pzmap(G); title('Continuos-Time System'); sgrid;
figure; 
pzmap(Gz); title('Discrete-Time System'); zgrid;

comment('Sub-Muestreo Por 10:');
figure; 
pzmap(Gz, c2d(G, Ts*10, 'zoh')); title('Discrete-Time System Vs Sub-Sampled System (Ts/10)'); zgrid;
legend('original', 'original', 'sub-sampled', 'sub-sampled');

comment('Polos Y Ceros Se Corren Hacia La Izquierda Al Aumentar Ts, Mantienen La Distancia Entre Ellos, El Polo En 1 Queda Invariante');

% ====================================================================================================================
comment('Respuestas A Lazo Abierto:');
figure; 
step(G, Gz); title('System Response: Countinuous Vs Discrete'); grid;

comment('A Lazo Abierto, Ambos Inestables');

% ====================================================================================================================
comment('Estudio De Error:');
Hz      = 1
FTLA    = Gz*Hz;
FTLC    = feedback(Gz, Hz)

damp(FTLA)
% Discrete-time model.
%    Pole        Magnitude    Damping      Frequency        Time Constant
%                                          (rad/seconds)    (seconds)
%    1.00e+00    1.00e+00     -1.00e+00    1.73e-14         -5.79e+13
%    8.35e-01    8.35e-01     1.00e+00     2.00e+00         5.00e-01

comment('Polo En 1, Sistema De Tipo-I, Se Espera essp = 0 Y essv = Constante');

kp      = dcgain(FTLA)
essp    = 1/(1 + kp)
% ! kp      = -1.6692e+15   ~ inf
% ! essp    = -5.9908e-16   ~ 0

t   = 0:Ts:Ts*100;
u1  = heaviside(t);

figure; grid;
lsim(FTLC, u1, t); title('Disctrete-Time Closed-Loop Step Response');

u1  = t;

figure; grid;
lsim(FTLC, u1, t); title('Disctrete-Time Closed-Loop Ramp Response');

comment('No Converge, Con Error Ante La Rampa Constante, Esperable Por El Tipo De Sistema')

% ====================================================================================================================
comment('Lugar De Raices:')

figure;
rlocusx(G*1);
% ! rlocusx es bloqueante, cerrar grafica para continuar
rlocusx(Gz*1);

comment('Sistema Continuo, Estable Para Todo K')
comment('Sistema Discreto, Estable Para Todo K < Kcrit == 4.4')

comment('Estabilidad Con Sub-Muestreo Por 10:')
rlocusx(c2d(G, Ts*10, 'zoh')*1);

comment('Con Sub-Muestreo, Estable Para Todo K < Kcrit == 0.18, Aumentar Ts Empeora Estabilidad')

comment("SUCCESS")
