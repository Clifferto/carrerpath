% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../../lib');
mylib

function [Y, X, U, E] = sys_model(A, B, C, D, Ka, r, in, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    x   = x0;
    
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        u1  = -Ka*x*in(k,1);
        u2  = in(k,2);

        % simular sistema ampliado con perturbacion u2, B debe ser 4x2, C debe ser 2x4
        u   = [u1 ; u2];
        xp  = A*x + [B ; zeros(1,2)]*u   + [0 ; 0 ; 0 ; 1]*r(k);
        x   = x + xp*h;
        y   = [C zeros(2,1)]*x + D*u;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
        E(k,:)  = xp(4,1);
    endfor

endfunction

function [Y, X, U, E] = sys_pid(A, B, C, D, in, t, x0, pid_config)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1);

    Kp  = pid_config(1);
    Ki  = pid_config(2);
    Kd  = pid_config(3);

    Ts  = h;
    A1  = (2*Kp*Ts + Ki*Ts^2 + 2*Kd)/(2*Ts);
    B1  = (-2*Kp*Ts + Ki*Ts^2 - 4*Kd)/(2*Ts);
    C1  = Kd/Ts;
    
    % set point
    r   = 15;

    x   = x0;
    pid = 0;
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        % ley de control aplicada
        u   = [pid, in(k,2)]';
        
        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        err(k)  = r - y;
        if length(err) > 2 && in(k,1) > 0
            pid = pid + A1*err(k) + B1*err(k-1) + C1*err(k-2);
        endif

        U(k,:)    = u';
        X(k,:)    = x';
        Y(k,:)    = y';
    endfor

    E = err';
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

comment('Verificar Controlabilidad: rank(M) == n')
M   = ctrb(A, B)
assert(rank(M) == 3)
% P   = obsv(A, B)

comment('Polos A Lazo Abierto, Con El t_step == 1ms, Polo Mas Rapido Posible')
eig(A)
% ans =
%           0   <-- TIPO-I
%   -428.8422
%    -10.8419

% ! %y  = e^(p t)
log(.95)/1E-3
% ans = -51.293

comment('Estrategia: Control Por Realimentacion De Estados Con Integral Error (u == -K x + KI psi)')
% ! Aa  =   [A  0]
% !         [-C 0]
% ! Ba  =   [B]
% !         [0]
% ! Ka  =   [K  -KI]
% ! xa  =   [x  psi] Donde: psi_p == r - y
% solo importa el sistema theta/va, polos una octava mas rapidos
Aa  = [A zeros(3,1) ;   -C(1,:) 0]
Ba  = [B(:,1)   ;   0]

comment('Calculo Del LQR')
Q           = diag([1 1200 .00001 100000])
% Q           = diag([1/(.3)^2 1/(2*pi)^2 1/(.95)^2 1])
R           = 95
[Ka, SR, P] = lqr(Aa, Ba, Q, R)
% eig(Aa - Ba*Ka)

comment('Simulacion')

% parametros de tiempo
pp              = eig(Aa - Ba*Ka)(:)';
[t_step, t_max] = get_time_params(pp)
% ! sobre 3 a 30 veces
t_step  = 1E-3
% t_step  /= 1
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
tl  = tl_amp*(heaviside(t' - tl_t0) - heaviside(t' - r_t1) + heaviside(t' - (r_t1 + tl_t0)));
in  = [va tl];

r   = r_amp*(heaviside(t - r_t0) - 2*heaviside(t - r_t1));
x0  = [0 ; 0 ; 0 ; 0];

[y, x, u, err]  = sys_model(Aa, B, C, D, Ka, r, in, t, x0);
% x(:,2)          = mod(x(:,2), 2*pi);

figure;
subplot(3,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2); title('State Var x_1 : ia(t)'); ylabel('x_1 [A]'); grid
legend('ia(t)');
subplot(3,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2); title('State Var x_2 : theta(t)'); ylabel('x_2 [rad]'); grid
legend('theta(t)');
subplot(3,1,3);
plot(t, x(:,3), 'r', 'LineWidth', 2); title('State Var x_3 : omega(t)'); ylabel('x_3 [rad/s]'); grid
legend('omega(t)');
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