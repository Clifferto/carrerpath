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
plot(t, y, 'LineWidth', 2); title('Output y_1: omega(t)'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
subplot(3,1,2); 
plot(t, u(:,1), 'LineWidth', 2); title('Input u_1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(3,1,3); 
plot(t, u(:,2), 'r', 'LineWidth', 2); title('Input u_2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
xlabel('Time [s]'); 

t_step  = t(2)-t(1)

comment('Respuesta: Sobre-Amortiguada, Intervalo Con Dinamica: 100ms - 500ms, Resolucion: 1ms')
% close all;

% ====================================================================================================================
comment("Estimar Contantes De Tiempo")
% de las graficas
K       = y(end)
k0      = K/2
t0      = 101E-3 
t1      = 110E-3

t1 -= t0;
i1  = find(t >= 1*t1    + t0)(1);
i2  = find(t >= 2*t1    + t0)(1);
i3  = find(t >= 3*t1    + t0)(1);

i_begin = 1;
i_end   = find(t >= 500E-3)(1);

figure; hold;
plot(t(i_begin:i_end), y(i_begin:i_end), 'LineWidth', 2);
plot([t(i1), t(i2), t(i3)], [y(i1), y(i2), y(i3)], 'or');
title('Output y_1 : Sample Points'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
xlabel('Time [s]');

[tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, [y(i1) y(i2) y(i3)])

comment('Sistema De Orden 2 Sin Ceros: G(s) == k0 / ((T1s + 1)(T2s + 1)), T1 < T2')
s           = tf('s');
omega_vs_va = k0 / ((tau_1*s + 1)*(tau_2*s + 1))

i_begin = 1;
i_end   = find(t >= 700E-3)(1);

[y_est, t_est]  = lsim(omega_vs_va, u(i_begin:i_end,1), t(i_begin:i_end));

figure; hold;
plot(t_est, y(i_begin:i_end,1), '-.k');
plot(t_est, y_est, 'r');
title('Output y_1: Omega vs Va Estimations'); ylabel('omega(t) [rad/s]'); grid;
legend('real', 'estimated');
xlabel('Time [s]');

comment("Modelar Efecto De TL Como Una Atenuacion")
% de las graficas
i_begin = find(t >= 701E-3)(1);
i_end   = find(t >= 1.001)(1);
k1      = (y(i_end) - y(i_begin))/max(u(:,2))

figure;
plot(t(i_begin-50:i_end+50), y(i_begin-50:i_end+50), 'LineWidth', 2); hold;
plot([t(i_begin), t(i_end)], [y(i_begin), y(i_end)], 'or');
title('Output y_1 : Sample Points'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
xlabel('Time [s]');

comment('Dinamica Depende De La Ecuacion Caracteristica, Solo Se Suma La Atenuacion')
omega_vs_tl = k1 / ((tau_1*s + 1)*(tau_2*s + 1));

[y_est, t_est]  = lsim(omega_vs_tl, u(i_begin-50:i_end+50,2), t(i_begin-50:i_end+50));
% sumar la condicion inicial de omega al momento de aplicar TL
y_est   += y(i_begin);

figure; hold;
plot(t_est, y(i_begin-50:i_end+50,1), '-.k');
plot(t_est, y_est, 'r');
title('Output y_1: Omega vs Tl Estimations'); ylabel('omega(t) [rad/s]'); grid;
legend('real', 'estimated');
xlabel('Time [s]');

% ====================================================================================================================
comment('Ajuste De La Atenuacion')
k1_step = .25;

figure; hold;
plot(t_est, y(i_begin-50:i_end+50,1), '-.k', 'DisplayName', 'real');
for i = 1:6
    k1          -= k1_step;
    omega_vs_tl = k1 / ((tau_1*s + 1)*(tau_2*s + 1));

    [y_est, t_est]  = lsim(omega_vs_tl, u(i_begin-50:i_end+50,2), t(i_begin-50:i_end+50));
    % sumar la condicion inicial de omega al momento de aplicar TL
    y_est   += y(i_begin);

    str = sprintf('k1 : %0f', k1);
    plot(t_est, y_est, 'DisplayName', str);
endfor
legend();
title('Output y_1: Attenuation Adjustment'); ylabel('omega(t) [rad/s]'); grid;
xlabel('Time [s]');

comment('Atenuacion Seleccionada')
k1          = -34.5
omega_vs_tl = k1 / ((tau_1*s + 1)*(tau_2*s + 1))

[y_est, t_est]  = lsim(omega_vs_tl, u(i_begin-50:i_end+50,2), t(i_begin-50:i_end+50));
% sumar la condicion inicial de omega al momento de aplicar TL
y_est   += y(i_begin);

figure; hold;
plot(t_est, y(i_begin-50:i_end+50,1), '-.k');
plot(t_est, y_est, 'r');
title('Output y_1: Omega vs Tl Estimations With Adjusted Attenuation'); ylabel('omega(t) [rad/s]'); grid;
legend('real', 'estimated : k1 = -34.5');
xlabel('Time [s]');

comment('Comparacion Estimado Vs Medido')
[y_est, t_est]  = lsim([omega_vs_va, omega_vs_tl], u, t);

figure;
subplot(3,1,1);
plot(t, y, '-.'); hold
plot(t_est, y_est, 'r');
title('Output y_1: omega(t) Estimated Vs Real'); ylabel('omega(t) [rad/s]'); grid;
legend('real', 'estimated');
subplot(3,1,2); 
plot(t, u(:,1), 'LineWidth', 2);
title('Input u_1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(3,1,3); 
plot(t, u(:,2), 'r', 'LineWidth', 2);
title('Input u_2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
xlabel('Time [s]'); 

% ====================================================================================================================
comment('Constantes Finales')
k0
k1
tau_1
tau_2

comment("SUCCESS")
