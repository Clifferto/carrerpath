% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U, Yo, Xo, Eo] = sys_model(A, B, C, D, K, Ko, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    x   = x0;
    x_o = [0 ; 0];
    
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        u   = -K*x_o;

        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        err_o   = y - C*x_o;
        xp_o    = A*x_o + B*u + Ko*err_o;
        x_o     = x_o   + xp_o*h;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
        Yo(k,:) = (C*x_o)';
        Xo(k,:) = x_o';
        Eo(k,:) = err_o;
    endfor

endfunction

% ====================================================================================================================
comment('Modelo En Espacio De Estados')
A   = [ 0   1   ;
        0   -1  ]

B   = [ 0   ;
        10  ]

C   = [ 1   0]
D   = [ 0]

comment('Polos Deseados A Lazo Cerrado: -2 +/- 2j, Ec Caracteristicas lazo Abierto/Cerrado:')
a_k     = poly(eig(A))
% a_k =
%    1   1   0
alpha_k = poly([-2+2*j -2-2*j])
% alpha_k =
%    1   4   8

K   = acker(A, B, [-2+2*j -2-2*j])
eig(A - B*K)

comment('Verificar Observabilidad: rank(P) == n')
P   = [ C   ;
        C*A ]
rank(P)

comment('Calculo Del Observador Con Polos En -3 +/- 3j, Sistema Dual:')
Ad  = A'
Bd  = C'
Cd  = B'

% ! autovalores invariantes ante transposicion
a_kd        = poly(eig(Ad))
% a_kd =
%    1   1   0
alpha_kd    = poly([-3+3*j -3-3*j])
% alpha_kd =
%    1    6   18

comment('Por Transformacion De La Matriz De Controlabilidad Dual:')
% ! Ko  == [(alpha2d - a2d), (alpha1d - a1d)] inv(Td)
% ! Td  == Md W
% ! Wd  ==  [a1d 1] == [a1 1]
% !         [1   0]    [1  0]
Md  = [Bd Ad*Bd]
Wd  = [ 1   1   ;
        1   0   ]
Td  = Md*Wd

Ko  = [18-0 6-1]*inv(Td);
Ko  = Ko'
eig(A - Ko*C)

comment('Por Formula De Ackermann:')
% ! Ko  == [0 1] inv(Md) fi(Ad)
fi_Ad   = Ad^2 + 6*Ad + 18*eye(2)
Ko      = [0 1]*inv(Md)*fi_Ad;
Ko      = Ko'
eig(A - Ko*C)

comment('Por Metodo Acker:')
Ko  = acker(Ad, Bd, [-3+3*j -3-3*j])
Ko  = Ko'
eig(A - Ko*C)

comment('Simulacion')
% array con todos los polos del sistema + observador agrupados
pp              = [eig(A - B*K) eig(A - Ko*C)](:)';
[t_step, t_max] = get_time_params(pp);
t_step  /= 30
t_max   *= 3

t   = 0:t_step:t_max;
% in  = heaviside(t);
x0  = [1 ; 1];

[y, x, u, yo, xo, err_o]    = sys_model(A, B, C, D, K, Ko, t, x0);

figure;
subplot(5,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2); hold
plot(t, xo(:,1), '-.', 'LineWidth', 2); title('State Var x_1: Observer Vs Real'); ylabel('x_1 []'); grid;
legend('real', 'observer');
subplot(5,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2); hold
plot(t, xo(:,2), '-.', 'LineWidth', 2); title('State Var x_2: Observer Vs Real'); ylabel('x_2 []'); grid;
legend('real', 'observer');
subplot(5,1,3); 
plot(t, u, 'LineWidth', 2); title('Control u_1'); ylabel('u_1 []'); grid;
legend('u_1(t)');
subplot(5,1,4); 
plot(t, y(:,1), 'r', 'LineWidth', 2); hold
plot(t, yo(:,1), '-.', 'LineWidth', 2); title('Output y_1: Observer Vs Real'); ylabel('y_1 []'); grid;
legend('real', 'observer');
subplot(5,1,5); 
plot(t, err_o(:,1), 'LineWidth', 2); title('Observer-Error err_o'); ylabel('err_o []'); grid;
legend('err_o(t)');
xlabel('Time [s]'); 

comment("SUCCESS")
