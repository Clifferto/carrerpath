% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load symbolic

% variables
syms R L K J B s real

k0  = 1/L;
k1  = R/L;
k2  = B/J;
k3  = K/L;
k4  = K/J;

% ==========================================================================
% MOTOR CC
% ==========================================================================

% numero de lazos = 3
% ganancias de los lazos
l1  = -1/s*k1
l2  = -1/s*k2
l3  = -1/s*1/s*k3*k4

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3) + (l1*l2) - 0

% W/E, con TL = 0
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = k0*1/s*k4*1/s

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;

W_vs_E__TL0 = factor((p1*D1)/D, s)

return
% Y4/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = G1*G2
p2  = G4

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y4_vs_Y1    = (p1*D1 + p2*D2)/D  

% Y2/Y1
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l4;

Y2_vs_Y1    = (p1*D1)/D  

% ==========================================================================
close all; clc;

% ==========================================================================
% SISTEMA 2
% ==========================================================================

% numero de lazos = 4
% ganancias de los lazos
l1  = -G4*G3*H3;
l2  = -G1*H1;
l3  = -G1*G2*G3*H3;
l4  = -G3*H2;
l5  = -H4;

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3+l4+l5) + (l2*l4+l2*l5) - 0

% Y5/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = G1*G2*G3
p2  = G4*G3

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y5_vs_Y1    = (p1*D1 + p2*D2)/D  

% Y4/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = G1*G2;
p2  = G4;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l5;
D2  = 1 - l5;

Y4_vs_Y1    = factor((p1*D1 + p2*D2)/D)

% Y2/Y1
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - (l4+l5)

Y2_vs_Y1    = (p1*D1)/D  

% ==========================================================================
close all; clc;

% ==========================================================================
% SISTEMA 3
% ==========================================================================

% numero de lazos = 5
% ganancias de los lazos
l1  = -5*1/s;
l2  = -1/s*10*s;
l3  = -1/s*1/s;
l4  = -5;
l5  = 5*10*s*5;

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3+l4+l5) + 0

% Y5/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 10*1/s*1/s
p2  = 10*5

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y5_vs_Y1    = factor((p1*D1 + p2*D2)/D, s)

% Y4/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 10*1/s*1/s
p2  = 10*5

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y4_vs_Y1    = factor((p1*D1 + p2*D2)/D, s)

% Y2/Y1
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 10

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l2

Y2_vs_Y1    = factor((p1*D1)/D, s)

% ==========================================================================
close all; clc;

% ==========================================================================
% SISTEMA 4
% ==========================================================================

% numero de lazos = 5
% ganancias de los lazos
l1  = -1/s;
l2  = -1/s;
l3  = -1/s*1/s*30*5*s;
l4  = -5*30*5*s;
l5  = 5;

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3+l4+l5) + 0

% Y5/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 1/s*1/s*30
p2  = 5*30

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y5_vs_Y1    = factor((p1*D1 + p2*D2)/D, s)

% Y4/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 1/s*1/s
p2  = 5

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - 0;
D2  = 1 - 0;

Y4_vs_Y1    = factor((p1*D1 + p2*D2)/D, s)

% Y2/Y1
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l2

Y2_vs_Y1    = factor((p1*D1)/D, s)

% ==========================================================================
close all; clc;

% ==========================================================================
% SISTEMA 5
% ==========================================================================

% numero de lazos = 5
% ganancias de los lazos
l1  = -1/s;
l2  = -30;
l3  = -1/s*1/s*30;
l4  = -5*1/s;
l5  = -10;

% determinante: D == 1 - sum(gan lazos) + sum(gan lazos disjuntos tomados de a 2) - sum(gan lazos disjuntos tomados de a 3) + ...
D   = 1 - (l1+l2+l3+l4+l5) + (l1*(l4+l5) + l5*(l2+l3)) - 0

% Y5/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 30*1/s*1/s;
p2  = 5*1/s;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l5;
D2  = 1 - l1;

Y5_vs_Y1    = factor((p1*D1 + p2*D2)/D, s)

% Y4/Y1
% ==========================================================================
% numero de caminos directos = 2
% ganancias del camino directo i: pi
p1  = 1/s*1/s;
p2  = -5*1/s;

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - l5;
D2  = 1 - 0;

Y4_vs_Y1    = factor((p1*D1 + p2*D2)/D, s)

% Y2/Y1
% ==========================================================================
% numero de caminos directos = 1
% ganancias del camino directo i: pi
p1  = 1

% cofactor del camino directo i: Di == 1 - sum(gan lazos disjuntos al camino directo i)
D1  = 1 - (l1+l2+l5)

Y2_vs_Y1    = factor((p1*D1)/D, s)

disp("======================================================================")
disp("SUCCESS");
