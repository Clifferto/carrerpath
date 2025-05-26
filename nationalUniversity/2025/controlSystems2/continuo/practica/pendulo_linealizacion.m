% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic

addpath('../../lib');
mylib

function [Y, X, U] = sys_model(A, B, C, D, in, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    X   = x0;
    x   = x0;

    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif

        u   = in(k);
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

function [Y, X, U] = not_lineal(params, in, t, x0)
    % paso igual a la resolucion temporal
    h   = t(2) - t(1)
    
    [delta, delta_p, Phi, Phi_p]    = num2cell(x0){:};
    X                               = x0;

    % ! Derivadas De Mayor Orden Del Sistema No Lineal
    % ! =======================================================================
    % ! delta_pp = (sym)
    % !           2             g⋅m⋅sin(2⋅Φ)
    % ! -F⋅δₚ + L⋅Φₚ ⋅m⋅sin(Φ) - ──────────── + u
    % !                             2
    % ! ─────────────────────────────────────────
    % !                      2
    % !              M + m⋅sin (Φ)
    % ! 
    % ! Phi_pp = (sym)
    % !                  2
    % !               L⋅Φₚ ⋅m⋅sin(2⋅Φ)
    % ! F⋅δₚ⋅cos(Φ) - ──────────────── + M⋅g⋅sin(Φ) + g⋅m⋅sin(Φ) - u⋅cos(Φ)
    % !                     2
    % ! ───────────────────────────────────────────────────────────────────
    % !                          ⎛         2   ⎞
    % !                         L⋅⎝M + m⋅sin (Φ)⎠
    [m, F, L, g, M] = num2cell(params){:}

    for k = 1:length(t)-1

        if mod(k, floor((length(t)-1)/10)) == 0
            printf('running iteration: %d / %d ...\n', k, length(t)-1);
        endif
        
        u           = in(k);
        delta_pp    = ( -F*delta_p + L*Phi_p^2*m*sin(Phi) - g*m*sin(2*Phi)/2 + u ) / ( M + m*(sin(Phi))^2 );
        Phi_pp      = ( F*delta_p*cos(Phi) - (L*Phi_p^2*m*sin(2*Phi))/2 + M*g*sin(Phi) + g*m*sin(Phi) - u*cos(Phi) ) / ( L*(M + m*(sin(Phi))^2) );

        delta_p = delta_p   + delta_pp*h;
        delta   = delta     + delta_p*h;
        Phi_p   = Phi_p     + Phi_pp*h;
        Phi     = Phi       + Phi_p*h;

        U(k+1,:)    = u;
        X(k+1,:)    = [delta delta_p Phi Phi_p];
        Y(k+1,:)    = [delta Phi];
    endfor

endfunction

% ====================================================================================================================
comment('MODELO PENDULO')
disp('  (M + m) delta_pp + m L Phi_pp cos(Phi) - m L Phi_p^2 sin(Phi) + F delta_p == u')
disp('  L Phi_pp - g sin(Phi) + delta_pp cos(Phi)                                 == 0')
disp('')
syms Phi Phi_p Phi_pp delta delta_p delta_pp M m u L F g;

eq1 = (M + m)*delta_pp + m*L*Phi_pp*cos(Phi) - m*L*Phi_p^2*sin(Phi) + F*delta_p == u
eq2 = L*Phi_pp - g*sin(Phi) + delta_pp*cos(Phi)                                 == 0

comment('Derivadas De Mayor Orden Del Sistema No Lineal')
sol = solve(eq1, eq2, delta_pp, Phi_pp);
expand(sol.delta_pp)
expand(sol.Phi_pp)

% ====================================================================================================================
comment('Para Equilibrio Inestable [Phi = 0, delta = 0], Simplificaciones [cos(Phi) ~ 1, sin(Phi) ~ Phi]')
eq1_ei  = subs(eq1, [cos(Phi) sin(Phi)], [1 Phi])
eq2_ei  = subs(eq2, [cos(Phi) sin(Phi)], [1 Phi])

comment('Linealizacion Derivadas De Mayor Orden, Entorno Al Equilibrio Inestable')
sol = solve(eq1_ei, eq2_ei, delta_pp, Phi_pp);

% ! el order es EXCLUYENTE, order = 2 es expansion lineal
delta_pp_lin    = collect(expand(taylor(sol.delta_pp, [delta delta_p Phi Phi_p], [0 0 0 0], 'order', 2)), [delta delta_p Phi Phi_p, u])
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
A   = simplify(jacobian(xp, x))
B   = simplify(jacobian(xp, u))
C   = simplify(jacobian(y, x))
D   = simplify(jacobian(y, u))

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
