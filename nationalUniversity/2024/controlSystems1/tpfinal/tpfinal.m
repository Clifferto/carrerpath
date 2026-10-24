% ====================================================================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% ====================================================================================================================
disp('')
disp('=======================================================================')
disp('MODELO MATEMATICO')
disp('=======================================================================')
disp('Sensor Con Pwm:')
disp('  V       == ko oi')
disp('Motor DC:')
disp('  V       == im R + im_p L + Vm')
disp('  Tm      == b om_p + Jm om_pp + T1')
disp('  Vm      == kw om_p')
disp('  Tm      == ki im')
disp('Caja Reductora:')
disp('  T2      == r T1')
disp('  o2_p    == om_p/r')
disp('Carga:')
disp('  T2      == J2 o2_pp')
disp('=======================================================================')

% sensor con pwm
% V     == ko oi
% motor DC
% V     == im R + im_p L + Vm
% Tm    == b om_p + Jm om_pp + T1
% Vm    == kw om_p
% Tm    == ki im
% caja reductora
% T2    == r T1
% o2_p  == om_p/r
% carga
% T2    == J2 o2_pp

% variables
syms Oi Om O2 ko kw ki r Im R L b Jm J2 T1 s real;

% sensor con pwm
V   = ko*Oi;
% contantes del motor
Vm  = kw*Om*s;
Tm  = ki*Im;
% caja reductora
T2  = r*T1;
O2  = Om/r;

eq1 = V     == R*Im + L*Im*s + Vm;
eq2 = Tm    == b*Om*s + Jm*Om*s^2 + T1;
eq3 = T2    == J2*O2*s^2;

eq2 = subs(eq2, T1, solve(eq3, T1));
eq1 = subs(eq1, Im, solve(eq2, Im));
O2  = simplify(solve(eq1, Om)/r);

O2_vs_Oi    = collect(simplify(O2/Oi), s)

% O2_vs_Oi = (sym)
%                                ki⋅ko⋅r
%   ──────────────────────────────────────────────────────────────────
%     ⎛    2         2    2⎛            2⎞     ⎛           2       2⎞⎞
%   s⋅⎝R⋅b⋅r  + ki⋅kw⋅r  + s ⋅⎝J₂⋅L + Jm⋅L⋅r ⎠ + s⋅⎝J₂⋅R + Jm⋅R⋅r  + L⋅b⋅r ⎠⎠

% ====================================================================================================================
clear all; close all;

disp('')
disp('=======================================================================')
disp('PLANTA')
disp('=======================================================================')
s   = tf('s');
ki  = 30.82E-3                  % [N/A]
ko  = 24/(pi/6)                 % [V/rad] (con un angulo de incidencia de 30*, se tiene una tension media de salida de 24V)
kw  = 3.226E-3/(2*pi/60)        % [V/(rad/s)]
r   = 4                         % []
R   = 26.9                      % [ohm]
L   = 600E-6                    % [H]
b   = .29E-3/(7200*(2*pi/60))   % [Nm/(rad/s)]
Jm  = 1.5/(1E3*100*100)         % [Kg m^2]

# disco dentado de pla: h=1.5cm, rad=5cm, densidad=1.32gr/cm3
% J == 1/2 (m r^2)
J2  = (1/2)*(1.32*pi*5^2*1.5)*5^2;  % [gr cm^2]
J2  = J2/(1E3*100*100)              % [Kg m^2]

O2_vs_Oi    = ki*ko*r/(s*(R*b*r^2 + ki*kw*r^2 + s^2*(J2*L + Jm*L*r^2) + s*(J2*R + Jm*R*r^2 + L*b*r^2)));
O2_vs_Oi    = minreal(O2_vs_Oi)

pole(O2_vs_Oi)

% ====================================================================================================================
disp('')
disp('=======================================================================')
disp('CARACTERIZACION DEL SISTEMA')
disp('=======================================================================')

% angulo de incidencia constante de 15*
amp = pi/12;
% realimentacion unitaria
H   = 1;
t   = linspace(0, 5, 5000);

figure;
lsim(O2_vs_Oi*H, amp*heaviside(t), t)
title('Open-Loop Step Response')
xlabel('time[sec]'); ylabel('output angle[rad]');

figure;
lsim(feedback(O2_vs_Oi, H), amp*heaviside(t), t)
line([0 5], [amp*1.02 amp*1.02])
line([0 5], [amp*.98 amp*.98])
title('Closed-Loop Step Response')
xlabel('time[sec]'); ylabel('output angle[rad]');

figure;
lsim(feedback(O2_vs_Oi, H), amp*t, t)
title('Closed-Loop Ramp Response')
xlabel('time[sec]'); ylabel('output angle[rad]');

figure;
lsim(feedback(O2_vs_Oi, H), amp*(1/2*t.^2), t)
title('Closed-Loop Parabolic Response')
xlabel('time[sec]'); ylabel('output angle[rad]');

% caracteristicas
tp  = .096
yp  = .49
yss = amp
tss = 2.71
Mp  = (yp-yss)/yss

