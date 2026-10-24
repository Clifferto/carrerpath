% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic

% MASON
% ==========================================================================

% variables
syms G1 G2 G3 H1 H2 H3 s real

% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = G1*G2*G3

% numero de lazos = 3
% ganancias de los lazos
l1  = -G1*H1
l2  = -G2*H2
l3  = -G3*H3

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3) + (l1*(l2+l3) + l2*l3) - l1*l2*l3

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0

% FTLC = sum(Pi Di)/D
FTLC1 = (p1*D1)/D

% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = G1*G2*G3

% numero de lazos = 3
% ganancias de los lazos
l1  = -G1*H1
l2  = -G2*H2
l3  = -G3*H3

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3) + (l1*l3) - 0

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0

% FTLC = sum(Pi Di)/D
FTLC2 = (p1*D1)/D

FTLC1 == FTLC2

disp("======================================================================")
disp("SUCCESS");

return
