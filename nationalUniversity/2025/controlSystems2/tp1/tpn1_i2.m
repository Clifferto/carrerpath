% ====================================================================================================================
clear all; close all; clc;

% carga pkgs
pkg load control;
pkg load io;

function comment(msg)
    disp('')
    disp(msg)
    disp('=======================================================================')
endfunction

function [t_step t_max] = get_time_params(p)
    re_min  = min(real(p));
    re_max  = max(real(p));

    % resolucion, relacionado al 95% de la exp amortiguadora mas rapida: e ^ (-t RE{p}_min)
    t_step  = abs(log(.95)/re_min);
    % tiempo de sim, relacionado al 5% de la exp amortiguadora mas lenta: e ^ (-t RE{p}_max)
    t_max   = abs(log(.05)/re_max);
endfunction

function [tau_1 tau_2 tau_3] = get_chen_time_constants(t1, K, y)
    k1  = y(1)/K - 1;
    k2  = y(2)/K - 1;
    k3  = y(3)/K - 1;

    b       = 4*(k1^3)*k3 - 3*(k1^2)*(k2^2) - 4*k2^3 + k3^2 + 6*k1*k2*k3;
    alpha1  = (k1*k2 + k3 - sqrt(b)) / (2*(k1^2 + k2));
    alpha2  = (k1*k2 + k3 + sqrt(b)) / (2*(k1^2 + k2));
    bbeta   = ((2*k1^3 + 3*k1*k2 + k3) / sqrt(b)) - 1;

    tau_1   = real(-t1/log(alpha1));
    tau_2   = real(-t1/log(alpha2));
    tau_3   = real(bbeta*(tau_1 - tau_2) + tau_1);

    if tau_1 < 0 disp('Warning: tau_1 < 0') endif
    if tau_2 < 0 disp('Warning: tau_2 < 0') endif
    if tau_3 < 0 disp('Warning: tau_3 < 0') endif
endfunction

% ====================================================================================================================

comment('Cargar Data')

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

% close all;

disp('')
disp('=======================================================================')
comment('METODO DE CHEN (polos distintos)')
disp('  tau_1   == -t1/Ln(alpha1)')
disp('  tau_2   == -t1/Ln(alpha2)')
disp('  tau_3   == beta (tau_1 - tau_2) + tau_1')
comment("Donde:")
disp('      alpha1  == (k1 k2 + k3 - sqrt(b)) / 2(k1**2 + k2)')
disp('      alpha2  == (k1 k2 + k3 + sqrt(b)) / 2(k1**2 + k2)')
disp('      beta    == ((2 k1**3 + 3 k1 k2 + k3) / sqrt(b)) - 1')
disp('      b       == 4 k1**3 k3 - 3 k1**2 k2**2 - 4 k2**3 + k3**2 + 6 k1 k2 k3')
disp('          k1      == y(t1)/K - 1')
disp('          k2      == y(2t1)/K - 1')
disp('          k3      == y(3t1)/K - 1')
disp('          K       == y(inf)')
disp('=======================================================================')

comment('Respuesta: Sobre-Amortiguada, Intervalo Con Dinamica: 10ms - 12ms, Resolucion: 10us')
t_delay         = 10E-3
t1              = 10.05E-3 - t_delay
t1_step         = 10E-6
K               = 12
n_iterations    = 5;

for n = 1:n_iterations

    t1  += t1_step * (n-1)
    i1  = find(t >= t1      + t_delay)(1);
    i2  = find(t >= 2*t1    + t_delay)(1);
    i3  = find(t >= 3*t1    + t_delay)(1);

    [tau_1(n) tau_2(n) tau_3(n)] = get_chen_time_constants(t1, K, [y(i1) y(i2) y(i3)]);

    % figure;
    % plot(t(1:find(t >= 20E-3)(1)), y(1:find(t >= 20E-3)(1)), 'LineWidth', 2); hold;
    % plot([t(i1), t(i2), t(i3)], [y(i1), y(i2), y(i3)], 'or'); hold;
    % title('Output y_1 : Sample Points'); ylabel('vc(t) [V]'); grid;
    % xlabel('Time [s]'); 
endfor

comment('Mejorar Promediando')
tau_1   = sum(tau_1) / n_iterations
tau_2   = sum(tau_2) / n_iterations
tau_3   = sum(tau_3) / n_iterations

comment('G(s) == K (T3s + 1) / ((T1s + 1)(T2s + 1)), T1 < T2')
s   = tf('s');
sys = K*(tau_3*s + 1) / ((tau_1*s + 1)*(tau_2*s + 1));
% ajuste de ganancia
sys /= 12


return

hfig1 = figure(1); set(hfig1, 'windowstate', 'maximized');

subplot(3,1,1);
plot(t, x(:,1), 'LineWidth', 2); title('State Var x_1 : i(t)');  ylabel('i(t) [A]'); grid;
subplot(3,1,2);
plot(t, u, 'LineWidth', 2); title('Input u_1 : ve(t)'); ylabel('ve(t) [V]'); grid;
subplot(3,1,3);
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : vr(t)'); ylabel('vr(t) [A]'); grid;
xlabel('Time [s]');


comment("SUCCESS")

return
