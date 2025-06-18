% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U, E]   = diff_equation_model(theta0, Kc, KI, r, t)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)

    [theta, theta_p, theta_pp]  = deal(num2cell(theta0){:});

    % para controlador
    x0  = [theta ; theta_p];
    x   = x0;
    y   = theta;
    Psi = 0;
    
    % constantes del modelo
    m   = 1;
    b   = .1;
    L   = 1;
    g   = 10;

    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        % calcular error para Phi y variable de estado asociada
        Psi_p   = r(k) - y;
        Psi     = Psi + Psi_p*h;
        
        % calcular accion de control
        u   = -Kc*(x - x0) + KI*Psi;
        
        % x2_p = (sym)
        % -L⋅g⋅m⋅sin(x₁) - b⋅x₂ + u₁
        % ──────────────────────────
        %              2
        %             L ⋅m
        % Donde: x1 == theta, x2 == theta_p, x2_p == theta_pp
        theta_pp    = ( -L*m*g*sin(theta) - b*theta_p + u )/( L^2*m );
        theta_p     = theta_p + theta_pp*h;
        theta       = theta + theta_p*h;

        x   = [theta ; theta_p];
        y   = theta;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
        E(k,:)  = Psi_p;
    endfor

endfunction

% ====================================================================================================================
comment('MODELO PENDULO SIMPLE')
disp('  m L^2 theta_pp + b theta_p + m g L sin(theta) == T')
disp('')
syms theta theta_p theta_pp m T L g b;

eq1 = m*L^2*theta_pp + b*theta_p + m*g*L*sin(theta) == T

syms x1 x2 x1_p x2_p u1 delta ue;
sol     = solve(eq1, theta_pp);
x1_p    = x2
x2_p    = subs(sol, [theta, theta_p, T], [x1, x2, u1])
y1      = x1

ue  = solve(x2_p, u1);
ue  = subs(ue, [x2_p x1 x2], [0 delta 0])

x2_p_lin = taylor(x2_p, [x1 x2 u1], [delta 0 ue], 'order', 2)

x   = [x1 x2];
xp  = [x1_p x2_p_lin];
u   = u1;
y   = [x1];
A   = simplify(jacobian(xp, x))
B   = simplify(jacobian(xp, u))
C   = simplify(jacobian(y, x))
D   = simplify(jacobian(y, u))

% ====================================================================================================================
comment('Parametros Asignados:');
disp('Nombre          Apellido(s) m   b   l   G   delta   p(triple)')
disp('Domingo Jesus   FERRARIS    1   0,1 1   10  90      -2')
disp('')
m   = 1
b   = .1
L   = 1
g   = 10
delta = pi/2
A   = eval(A)
B   = eval(B)
C   = eval(C)
D   = eval(D)
% fix medio raro
A(2,1)  = 0;

eig(A)
% ans =
%   -6.1340e-15
%   -1.0000e-01
rank(ctrb(A, B))

% ====================================================================================================================
comment('Estrategia: Control Por Realimentacion De Estados Con Integral Error (u == -K x + KI psi)')
% ! Aa  =   [A  0]      Ba  =   [B]
% !         [-C 0]              [0]
% ! Ka  =   [K -KI]
% ! xa  =   [x psi]     Donde: psi_p == r - y
Aa  = [A zeros(2,1) ;   -C 0]
Ba  = [B            ;   0]

comment('Calculo Del Del Controlador Por LQR')
Q           = diag([1 1 1])
R           = 1
[Ka, SR, P] = lqr(Aa, Ba, Q, R)
Kc          = Ka(1:2);
KI          = -Ka(3);

% ====================================================================================================================
comment('Simulacion')
% parametros de tiempo
pp              = eig(Aa - Ba*Ka)(:)';
[t_step, t_max] = get_time_params(pp)
% ! sobre 3 a 30 veces
t_step  /= 10
t_max   *= 2
t       = 0:t_step:t_max;

% parametros de la referencia
r_amp   = delta;
% r_t0    = va_t0;
% r_t1    = 2;
r       = r_amp*heaviside(t);

disp('');
if strcmpi(input('Press "x" to cancel: ', 's'), 'x')
    return;
