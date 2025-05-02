% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load control
pkg load symbolic
pkg load io

addpath('../lib');
mylib

% ====================================================================================================================

comment('Parametros Estimados')
R   = 220.00
C   = 2.2032e-06
L   = 6.6224e-04

comment('Modelo En Espacio De Estados')

% Matrices De Estado
% =======================================================================
% matA = (sym 2×2 matrix)

%   ⎡-R   -1 ⎤
%   ⎢───  ───⎥
%   ⎢ L    L ⎥
%   ⎢        ⎥
%   ⎢ 1      ⎥
%   ⎢ ─    0 ⎥
%   ⎣ C      ⎦

% matB = (sym 2×1 matrix)

%   ⎡1⎤
%   ⎢─⎥
%   ⎢L⎥
%   ⎢ ⎥
%   ⎣0⎦

% matC = (sym) [R  0]  (1×2 matrix)
% matD = (sym) 0

matA    = [-R/L -1/L ; 1/C 0];
matB    = [1/L ; 0];
matC    = [R 0];
matD    = [0];

sys = ss(matA, matB, matC, matD)

comment('Simular Y Comparar Data')
% ! xlsread tiene problemas en linux, cargo/guardo datos en txt
% ! ssconvert Curvas_Medidas_RLC_2025.xls Curvas_Medidas_RLC_2025.txt
% "Tiempo [Seg.]","Corriente [A]","Tensión en el capacitor [V]","Tensión de entrada [V]","Tensión de salida [V]"
data    = load('Curvas_Medidas_RLC_2025.txt');
t       = data(:,1);
u       = data(:,4);
ii      = data(:,2);

[y t x] = lsim(sys, u, t);

figure; hold;
plot(t, ii, 'b');
plot(t, x(:,1), 'r');
title('Data Current Vs Estimated Model: i(t)'); ylabel('i(t) [A]'); grid;
legend('data', 'estimated');
xlabel('Time [s]'); 

comment("SUCCESS")
