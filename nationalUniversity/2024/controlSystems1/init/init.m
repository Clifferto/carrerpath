% ==========================================================================
clear all; close all; clc;

% INIT
disp("Hola mundooooo");
a = 13; b = "ramon";
c = 17;

a-c

disp("SUCCESS");

% ==========================================================================
clear all; close all; clc;

% ROOTS
a = 3; b = 8; c = 4;

% baskara
r1 = (-b - sqrt(b^2 - 4*a*c))/(2*a)
r2 = (-b + sqrt(b^2 - 4*a*c))/(2*a)

% roots
roots([a b c])
disp("======================================================================")
disp("SUCCESS");

% ==========================================================================
clear all; close all; clc;

% VECTORS
vr1 = [1 2 3]
vc1 = [1;2;3]

vr1'

% MATRIX
mat1  = [ 1   2   3 ;...
          4   -5  6 ;...
          7   8   9 ]

mat1_det    = det(mat1)
mat1_trasp  = mat1'
mat1_inv    = inv(mat1)

id = eye(5,5)

mat2  = 2*eye(3,3)

mat1 * mat2
mat2 * mat1'

mat2(5) = -2

disp("======================================================================")
disp("SUCCESS");

% ==========================================================================
clear all; close all; clc;

% FUNCTIONS

% vectors time axis
t1  = -10:.01:10;
f1  = 4*sin(10*t1);

length(t1)

% linspace time axis
t2  = linspace(-10,10,length(t1));
f2  = cos(2*t2);

plot(t1,f1,t2,f2)
plot(t2,(f1.*f2))

% ==========================================================================
clear all; close all; clc;

% POLYNOMIALS
pol1  = [2 3 5 10]

roots(pol1)

disp("======================================================================")
disp("SUCCESS");

return