end

% ! x0 == xop
theta0  = [delta 0 0];

[y, x, u, err]  = diff_equation_model(theta0, Kc, KI, r, t);
% x(:,3)      = mod(x(:,3), 2*pi);

scrsz = get(0, 'screensize'); scrsz(end) -= 80

figure('Position', scrsz);
subplot(4,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2); title('State Var x_1 == delta(t)'); ylabel('x_1 [m]'); grid;
% plot(t, x_o(:,1), '-.', 'LineWidth', 2); title('State Var x_1 == ia(t) : Real Vs Observer'); ylabel('x_1 [A]'); grid;
legend('real', 'observer');
subplot(4,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2); title('State Var x_2 == delta_p(t)'); ylabel('x_2 [m/s]'); grid;
% plot(t, x_o(:,2), '-.', 'LineWidth', 2); title('State Var x_2 == theta(t) : Real Vs Observer'); ylabel('x_2 [rad]'); grid;
legend('real', 'observer');
subplot(4,1,3);
plot(t, rad2deg(x(:,3)), 'r', 'LineWidth', 2); title('State Var x_3 == Phi(t)'); ylabel('x_3 [deg]'); grid;
% plot(t, x_o(:,3), '-.', 'LineWidth', 2); title('State Var x_3 == omega(t) : Real Vs Observer'); ylabel('x_3 [rad/s]'); grid;
legend('real', 'observer');
subplot(4,1,4);
plot(t, x(:,4), 'r', 'LineWidth', 2); title('State Var x_4 == Phi_p(t)'); ylabel('x_3 [rad/s]'); grid;
% plot(t, x_o(:,3), '-.', 'LineWidth', 2); title('State Var x_3 == omega(t) : Real Vs Observer'); ylabel('x_3 [rad/s]'); grid;
legend('real', 'observer');
% subplot(4,1,4);
% plot(t, err_o(:,1), 'LineWidth', 2, t, err_o(:,2), 'LineWidth', 2); title('Observer Errors'); ylabel('error'); grid
% legend('error');
xlabel('Time [s]');

figure('Position', scrsz);
subplot(4,1,1);
plot(t, u(:,1), 'LineWidth', 2); title('Control Action u_1 : force(t)'); ylabel('u_1 [N]'); grid
legend('force(t)');
subplot(4,1,2); 
plot(t, rad2deg(y(:,2)), 'LineWidth', 2);  title('Output y_2 : Phi(t)'); ylabel('y_2 [deg]'); hold;
plot(xlim(), [180+1, 180+1], '-.r', xlim(), [180-1, 180-1], '-.r'); grid;
% plot(t, r, '-.r'); title('Output Vs Set-Point'); ylabel('y_1 [rad]'); grid
legend('Phi(t)', 'set-point');
subplot(4,1,3);
plot(t, y(:,1), 'LineWidth', 2); hold;
plot(t, r, '-.r'); title('Output y_1 Vs Set-Point'); ylabel('y_1 [m]'); grid
legend('delta(t)', 'set-point');
subplot(4,1,4); 
plot(t, err(:,1), 'LineWidth', 2); title('Error : Psi_p(t)'); ylabel('Psi_p [m]'); grid
legend('error(t)');
xlabel('Time [s]');

comment("SUCCESS")

return
comment('Variables, Corrimiento Al Origen [delta 0]')
disp('x1 == theta   - delta     ->  x1_p    == theta_p  == x2')
disp('x2 == theta_p - 0         ->  x2_p    == theta_pp (mayor orden)')
comment('Entradas / Salidas')
disp('u1 == T, y1 == x1')
disp('')
syms x1 x2 x1_p x2_p u1 delta ue;
sol     = solve(eq1, theta_pp);
x1_p    = x2
x2_p    = subs(sol, [theta, theta_p, T], [x1 + delta, x2, u1])
y1      = x1

comment('Torque Estatico Para Llevar Al Equilibrio: ue / xp == 0')
ue  = solve(x2_p, u1);
ue  = subs(ue, [x2_p x1 x2], [0 0 0])

