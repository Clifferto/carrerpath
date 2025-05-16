% ====================================================================================================================
clear all; close all; clc;

% carga pkgs
pkg load control;
pkg load symbolic;
pkg load signal;

addpath('../../lib');
mylib

% ====================================================================================================================

disp('')
disp('=======================================================================')
disp('MODELO RLC')
disp('=======================================================================')
disp('  ii_p    == -R/L ii - 1/L vc + 1/L ve')
disp('  vc_p    == 1/C ii')
disp('  vr      == R ii')
disp('=======================================================================')

% variables
syms ii vc ii_p vc_p ve R L C real;

% para representar el espacio de estados
ii_p    = -R/L*ii - 1/L*vc + 1/L*ve;
vc_p    = 1/C*ii;
vr      = R*ii

comment('Asignacion Arbitraria (Espacio De Estados)')
disp('x1 == ii  ->  x1_p == ii_p')
disp('x2 == vc  ->  x2_p == vc_p')
comment('Entradas / Salidas')
disp('u1 == ve  --  y1 == vr == R ii')
x   = [ii vc];
xp  = [ii_p vc_p];
u   = ve;
y   = vr;

comment('Matrices De Estado')
matA1   = jacobian(xp, x)
matB1   = jacobian(xp, u)
matC1   = jacobian(y, x)
matD1   = jacobian(y, u)

R       = 220;
L       = 500E-3;
C       = 2.2E-6;
matA1   = eval(matA1);
matB1   = eval(matB1);
matC1   = eval(matC1);
matD1   = eval(matD1);

comment('Modelo En Espacio De Estados, Soluciones:')
sys = ss(matA1, matB1, matC1, matD1)
p   = pole(sys)

comment('Simulacion')
[t_step t_max]  = get_time_params(p)
t_step  /= 20;
t_max   *= 5;

t   = 0:t_step:t_max;
amp = 12;
t0  = 10E-3;
i0  = find(t >= t0)(1);
u1  = amp*heaviside(t);

u1(1:i0) = 0;

[y, t, x] = lsim(sys, u1, t);

figure;
subplot(4,1,1); 
plot(t, x(:,1), 'LineWidth', 2); title('State Var x_1 : i(t)');  ylabel('i(t) [A]'); grid;
subplot(4,1,2); 
plot(t, x(:,2), 'r', 'LineWidth', 2); title('State Var x_2 : vc(t)'); ylabel('vc(t) [V]'); grid;
subplot(4,1,3); 
plot(t, u1, 'LineWidth', 2); title('Input u_1 : ve(t)'); ylabel('ve(t) [V]'); grid;
subplot(4,1,4); 
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : vr(t)'); ylabel('vr(t) [V]'); grid;
xlabel('Time [s]');

figure;
plot(x(:,1), x(:,2), 'LineWidth', 2); title('State Space: x_2 vs x_1 (vc(t) vs i(t))'); ylabel('vc(t) [V]'); grid;
xlabel('i(t) [A]');

% ====================================================================================================================
disp('')
disp('=======================================================================')
disp('MODELO RLC')
disp('=======================================================================')
disp('  ii      == C vc_p')
disp('  ii_p    == C vc_pp')
disp('  ii_p    == -R/L ii - 1/L vc + 1/L ve')
disp('  vr      == R ii')
disp('=======================================================================')
% variables
syms ii vc ii_p vc_p ve R L C vc_pp real;

% para representar el espacio fasico
ii      = C*vc_p;
ii_p    = C*vc_pp;
vc_pp   = expand(solve(ii_p == -R/L*ii - 1/L*vc + 1/L*ve, vc_pp))
vr      = R*ii

comment('Asignacion De Fases (Espacio Fasico)')
disp('x1 == vc      ->  x1_p == vc_p')
disp('x2 == vc_p    ->  x2_p == vc_pp')
comment('Entradas / Salidas')
disp('u1 == ve  --  y1 == vr == C R vc_p')
x   = [vc vc_p];
xp  = [vc_p vc_pp];
u   = ve;
y   = vr;

comment('Matrices De Estado')
matA2   = jacobian(xp, x)
matB2   = jacobian(xp, u)
matC2   = jacobian(y, x)
matD2   = jacobian(y, u)

R       = 220;
L       = 500E-3;
C       = 2.2E-6;
matA2   = eval(matA2);
matB2   = eval(matB2);
matC2   = eval(matC2);
matD2   = eval(matD2);

comment('Modelo En Espacio De Estados, Soluciones:')
sys = ss(matA2, matB2, matC2, matD2)
p   = pole(sys)

comment('Simulacion')
[t_step t_max]  = get_time_params(p)
t_step  /= 20;
t_max   *= 5;

t   = 0:t_step:t_max;
amp = 12;
t0  = 10E-3;
i0  = find(t >= t0)(1);
u1  = amp*heaviside(t);

u1(1:i0) = 0;

[y, t, x] = lsim(sys, u1, t);

figure;
subplot(4,1,1); 
plot(t, x(:,1), 'r', 'LineWidth', 2); title('State Var x_1 : vc(t)');  ylabel('vc(t) [V]'); grid;
subplot(4,1,2); 
plot(t, x(:,2), '-.r', 'LineWidth', 2); title('State Var x_2 : vc_p(t)'); ylabel('vc_p(t) [V/s]'); grid;
subplot(4,1,3); 
plot(t, u1, 'LineWidth', 2); title('Input u_1 : ve(t)'); ylabel('ve(t) [V]'); grid;
subplot(4,1,4); 
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : vr(t)'); ylabel('vr(t) [V]'); grid;
xlabel('Time [s]');

figure;
plot(x(:,1), x(:,2), 'r', 'LineWidth', 2); title('Phase Space: x_2 vs x_1 (vc_p(t) vs vc(t))'); ylabel('vc_p(t) [V/s]'); grid;
xlabel('vc(t) [V]');

disp("====================================================================================================================")
disp("SUCCESS");
