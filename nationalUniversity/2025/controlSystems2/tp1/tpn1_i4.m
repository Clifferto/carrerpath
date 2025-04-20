% ====================================================================================================================
clear all; close all; clc;

% carga pkgs
pkg load control;
pkg load symbolic;
pkg load signal;

function comment(msg)
    disp('')
    disp(msg)
    disp('=======================================================================')
endfunction

% ====================================================================================================================

disp('')
disp('=======================================================================')
disp('MODELO CASO 2')
disp('=======================================================================')
disp('  ia_p    == -Ra/Laa ia - Km/Laa omega + 1/Laa va')
disp('  omega_p == Ki/JJ ia - Bm/JJ omega - 1/JJ TL')
disp('  theta_p == omega')
disp('=======================================================================')

% variables
syms ia ia_p va omega omega_p TL theta_p Ra Laa Km Ki Bm JJ real;

ia_p    = -Ra/Laa*ia - Km/Laa*omega + 1/Laa*va
omega_p = Ki/JJ*ia - Bm/JJ*omega - 1/JJ*TL
theta_p = omega

comment('Variables De Estado')
disp('x1 == ia  ->  x1_p == ia_p')
disp('x2 == theta  ->  x2_p == theta_p == x3 -> x3_p == theta_pp')
comment('Entradas / Salidas')
disp('u1 == va, u2 == TL, y1 == ia, y2 == theta, y3 == theta_p == omega')
x   = [ia theta theta_p];
xp  = [ia_p theta_p theta_pp];
u   = [va TL];
y   = [ia theta theta_p];

comment('Matrices De Estado')
global matA; matA   = jacobian(xp, x)
global matB; matB   = jacobian(xp, u)
global matC; matC   = jacobian(y, x)
global matD; matD   = jacobian(y, u)

return
comment('Parametros')
R   = 220
L   = 500E-3
C   = 2.2E-6

matA    = eval(matA);
matB    = eval(matB);
matC    = eval(matC);
matD    = eval(matD);

comment('Modelo En Espacio De Estados')
sys = ss(matA, matB, matC, matD)
damp(sys)

comment('Simulacion')
period  = 20E-3
amp     = 12
delay   = 10E-3
t       = linspace(0, period*10, 1000);
u       = amp * square((2*pi/period) * (t - delay));

% ! hacer u = 0 para t<delay
for n = 1:length(t) 
    if t(n) < delay
        u(n) = 0;
    end
end

[y, t, x] = lsim(sys, u, t);

hfig1 = figure(1); set(hfig1, 'windowstate', 'maximized');

subplot(4,1,1); 
plot(t, x(:,1), 'LineWidth', 2); title('State Var x_1 : i(t)');  ylabel('i(t) [A]'); grid;
subplot(4,1,2); 
plot(t, x(:,2), 'LineWidth', 2); title('State Var x_2 : vc(t)'); ylabel('vc(t) [V]'); grid;
subplot(4,1,3); 
plot(t, u, 'LineWidth', 2); title('Input u_1 : ve(t)'); ylabel('ve(t) [V]'); grid;
subplot(4,1,4); 
plot(t, y(:,1), 'LineWidth', 2); title('Output y_1 : vr(t)'); ylabel('vr(t) [A]'); grid;
xlabel('Time [s]');

disp("====================================================================================================================")
disp("SUCCESS");
