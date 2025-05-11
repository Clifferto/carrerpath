% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../../lib');
mylib

% ====================================================================================================================

comment('Cargar Data')

% ! xlsread tiene problemas en linux, cargo/guardo datos en txt
% ! ssconvert Curvas_Medidas_RLC_2025.xls Curvas_Medidas_RLC_2025.txt
% "Tiempo [Seg.]","Corriente [A]","Tensión en el capacitor [V]","Tensión de entrada [V]","Tensión de salida [V]"
data    = load('Curvas_Medidas_RLC_2025.txt');
t       = data(:,1);
u       = data(:,4);
x       = data(:,2);
y       = data(:,3);

figure;
subplot(3,1,1);
plot(t, x(:,1), 'LineWidth', 2); title('State Var x_1 : i(t)');  ylabel('i(t) [A]'); grid;
subplot(3,1,2);
plot(t, u, 'LineWidth', 2); title('Input u_1 : ve(t)'); ylabel('ve(t) [V]'); grid;
subplot(3,1,3);
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : vc(t)'); ylabel('vr(t) [V]'); grid;
xlabel('Time [s]'); 

t(2)-t(1)

comment('Respuesta: Sobre-Amortiguada, Intervalo Con Dinamica: 10ms - 12ms, Resolucion: 10us')
% close all;

comment("Estimar Contantes De Tiempo")
% de las graficas
k0      = 12/12
K       = 12
t0      = 10E-3 
t1      = 10.1E-3

t1 -= t0;
i1  = find(t >= 1*t1    + t0)(1);
i2  = find(t >= 2*t1    + t0)(1);
i3  = find(t >= 3*t1    + t0)(1);

figure; hold;
plot(t(1:find(t >= 15E-3)(1)), y(1:find(t >= 15E-3)(1)), 'LineWidth', 2);
plot([t(i1), t(i2), t(i3)], [y(i1), y(i2), y(i3)], 'or');
title('Output y_1 : Sample Points'); ylabel('vc(t) [V]'); grid;
legend('vc(t)');
xlabel('Time [s]');

[tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, [y(i1) y(i2) y(i3)])

comment('G(s) == k0 (T3s + 1) / ((T1s + 1)(T2s + 1)), T1 < T2')
s               = tf('s');
sys_zero_poles  = k0*(tau_3*s + 1) / ((tau_1*s + 1)*(tau_2*s + 1))
sys_only_poles  = k0 / ((tau_1*s + 1)*(tau_2*s + 1))

[y_zp t]    = lsim(sys_zero_poles, u, t);
[y_op t]    = lsim(sys_only_poles, u, t);

figure; hold;
plot(t, y, '-.k');
plot(t, y_zp, 'b');
plot(t, y_op, 'r');
title('Output y1 Vs Estimations'); ylabel('vc(t) [V]'); grid;
legend('real', 'zero-poles', 'only-poles');
xlabel('Time [s]');

comment("La Funcion De Transferencia De Solo-Polos Aproxima Mejor A La Respuesta")

comment("Modelo Del RLC")
disp('  ii_p    == -R/L ii - 1/L vc + 1/L ve')
disp('  vc_p    == 1/C ii')
disp('')

% variables
syms II Vc Ve R L C s real;
eq1 = II*s  == -R/L*II - 1/L*Vc + 1/L*Ve
eq2 = Vc*s  == 1/C*II

sol     = solve([eq1, eq2], [Vc, Ve]);
sys_sym = simplify(sol.Vc/sol.Ve)

% sys_sym = (sym)
%           1
%   ──────────────────
%        2
%    C⋅L⋅s  + C⋅R⋅s + 1

comment("Estimar Parametros Por Igualacion")
[num, den]  = tfdata(sys_only_poles, 'vector');
vr          = data(:,5);

R   = vr(end)/x(end)
C   = den(2)/R
L   = den(1)/C

% Estimar Parametros Por Igualacion
% =======================================================================
% R = 220.00
% C = 2.1964e-06
% L = 3.3873e-04

comment("SUCCESS")
