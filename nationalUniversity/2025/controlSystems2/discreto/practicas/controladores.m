% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control

addpath('../../lib');
mylib

% ====================================================================================================================
comment('Controladores Basicos:')
disp('   Proporcional   : (v) Menos Error                               |   (x) Aumenta Sobrepico, Disminuye Estabilidad')
disp('   Integral       : (v) Mejora ess                                |   (x) Aumenta Sobrepico, Disminuye Estabilidad')
disp('   Derivativa     : (v) Amortiguamiento, Sobrepico, Estabilidad   |   (x) No Afecta ess, Derivative-Kick')
disp('')
comment('Controladores Combinados')
disp('   PID, atrazo (curva LR hacia la derecha), adelanto (curva LR hacia la izquierda)')
disp('   Integral       : (v) Mejora ess                                |   (x) Aumenta Sobrepico, Disminuye Estabilidad')
disp('   Derivativa     : (v) Amortiguamiento, Sobrepico, Estabilidad   |   (x) No Afecta ess, Derivative-Kick')
disp('')

% ====================================================================================================================
comment('Control Por Lugar De Raices')
Hz  = 1
% especificaciones
psita   = .5
tss     = 2
Ts      = .2

G       = zpk([],[0 -2],[1])
Gz      = c2d(G, Ts, 'zoh')
FTLA    = Gz*Hz;

comment('Sub-Amortiguado, Comprobar Muestras Por Ciclo')
% tss = 4 / (psita*wn)
wn  = 4/(psita*tss);
wd  = wn*sqrt(1 - psita^2);
ws  = 2*pi/Ts;
m   = ws/wd

comment('No Cumple Con 10 Muestra/Ciclo, Pero Es Aceptable')

comment('Punto De Trabajo Necesario')
disp('z == e ** (-psita wn Ts +/- j wd Ts)')
disp('   |z|     == e ** (-psita wn Ts)')
disp('   fase(z) == wd Ts')
disp('')
zp  = exp(-psita*wn*Ts + j*wd*Ts)

rlocus(FTLA); hold
plot(real(zp), imag(zp), 'or');

comment('No Es Posible Controlador Proporcional, Se Elige En Adelanto, Cero Cancela Polo Dominante')
disp('  Cad   == kc (z + a)/(z + b)')
disp('')
poles   = pole(FTLA)
a       = poles(2);

comment('Condicion De Angulo: theta_z - theta_p + theta_c == k*180°')
comment('Por Trig Se Halla: theta_z - theta_p = -121°   ->  theta_c = 59°   ->  b = 0.26')
b   = .26
kc  = 1

Cad = zpk([a],[b],[kc], Ts) 

comment('Lugar De Raices Compensado')
FTLA = minreal(Cad*Gz*Hz)

figure;
rlocus(FTLA); hold
plot(real(zp), imag(zp), 'or');

comment('Condicion De Modulo: (|FTLA|)zp == 1')
% Transfer function 'ans' from input 'u1' to output ...
%       0.01758 z + 0.01539
%  y1:  -------------------
%       z^2 - 1.26 z + 0.26
[num, den]  = tfdata(FTLA, 'v')
kc  = 1/abs((num(2)*zp + num(3)) / (den(1)*zp^2 + den(2)*zp + den(3)))

comment('Controlador Adelanto Final')
Cad = zpk([a],[b],[kc], Ts) 

FTLA

close all; clc;

% ====================================================================================================================
comment('Control Por Lugar De Raices')
G   = zpk([],[-1 -10],[10])
H   = 1

comment('Especificaciones:')
psita   = .5
tp      = 2
m       = 16

comment('Sub-Amortiguado, Cumplir Muestras Por Ciclo:')
% ! tp  == pi/wd
wd  = pi/tp;
ws  = m*wd;
Ts  = 2*pi/ws

comment('Cumple m >= 16 Con:')
Ts  /= 2

Gz      = c2d(G, Ts, 'zoh')
Hz      = 1
FTLA    = Gz*Hz;
FTLC    = feedback(Gz, Hz);    

figure;
step(FTLC)

comment('Punto De Trabajo Necesario')
disp('z == e ** (-psita wn Ts +/- j wd Ts)')
disp('   |z|     == e ** (-psita wn Ts)')
disp('   fase(z) == wd Ts')
disp('')
wn  = wd/(sqrt(1 - psita^2));
zp  = exp(-psita*wn*Ts + j*wd*Ts)

