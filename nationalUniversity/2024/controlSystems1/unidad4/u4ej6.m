% ==========================================================================
clear all; close all; clc;

% Carga de paquete utilizado
pkg load control
pkg load symbolic

% variables
s = tf('s');

disp('==========================================================================')
disp('SISTEMA1')
disp('==========================================================================')

G1  = 15/(5*s+1)

figure
step(G1, tfinal=30)
figure
title('Open Loop Response')
step(feedback(G1,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA2')
disp('==========================================================================')

G2  = 1/(5*s+1)

figure
step(G2, tfinal=30)
title('Open Loop Response')
figure
step(feedback(G2,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA3')
disp('==========================================================================')

G3  = 1/(s+5)

figure
step(G3)
title('Open Loop Response')
figure
step(feedback(G3,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA4')
disp('==========================================================================')

G4  = 15/(s+5)

figure
step(G4)
title('Open Loop Response')
figure
step(feedback(G4,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA5')
disp('==========================================================================')
t   = linspace(0,30,1E3);
x   = heaviside(t-2);

G5  = 15/(5*s+1)

figure
lsim(G5, x, t)
title('Open Loop Response')
figure
lsim(feedback(G5,1), x, t)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA6')
disp('==========================================================================')
a   = 625
b   = 1
c   = 60
d   = 625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G6  = a/(b*s^2+c*s+d)

figure
step(G6)
title('Open Loop Response')
figure
step(feedback(G6,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA7')
disp('==========================================================================')
a   = 1875
b   = 1
c   = 60
d   = 625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G7  = a/(b*s^2+c*s+d)
figure
step(G7)
title('Open Loop Response')
figure
step(feedback(G7,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA8')
disp('==========================================================================')

a   = 1875
b   = 1
c   = 60
d   = 625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)
td      = .1

t   = linspace(0,1.5,1E3);
x   = heaviside(t-td);

G8  = a/(b*s^2+c*s+d)

figure
lsim(G8, x, t)
title('Open Loop Response')
figure
lsim(feedback(G8,1), x, t)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA9')
disp('==========================================================================')
z   = []
p   = [-46.58 -13.42]
k   = 1875

G9  = zpk(z, p, k)
[num,den]   = tfdata(G9,'vector');
a           = num(1)
b           = den(1)
c           = den(2)
d           = den(3)

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)
td      = .1

t   = linspace(0,1.5,1E3);
x   = heaviside(t-td);

figure
lsim(G9, x, t)
title('Open Loop Response')
figure
lsim(feedback(G9,1), x, t)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA10')
disp('==========================================================================')
a   = 187500
b   = 1
c   = 600
d   = 62500

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G10  = a/(b*s^2+c*s+d)
figure
step(G10)
title('Open Loop Response')
figure
step(feedback(G10,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA11')
disp('==========================================================================')
a   = .1875
b   = 1
c   = .6
d   = .0625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G11  = a/(b*s^2+c*s+d)

figure
step(G11)
title('Open Loop Response')
figure
step(feedback(G11,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA12')
disp('==========================================================================')
a   = .0625
b   = 1
c   = .35
d   = .0625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G12  = a/(b*s^2+c*s+d)
pole(G12)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

figure
step(G12)
title('Open Loop Response')
figure
step(feedback(G12,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA13')
disp('==========================================================================')
a   = .0625
b   = 1
c   = .3
d   = .0625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G13  = a/(b*s^2+c*s+d)
pole(G13)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

figure
step(G13)
title('Open Loop Response')
figure
step(feedback(G13,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA14')
disp('==========================================================================')
a   = .0625
b   = 1
c   = .3
d   = .0625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)
td      = 5
G14  = a/(b*s^2+c*s+d)
pole(G14)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

t   = linspace(0,45,1E3);
x   = heaviside(t-td);

figure
lsim(G14, x, t)
title('Open Loop Response')
figure
lsim(feedback(G14,1), x, t)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA15')
disp('==========================================================================')
a   = .1563
b   = 1
c   = .3
d   = .0625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)
td      = 5

G15  = a/(b*s^2+c*s+d)
pole(G15)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

t   = linspace(0,45,1E3);
x   = heaviside(t-td);

figure
lsim(G15, x, t)
title('Open Loop Response')
figure
lsim(feedback(G15,1), x, t)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA16')
disp('==========================================================================')
a   = .0625
b   = 1
c   = 0
d   = .0625

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G16  = a/(b*s^2+c*s+d)
pole(G16)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

figure
step(G16, tfinal=45)
title('Open Loop Response')
figure
step(feedback(G16,1), tfinal=45)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA17')
disp('==========================================================================')
a   = .25
b   = 1
c   = 0
d   = .25

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G17  = a/(b*s^2+c*s+d)
pole(G17)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

figure
step(G17, tfinal=35)
title('Open Loop Response')
figure
step(feedback(G17,1), tfinal=35)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA18')
disp('==========================================================================')
a   = .5
b   = 1
c   = 0
d   = .25

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)

G18  = a/(b*s^2+c*s+d)
pole(G18)

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

figure
step(G18, tfinal=35)
title('Open Loop Response')
figure
step(feedback(G18,1), tfinal=35)
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA19')
disp('==========================================================================')

G19  = 2/(3*s+1)^2
pole(G19)

[num,den]   = tfdata(G19,'vector');
coef_principal  = den(1)
a               = num(1)/coef_principal
b               = den(1)/coef_principal
c               = den(2)/coef_principal
d               = den(3)/coef_principal

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)
mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

figure
step(G19)
title('Open Loop Response')
figure
step(feedback(G19,1))
title('Feedback Response')

% ==========================================================================
close all; clc;

disp('==========================================================================')
disp('SISTEMA20')
disp('==========================================================================')

G20  = 2/(3*s+1)^2
pole(G20)

[num,den]   = tfdata(G20,'vector');
coef_principal  = den(1)
a               = num(1)/coef_principal
b               = den(1)/coef_principal
c               = den(2)/coef_principal
d               = den(3)/coef_principal

k       = a/d
w       = sqrt(d)
psita   = c/(2*w)
tss     = 4/(w*psita)
td      = 4

mp  = e^(-pi*psita/(sqrt(1-psita^2)))
tp  = pi/(w*sqrt(1-psita^2))

t   = linspace(0,25,1E3);
x   = heaviside(t-td);

figure
lsim(G20, x, t)
title('Open Loop Response')
figure
lsim(feedback(G20,1), x, t)
title('Feedback Response')

disp('======================================================================')
disp('SUCCESS')
