% ==========================================================================
clear all; close all; clc;

%Carga del paquete utilizado
pkg load symbolic

% variables
syms s t a w real
assume w positive

%Resolucion diferentes funciones
g1  = ilaplace(2/(s + 3))
g2  = ilaplace(1/(s*(s + 2)*(s + 3)))
partfrac(1/(s*(s + 2)*(s + 3)))

g3  = ilaplace((6*s + 8)/(s*(s + 1)*(s + 2)))
partfrac((6*s + 8)/(s*(s + 1)*(s + 2)))

g4  = ilaplace((10*s)/(s^3 + 6*s^2 + 11*s + 6))
partfrac((10*s)/(s^3 + 6*s^2 + 11*s + 6))

g5  = ilaplace(10/(((s + 1)^2)*(s + 3)))
partfrac(10/(((s + 1)^2)*(s + 3)))

g6  = ilaplace(w/(((s + a)^2) + w^2))
g7  = ilaplace(9/(2*s^2 + 4*s + 4))

g8  = ilaplace((2*s + 12)/(s^2 + 2*s + 5))
% (s - (-1+2j)) (s - (-1-2j))       == (s + 1 - 2j)) (s + 1 + 2j)
% ((s + 1) - 2j)) ((s + 1) + 2j)    == (s + 1)^2 + (2)^2
s^2 + 2*s + 5 == (s + 1)^2 + (2)^2

g9  = ilaplace(2/(s^2 + 4) * exp(-5*s))
g10 = ilaplace(100 / (s*(s^2 + 4)))

g11 = expand(ilaplace(100*(s + 2)*exp(-s)/(s*(s^2 + 4)*(s + 1))))
expand(partfrac(100*(s + 2)/(s*(s^2 + 4)*(s + 1))))

disp("======================================================================")
disp("SUCCESS");
