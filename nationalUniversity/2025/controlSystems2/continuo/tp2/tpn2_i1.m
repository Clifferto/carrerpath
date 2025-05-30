% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../../lib');
mylib

function [Y, X, U, E] = sys_model(A, B, C, D, Ka, r, in, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    x   = x0;
    
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        u1  = -Ka*x;
        u2  = in(k,2);

        % simular sistema ampliado con perturbacion u2, B debe ser 4x2, C debe ser 2x4
        u   = [u1 ; u2];
        xp  = A*x + [B ; zeros(1,2)]*u   + [0 ; 0 ; 0 ; 1]*r;
        x   = x + xp*h;
        y   = [C zeros(2,1)]*x + D*u;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
        E(k,:)  = xp(4,1);
    endfor

endfunction

function [Y, X, U, E] = sys_pid(A, B, C, D, in, t, x0, pid_config)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1);

    Kp  = pid_config(1);
    Ki  = pid_config(2);
    Kd  = pid_config(3);

    Ts  = h;
    A1  = (2*Kp*Ts + Ki*Ts^2 + 2*Kd)/(2*Ts);
    B1  = (-2*Kp*Ts + Ki*Ts^2 - 4*Kd)/(2*Ts);
    C1  = Kd/Ts;
    
    % set point
    r   = 15;

    x   = x0;
    pid = 0;
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        % ley de control aplicada
        u   = [pid, in(k,2)]';
        
        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        err(k)  = r - y;
        if length(err) > 2 && in(k,1) > 0
            pid = pid + A1*err(k) + B1*err(k-1) + C1*err(k-2);
        endif

        U(k,:)    = u';
        X(k,:)    = x';
        Y(k,:)    = y';
    endfor

    E = err';
endfunction

% ====================================================================================================================
comment('Parametros Tomados De: OptimalControl/TP_N1_Identificacion_Exacta.ipynb')
Ra  = 2.2781228953606902
Laa = 0.005187184919244553
Kb  = 0.2499435593696499
Jm  = 0.002848787974411428
Bm  = 0.0014279727330389095
Ki  = 0.2618711775870197

comment('Modelo En Espacio De Estados Del Tp1 (x1 == ia, x2 == theta, x3 == theta_p == omega, y1 == theta, y2 == omega)')
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
A   = [-Ra/Laa 0 -Kb/Laa    ;   0 0 1   ;   Ki/Jm 0 -Bm/Jm]
B   = [1/Laa 0  ;   0 0 ;   0 -1/Jm]
C   = [0 1 0    ; 0 0 1]
D   = zeros(2,2);

comment('Verificar Controlabilidad: rank(M) == n')
M   = ctrb(A, B)
assert(rank(M) == 3)
% P   = obsv(A, B)

comment('Polos A Lazo Abierto, Con El t_step == 1ms, Polo Mas Rapido Posible')
eig(A)
% ans =
%           0   <-- TIPO-I
%   -428.8422
%    -10.8419

% ! %y  = e^(p t)
log(.95)/1E-3
% ans = -51.293

comment('Estrategia: Control Por Realimentacion De Estados Con Integral Error (u == -K x + KI psi)')
% ! Aa  =   [A  0]
% !         [-C 0]
% ! Ba  =   [B]
% !         [0]
% ! Ka  =   [K  -KI]
% ! xa  =   [x  psi] Donde: psi_p == r - y
% solo importa el sistema theta/va, polos una octava mas rapidos
Aa  = [A zeros(3,1) ;   -C(1,:) 0]
Ba  = [B(:,1)   ;   0]
Ka  = acker(Aa, Ba, [-25+j -25-j -50 -1])
eig(Aa - Ba*Ka)

comment('Simulacion')
% ! de las graficas de mediciones
va_amp  = 2;
tl_amp  = 0;
% tl_amp  = .12;
va_t0   = 0;
% va_t0   = 100E-3;
tl_t0   = 700E-3;

pp              = eig(Aa - Ba*Ka)(:)';
[t_step, t_max] = get_time_params(pp)
% ! sobre 3 a 30 veces
t_step  /= 1
t_max   *= 2

t   = 0:t_step:t_max;
va  = va_amp*heaviside(t' - va_t0);
tl  = tl_amp*heaviside(t' - tl_t0);
in  = [va tl];

r   = pi/2;
x0  = [0 ; 0 ; 0 ; 1];

[y, x, u, err]  = sys_model(Aa, B, C, D, Ka, r, in, t, x0);
x(:,2)          = mod(x(:,2), 2*pi);

figure;
subplot(3,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2); title('State Var x_1 : ia(t)'); ylabel('x_1 [A]'); grid
legend('ia(t)');
subplot(3,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2); title('State Var x_2 : theta(t)'); ylabel('x_2 [rad]'); grid
legend('theta(t)');
subplot(3,1,3);
plot(t, x(:,3), 'r', 'LineWidth', 2); title('State Var x_3 : omega(t)'); ylabel('x_3 [rad/s]'); grid
legend('omega(t)');
xlabel('Time [s]');

figure;
subplot(5,1,1);
plot(t, u(:,1), 'LineWidth', 2); title('Input u_1 : va(t)'); ylabel('u_1 [V]'); grid
legend('va(t)');
subplot(5,1,2); 
plot(t, u(:,2), 'LineWidth', 2); title('Input u_2 : TL(t)'); ylabel('u_2 [Nm]'); grid
legend('TL(t)');
subplot(5,1,3); 
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : theta(t)'); ylabel('y_1 [rad]'); grid
legend('theta(t)');
subplot(5,1,4); 
plot(t, err(:,1), 'LineWidth', 2); title('Error : Psi(t)'); ylabel('Psi [rad]'); grid
legend('error(t)');
xlabel('Time [s]');

return
% parametros del PID (Tip: partir de KP=0,1;Ki=0,01; KD=5)
Kp  = 17;
Ki  = 100;
Kd  = .8;
% Kp  = 200;
% Ki  = 2000;
% Kd  = 5;
pid_config          = [Kp Ki Kd]
x0                  = [0 ; 0 ; 0];
[y_est, x, u, err]  = sys_model(matA, matB, matC, matD, in, t, x0, pid_config);

figure;
subplot(3,1,1);
plot(t, x(:,2), 'r', 'LineWidth', 2);
title('Output y_1: theta(t)'); ylabel('theta(t) [rad]'); grid;
legend('theta(t)');
subplot(3,1,2);
plot(t, in(:,1), 'LineWidth', 2);
title('Input i_1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(3,1,3); 
plot(t, in(:,2), 'LineWidth', 2);
title('Input i_2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
xlabel('Time [s]'); 

% close all;

figure;
subplot(3,1,1);
plot(t, err, 'r', 'LineWidth', 2);
str = sprintf('Error: e(t) vs PID: kp = %0d, ki = %0d, kd = %0d', Kp, Ki, Kd);
title(str); ylabel('e(t) [rad]'); grid;
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
