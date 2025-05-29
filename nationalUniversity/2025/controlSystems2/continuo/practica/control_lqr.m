% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U] = sys_model(A, B, C, D, K, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    x   = x0;
    
    for k = 1:length(t)

        if mod(k, floor((length(t))/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t));
        endif

        u   = -K*x;

        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        X(k,:)  = x';
        Y(k,:)  = y';
        U(k,:)  = u';
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

comment('Verificar Controlabilidad: rank(M) == n')
M   = [B A*B]
rank(M)

comment('Calculo Del Control LQR Por Metodo lqr():')
Q   = diag([50 10])
R   = 100

[K, SR, P]  = lqr(A, B, Q, R)
eig(A - B*K)

comment('Simulacion')
[t_step, t_max] = get_time_params((eig(A - B*K)(:))');
t_step  /= 15
t_max   *= 3

t   = 0:t_step:t_max;
x0  = [10 ; 5];

[y, x, u]   = sys_model(A, B, C, D, K, t, x0);

figure;
subplot(4,1,1);
str = sprintf('State Var x_1 : Q11 == %0d', Q(1,1));
plot(t, x(:,1), 'r', 'LineWidth', 2); title(str); ylabel('x_1 []'); grid;
legend('x_1(t)');
subplot(4,1,2);
str = sprintf('State Var x_2 : Q22 == %0d', Q(2,2));
plot(t, x(:,2), 'r', 'LineWidth', 2); title(str); ylabel('x_2 []'); grid;
legend('x_2(t)');
subplot(4,1,3); 
str = sprintf('Control u_1 : R11 == %0d', R);
plot(t, u, 'LineWidth', 2); title(str); ylabel('u_1 []'); grid;
legend('u_1(t)');
subplot(4,1,4); 
plot(t, y(:,1), 'r', 'LineWidth', 2); title('Output y_1'); ylabel('y_1 []'); grid;
legend('y_1(t)');
xlabel('Time [s]'); 

comment("SUCCESS")