figure;
rlocus(FTLA); hold
plot(real(zp), imag(zp), 'or'); zgrid;

comment('No Es Posible Controlador Proporcional, Se Elige PID, Un Cero Cancela Polo No Dominante')
disp('  Cpid    == kc [(z - a) (z - b)]/[z (z - 1)]')
disp('')
poles   = pole(FTLA)
a       = min(poles);

comment('Condicion De Angulo: theta_z - theta_p + theta_c == k*180°')
comment('Por Trig Se Halla: theta_z - theta_p = -220°   ->  theta_c = 40°   ->  b = 0.68')
b   = .68
kc  = 1

Cpid    = zpk([a b],[0 1],[kc], Ts) 

comment('Lugar De Raices Compensado')
FTLA = minreal(Cpid*Gz*Hz)

figure;
rlocus(FTLA); hold
plot(real(zp), imag(zp), 'or'); zgrid;

comment('Condicion De Modulo: (|FTLA|)zp == 1')
% Transfer function 'FTLA' from input 'u1' to output ...
%       0.05128 z^2 - 0.002315 z - 0.02214
%  y1:  ----------------------------------
%           z^3 - 1.882 z^2 + 0.8825 z
[num, den]  = tfdata(FTLA, 'v')
kc  = 1/abs((num(2)*zp + num(3)*zp + num(4)*zp) / (den(1)*zp^3 + den(2)*zp^2 + den(3)*zp))

comment('Controlador PID Final')
Cpid    = zpk([a b],[0 1],[kc], Ts)
FTLA    = minreal(Cpid*Gz*Hz)
FTLC    = feedback(minreal(Cpid*Gz), Hz)

step(FTLC)

close all; clc;

% ====================================================================================================================
pkg load symbolic;

comment('Control Por Disenio Analitico')
syms z kp kd a k real;
Gz  = z/((z - 1)*(z - 1/2))
Hz  = 1

comment('Especificaciones:')
% ! criticamente amortiguado, polo doble
ess = 0
p   = 1/4

comment('Ya Tiene Accion Integral, Se Elige PD:')
disp('  PD  == kp + kd (z - 1)/z                == (kd z + kp z - kd)/z == ((kd + kp) z - kd)/z')
disp('      == (kd + kp) (z - kd/(kd + kp))/z   == [k] (z + [a])/z')
disp('      * k == (kd + kp)')
disp('      * a == - kd/(kd + kp) == - kd/k')
disp('')
PD          = k*(z + a)/z
FTLC        = simplify(PD*Gz/(1 + PD*Gz*Hz))
[num, den]  = numden(FTLC);

comment('Plantear Ec Caracteristica Deseada:')
ECC = expand((z - 1/4)^2)
% ECC = (sym)
%    2   z   1
%   z  - ─ + ──
%        2   16

comment('Igualar Ec Caracteristica A Lazo Cerrado Con La Deseada:')
den = expand(den)
% den = (sym)
%                    2
%   2⋅a⋅k + 2⋅k⋅z + 2⋅z  - 3⋅z + 1

eq1 = collect(den/2 - ECC, z)   == 0
% eq1 = (sym) a⋅k + z⋅(k - 1) + 7/16 = 0

eq2 = a*k + 7/16    == 0
eq3 = k - 1         == 0
sol = solve(eq2, eq3, k, a);

kd  = -sol.a*sol.k
kp  = sol.k - kd
PD  = kp + kd*(z - 1)/z
% >> simplify(PD)
% ans = (sym)
%   z - 7/16
%   ────────
%      z

comment('Sistema Original')
Gz      = zpk([0], [1 1/2], [1], .1)
Hz      = 1
FTLA    = minreal(Gz*Hz);
FTLC    = feedback(Gz, Hz)

figure;
rlocus(FTLA); zgrid
figure;
step(FTLC); hold;

comment('Sistema Compensado')
PD      = zpk([7/16], [0], [1], .1)
FTLA    = minreal(PD*Gz*Hz);
FTLC    = feedback(PD*Gz, Hz)

step(FTLC);
figure;
rlocus(FTLA); zgrid

step(FTLC)

comment("SUCCESS")
