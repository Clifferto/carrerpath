% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../../lib');
mylib

function [Y, X, U, err] = sys_model(A, B, C, D, in, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)

    % parametros del PID (Tip: partir de KP=0,1;Ki=0,01; KD=5)
    Kp  = 13;
    Ki  = 100;
    Kd  = 1;
    % Kp  = 200;
    % Ki  = 2000;
    % Kd  = 5;

    Ts  = h;
    A1  = (2*Kp*Ts + Ki*Ts^2 + 2*Kd)/(2*Ts);
    B1  = (-2*Kp*Ts + Ki*Ts^2 - 4*Kd)/(2*Ts);
    C1  = Kd/Ts;
    
    % set point
    r   = 1;

    X   = x0;
    x   = x0;
    pid = 0;
    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif

        u       = in(k,:)';
        u(1,1)  = pid;
        
        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        err(k)  = r - y;
        if length(err) > 2 && in(k,1) > 0
            pid = pid + A1*err(k) + B1*err(k-1) + C1*err(k-2);
        endif

        U(:,k+1)    = u;
        X(:,k+1)    = x;
        Y(:,k+1)    = y;
    endfor

    err = err';
    U   = U';
    X   = X';
    Y   = Y';
endfunction

% ====================================================================================================================
comment('Parametros Tomados De: OptimalControl/TP_N1_Identificacion_Exacta.ipynb')
# Ra=2.27;La=0.0047;Ki=0.25;Kb=0.25;Bm=0.00131;Jm=0.00233;Km=Kb; Laa=La; J=Jm;B=Bm; %Motor KUO Ec 6-37
Ra  = 2.27
Laa = 0.0047
Ki  = 0.25
Km  = 0.25
Bm  = 0.00131
JJ  = 0.00233

% matA = (sym 3×3 matrix)

%   ⎡-Ra      -Km ⎤
%   ⎢────  0  ────⎥
%   ⎢Laa      Laa ⎥
%   ⎢             ⎥
%   ⎢ 0    0   1  ⎥
%   ⎢             ⎥
%   ⎢ Ki      -Bm ⎥
%   ⎢ ──   0  ────⎥
%   ⎣ JJ       JJ ⎦

% matB = (sym 3×2 matrix)

%   ⎡ 1      ⎤
%   ⎢───   0 ⎥
%   ⎢Laa     ⎥
%   ⎢        ⎥
%   ⎢ 0    0 ⎥
%   ⎢        ⎥
%   ⎢     -1 ⎥
%   ⎢ 0   ───⎥
%   ⎣     JJ ⎦

% matC = (sym) [0  1  0]  (1×3 matrix)
% matD = (sym) [0  0]  (1×2 matrix)

matA    = [ -Ra/Laa 0   -Km/Laa ;
            0       0   1       ;
            Ki/JJ   0   -Bm/JJ  ];

matB    = [  1/Laa   0       ;
             0       0       ;
             0       -1/JJ   ];

matC    = [  0   1   0];
matD    = [  0   0];

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
t_step  /= 3
% t_step  = 1E-3;
t_max   *= 5
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

close all;

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
