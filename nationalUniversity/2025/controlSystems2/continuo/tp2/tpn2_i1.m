% ====================================================================================================================
close all; clear all; clc;

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
    
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        % calcular error para theta y variable de estado asociada
        Psi_p   = r(k) - y(1,1);
        Psi     = Psi + Psi_p*h;
        
        % calcular accion de control
        u1  = (-Kc*x_o + KI*Psi) * in(k,1);
        u2  = in(k,2);
        u   = [u1 ; u2];

        % simular sistema con perturbacion u2
        xp  = A*x + B*u;
        x   = x + xp*h;
        y   = C*x + D*u;
        
        % calcular error de observacion, actualizar observador
        err_o   = y - C*x_o;
        xp_o    = A*x_o + B*u + Ko*err_o;
        x_o     = x_o   + xp_o*h;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
        E(k,:)  = Psi_p;
        Yo(k,:) = (C*x_o)';
        Xo(k,:) = x_o';
        Eo(k,:) = err_o';
    endfor

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

comment('Polos A Lazo Abierto, Con El t_step == 1ms, Polo Mas Rapido Posible')
eig(A)
% ans =
%           0   <-- TIPO-I
%   -428.8422
%    -10.8419

% ! %y  = e^(p t)
log(.95)/1E-3
% ans = -51.293 <-- DIFICIL DE CUMPLIR PARA LA DINAMICA REQUERIDA

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
Ba  = [B(:,1)   ;   0]

comment('Verificar Controlabilidad: rank(M) == n')
M   = ctrb(A, B)
assert(rank(M) == 3)

comment('Calculo Del Del Controlador Por LQR')
Q           = diag([1 1200 .00001 100000])
% Q           = diag([1/(.3)^2 1/(2*pi)^2 1/(.95)^2 1])
R           = 95
[Ka, SR, P] = lqr(Aa, Ba, Q, R)
% eig(Aa - Ba*Ka)

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
% eig(A - Ko*C)

comment('Simulacion')
% parametros de tiempo
pp              = eig(Aa - Ba*Ka)(:)';
[t_step, t_max] = get_time_params(pp)
% ! sobre 3 a 30 veces
t_step  = 1E-3
% t_max   *= 3
t_max   *= 15

% ! de las graficas de mediciones, parametros de las entradas
va_amp  = 2/2;
% tl_amp  = 0;
tl_amp  = .12;
va_t0   = 100E-3;
tl_t0   = 700E-3;

% parametros de la referencia
r_amp   = pi/2;
r_t0    = va_t0;
r_t1    = 2;

disp('');
if strcmpi(input('Press "x" to cancel: ', 's'), 'x')
    return;
end

t   = 0:t_step:t_max;
va  = va_amp*heaviside(t' - va_t0);
tl  = tl_amp*(heaviside(t' - tl_t0) - heaviside(t' - r_t1) - heaviside(t' - (r_t1 + tl_t0)));
in  = [va tl];

r   = r_amp*(heaviside(t - r_t0) - 2*heaviside(t - r_t1));
Kc  = Ka(1:3);
KI  = -Ka(4);

x0  = [0 ; 0 ; 0];
xo0 = [.1 ; 0 ; 2];

[y, x, u, err, y_o, x_o, err_o] = sys_model(A, B, C, D, Kc, KI, Ko, r, in, t, x0, xo0);
% x(:,2)          = mod(x(:,2), 2*pi);

figure;
subplot(4,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2); hold
plot(t, x_o(:,1), '-.', 'LineWidth', 2); title('State Var x_1 == ia(t) : Real Vs Observer'); ylabel('x_1 [A]'); grid;
legend('real', 'observer');
subplot(4,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2); hold
plot(t, x_o(:,2), '-.', 'LineWidth', 2); title('State Var x_2 == theta(t) : Real Vs Observer'); ylabel('x_2 [rad]'); grid;
legend('real', 'observer');
subplot(4,1,3);
plot(t, x(:,3), 'r', 'LineWidth', 2); hold
plot(t, x_o(:,3), '-.', 'LineWidth', 2); title('State Var x_3 == omega(t) : Real Vs Observer'); ylabel('x_3 [rad/s]'); grid;
legend('real', 'observer');
subplot(4,1,4);
plot(t, err_o(:,1), 'LineWidth', 2, t, err_o(:,2), 'LineWidth', 2); title('Observer Errors'); ylabel('error'); grid
legend('error');
xlabel('Time [s]');

figure;
subplot(4,1,1);
plot(t, u(:,1), 'LineWidth', 2); title('Input u_1 : va(t)'); ylabel('u_1 [V]'); grid
legend('va(t)');
subplot(4,1,2); 
plot(t, u(:,2), 'LineWidth', 2); title('Input u_2 : TL(t)'); ylabel('u_2 [Nm]'); grid
legend('TL(t)');
subplot(4,1,3); 
plot(t, y(:,1), 'LineWidth', 2); hold
plot(t, r, '-.r'); title('Output Vs Set-Point'); ylabel('y_1 [rad]'); grid
legend('theta(t)', 'set-point');
subplot(4,1,4); 
plot(t, err(:,1), 'LineWidth', 2); title('Error : Psi_p(t)'); ylabel('Psi_p [rad]'); grid
legend('error(t)');
xlabel('Time [s]');

comment("SUCCESS")

% % Ejemplo de no-linealidad
% ue=-2.5:.1:2.5; N=length(ue); uo=zeros(1,N);
% ZM=.5;
% for ii=1:N
%     if abs(ue(ii))>ZM
%     uo(ii)=ue(ii)-ZM*sign(ue(ii));
%     end
% end
% plot(ue,uo,'k');xlabel('Tensión de entrada');
% ylabel('V_o','Rotation',0);grid on;

% https://github.com/Julianpucheta/OptimalControl/blob/main/Pontryagin%20minimum%20principle/Control_CyO_Pendulo_MH.ipynb