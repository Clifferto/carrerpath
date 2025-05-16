% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control

addpath('../../lib');
mylib

% ====================================================================================================================
comment('Lugar De Raices Para Distintos Periodos De Muestreo')
k0  = 1;
G   = zpk([], [0 -1],[1])

comment('Comparar Ts = 1 Y Ts = 4')
Ts0 = 1;
Ts1 = 4;

Gz0 = c2d(G, Ts0, 'ZOH')
Gz1 = c2d(G, Ts1, 'ZOH')

% rlocusx(Gz0);
% rlocusx(Gz1);

% ! k_crit0 ~ 2.4
% ! k_crit1 ~ 1
comment('En Sistemas Discretos: k_crit Proporcional A fs = 1/Ts')

comment('tau_eq = -Ts / Ln(r)')
disp('   - Sist 1er o 2do Orden Sub-Amortiguados: tss = 4 tau_eq')
disp('   - Sist 2do Orden Crit-Amortiguado      : tss = 5.8 tau_eq')
disp('')
tau_eq0 = -Ts0/log(.64719);
tau_eq1 = -Ts1/log(.34368);
tss0    = 5.8*tau_eq0
tss1    = 5.8*tau_eq1

comment('Criterio De Muestras Por Ciclo/Tau: m >= 10')
damp(feedback(G, 1))
% Pole                   Damping     Frequency        Time Constant
%                                       (rad/seconds)    (seconds)
%    -5.00e-01+8.66e-01i    5.00e-01    1.00e+00         2.00e+00
%    -5.00e-01-8.66e-01i    5.00e-01    1.00e+00         2.00e+00
% ! ws  == m wd
m   = 10
wd  = 1
ws  = m*wd
Ts  = ws/(2*pi)

comment('Aseguramos 10 Muestras Por Ciclo Con:')
Ts  = 1.5
Gz  = c2d(G, Ts, 'ZOH')

rlocusx(Gz*1)

comment("SUCCESS")
