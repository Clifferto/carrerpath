% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U] = sys_model(A, B, C, D, K, G, r, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    X   = x0;
    x   = x0;

    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif

        u   = -K*x + G*r;
        xp  = A*x   + B*u;
        x   = x     + xp*h;
        y   = C*x   + D*u;

        U(:,k+1)    = u;
        X(:,k+1)    = x;
        Y(:,k+1)    = y;
    endfor

    U   = U';
    X   = X';
    Y   = Y';
endfunction

% ====================================================================================================================
comment('Modelo En Espacio De Estados')
matA    = [ 0   1   ;
            0   -1  ];

matB    = [ 0   ;
            10  ];

matC    = [ 1   0];
matD    = [ 0];

comment('Polos Deseados A Lazo Cerrado: -2 +/- 2j, Ec Caracteristicas lazo Abierto/Cerrado:')
syms s real;
ec_la = expand(det(s*eye(2) - matA))
ec_lc = expand((s + 2+2*j)*(s + 2-2*j))
% ec_la = (sym)
%    2
%   s  + s

% ec_lc = (sym)
%    2
%   s  + 4⋅s + 8

M   = [matB matA*matB]

comment('Por Metodo Acker:')
K   = acker(matA, matB, [-2+2*j -2-2*j])

comment('Con Referencia No Nula, Prealimentacion G:')
% ! G   == - inv( C inv(A - BK) B )
r   = 5
G   = -inv(matC*inv(matA - matB*K)*matB)

comment('Simulacion')
[t_step, t_max] = get_time_params(pole(ss(matA, matB, matC, matD)));
t_step  /= 30
t_max   *= 2

t   = 0:t_step:t_max;
in  = heaviside(t);
x0  = [0 ; 0];

[y, x, u]   = sys_model(matA, matB, matC, matD, K, G, r, t, x0);

figure;
subplot(4,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2);
title('State Var x_1'); ylabel('x_1 []'); grid;
legend('x_1(t)');
subplot(4,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2);
title('State Var x_2'); ylabel('x_2 []'); grid;
legend('x_2(t)');
subplot(4,1,3); 
plot(t, u, 'LineWidth', 2);
title('Control u_1'); ylabel('u_1 []'); grid;
legend('u_1(t)');
subplot(4,1,4); 
plot(t, y(:,1), 'LineWidth', 2);
title('Output y_1'); ylabel('y_1 []'); grid;
legend('y_1(t)');
xlabel('Time [s]'); 

comment("SUCCESS")
