% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% ERRORES EN ESTADO ESTABLE Y CONSTANTES DE ERROR
% ==========================================================================

% variables
s = tf('s');

% ! Definicion de las entradas usadas
% ! ==========================================================================
% ! 1 u(t)          --> ess_p
% ! t u(t)          --> ess_v
% ! 1/2 t^2 u(t)    --> ess_a

disp('==========================================================================')
disp('G1')
disp('==========================================================================')

G1  = 50/((1+.5*s)*(1+2*s))
kp  = dcgain(G1)
kv  = dcgain(minreal(s*G1))
ka  = dcgain(minreal(s^2*G1))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G2')
disp('==========================================================================')

G2  = 2/(s*(1+.1*s)*(1+.5*s))
kp  = dcgain(G2)
kv  = dcgain(minreal(s*G2))
ka  = dcgain(minreal(s^2*G2))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G3')
disp('==========================================================================')

G3  = 1/(s*(s^2+4*s+200))
kp  = dcgain(G3)
kv  = dcgain(minreal(s*G3))
ka  = dcgain(minreal(s^2*G3))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G4')
disp('==========================================================================')

G4  = (30*(1+2*s)*(1+4*s))/(s*(s^2+2*s+10))
kp  = dcgain(G4)
kv  = dcgain(minreal(s*G4))
ka  = dcgain(minreal(s^2*G4))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G5')
disp('==========================================================================')

G5  = 10*(1 + s)/(s*(s + 4)*(4*s^2 + 6*s + 1))
kp  = dcgain(G5)
kv  = dcgain(minreal(s*G5))
ka  = dcgain(minreal(s^2*G5))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G6')
disp('==========================================================================')
syms s k real

G6  = k/((1+s)*(1+10*s)*(1+20*s))
kp  = limit(G6, s, 0)
kv  = limit(s*G6, s, 0)
ka  = limit(s^2*G6, s, 0)

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G7')
disp('==========================================================================')
s = tf('s');

G7  = 10*(1 + s)/(s^2*(s + 5)*(s + 6))
kp  = dcgain(G7)
kv  = dcgain(minreal(s*G7))
ka  = dcgain(minreal(s^2*G7))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G8')
disp('==========================================================================')

G8  = 10*(1 + s)/(s^3*(s^2 + 5*s + 5))
kp  = dcgain(G8)
kv  = dcgain(minreal(s*G8))
ka  = dcgain(minreal(s^2*G8))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G9')
disp('==========================================================================')
syms s real

G9  = 10*exp(-.2*s)/((1+s)*(1+10*s)*(1+20*s))
kp  = limit(G9, s, 0)
kv  = limit(s*G9, s, 0)
ka  = limit(s^2*G9, s, 0)

ess_p   = double(1/(1+kp))
ess_v   = double(1/kv)
ess_a   = double(1/ka)

disp('==========================================================================')
disp('G10')
disp('==========================================================================')
s = tf('s');

G10 = 100*(1 + s)/(s^2*(s + 5)*(s + 6)^2)
kp  = dcgain(G10)
kv  = dcgain(minreal(s*G10))
ka  = dcgain(minreal(s^2*G10))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G11')
disp('==========================================================================')

G11 = 1000/(s*(s + 10)*(s + 100))
kp  = dcgain(G11)
kv  = dcgain(minreal(s*G11))
ka  = dcgain(minreal(s^2*G11))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

disp('==========================================================================')
disp('G11')
disp('==========================================================================')

G11 = 3*s/(s^2*(s + 6))
kp  = dcgain(minreal(G11))
kv  = dcgain(minreal(s*G11))
ka  = dcgain(minreal(s^2*G11))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

FTS = {G1 G2 G3 G4 G5 G7 G8 G10 G11};
t   = linspace(0,100,1E3);

return

for i = 1:length(FTS) 
    figure;
    lsim(feedback(FTS{i},1), heaviside(t), t)
    input("ENTER PARA CONTINUAR >")
    % figure;
    lsim(feedback(FTS{i},1), t, t)
    input("ENTER PARA CONTINUAR >")
    % figure;
    lsim(feedback(FTS{i},1), 1/2*t.^2, t)
    
    input("ENTER PARA CONTINUAR >")
    close all;
endfor

disp('======================================================================')
disp('SUCCESS')
