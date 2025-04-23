% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control;
pkg load symbolic;
pkg load signal;

mylib

% ====================================================================================================================

disp('')
disp('=======================================================================')
disp('MODELO CASO 2')
disp('=======================================================================')
disp('  ia_p    == -Ra/Laa ia - Km/Laa omega + 1/Laa va')
disp('  omega_p == Ki/JJ ia - Bm/JJ omega - 1/JJ TL')
disp('  theta_p == omega')
disp('=======================================================================')

% variables
syms ia ia_p va omega omega_p TL theta theta_p Ra Laa Km Ki Bm JJ real;

ia_p    = -Ra/Laa*ia - Km/Laa*omega + 1/Laa*va
omega_p = Ki/JJ*ia - Bm/JJ*omega - 1/JJ*TL
theta_p = omega

comment('Variables De Estado')
disp('x1 == ia      ->  x1_p == ia_p')
disp('x2 == theta   ->  x2_p == theta_p == omega == x3  -> x3_p == theta_pp == omega_p')
comment('Entradas / Salidas')
disp('u1 == va, u2 == TL    ,   y1 == theta')
x   = [ia theta omega];
xp  = [ia_p omega omega_p];
u   = [va TL];
y   = [theta];

comment('Matrices De Estado')
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

% Matrices De Estado
% =======================================================================

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

comment('Parametros')
Laa = 366E-6
JJ  = 5E-9
Ra  = 55.6
Bm  = 0
Ki  = 6.49E-3
Km  = 6.53E-3

matA    = eval(matA);
matB    = eval(matB);
matC    = eval(matC);
matD    = eval(matD);

comment('Modelo En Espacio De Estados')
sys     = ss(matA, matB, matC, matD);

damp(sys)
pzmap(sys)

comment('Simulacion')
poles           = pole(sys);
[t_step t_max]  = get_time_params(poles);

% parametros de simulacion dados
t_step  = 10E-7
t_max   *= 100

t           = 0:t_step:t_max;
va_delay    = 10E-3;
tl_delay    = 50E-3;
va_amp      = 12;
tl_amp      = 1E-3;

va  = va_amp .* heaviside(t - va_delay);
tl  = tl_amp .* (t - tl_delay) .* heaviside(t - tl_delay);
u   = [va ; tl]';

[y, t, x] = lsim(sys, u, t);

comment('Torque Y Corriente Maximos (Donde omega == 0)')

i0  = find(x(:,3) > 0)(1);
i1  = find(x(i0:end,3) <= 0)(1);
u(:,2)(i1)
x(:,1)(i1)

% ans = 1.3973e-03
% ans = 0.2143

figure;
subplot(4,1,1); 
plot(t, u(:,1), 'LineWidth', 2); title('Input u1: va(t)'); ylabel('va(t) [V]'); grid;
legend('va(t)');
subplot(4,1,2); 
plot(t, u(:,2), 'r', 'LineWidth', 2); title('Input u2: tl(t)'); ylabel('tl(t) [Nm]'); grid;
legend('tl(t)');
subplot(4,1,3); 
plot(t, x(:,1), 'LineWidth', 2); title('State Var x1: ia(t)'); ylabel('ia(t) [A]'); grid;
legend('ia(t)');
subplot(4,1,4); 
plot(t, x(:,3), 'LineWidth', 2); title('State Var x3: omega(t)'); ylabel('omega(t) [rad/s]'); grid;
legend('omega(t)');
xlabel('Time [s]'); 

comment('SUCCESS')
