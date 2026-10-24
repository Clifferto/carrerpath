% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% SISTEMA 1
% ==========================================================================

% variables
s   = tf('s');
kp  = 31;
kd  = 16;
G1  = 53*(s+1)/( (s+10)*(s+100) )
G2  = 1/s

FLC1  = feedback(G1,kd)

FLA1  = kp*FLC1*G2
FLC2  = feedback(FLA1,1)

step(FLA1,FLC2,tfinal=10)

% ==========================================================================
clear all; close all; clc;

% SISTEMA 2
% ==========================================================================

% variables
s   = tf('s');
p   = 12;
PI  = (s+.1)/s
G1  = 27/(s+200)
G2  = 5/(s+.1)

FLC1 = feedback(p*G1,1)

FLA1 = PI*FLC1*G2
FLC2 = feedback(FLA1,1)

step(FLC2)

% ==========================================================================
clear all; close all; clc;

% SISTEMA 3
% ==========================================================================

% variables
syms kp Ti Td s wn psita real

G1 = (Ti*Td*s^2 + Ti*s + 1)/(Ti*s)
G2 = wn^2/(s^2 + 2*psita*wn*s + wn^2)

G3 = kp*G1*G2
FLC1 = G3/(1 + G3*1)

% ==========================================================================
clear all; close all; clc;

% SISTEMA 4
% ==========================================================================

% variables
syms kp ki kd Ti Td T K s real

PID = (1 + 1/(Ti*s) + Td*s)*kp
G1  = K/(T*s + 1)

FLC1 = PID*G1/(1 + PID*G1*1)

factor(FLC1)

disp("======================================================================")
disp("SUCCESS");

return