% figure;
% rlocusx(O2_vs_Oi, 10E3, 0, 5E6)
% figure;
% rlocusx(O2_vs_Oi, 1, 0, 1E3)

% ! limite de estabilidad complicado, sistema lento, sobrepico alto
% ! sitema de TIPO I, polo dominante 2.9, sistema de 3er orden
% ! ERRORES / CONSTANTES, ANALISIS DE ESTABILIDAD

return
% ====================================================================================================================
close all;

disp('')
disp('=======================================================================')
disp('COMPENSADOR EN ADELANTO')
disp('=======================================================================')


disp('')
disp('Requerimientos')
disp('=======================================================================')
% REQUERIMIENTOS: tss AL MENOS 10 VECES MENOR, SIN SOBREPICO
psita   = 1
tss     = tss/10

% tss ~ 4/(psita w)
w   = 4/(psita*tss)

figure;
% rlocus(O2_vs_Oi*H)
rlocus(O2_vs_Oi*H, 1, 0, 1E3)
title('Root Locus Of System')
sgrid(psita, w)

disp('')
disp('Polo, Doble Del Punto De Trabajo')
disp('=======================================================================')
% polo, 2 veces el punto de desprendimiento
pc      = 2*14.76
zc      = 2.9012
kc      = 1
alpha   = zc/pc

CADEL   = kc*(s + zc)/(s + zc/alpha);

figure;
rlocus(minreal(CADEL*O2_vs_Oi*H))
% rlocus(minreal(CADEL*O2_vs_Oi*H), 1, 0, 1E3)
title('Root Locus Of Controlled System')
sgrid(psita, w)

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')
sp = -14.758

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
% minreal(CADEL*O2_vs_Oi*H)
% Transfer function 'ans' from input 'u1' to output ...
%                   4.786e+07
%  y1:  ---------------------------------
%       s^3 + 4.486e+04 s^2 + 1.323e+06 s
FTLAp   = 4.786e+07/(sp^3 + 4.486e+04*sp^2 + 1.323e+06*sp);
kc      = 1/(abs(FTLAp))

disp('')
disp('Controlador En Adelanto')
disp('=======================================================================')
CADEL   = kc*(s + zc)/(s + zc/alpha)

figure
lsim(feedback(CADEL*O2_vs_Oi, H), amp*heaviside(t), t)
line([0 5], [amp*1.02 amp*1.02])
line([0 5], [amp*.98 amp*.98])
line([.396 .396], [0 amp])
title('Response Of Controlled System')
xlabel('time[sec]'); ylabel('output angle[rad]');

% ====================================================================================================================
close all;

% ! mejoro sobrepico, pero no cumple tss, hay que alejar el polo dominante, variando alpha

disp('')
disp('=======================================================================')
disp('AJUSTE DEL COMPENSADOR')
disp('=======================================================================')
kc      = 1;
alpha   = 0.05
CADEL   = kc*(s + zc)/(s + zc/alpha);

rlocus(minreal(CADEL*O2_vs_Oi*H))

disp('')
disp('Por Inspeccion Del LR, Puntos De Trabajo (Polos Deseados)')
disp('=======================================================================')

sp = -28.8

disp('')
disp('Por Condicion De Modulo: | 1/k | == | (G*H)p |')
disp('=======================================================================')
minreal(CADEL*O2_vs_Oi*H);
% Transfer function 'ans' from input 'u1' to output ...
%                   4.786e+07
%  y1:  ---------------------------------
%       s^3 + 4.489e+04 s^2 + 2.601e+06 s
FTLAp   = 4.786e+07/(sp^3 + 4.486e+04*sp^2 + 2.601e+06*sp);
kc      = 1/(abs(FTLAp))

disp('')
disp('Controlador En Adelanto Final')
disp('=======================================================================')
CADEL   = kc*(s + zc)/(s + zc/alpha)

figure
lsim(feedback(CADEL*O2_vs_Oi, H), amp*heaviside(t), t)
line([0 5], [amp*1.02 amp*1.02])
line([0 5], [amp*.98 amp*.98])
line([.201 .201], [0 amp])
title('Response Of Controlled System')

% ? ==================================================================================================================
% ? tss = 200ms < 270ms y sin sobrepico, cumple las especificaciones
% ? ==================================================================================================================
figure
lsim(feedback(O2_vs_Oi, H), feedback(CADEL*O2_vs_Oi, H), amp*heaviside(t), t)
line([0 5], [amp*1.02 amp*1.02])
line([0 5], [amp*.98 amp*.98])
title('Closed-Loop Response Comparison')
xlabel('time[sec]'); ylabel('output angle[rad]');

disp("====================================================================================================================")
disp("SUCCESS");

return

% estoy escribiendo un informe de ingenieria donde se disenio un sistema de control para un seguidor de luz.
% formatea el siguiente texto, agrengando terminologia y descripciones para formar parte del informe:

syms zc alpha kc s real;

CADEL   = kc*((s+zc)/(s+zc/alpha))