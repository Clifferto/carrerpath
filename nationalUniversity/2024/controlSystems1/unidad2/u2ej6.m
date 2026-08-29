% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic

% MASON
% ==========================================================================

% variables
syms G1 H1 s real

% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 1*G1*1

% numero de lazos = 1
% ganancias de los lazos
l1  = -G1*H1

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - l1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0

% FTLC = sum(Pi Di)/D
FTLC1 = (p1*D1)/D

% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 1*G1*1

% numero de lazos = 1
% ganancias de los lazos
l1  = -G1*H1

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - l1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0

% FTLC = sum(Pi Di)/D
FTLC2 = (p1*D1)/D

FTLC1 == FTLC2

disp("======================================================================")
disp("SUCCESS");

return
