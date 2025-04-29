% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../lib');
mylib

% ====================================================================================================================

comment('Cargar Data')

% ! xlsread tiene problemas en linux, cargo/guardo datos en txt
% ! ssconvert Curvas_Medidas_Motor_2025_v.xls Curvas_Medidas_Motor_2025_v.txt
% "Tiempo [Seg.]","Velocidad angular [rad /seg]","Corriente en armadura [A]","Tensión [V]","Torque"
data    = load('Curvas_Medidas_Motor_2025_v.txt');
t       = data(:,1);
u       = data(:,4:5);
y       = data(:,2);

figure;
subplot(3,1,1); 
plot(t, u(:,1), 'LineWidth', 2); title('Input u1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(3,1,2); 
plot(t, u(:,2), 'r', 'LineWidth', 2); title('Input u2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
subplot(3,1,3); 
plot(t, y, 'LineWidth', 2); title('Output y1: omega(t)'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
xlabel('Time [s]'); 

t(2)-t(1)

comment('Respuesta: Sobre-Amortiguada, Intervalo Con Dinamica: 100ms - 500ms, Resolucion: 1ms')
% close all;

comment("Estimar Constantes De Tiempo: Omega_vs_Va")
va_amp  = max(u(:,1))
K       = max(y)
t0      = t(find(y > 0)(1)); 
t1      = 110E-3 - t0

i1  = find(t >= 1*t1    + t0)(1);
i2  = find(t >= 2*t1    + t0)(1);
i3  = find(t >= 3*t1    + t0)(1);

figure;
plot(t(1:find(t >= 700E-3)(1)), y(1:find(t >= 700E-3)(1)), 'LineWidth', 2); hold;
plot([t(i1), t(i2), t(i3)], [y(i1), y(i2), y(i3)], 'or');
title('Output y_1 : Sample Points'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
xlabel('Time [s]');

[tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, [y(i1) y(i2) y(i3)])

comment('Sistema De Orden 2 Sin Ceros: G(s) == K / ((T1s + 1)(T2s + 1)), T1 < T2')
s           = tf('s');
omega_vs_va = K / ((tau_1*s + 1)*(tau_2*s + 1));
% ajuste de ganancia
omega_vs_va /= va_amp

comment("Estimar Constantes De Tiempo: Omega_vs_TL")
tl_amp  = max(u(:,2))
i_begin = find(t >= 701E-3)(1);
i_end   = find(t >= 1.001)(1);

return
K       = max(y)
t0      = t(find(y > 0)(1)); 
t1      = 110E-3 - t0

i1  = find(t >= 1*t1    + t0)(1);
i2  = find(t >= 2*t1    + t0)(1);
i3  = find(t >= 3*t1    + t0)(1);

figure;
plot(t(1:find(t >= 700E-3)(1)), y(1:find(t >= 700E-3)(1)), 'LineWidth', 2); hold;
plot([t(i1), t(i2), t(i3)], [y(i1), y(i2), y(i3)], 'or');
title('Output y_1 : Sample Points'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
xlabel('Time [s]');

[tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, [y(i1) y(i2) y(i3)])

comment('Sistema De Orden 2 Sin Ceros: G(s) == K / ((T1s + 1)(T2s + 1)), T1 < T2')
s           = tf('s');
omega_vs_va = K / ((tau_1*s + 1)*(tau_2*s + 1));
% ajuste de ganancia
omega_vs_va /= va_amp
return
[y_op t]    = lsim(sys_only_poles, u(:,1), t);


figure
plot(t, y, '-.k', t, y_zp, 'r'); title('Output y Vs Estimation (zero-poles)'); ylabel('vc(t) [V]'); grid;
xlabel('Time [s]');
figure
plot(t, y, '-.k', t, y_op, 'r'); title('Output y Vs Estimation (only-poles)'); ylabel('vc(t) [V]'); grid;
xlabel('Time [s]');

return
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
