% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control

addpath('../../lib');
mylib

% ====================================================================================================================
comment('Lugar De Raices Con Octave')
k0  = 1;
G   = zpk([], [0 -1],[1])

comment('Comparar Ts = 1 Y Ts = 4')

comment('Definir Muestreo Segun El Sistema Continuo')
p               = pole(G);
[t_step, t_max] = get_time_params(p)

return

comment('Simulacion')
% ! de las graficas de mediciones
va_amp  = 2;
% tl_amp  = 0;
tl_amp  = .12;
va_t0   = 100E-3;
% tl_t0   = 5;
tl_t0   = 700E-3;
tl_t1   = 800E-3;

[t_step, t_max] = get_time_params(pole(ss(matA, matB, matC, matD)));
t_step  /= 3;
% t_step  = 1E-3;
t_max   *= 7
% t_max   = 10
t       = 0:t_step:t_max;
va      = va_amp*heaviside(t - va_t0);
tl      = tl_amp*(heaviside(t - tl_t0) - heaviside(t - tl_t1));
in      = [va ; tl]';

x0                  = [0 ; 0 ; 0];
[y_est, x, u, err]  = sys_model(matA, matB, matC, matD, in, t, x0);

figure;
subplot(5,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2);
title('State var x_1: ia(t)'); ylabel('ia(t) [A]'); grid;
legend('ia(t)');
subplot(5,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2);
title('State var x_2: theta(t)'); ylabel('theta(t) [rad]'); grid;
legend('theta(t)');
subplot(5,1,3);
plot(t, x(:,3), 'r', 'LineWidth', 2);
title('State var x_3: omega(t)'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
subplot(5,1,4);
plot(t, in(:,1), 'LineWidth', 2);
title('Input i_1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(5,1,5); 
plot(t, in(:,2), 'LineWidth', 2);
title('Input i_2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
xlabel('Time [s]'); 

% close all;

figure;
subplot(3,1,1);
plot(t(1:end-1), err, 'r', 'LineWidth', 2);
title('Error: e(t)'); ylabel('e(t) [rad]'); grid;
legend('e(t)');
subplot(3,1,2);
plot(t, u(:,1), 'r', 'LineWidth', 2);
title('Control Action u_1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(3,1,3);
plot(t, y_est, 'r', 'LineWidth', 2); hold
plot([t(1), t(end)], [1, 1], '-.k');
title('Output y_1: theta(t) vs Set Point'); ylabel('theta(t) [rad]'); grid;
legend('theta(t)', 'set-point');
xlabel('Time [s]'); 

comment("SUCCESS")
