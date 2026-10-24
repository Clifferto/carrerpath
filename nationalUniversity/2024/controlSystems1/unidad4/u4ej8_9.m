% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

% variables
s = tf('s');

disp('==========================================================================')
disp('SISTEMA1: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = .5E-3

k   = 2
yp  = 2.4
tp  = 1.5E-3 - td

mp      = (yp-k)/k
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G1  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,4E-3,10E3);
x   = heaviside(t-td);

lsim(G1, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA2: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = 0

yss = 1
yp  = 1.3
k   = yss
tp  = .1 - td

mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G2  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,.45,1E3);
x   = heaviside(t-td);

lsim(G2, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA3: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = 0

yss = 1
yp  = 1.04
k   = yss
tp  = 15 - td

mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G3  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,30,10E3);
x   = heaviside(t-td);

lsim(G3, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA4: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = .05

yss = 1
yp  = 1.1
tp  = .15 - td

k       = yss
mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G4  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,.3,10E3);
x   = heaviside(t-td);

lsim(G4, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA5: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = 0

yss = 900
yp  = 1200
tp  = .4 - td

k       = yss
mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G5  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,2.5,10E3);
x   = heaviside(t-td);

lsim(G5, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA6: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = 0

yss = .7
yp  = .75
tp  = 10 - td

k       = yss
mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G6  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,20,1E3);
x   = heaviside(t-td);

lsim(G6, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA7: Segundo Orden - Sub-Amortiguado')
disp('==========================================================================')
td  = 0

yss = 2
yp  = 2.75
tp  = 1.25 - td

k       = yss
mp      = (yp-yss)/yss
psita   = sqrt(log(mp)^2/(pi^2 + log(mp)^2))
w       = pi/(tp*sqrt(1-psita^2))

G7  = k*w^2/(s^2 + 2*psita*w*s + w^2)

t   = linspace(0,7,1E3);
x   = heaviside(t-td);

lsim(G7, x, t)
title('Open Loop Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA8: Segundo Orden - Sobre-Amortiguado')
disp('Aproximacion De Primer Orden: G == k/(tau/2 s + 1)^2')
disp('==========================================================================')
td  = 0

yss = 1.2
tss = 2.5 - td

k   = yss
tau = tss/4

G8  = k/((tau/2)*s + 1)^2

t   = linspace(0,4.5,1E3);
x   = heaviside(t-td);

figure
lsim(G8, x, t)
title('Open Loop Response')

disp('AJUSTES')
disp('==========================================================================')
G8_adjust   = k/((.95/2)*s + 1)^2

figure
lsim(G8_adjust, x, t)
title('Ajusted Response')

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA9: Segundo Orden - Sobre-Amortiguado')
disp('Aproximacion De Primer Orden: G == k/(tau/2 s + 1)^2')
disp('==========================================================================')

% GG
% ...

% ==========================================================================
close all

disp('==========================================================================')
disp('SISTEMA10: Segundo Orden - Sobre-Amortiguado')
disp('Aproximacion De Primer Orden: G == k/(tau/2 s + 1)^2')
disp('==========================================================================')
td  = 5E-3

yss = 3.5
tss = 10E-3 - td

k   = yss
tau = tss/4

G10  = k/((tau/2)*s + 1)^2

t   = linspace(0,20E-3,10E3);
x   = heaviside(t-td);

figure
lsim(G10, x, t)
title('Open Loop Response')

disp('AJUSTES')
disp('==========================================================================')
G10_adjust   = k/((1.75E-3/2)*s + 1)^2

figure
lsim(G10_adjust, x, t)
title('Ajusted Response')

disp('======================================================================')
disp('SUCCESS')
