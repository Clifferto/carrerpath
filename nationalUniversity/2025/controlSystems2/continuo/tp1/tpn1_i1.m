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
disp('MODELO CASO 1')
disp('=======================================================================')
disp('  ii_p    == -R/L ii - 1/L vc + 1/L ve')
disp('  vc_p    == 1/C ii')
disp('=======================================================================')

% variables
syms ii vc ii_p vc_p ve R L C real;

ii_p    = -R/L*ii - 1/L*vc + 1/L*ve;
vc_p    = 1/C*ii;
vr      = R*ii;

comment('Variables De Estado')
disp('x1 == ii  ->  x1_p == ii_p')
disp('x2 == vc  ->  x2_p == vc_p')
comment('Entradas / Salidas')
disp('u == ve, y1 == vr == R ii')
x   = [ii vc];
xp  = [ii_p vc_p];
u   = ve;
y   = vr;

comment('Matrices De Estado')
global matA; matA   = jacobian(xp, x)
global matB; matB   = jacobian(xp, u)
global matC; matC   = jacobian(y, x)
global matD; matD   = jacobian(y, u)

comment('Parametros')
R   = 220
L   = 500E-3
C   = 2.2E-6

matA    = eval(matA);
matB    = eval(matB);
matC    = eval(matC);
matD    = eval(matD);

comment('Modelo En Espacio De Estados')
sys = ss(matA, matB, matC, matD)
p   = pole(sys)

damp(sys)

comment('Simulacion')
[t_step t_max] = get_time_params(p)

t_step  /= 100;
t_max   *= 10;

t       = 0:t_step:t_max;
period  = 20E-3
amp     = 12
delay   = 10E-3
u       = amp * square((2*pi/period) * (t - delay));

% ! hacer u = 0 para t<delay
for n = 1:length(t) 
    if t(n) < delay
        u(n) = 0;
    end
end

[y, t, x] = lsim(sys, u, t);

hfig1 = figure(1); set(hfig1, 'windowstate', 'maximized');

subplot(4,1,1); 
plot(t, x(:,1), 'LineWidth', 2); title('State Var x_1 : i(t)');  ylabel('i(t) [A]'); grid;
subplot(4,1,2); 
plot(t, x(:,2), 'LineWidth', 2); title('State Var x_2 : vc(t)'); ylabel('vc(t) [V]'); grid;
subplot(4,1,3); 
plot(t, u, 'LineWidth', 2); title('Input u_1 : ve(t)'); ylabel('ve(t) [V]'); grid;
subplot(4,1,4); 
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : vr(t)'); ylabel('vr(t) [V]'); grid;
xlabel('Time [s]');

disp("====================================================================================================================")
disp("SUCCESS");
