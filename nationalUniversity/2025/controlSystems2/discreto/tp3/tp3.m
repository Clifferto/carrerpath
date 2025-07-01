% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

% masa para variar globalmente
global m;

function [Y, X, U, E]   = diff_equation_model(opp, theta0, Kc, KI, r, t)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1);

    % condiciones iniciales sistema
    [theta, theta_p, theta_pp]  = deal(num2cell(theta0){:});
    
    % codiciones iniciales controlador
    x0  = [theta ; theta_p];
    x   = x0;
    y   = theta;
    Psi = 0;

    % puntos de operacion
    xop = opp(1:2);
    uop = opp(end);
    
    % constantes del modelo
    global m;
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
        u   = uop - Kc*(x - xop) + KI*Psi;

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

comment('Variables De Estado, Asignacion De Fase')
disp('x1 == theta   ->  x1_p    == theta_p  == x2')
disp('x2 == theta_p ->  x2_p    == theta_pp (mayor orden)')
comment('Entradas / Salidas')
disp('u1 == T, y1 == x1')
disp('')
syms x1 x2 x1_p x2_p u1 delta ue;
sol     = solve(eq1, theta_pp);
% sys = [x1_p ; x2_p] == [x2 ; subs(sol, [theta, theta_p, T], [x1, x2, u1])]
x1_p    = x2
x2_p    = subs(sol, [theta, theta_p, T], [x1, x2, u1])
y1      = x1

comment('Definir Punto Equilibrio, Linealizar Entono A: [delta 0 ue]')
% torque necesario para llevar al equilibrio
ue          = solve(x2_p, u1);
ue          = subs(ue, [x2_p x1 x2], [0 delta 0]);
x1_p
x2_p_lin    = taylor(x2_p, [x1 x2 u1], [delta 0 ue], 'order', 2)
y1

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
m   = 1;
b   = .1;
L   = 1;
g   = 10;
delta = pi/2;
A   = eval(A)
B   = eval(B)
C   = eval(C)
D   = eval(D)
% ! fix medio raro, cos(pi/2) ~ 0
A(2,1)  = 0;

comment('Estabilidad Por Lyapunov Indirecto ( eig(A) ), Controlabilidad ( rank(ctrb(A, B)) )');
eig(A)
% ans =
%    0
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

comment('Estabilidad Por Lyapunov Indirecto ( eig(Aa) ), Controlabilidad ( rank(ctrb(Aa, Ba)) )');
eig(Aa)
rank(ctrb(Aa, Ba))

comment('Calculo Del Del Controlador Por LQR, Polos Y Ganancias Finales')
Q           = diag([1000000 50000 50000])
R           = 3000
% Q           = diag([1000 1 1])
% R           = 10
% Ka          = acker(Aa, Ba, [-2 -2 -2])
[Ka, SR, P] = lqr(Aa, Ba, Q, R);
P
Kc          = Ka(1:2)
KI          = -Ka(3)

% ! Con Acker, Polo Triple -2: tss ~ 3.2s, theta_max ~ 110*, u_max ~ 30Nm

% ====================================================================================================================
comment('Simulacion')
% parametros de tiempo
pp              = eig(Aa - Ba*Ka)(:)';
[t_step, t_max] = get_time_params(pp)
% ! sobre 3 a 30 veces
t_step  /= 3
t_max   *= 1
t       = 0:t_step:t_max;

% parametros de la referencia
r_amp   = delta;
r       = r_amp*heaviside(t);

disp('');
if strcmpi(input('Press "x" to cancel: ', 's'), 'x')
    return;
end

% ! en este sistema x0 =! xop
opp     = [delta    ; 0 ; eval(ue)];
theta0  = [0        ; 0 ; 0];

[y, x, u, err]  = diff_equation_model(opp, theta0, Kc, KI, r, t);

scrsz = get(0, 'screensize'); scrsz(end) -= 80;

figure('Position', scrsz);
subplot(2,1,1);
plot(t, rad2deg(x(:,1)), 'r', 'LineWidth', 2); title('State Var x_1 : theta(t)'); ylabel('x_1 [deg]'); grid;
legend('theta');
subplot(2,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2); title('State Var x_2 : theta_p(t)'); ylabel('x_2 [rad/s]'); grid;
legend('theta_p');
xlabel('Time [s]');

figure('Position', scrsz);
subplot(3,1,1);
plot(t, u(:,1), 'LineWidth', 2); title('Control Action u_1 : T(t)'); ylabel('u_1 [Nm]'); grid
legend('T(t)');
subplot(3,1,2); 
plot(t, rad2deg(y(:,1)), 'LineWidth', 2); hold;
plot(t, rad2deg(r), '-.r'); title('Output y_1 : theta Vs Set-Point'); ylabel('y_1 [deg]'); grid
legend('theta(t)', 'set-point');
subplot(3,1,3);
plot(t, err(:,1), 'LineWidth', 2); title('Error : Psi_p(t)'); ylabel('Psi_p [rad]'); grid
legend('error(t)');
xlabel('Time [s]');

figure('Position', scrsz);
plot(rad2deg(x(:,1)), rad2deg(x(:,2)), 'LineWidth', 2); title('Phase Space x1_p: theta_p vs theta'); ylabel('theta_p [deg/s]'); grid
legend('x1_p(x1)');
xlabel('theta [deg]');

% ====================================================================================================================
comment('Estudio De Robustez, Variar Masa +/- 10%')
m0  = m;

% variar masa +10%
m   = m0 + .1*m0   
[~, xp, up, ~]  = diff_equation_model(opp, theta0, Kc, KI, r, t);

% variar masa -10%
m   = m0 - .1*m0   
[~, xm, um, ~]  = diff_equation_model(opp, theta0, Kc, KI, r, t);

figure('Position', scrsz);
subplot(2,1,1);
plot(t, u(:,1), '-.k'); hold
plot(t, up(:,1), 'r');
plot(t, um(:,1), 'b'); title('Control Action u_1 : T(t) Vs Mass Variation'); ylabel('u_1 [Nm]'); grid
legend('m0', '+10%', '-10%');
subplot(2,1,2); 
plot(t, rad2deg(r), '-.r'); hold
plot(t, rad2deg(x(:,1)), '-.k');
plot(t, rad2deg(xp(:,1)), 'r');
plot(t, rad2deg(xm(:,1)), 'b'); title('Output y_1 : theta Vs Mass Variation'); ylabel('y_1 [deg]'); grid
legend('set-point', 'm0', '+10%', '-10%');
xlabel('Time [s]');

figure('Position', scrsz);
plot(rad2deg(x(:,1)), rad2deg(x(:,2)), '-.k'); hold;
plot(rad2deg(xp(:,1)), rad2deg(xp(:,2)), 'r');
plot(rad2deg(xm(:,1)), rad2deg(xm(:,2)), 'b'); title('Phase Space x1_p Vs Mass Variation'); ylabel('theta_p [deg/s]'); grid
legend('m0', '+10%', '-10%');
xlabel('theta [deg]');

comment("SUCCESS")
