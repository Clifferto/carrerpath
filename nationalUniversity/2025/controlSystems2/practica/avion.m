% ====================================================================================================================
clear all; close all; clc;

% carga pkgs
pkg load control;
pkg load symbolic;
pkg load signal;

function comment(msg)
    disp('')
    disp(msg)
    disp('=======================================================================')
endfunction

% ====================================================================================================================

disp('')
disp('=======================================================================')
disp('MODELO')
disp('=======================================================================')
disp('  alpha_p == a (phi - alpha)')
disp('  phi_pp  == -omega^2 (phi - alpha - b u)')
disp('  h_p     == c alpha')
disp('=======================================================================')

% variables
syms alpha alpha_p phi phi_p phi_pp h h_p u a omega b c real;

alpha_p = a*(phi - alpha)
phi_pp  = -omega^2*(phi - alpha - b*u)
h_p     = c*alpha

% alpha (1 integ), phi (2 integ), h (1 integ), 4 integ total
comment('Variables De Estado')
disp('x1 == alpha   ->  x1_p == alpha_p')
disp('x2 == phi     ->  x2_p == phi_p == x3 ->  x3_p == phi_pp')
disp('x4 == h       ->  x4_p == h_p')
comment('Entradas / Salidas')
disp('u == u, y1 == alpha, y2 == phi, y3 == h')
x   = [alpha, phi, phi_p, h];
xp  = [alpha_p, phi_p, phi_pp, h_p];
u   = u;
y   = [alpha, phi, h];

comment('Matrices De Estado')
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

% parametros iniciales
comment('Parametros')
a       = .05;
omega   = 2;
b       = 5;
c       = 50;

matA    = eval(matA);
matB    = eval(matB);
matC    = eval(matC);
matD    = eval(matD);

comment('Modelo En Espacio De Estados')
sys = ss(matA, matB, matC, matD)

comment('Simulacion')
x0      = [0 0 0 0]; u0 = 0;
t_max   = 20;
t       = linspace(0, t_max, 10000);
u       = heaviside(t);
% u       = square((2*pi/2) * t);
u(1)    = u0;

[y, t, x] = lsim(sys, u, t, x0);

hfig1 = figure(1); set(hfig1, 'windowstate', 'maximized');

subplot(4,1,1); 
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : alpha(t)');  ylabel('alpha(t) [rad]'); grid;
subplot(4,1,2); 
plot(t, y(:,2), 'LineWidth', 2); title('Output y_2 : phi(t)'); ylabel('phi(t) [rad]'); grid;
subplot(4,1,3); 
plot(t, y(:,3), 'LineWidth', 2); title('Output y_3 : h(t)'); ylabel('h(t) [m]'); grid;
subplot(4,1,4); 
plot(t, u, 'LineWidth', 2); title('Input u_1 : u(t)'); ylabel('u(t) [rad]'); grid;
xlabel('Time [s]');

disp("====================================================================================================================")
disp("SUCCESS");
