% ==========================================================================
clear all; close all; clc;

%Carga de paquete utilizado
pkg load symbolic

% variables
syms s t a w real

% Resolucion diferentes funciones
G1 = laplace(dirac(t))
G2 = laplace(heaviside(t))
% x(t) * exp(+/- at)    --> X(s -/+ a) [invierte]
G3 = laplace(exp(-2*t))
G4 = laplace(7*exp(-5*t))
G5 = laplace(heaviside(t) + exp(-2*t))
% t * x(t)  --> - dX/ds
G6 = factor(simplify(laplace(t*sin(2*t) + 3*exp(-10*t))),s)
% x(t +/- a)    --> X exp(+/- a)    [no invierte]
G7 = laplace(exp(-5*(t-2))*heaviside(t-2))
G8 = laplace(exp(-a*t)*cos(w*t))

disp("======================================================================")
disp("SUCCESS");
