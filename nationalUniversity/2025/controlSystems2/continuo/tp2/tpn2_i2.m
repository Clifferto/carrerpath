% ====================================================================================================================
close all; clear all; clc;

% config simulacion, nombre de archivo
global CFG;
CFG.SIM_OBSERVER    = true;
CFG.SIM_NONLINEAR   = true;
CFG.SAVE_FILENAME   = 'motor_obs_nolineal';
% CFG.SAVE_FILENAME   = 'motor_obs';
% CFG.SAVE_FILENAME   = 'motor';

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../../lib');
mylib

function [Y, X, U, E, Yo, Xo, Eo] = sys_model(A, B, C, D, Kc, KI, Ko, r, in, t, x0, xo0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    x   = x0;
    y   = C*x0;
    Psi = 0;
    x_o = xo0;

    % parametro de la no linealidad del actuador
    ZM  = .5;
    
    global CFG;

    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        % calcular error para theta y variable de estado asociada
        Psi_p   = r(k) - y(1,1);
        Psi     = Psi + Psi_p*h;
        
        % calcular accion de control
        if CFG.SIM_OBSERVER
            % ia del observador, theta y omega medidas
            u1  = -Kc*[x_o(1) ; x(2:3)] + KI*Psi;
        else
            u1  = -Kc*x + KI*Psi;
        endif
        
        % guardar accion de control original
        ue  = u1;

        % agregar no linealidad en el actuador de u1
        if CFG.SIM_NONLINEAR
            if abs(u1) > ZM
                u1  = u1 - ZM*sign(u1);
            endif
        endif

        % simular sistema con perturbacion u2
        u2  = in(k,2);

        u   = [u1 ; u2];
        xp  = A*x + B*u;
        x   = x + xp*h;
        y   = C*x + D*u;
        
        % calcular error de observacion, actualizar observador
        err_o   = y - C*x_o;
        xp_o    = A*x_o + B*u + Ko*err_o;
        x_o     = x_o   + xp_o*h;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = [u', ue];
        E(k,:)  = Psi_p;
        Yo(k,:) = (C*x_o)';
        Xo(k,:) = x_o';
        Eo(k,:) = err_o';
    endfor

endfunction

% ====================================================================================================================
comment('Cargar Resultados Del Caso Anterior')
% ! tiempo, r, theta, theta_p, va, TL
data    = load(CFG.SAVE_FILENAME);
t       = data(:,1);
r       = data(:,2);
yc1     = data(:,3:4);
uc1     = data(:,5:6);

comment('Parametros Tomados De La Consigna')
Ra  = 2.27
Laa = 0.0047
Ki  = 0.25
Kb  = 0.25
Bm  = 0.00131
Jm  = 0.00233

comment('Modelo En Espacio De Estados Del Tp1 (x1 == ia, x2 == theta, x3 == theta_p == omega, y1 == theta, y2 == omega)')
A   = [-Ra/Laa 0 -Kb/Laa    ;   0 0 1   ;   Ki/Jm 0 -Bm/Jm]
B   = [1/Laa 0              ;   0 0     ;   0 -1/Jm]
C   = [0 1 0                ;   0 0 1]
D   = zeros(2,2);

comment('Polos A Lazo Abierto')
eig(A)
% ans =
%           0
%   -470.8429
%    -12.6981   <-- MOTOR MAS RAPIDO

% ====================================================================================================================
comment('Estrategia: Control Por Realimentacion De Estados Con Integral Error (u == -K x + KI psi)')
% ! Aa  =   [A  0]
% !         [-C 0]
% ! Ba  =   [B]
% !         [0]
% ! Ka  =   [K  -KI]
% ! xa  =   [x  psi] Donde: psi_p == r - y
% solo importa el sistema theta/va, se ignora c2 de B, se ignora f2 de C
Aa  = [A zeros(3,1) ;   -C(1,:) 0]
Ba  = [B(:,1)       ;   0]

comment('Verificar Controlabilidad: rank(M) == n')
M   = ctrb(A, B)
assert(rank(M) == 3)

comment('Calculo Del Del Controlador Por LQR')
% ! si Q es de nxn, la variable controlada es i:
% !     ++Qii   : penalizar la desviacion del estado xi == set-point
% !     ++Qnn   : penalizar la desviacion del estado error == 0
% !     ++Qjj   : penalizar la desviacion del origen para las variables
Q           = diag([1 1200 .00001 100000])
R           = 95
[Ka, SR, P] = lqr(Aa, Ba, Q, R)

% ====================================================================================================================
comment('Observador Midiendo (theta, omega) Y Controlando va: 2 Entradas, 2 Salidas')
Ad  = A'
Bd  = C'
Cd  = B(:,1)'

comment('Verificar Observabilidad: rank(P) == n')
P   = obsv(A, C)
assert(rank(P) == 3)

comment('Calculo Del Observador Por LQR')
Qo              = diag([1 1 1])
Ro              = eye(2)
[Kod, SR, P]    = lqr(Ad, Bd, Qo, Ro)
Ko              = Kod';

comment('Simulacion')
% parametros de tiempo tomados de datos
pp              = [eig(Aa - Ba*Ka)', eig(A - Ko*C)']
[t_step, t_max] = get_time_params(pp)

disp('');
if strcmpi(input('Press "x" to cancel: ', 's'), 'x')
    return;
end

Kc  = Ka(1:3);
KI  = -Ka(4);

% va no se va a usar para simulacion, el controlador genera la va
in  = uc1;

x0  = [0 ; 0 ; 0];
xo0 = [.5 ; .1 ; 2];

[y, x, u, err, y_o, x_o, err_o] = sys_model(A, B, C, D, Kc, KI, Ko, r, in, t, x0, xo0);

% maximizar graficas por default
scrsz = get(0, 'screensize'); scrsz(end) -= 80;

figure('Position', scrsz);
subplot(4,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2); hold;
plot(t, x_o(:,1), '-.', 'LineWidth', 2); title('State Var x_1 == ia(t) : Real Vs Observer'); ylabel('x_1 [A]'); grid;
legend('real', 'observer');
subplot(4,1,2);
plot(t, rad2deg(x(:,2)), 'r', 'LineWidth', 2); hold;
plot(t, rad2deg(x_o(:,2)), '-.', 'LineWidth', 2); title('State Var x_2 == theta(t) : Real Vs Observer'); ylabel('x_2 [deg]'); grid;
% plot(t, x(:,2), 'r', 'LineWidth', 2); hold;
% plot(t, x_o(:,2), '-.', 'LineWidth', 2); title('State Var x_2 == theta(t) : Real Vs Observer'); ylabel('x_2 [rad]'); grid;
legend('real', 'observer');
subplot(4,1,3);
plot(t, x(:,3), 'r', 'LineWidth', 2); hold;
plot(t, x_o(:,3), '-.', 'LineWidth', 2); title('State Var x_3 == omega(t) : Real Vs Observer'); ylabel('x_3 [rad/s]'); grid;
legend('real', 'observer');
subplot(4,1,4);
plot(t, err_o(:,1), 'LineWidth', 2, t, err_o(:,2), 'LineWidth', 2); title('Observer Errors'); ylabel('error'); grid;
legend('error');
xlabel('Time [s]');

figure('Position', scrsz);
subplot(4,1,1);
plot(t, u(:,3), '-.r'); hold;
plot(t, u(:,1), 'LineWidth', 2); title('Input u_1 : va(t)'); ylabel('u_1 [V]'); grid;
legend('linear', 'non-linear');
subplot(4,1,2); 
plot(t, u(:,2), 'LineWidth', 2); title('Input u_2 : TL(t)'); ylabel('u_2 [Nm]'); grid;
legend('TL(t)');
subplot(4,1,3); 
plot(t, rad2deg(y(:,1)), 'LineWidth', 2); hold;
plot(t, rad2deg(r), '-.r'); title('Output Vs Set-Point'); ylabel('y_1 [deg]'); grid;
% plot(t, y(:,1), 'LineWidth', 2); hold;
% plot(t, r, '-.r'); title('Output Vs Set-Point'); ylabel('y_1 [rad]'); grid;
legend('theta(t)', 'set-point');
subplot(4,1,4); 
plot(t, rad2deg(err(:,1)), 'LineWidth', 2); title('Error : Psi_p(t)'); ylabel('Psi_p [deg]'); grid;
% plot(t, err(:,1), 'LineWidth', 2); title('Error : Psi_p(t)'); ylabel('Psi_p [rad]'); grid;
legend('error(t)');
xlabel('Time [s]');

figure('Position', scrsz);
subplot(4,1,1);
plot(t, uc1(:,1), '-.k'); hold;
plot(t, u(:,1)); title('Input u_1 == va : Case1 Vs Case2'); ylabel('u_1 [V]'); grid;
legend('motor1', 'motor2');
subplot(4,1,2);
plot(t, u(:,2)); title('Input u_2 == TL(t)'); ylabel('u_2 [Nm]'); grid;
legend('TL(t)');
subplot(4,1,3); 
plot(t, rad2deg(yc1(:,1)), '-.k'); hold;
plot(t, rad2deg(y(:,1)));
plot(t, rad2deg(r), '-.r'); title('Output y_1 == theta : Case1 Vs Case2'); ylabel('y_1 [deg]'); grid;
% plot(t, y(:,1)); hold;
% plot(t, r, '-.r'); title('Output Vs Set-Point'); ylabel('y_1 [rad]'); grid;
legend('motor1', 'motor2', 'set-point');
subplot(4,1,4);
plot(t, yc1(:,2), '-.k'); hold;
plot(t, y(:,2)); title('Output y_1 == omega : Case1 Vs Case2'); ylabel('y_2 [rad/s]'); grid;
legend('motor1', 'motor2');
xlabel('Time [s]');

comment("SUCCESS")
