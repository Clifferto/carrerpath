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

comment('Relacionar G == Y1/U1, Aislar Y1')
syms Y1 U1 real;

eq1 = collect(expand(den*Y1), Y1) == collect(expand(num*U1), U1)
% eq1 = (sym)
%      ⎛ 3     2          ⎞
%   Y₁⋅⎝s  + 6⋅s  + 5⋅s + 10⎠ = U₁⋅(10⋅s + 10)
eq1 = expand(lhs(eq1) - (6*s^2 + 5*s + 10)*Y1)  == expand(rhs(eq1) - (6*s^2 + 5*s + 10)*Y1);
eq1 = collect(expand(lhs(eq1)/s^3), s)          == collect(expand(rhs(eq1)/s^3), s);

OUT = rhs(eq1)
% OUT = (sym)
%     6⋅Y₁   10⋅U₁ - 5⋅Y₁   10⋅U₁ - 10⋅Y₁
%   - ──── + ──────────── + ─────────────
%      s           2              3
%                 s              s

comment('Asignacion, SISO, Metodo Asignacion Anidada:')
disp('X3    = Y1(terminos de potencia negativa) ->  s X3 = (bi U1 - ai Y1) + X2 ->  x3_p = (bi u - ai y) + x2')
disp('X2    = X3(terminos de potencia negativa) ->  s X2 = (bi U1 - ai Y1) + X1 ->  x2_p = (bi u - ai y) + x1')
disp('...')
disp('Y1     = X3 + b0 U1                       ->  y = x3 + b0 u ')
disp('=======================================================================')
syms x1 x2 x3 u1 y1 real;

X3      = OUT - 0*U1
X3_s    = collect(expand(X3*s), s)
% X3_s = (sym)
%           10⋅U₁ - 5⋅Y₁   10⋅U₁ - 10⋅Y₁
%   -6⋅Y₁ + ──────────── + ─────────────
%                s               2
%                               s
X2      = X3_s + 6*Y1
x3_p    = (0*u1 - 6*y1) + x2;

X2_s    = collect(expand(X2*s), s)
% X2_s = (sym)
%                  10⋅U₁ - 10⋅Y₁
%   10⋅U₁ - 5⋅Y₁ + ─────────────
%                        s
X1      = X2_s - (10*U1 - 5*Y1)
x2_p    = (10*u1 - 5*y1) + x1;

X1_s    = collect(expand(X1*s), s)
% X1_s = (sym) 10⋅U₁ - 10⋅Y₁
x1_p    = (10*u1 - 10*y1);

comment('Ecuacion De Salida:')
% ! Y1 = X3 + b0*U1
y1     = 0*u1 + x3

comment('Ecuacion De Estados:')
x1_p    = collect(expand(eval(x1_p)), u1)
x2_p    = collect(expand(eval(x2_p)), u1)
x3_p    = collect(expand(eval(x3_p)), u1)

comment('Forma Canonica Observable')
x       = [x1 x2 x3];
xp      = [x1_p x2_p x3_p];
y       = [y1];
u       = [u1];
matA    = double(jacobian(xp, x))
matB    = double(jacobian(xp, u))
matC    = double(jacobian(y, x))
matD    = double(jacobian(y, u))

comment('A = Traspuesta De Controlable, B = [ai b0 + bi] (i == Elementos De La Ultima Columna De A), C = [0 0.. 1], D = [b0]')

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

