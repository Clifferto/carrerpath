% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic
pkg load control

% CIRCUITO RLC
% ==========================================================================

disp('==========================================================================')
disp('Modelo')
disp('==========================================================================')
disp('e     == (R1+XL1+XC1) i1 - XC1 i2')
disp('0     == (XC1+XL2+R2) i2 - XC1 i1')
disp('er    == R2 i2')
disp('')

% variables
syms R1 R2 L1 L2 C1 I1 I2 E s real
XL1 = s*L1
XL2 = s*L2
XC1 = 1/(s*C1)

eq1 = E == (R1+XL1+XC1)*I1 - XC1*I2
eq2 = 0 == (XC1+XL2+R2)*I2 - XC1*I1

sol = solve(eq1,eq2,I1,I2)

Er      = sol.I2*R2
Er_vs_E = collect(Er/E,s)

R1 = 100; R2 = 250; L1 = 100E-3; L2 = 100E-3; C1 = 1E-6;

[num,den]   = numden(eval(Er_vs_E))
num = double(coeffs(num,s,'all'))
den = double(coeffs(den,s,'all'))

Er_vs_E = tf(num,den)

step(Er_vs_E)

return

Tm  = ka*I
eq1 = eval(eq1)

Om  = solve(eq3,Om)
I   = solve(eval(eq2),I)
O   = solve(eval(eq1),O)

O_vs_V  = collect(simplify(O/V),s)

disp("======================================================================")
disp("SUCCESS");
