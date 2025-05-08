% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../lib');
mylib

function [Y, X] = sys_model(A, B, C, D, U, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    X   = x0;
    x   = x0;

    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif

        u   = U(k,:)';
        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        X(:,k+1)  = x;
        Y(:,k+1)  = y;
    endfor

    X   = X';
    Y   = Y';
endfunction

% ====================================================================================================================
comment('Cargar Data')

% ! xlsread tiene problemas en linux, cargo/guardo datos en txt
% ! ssconvert Curvas_Medidas_Motor_2025_v.xls Curvas_Medidas_Motor_2025_v.txt
% "Tiempo [Seg.]","Velocidad angular [rad /seg]","Corriente en armadura [A]","Tensión [V]","Torque"
data    = load('Curvas_Medidas_Motor_2025_v.txt');
t       = data(:,1);
u       = data(:,4:5);
y       = data(:,2);

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

matB   = [  1/Laa   0       ;
            0       0       ;
            0       -1/JJ   ];

matC   = [  0   1   0];
matD   = [  0   0];

comment('Simulacion')

[t_step, t_max] = get_time_params(pole(ss(matA, matB, matC, matD)));
t_step  /= 10
t_max   *= 10

x0          = [0 ; 0 ; 0];
[y_est, x]  = sys_model(matA, matB, matC, matD, u, t, x0);

figure;
subplot(5,1,1);
plot(t, data(:,3), '-.', 'LineWidth', 2); hold
plot(t, x(:,1), 'r', 'LineWidth', 2);
title('State var x_1: ia(t)'); ylabel('ia(t) [A]'); grid;
legend('real', 'estimated');
subplot(5,1,2);
plot(t, y, '-.', 'LineWidth', 2); hold
plot(t, x(:,3), 'r', 'LineWidth', 2);
title('State var x_3: omega(t)'); ylabel('omega(t) [rad/s]'); grid;
legend('real', 'estimated');
subplot(5,1,3);
% plot(t, x(:,2), 'r', 'LineWidth', 2);
plot(t, y_est, 'r', 'LineWidth', 2);
title('Output y_1: theta(t)'); ylabel('theta(t) [rad]'); grid;
legend('theta(t)');
subplot(5,1,4);
plot(t, u(:,1), 'LineWidth', 2);
title('Input u_1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(5,1,5); 
plot(t, u(:,2), 'r', 'LineWidth', 2);
title('Input u_2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
xlabel('Time [s]'); 

comment("SUCCESS")
