% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;
pkg load control;

addpath('../lib');
mylib

% ====================================================================================================================
comment('MODELO (Realimentacion Negativa)')
disp('G1    == 1/s')
disp('G2    == 10/(s + 5)')
disp('H1    == 1/(s + 1)')
disp('=======================================================================')

syms s real;

G1  = 1/s;
G2  = 10/(s + 5);
H1  = 1/(s + 1);

G           = simplify(G1*G2/(1 + G1*G2*H1))
[num den]   = numden(G);

% multiplica num, den por variable auxiliar
syms Y1 U1 X real;

Y1   = collect(expand(num .* X), s)
U1   = collect(expand(den .* X), s)

% antitransforma salida/entrada
syms x x_p x_pp x_ppp y1 u1 u1_p u1_pp u1_ppp real;

% Y1 = (sym) 10⋅X⋅s + 10⋅X
% U1 = (sym)
%      3        2
%   X⋅s  + 6⋅X⋅s  + 5⋅X⋅s + 10⋅X

eq1 = y1    == 10*x_p + 10*x
eq2 = u1    == x_ppp + 6*x_pp + 5*x_p + 10*x

comment('Asignacion, SISO, Metodo Variable Auxiliar')
disp('x1    = x     ->  x1_p = x_p      = x2')
disp('x2    = x_p   ->  x2_p = x_pp     = x3')
disp('x3    = x_pp  ->  x3_p = x_ppp    = (mayor orden)')

comment('Relacionando Con La EDO')
syms x1 x2 x3 x1_p x2_p x3_p real;

x       = x1;
x_p     = x2;
x_pp    = x3;
x_ppp   = eval(solve(eq2, x_ppp))
y1      = eval(rhs(eq1))

comment('Ecuacion De Estados')
x1_p    = x2
x2_p    = x3
x3_p    = x_ppp 

comment('Forma Canonica Controlable')
x       = [x1 x2 x3];
xp      = [x1_p x2_p x3_p];
y       = [y1];
u       = [u1];
matA    = double(jacobian(xp, x))
matB    = double(jacobian(xp, u))
matC    = double(jacobian(y, x))
matD    = double(jacobian(y, u))

comment('A = Forma Canonica, B = [0 0.. 1], C = [ai b0 + bi] (i == Elementos De La Ultima Fila De A), D = [b0]')

comment('Comprobacion Funcion De Transferencia Vs Espacio De Estados')
s   = tf('s');
G1  = 1/s;
G2  = 10/(s + 5);
H1  = 1/(s + 1);

sys_tf  = feedback(G1*G2, H1)
sys_ss  = ss(matA, matB, matC, matD)

comment('Caracteristicas')
damp(sys_tf)
damp(sys_ss)

%    Pole                   Damping     Frequency        Time Constant
%                                       (rad/seconds)    (seconds)
%    -2.91e-01+1.33e+00i    2.14e-01    1.36e+00         3.44e+00
%    -2.91e-01-1.33e+00i    2.14e-01    1.36e+00         3.44e+00
%    -5.42e+00+0.00e+00i    1.00e+00    5.42e+00         1.85e-01
p_dom   = [-2.91e-01+1.33i -2.91e-01-1.33i];
p_non   = [-5.42];

comment('Simulacion')
[~      , t_max ]   = get_time_params(p_dom);
[t_step , ~     ]   = get_time_params(p_non);
t_step  /= 10
t_max   *= 4

t   = 0:t_step:t_max;

[y_tf, t] = step(sys_tf, t);
[y_ss, t] = step(sys_ss, t);

figure; hold;
plot(t, y_tf, 'LineWidth', 2);
plot(t, y_ss, 'LineWidth', 2);
title('Transfer-Function Vs State-Space Models'); ylabel('y1(t) [adim]'); grid;
legend('sys\_tf', 'sys\_ss');
xlabel('Time [s]');

comment('SUCCESS')
