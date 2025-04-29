% ==========================================================================
clear all; close all; clc;

% PLOTS
alpha1  = linspace(-pi, pi, 1000);
alpha1(1)
alpha1(end)
alpha1(1:10)

size(alpha1)
length(alpha1)

alpha1(1)-alpha1(2)

f1  = cos(alpha1);
f2  = sin(10*alpha1);

% "<linestyle><marker><color><;displayname;>"
plot( alpha1, f1, ';Cos(\alpha);',
      alpha1, f2, '-.r;Sin(\alpha);',
      alpha1, (f2.*f2), ';AM;', 'linewidth', 3)
title('TRIGONOMETRIC FUNCTIONS')
xlabel('angle[rad]'); ylabel('amplitude');
grid;

disp("======================================================================")
disp("SUCCESS");

% ==========================================================================
clear all; close all; clc;

% SUBPLOTS

xaxis = '\alpha [rad]';
yaxis = 'amplitude';
alpha = linspace(-pi,pi,1000);

f1  = 4*sin(30*alpha);
f2  = cos(3*alpha);
f3  = f1.*f2

subplot(2,2,1)
  plot( alpha, f1, ';4 Sen(30 \alpha);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('CARRIER')

subplot(2,2,2)
  plot( alpha, f2, ';Cos(3 \alpha);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('BASEBAND')

subplot(2,2,3:4)
  plot( alpha, f3, ';4 Cos(3 \alpha) Sen(30 \alpha);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('AM')

disp("======================================================================")
disp("SUCCESS");

% ==========================================================================
clear all; close all; clc;

theta = linspace(-2*pi,2*pi,1000)
f1    = sin(theta)
f2    = cos(theta)
f3    = tan(theta)
f4    = sec(theta)
f5    = csc(theta)
f6    = cot(theta)
f7    = sinc(theta)

subplot(3,3,1)
  plot( theta, f1, ';Sen(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('SINE')

subplot(3,3,2)
  plot( theta, f2, ';Cos(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('COSINE')

subplot(3,3,3)
  plot( theta, f3, ';Tan(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('TANGENT')

subplot(3,3,4)
  plot( theta, f4, ';Sec(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('SECANT')

subplot(3,3,5)
  plot( theta, f5, ';Cosec(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('COSECANT')

subplot(3,3,6)
  plot( theta, f6, ';Cotan(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('COTANGENT')

subplot(3,3,7:9)
  plot( theta, f7, ';Senc(\theta);')
  xlabel('angle[rad]'); ylabel('amplitude');
  grid;
  title('SENC')

disp("======================================================================")
disp("SUCCESS");

return
