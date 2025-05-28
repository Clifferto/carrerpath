% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U, err] = sys_model(A, B, C, D, Ka, r, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    x   = x0;
    X   = x0';
    
    % [K, KI] = [num2cell(Ka){1:2}, num2cell(Ka){3}]

    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif

        % psi_p   = r - C*x;
        % psi     = psi + psi_p*h;
        u   = -Ka*x;

        xp  = A*x   + B*u   + [0 ; 0 ; 1]*r;
        x   = x     + xp*h;
        y   = C*x(1:2)   + D*u;

        err(k+1,:)  = xp(3);
        U(k+1,:)    = u;
        X(k+1,:)    = x;
        Y(k+1,:)    = y;
    endfor

endfunction

function [Y, X, U, err] = diff_eq(Ka, r, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    
    [y, y_p]    = num2cell(x0'){1:2};
    Psi         = 0;
    
    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif

        % ! A, B, C, D con x == (y1, y1p)  --> Y1/U1 == 10/(s^2 + s)   --> y1pp == - y1p + 10 u1  
        x       = [y ; y_p];
        Psi_p   = r - y;
        Psi     = Psi + Psi_p*h;
        u       = -Ka(1:2)*x + Ka(end)*Psi;

        y_pp    = -y_p + 10*u;
        y_p     = y_p + y_pp*h;
        y       = y + y_p*h;

        err(k+1,:)  = Psi_p;
        U(k+1,:)    = u;
        X(k+1,:)    = x;
        Y(k+1,:)    = y;
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

comment('Agregar Integrador Del Error, Sistema Ampliado:')
% ! Aa  =   [A  0]
% !         [-C 0]
% ! Ba  =   [B]
% !         [0]
% ! Ka  =   [K  -KI]
% ! xa  =   [x  psi] Donde: psi_p == r - y
Aa  = [ A   zeros(2,1)  ;
        -C  0           ]
Ba  = [ B   ;
        0   ]

comment('Por Metodo Acker, Polo Adicional Mas Alejado De Los Dominantes:')
Ka  = acker(Aa, Ba, [-2+2*j -2-2*j -20])
eig(Aa - Ba*Ka)

comment('Simulacion')
[t_step, t_max] = get_time_params(eig(Aa - Ba*Ka));
t_step  = -1/real(min(eig(Aa - Ba*Ka)))
t_step  /= 30
t_max   *= 5

r   = 10
t   = 0:t_step:t_max;
in  = r*heaviside(t);
x0  = [0 ; 0 ; 1];

% [y, x, u, err]  = diff_eq(Ka, r, t, x0);
[y, x, u, err]  = sys_model(Aa, Ba, C, D, Ka, r, t, x0);

figure;
subplot(5,1,1);
plot(t, x(:,1), 'r', 'LineWidth', 2);
title('State Var x_1'); ylabel('x_1 []'); grid;
legend('x_1(t)');
subplot(5,1,2);
plot(t, x(:,2), 'r', 'LineWidth', 2);
title('State Var x_2'); ylabel('x_2 []'); grid;
legend('x_2(t)');
subplot(5,1,3);
plot(t, err(:,1), 'r', 'LineWidth', 2);
title('Error Psi_p: r - y1'); ylabel('err []'); grid;
legend('err(t)');
subplot(5,1,4); 
plot(t, u(:,1), 'LineWidth', 2);
title('Control u_1'); ylabel('u_1 []'); grid;
legend('u_1(t)');
subplot(5,1,5); 
plot(t, y(:,1), 'LineWidth', 2);
title('Output y_1'); ylabel('y_1 []'); grid;
legend('y_1(t)');
xlabel('Time [s]'); 

comment("SUCCESS")
