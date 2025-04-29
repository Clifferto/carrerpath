% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

disp('==========================================================================')
disp('IDENTIFICACION')
disp('==========================================================================')
s = tf('s');

G1  = 1.2/(.2*s+1)^2
G2  = 1.2/(.1*s+1)^2
G3  = 1.2/(.05*s-1)^2
G4  = 1.2/(.05*s+1)^2
G5  = 1.2/(.05*s+1)

figure
step(G1, tfinal=.5)
title('G1')
figure
step(G2, tfinal=.5)
title('G2')
figure
step(G3, tfinal=.5)
title('G3')
figure
step(G4, tfinal=.5)
title('G4')
figure
step(G5, tfinal=.5)
title('G5')

.98*1.2

return
disp('==========================================================================')
disp('SISTEMA1: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
s = tf('s');

td  = 0

yss = 1.2
yp  = 1.5
tp  = .03 - td

k       = yss
mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G1  = k*w^2/(s^2 + 2*psita*w*s + w^2)
step(G1, tfinal=.14)
title('Step Response')

return
disp('==========================================================================')
disp('MODELO MATEMATICO')
disp('(j/r^2 + m) d_pp  == -mg/l o')
disp('o                 == k/tau v e^(-t/tau)')
disp('==========================================================================')

% variables
syms j m tau r l k g D V O s real;
eq1 = (j/r^2 + m)*D*s^2 == -m*g/l*O
eq2 = O                 == k/tau*V

sol = solve(eq2, O)
sol = solve(subs(eq1, O, sol), D)
G   = collect(sol/V, s)

j=4E-6; m=.25; tau=2E-3; r=.03; l=.45; k=36; g=9.81;
eval(G)

return
disp('==========================================================================')
disp('ERROR')
disp('==========================================================================')

% variables
s   = tf('s');
C   = 42/s
G1  = 12/(s^2 + 257*s)
G2  = 78/(s + 78)

G   = minreal((G1+G2)*C)

disp('Dos Polos En Origen -> Tipo 2')
disp('ERROR DE VELOCIDAD: ess_v == 0')
disp('==========================================================================')




return
disp('==========================================================================')
disp('MASON')
disp('==========================================================================')

% variables
syms G1 G2 G3 G4 G5 G6 H2 H4 H6 s real;

% numero de lazos = 3
% ganancias de los lazos
l1  = -G2*H2
l2  = -G1*G2*G3*G4*H4
l3  = -G6*H6

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3) + (l1*l3) - 0

% Y/R
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 1*G1*G2*G3*G4*G5*1
p2  = 1*G1*G6*1*1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l3
D2  = 1 - 0

Y_vs_R  = factor((p1*D1 + p2*D2)/D)

% sospecho de a
[num,den] = numden(Y_vs_R);
factor(num,G1)
factor(den,(G6*H6+1))

return

% variables
s = tf('s');

disp('==========================================================================')
disp('1-MASON')
disp('==========================================================================')

G1=(51*s^2+714*s+2295)/(s^3+124*s^2+3360*s)

step(G1, tfinal=1)
title('Step Response')

disp('RTA: inf')
disp('==========================================================================')

% ==========================================================================
close all

disp('==========================================================================')
disp('Errores Y Constantes De Error: Posicion')
disp('==========================================================================')

k   = 1;
G1  = 443/(s + 211);
G2  = 384/(s + 80);
H1  = .07/(s + 2);

G3  = minreal(feedback(G1*G2,H1));
G   = minreal(k*G3)

kp  = dcgain(G)
kv  = dcgain(minreal(s*G))
ka  = dcgain(minreal(s^2*G))

ess_p   = 1/(1+kp)
ess_v   = 1/kv
ess_a   = 1/ka

Gf  = minreal(feedback(k*G3,1))
% step(Gf)
% title('Feedback Step Response')

disp('==========================================================================')
disp('Ganancia Estatica Para Cumplir ess_p == .01')
disp('==========================================================================')

syms s k real;

[num,den]   = tfdata(G,'vector');

G   = k*poly2sym(num, s)/poly2sym(den, s)
R   = 1/s
E   = R/(1+G)

eq1 = limit(simplify(s*E), s, 0) == .01

k  = double(solve(eq1, k))

% ==========================================================================
close all; clear all

disp('==========================================================================')
disp('Modelo:')
disp('u - C y           == A x + F x_p')
disp('E y_p - D x + B y == 0')
disp('==========================================================================')

syms A B C D E F Y X U s real;

eq1 = U - C*Y           == A*X + F*X*s
eq2 = E*Y*s - D*X + B*Y == 0

sol = solve(eq2,X)
sol = solve(subs(eq1,X,sol),Y)

disp('Funcion De Transferencia Del Modelo')
disp('==========================================================================')

G   = collect(sol/U, s)

disp('Funcion De Transferencia Del Sistema')
disp('==========================================================================')

A=60, B=3, C=70, D=70, E=64, F=4

[num,den]   = numden(eval(G));
num         = double(coeffs(num, s, 'all'));
den         = double(coeffs(den, s, 'all'));

G = tf(num,den)

disp('Polos')
disp('==========================================================================')

pole(G)

disp('Yss')
disp('==========================================================================')

u_amp   = 1

step(G)
yss = u_amp*dcgain(G)

% ==========================================================================
close all; clear all; clc;

disp('==========================================================================')
disp('MASON')
disp('==========================================================================')
syms s real;

% variables
G1  = 8
G2  = 1/s
G3  = (s+10)/(s+100)
G4  = 1/s
G5  = 4
G6  = 1 
G7  = 10 
G8  = 1/s
G9  = -1 
G10 = -2

% numero de lazos = 3
% ganancias de los lazos
l1  = G2*G9
l2  = G3*G4*G10
l3  = G6*G7*G8*G4*G10*G9

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3) + 0

% Y/R
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = G1*G2*G3*G4*G5
p2  = G1*G6*G7*G8*G4*G5

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y_vs_R    = factor((p1*D1 + p2*D2)/D, s)

% ! SOLUCION DEL PARCIAL

% s=tf('s');
% M1=8*1/s*(s+10)/(s+100)*1/s*4;
% M2=8*1*10*1/s*1/s*4;
% l1=-1/s;
% l2=-2*1/s*(s+10)/(s+100);
% l3=1*10*1/s*1/s*(-2)*(-1);
% D=1-(l1+l2+l3);
% D1=1;
% D2=1;
% G=minreal((M1*D1+M2*D2)/D)

disp('======================================================================')
disp('SUCCESS')