% ====================================================================================================================
comment('Linealizacion Entorno Al Equilibrio [delta 0 ue]')
% ! el order es EXCLUYENTE, order = 2 es expansion lineal
x2_p_lin = taylor(x2_p, [x1 x2 u1], [0 0 ue], 'order', 2)

comment('Modelo En Espacio De Estados, Punto De Operacion: [theta theta_p ue] == [delta 0 L⋅g⋅m⋅sin(δ)]')
x   = [x1 x2]
xp  = [x1_p x2_p_lin]
u   = u1
y   = [x1];
A   = simplify(jacobian(xp, x))
B   = simplify(jacobian(xp, u))
C   = simplify(jacobian(y, x))
D   = simplify(jacobian(y, u))




return

Phi_pp_lin      = collect(expand(taylor(sol.Phi_pp, [delta delta_p Phi Phi_p], [0 0 0 0], 'order', 2)), [delta delta_p Phi Phi_p, u])

comment('Variables De Estado, Asignacion De Fases (Espacio Fasico)')
disp('x1 == delta   ->  x1_p    == delta_p  == x2')
disp('x2 == delta_p ->  x2_p    == delta_pp == (mayor orden)')
disp('x3 == Phi     ->  x3_p    == Phi_p    == x4')
disp('x4 == Phi_p   ->  x4_p    == Phi_pp   == (mayor orden)')
comment('Entradas / Salidas')
disp('u1 == u   --  y1 == delta, y2 == Phi')
x   = [delta delta_p Phi Phi_p];
xp  = [delta_p delta_pp_lin Phi_p Phi_pp_lin];
u   = u;
y   = [delta Phi];

comment('Matrices De Estado Para El Equilibrio Inestable')

comment('Modelo En Espacio De Estados')
m   = .1
F   = .1
L   = .6
g   = 9.8
M   = .5

A   = eval(A);
B   = eval(B);
C   = eval(C);
D   = eval(D);

comment('Simulacion')
[t_step, t_max] = get_time_params(pole(ss(A, B, C, D)));
t_step  /= 30
t_max   *= 2

t   = 0:t_step:t_max;
in  = heaviside(t);
x0  = [0 ; 0 ; 0 ; 0]';

[y, x, u]       = not_lineal([m F L g M], in, t, x0);
[yl, xl, ul]    = sys_model(A, B, C, D, in, t, x0);
% [y, t, x]   = lsim(ss(A, B, C, D), in, t, x0);

figure;
subplot(4,1,1);
plot(t, xl(:,1), 'r', 'LineWidth', 2, t, x(:,1), '-.-', 'LineWidth', 2);
title('State Var x_1: delta'); ylabel('delta [m]'); grid;
legend('lineal', 'real');
subplot(4,1,2);
plot(t, xl(:,2), 'r', 'LineWidth', 2, t, x(:,2), '-.-', 'LineWidth', 2);
title('State Var x_2: delta_p'); ylabel('delta_p [m/s]'); grid;
legend('lineal', 'real');
subplot(4,1,3);
plot(t, xl(:,3), 'r', 'LineWidth', 2, t, x(:,3), '-.-', 'LineWidth', 2);
title('State Var x_3: Phi'); ylabel('Phi [rad]'); grid;
legend('lineal', 'real');
subplot(4,1,4);
plot(t, xl(:,4), 'r', 'LineWidth', 2, t, x(:,4), '-.-', 'LineWidth', 2);
title('State Var x_4: Phi_p'); ylabel('Phi_p [rad/s]'); grid;
legend('lineal', 'real');
xlabel('Time [s]'); 

figure;
subplot(3,1,1); 
plot(t, u, 'LineWidth', 2);
% plot(t, in, 'LineWidth', 2);
title('Input u_1: force'); ylabel('force [N]'); grid;
legend('force(t)');
subplot(3,1,2); 
plot(t, y(:,1), 'LineWidth', 2);
title('Output y_1: delta'); ylabel('delta [m]'); grid;
legend('delta(t)');
subplot(3,1,3); 
plot(t, y(:,2), 'LineWidth', 2);
title('Output y_2: Phi'); ylabel('Phi [rad]'); grid;
legend('Phi(t)');
xlabel('Time [s]'); 

