% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U, E]   = diff_equation_model(delta0, Phi0, Kc, KI, r, t)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)

    delta       = delta0(1);
    delta_p     = delta0(2);
    delta_pp    = delta0(3);
    Phi         = Phi0(1);
    Phi_p       = Phi0(2);
    Phi_pp      = Phi0(3);
    
    x   = [delta ; delta_p ; Phi ; Phi_p];
    y   = [delta ; Phi];
    Psi = 0;
    % x_o = xo0;
    
    % constantes del modelo
    F   = .1;
    L   = 1.6;
    m   = .1;
    M   = 1.5;
    g   = 9.8;

    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        % calcular error para Phi y variable de estado asociada
        Psi_p   = r(k) - y(1,1);
        Psi     = Psi + Psi_p*h;
        
        % calcular accion de control
        u   = (-Kc*(x - [0 ; 0 ; pi ; 0]) + KI*Psi);

        % delta_pp = (sym)
        %               2
        %    -F⋅δₚ + L⋅Φₚ ⋅m⋅sin(Φ) - L⋅Φₚₚ⋅m⋅cos(Φ) + u
        %   ───────────────────────────────────────────
        %                      M + m
        % Phi_pp = (sym)
        %    -δₚₚ⋅cos(Φ) + g⋅sin(Φ)
        %   ──────────────────────
        %             L
        delta_pp    = ( -F*delta_p + L*Phi_p*m*sin(Phi) - L*Phi_pp*m*cos(Phi) + u )/( M + m );
        delta_p     = delta_p + delta_pp*h;
        delta       = delta + delta_p*h;

        Phi_pp      = ( -delta_pp*cos(Phi) + g*sin(Phi) )/( L );
        Phi_p       = Phi_p + Phi_pp*h;
        Phi         = Phi + Phi_p*h;

        x   = [delta ; delta_p ; Phi ; Phi_p];
        y   = [delta ; Phi];

        % calcular error de observacion, actualizar observador
        % err_o   = y - C*x_o;
        % xp_o    = A*x_o + B*u + Ko*err_o;
        % x_o     = x_o   + xp_o*h;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
        E(k,:)  = Psi_p;
        % Yo(k,:) = (C*x_o)';
        % Xo(k,:) = x_o';
        % Eo(k,:) = err_o';
    endfor

endfunction

% ====================================================================================================================
comment('MODELO PENDULO')
disp('  (M + m) delta_pp + m L Phi_pp cos(Phi) - m L Phi_p^2 sin(Phi) + F delta_p   == u')
disp('  L Phi_pp - g sin(Phi) + delta_pp cos(Phi)                                   == 0')
disp('')
% syms Phi Phi_p Phi_pp delta delta_p delta_pp M m u L F g;

% eq1         = (M + m)*delta_pp + m*L*Phi_pp*cos(Phi) - m*L*Phi_p^2*sin(Phi) + F*delta_p == u
% eq2         = L*Phi_pp - g*sin(Phi) + delta_pp*cos(Phi)                                 == 0
% % ! derivadas de mayor orden, con DENOMINADOR CONSTANTE
% delta_pp    = factor(solve(eq1, delta_pp))
% Phi_pp      = factor(solve(eq2, Phi_pp))

% delta_pp = (sym)
%               2
%    -F⋅δₚ + L⋅Φₚ ⋅m⋅sin(Φ) - L⋅Φₚₚ⋅m⋅cos(Φ) + u
%   ───────────────────────────────────────────
%                      M + m

% Phi_pp = (sym)
%    -δₚₚ⋅cos(Φ) + g⋅sin(Φ)
%   ──────────────────────
%             L

comment('Parametros Del Sistema')
F   = .1
L   = 1.6
m   = .1
M   = 1.5
g   = 9.8

comment('Modelo Linealizado En Equilibrio Estable (x1 == delta, x2 == delta_p, x3 == Phi, x4 == Phi_p, y1 == delta, y2 == Phi)')
A   = [0 1 0 0  ;   0 -F/M -m*g/M 0     ;   0 0 0 1     ;   0 -F/(L*M) -g*(m+M)/(L*M) 0];
B   = [0        ;   1/M                 ;   0           ;   1/(L*M)];
C   = [1 0 0 0  ;   0 0 1 0];
D   = zeros(2,1);

comment('Polos A Lazo Abierto')
eig(A)
% ans =
%         0 +      0i
%   -0.0625 +      0i
%   -0.0021 + 2.5560i
%   -0.0021 - 2.5560i

comment('Verificar Controlabilidad: rank(M) == n')
M   = ctrb(A, B)
assert(rank(M) == 4)

% ====================================================================================================================
comment('Estrategia: Control Por Realimentacion De Estados Con Integral Error (u == -K x + KI psi)')
% ! Aa  =   [A  0]      Ba  =   [B]
% !         [-C 0]              [0]
% ! Ka  =   [K -KI]
% ! xa  =   [x psi]     Donde: psi_p == r - y
% solo importa el sistema delta/u, se ignora f2 de C
Aa  = [A zeros(4,1)     ;   -C(1,:) 0]
Ba  = [B                ;   0]

comment('Calculo Del Del Controlador Por LQR')
Q           = diag([.1 1 10 10000 1])
R           = 10000
[Ka, SR, P] = lqr(Aa, Ba, Q, R)

% ====================================================================================================================
% comment('Observador Midiendo (theta, omega) Y Controlando va: 2 Entradas, 2 Salidas')
% Ad  = A'
% Bd  = C'
% Cd  = B(:,1)'

% comment('Verificar Observabilidad: rank(P) == n')
% P   = obsv(A, C)
% assert(rank(P) == 3)

% comment('Calculo Del Observador Por LQR')
% Qo              = diag([1 1 1])
% Ro              = eye(2)
% [Kod, SR, P]    = lqr(Ad, Bd, Qo, Ro)
% Ko              = Kod';
% % eig(A - Ko*C)

comment('Simulacion')
% parametros de tiempo
pp              = eig(Aa - Ba*Ka)(:)';
[t_step, t_max] = get_time_params(pp)
% ! sobre 3 a 30 veces
t_step  /= 10
t_max   *= 2

% force_amp   = 0;
% force_t0    = 100E-3;
% force_t1    = 101E-3;

% parametros de la referencia
r_amp   = 10;
% r_t0    = va_t0;
% r_t1    = 2;

disp('');
if strcmpi(input('Press "x" to cancel: ', 's'), 'x')
    return;
end

t       = 0:t_step:t_max;
% force   = force_amp*( heaviside(t' - force_t0) - heaviside(t' - force_t1));
% in      = force;

r   = r_amp*heaviside(t);
Kc  = Ka(1:4);
KI  = -Ka(5);

% x0  = [0 ; 0 ; pi ; 0];
% xo0 = [.1 ; 0 ; 2];
delta0  = [0 0 0];
Phi0    = [pi 0 0];

[y, x, u, err]  = diff_equation_model(delta0, Phi0, Kc, KI, r, t);
% [y, x, u, err, y_o, x_o, err_o] = sys_model(A, B, C, D, Kc, KI, Ko, r, in, t, x0, xo0);
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
plot(t, x(:,3), 'r', 'LineWidth', 2); title('State Var x_3 == Phi(t)'); ylabel('x_3 [rad]'); grid;
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
plot(t, y(:,2), 'LineWidth', 2);  title('Output y_2 : Phi(t)'); ylabel('y_2 [rad]'); grid
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