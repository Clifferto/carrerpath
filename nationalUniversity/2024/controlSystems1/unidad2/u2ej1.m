% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic

% SISTEMA 1
% ==========================================================================

% variables
syms s Vo Vi I1 C1 R1 real;
X1 = 1/(s*C1);

% modelo
% eq1: Vo == I1 X1
% eq2: Vi == [R1+X1]I1
eq1 = Vo == I1*X1
eq2 = Vi == (R1 + X1)*I1

S = solve(eq1,eq2,Vo,Vi,I1)

G1 = S.Vo/S.Vi

% ==========================================================================
clear all; close all; clc;

% SISTEMA 2
% ==========================================================================
% variables
syms s Vo Vi I1 I2 C1 C2 R1 R2 real;

X1  = 1/(s*C1);
X2  = 1/(s*C2);

% modelo
% eq1 : Vi  == I1(R1 + X1) - I2 X1
% eq2 : 0   == I2(R2 + X1 + X2) - I1 X1
% eq3 : Vo  == I2 X2
%
% con : I1 = corriente de malla R1,C1
%       I2 = corriente de malla C1,R2,C2
I2  = Vo/X2

eq1 = Vi  == I1*(R1 + X1) - I2*X1
eq2 = 0   == I2*(R2 + X1 + X2) - I1*X1

sol = solve(eq1,I1)
eq2 = subs(eq2,I1,sol)
sol = solve(eq2,Vo)

G2  = factor(sol/Vi,s)

% ==========================================================================
clear all; close all; clc;

% SISTEMA 3
% ==========================================================================
% variables
syms s Vo Vi I1 I2 C1 C2 R1 R2 real;

X1  = 1/(s*C1);
X2  = 1/(s*C2);

% modelo
% eq1 : Vo == V3 X2/(R2 + X2)
% eq2 : V3 == Vi X1/(R1 + X1)
V3  = Vi*X1/(R1 + X1)
Vo  = V3*X2/(R2 + X2)

G3 = expand(Vo/Vi)

% pero como existe el buffer, G2 no carga a G1. 
% Entonces:

G31 =1/(s*R1*C1 + 1);
G32 =1/(s*R2*C2 + 1);

G3 = expand(G31*G32)

disp("======================================================================")
disp("SUCCESS");