return
% ====================================================================================================================
comment('Para Equilibrio Estable [Phi = pi, delta = 0], Simplificaciones [cos(Phi) ~ -1, sin(Phi) ~ -Phi]')
eq1_ee  = subs(eq1, [cos(Phi) sin(Phi)], [-1 -Phi])
eq2_ee  = subs(eq2, [cos(Phi) sin(Phi)], [-1 -Phi])

comment('Linealizacion Derivadas De Mayor Orden, Entorno Al Equilibrio Estable')
sol = solve(eq1_ee, eq2_ee, delta_pp, Phi_pp);

% ! el order es EXCLUYENTE, order = 2 es expansion lineal
delta_pp_lin    = collect(expand(taylor(sol.delta_pp, [delta delta_p Phi Phi_p], [0 0 pi 0], 'order', 2)), [delta delta_p Phi Phi_p, u])
Phi_pp_lin      = collect(expand(taylor(sol.Phi_pp, [delta delta_p Phi Phi_p], [0 0 pi 0], 'order', 2)), [delta delta_p Phi Phi_p, u])

comment('Variables De Estado, Asignacion De Fases (Espacio Fasico)')
disp('x1 == delta   ->  x1_p    == delta_p  == x2')
disp('x2 == delta_p ->  x2_p    == delta_pp == (mayor orden)')
disp('x3 == Phi     ->  x3_p    == Phi_p    == x4')
disp('x4 == Phi_p   ->  x4_p    == Phi_pp   == (mayor orden)')
comment('Entradas / Salidas')
disp('u1 == u   --  y1 == delta, y2 == Phi')
x   = [delta delta_p Phi Phi_p];
xp  = [delta_p delta_pp_lin Phi_p Phi_pp_lin];
u   = u;
y   = [delta Phi];

comment('Matrices De Estado Para El Equilibrio Estable')
A   = simplify(jacobian(xp, x))
B   = simplify(jacobian(xp, u))
C   = simplify(jacobian(y, x))
D   = simplify(jacobian(y, u))

return
comment('Modelo En Espacio De Estados')
m   = .1
F   = .1
L   = .6
g   = 9.8
M   = .5

A   = eval(A)
B   = eval(B)
C   = eval(C)
D   = eval(D)

comment('Simulacion')
[t_step, t_max] = get_time_params(pole(ss(A, B, C, D)));
t_step  /= 30
t_max   *= 2

t   = 0:t_step:t_max;
in  = heaviside(t);
x0  = [0 ; 0 ; 0 ; 0]';

[y, x, u]   = not_lineal([m F L g M], in, t, x0);
% [y, x, u]   = sys_model(A, B, C, D, in, t, x0);
% [y, t, x]   = lsim(ss(A, B, C, D), in, t, x0);

figure;
subplot(4,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2);
title('State Var x_1: delta'); ylabel('delta [m]'); grid;
legend('delta(t)');
subplot(4,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2);
title('State Var x_2: delta_p'); ylabel('delta_p [m/s]'); grid;
legend('delta_p(t)');
subplot(4,1,3);
plot(t, x(:,3), 'r', 'LineWidth', 2);
title('State Var x_3: Phi'); ylabel('Phi [rad]'); grid;
legend('Phi(t)');
subplot(4,1,4);
plot(t, x(:,4), 'r', 'LineWidth', 2);
title('State Var x_4: Phi_p'); ylabel('Phi_p [rad/s]'); grid;
legend('Phi_p(t)');
xlabel('Time [s]'); 

figure;
subplot(3,1,1); 
plot(t, u, 'LineWidth', 2);
% plot(t, in, 'LineWidth', 2);
title('Input u_1: force'); ylabel('force [N]'); grid;
legend('force(t)');
subplot(3,1,2); 
plot(t, y(:,1), 'LineWidth', 2);
title('Output y_1: delta'); ylabel('delta [m]'); grid;
legend('delta(t)');
subplot(3,1,3); 
plot(t, y(:,2), 'LineWidth', 2);
title('Output y_2: Phi'); ylabel('Phi [rad]'); grid;
legend('Phi(t)');
xlabel('Time [s]'); 

comment("SUCCESS")
