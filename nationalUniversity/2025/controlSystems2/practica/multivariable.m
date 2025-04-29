% ====================================================================================================================
close all; clear all; clc;

% carga pkgs
pkg load symbolic;

addpath('../lib');
mylib

% ====================================================================================================================
comment('MODELO')
disp('y_pp + y_p + y    == u + u_p')
disp('=======================================================================')

syms y y_p y_pp u u_p u_pp x1 x2 x1_p x2_p beta0 beta1 real;

eq1 = y_pp + y_p + y == u + u_p

comment('Asignacion, SISO, Derivadas De La Entrada')
% x1  = y - beta0 u                   -> x1_p = y_p - beta0 u_p                   = x2 + beta1 u
% x2  = (y_p - beta0 u_p) - beta1 u   -> x2_p = (y_pp - beta0 u_pp) - beta1 u_p   = (mayor orden)

comment('Relacionando Con La EDO')
y       = x1 + beta0*u
y_p     = x2 + beta1*u + beta0*u_p
y_pp    = eval(solve(eq1, y_pp))

comment('Ecuacion De Estados')
x1_p    = x2 + beta1*u
x2_p    = collect((y_pp - beta0*u_pp) - beta1*u_p, [u_p u_pp]) 

comment('Cancelando Derivadas De La Entrada:')
% x2_p = (sym) -β₀⋅u - β₀⋅uₚₚ - β₁⋅u + u + uₚ⋅(-β₀ - β₁ + 1) - x₁ - x₂
%   - β₀⋅uₚₚ            == 0
%   uₚ⋅(-β₀ - β₁ + 1)   == 0

cond1   = - beta0               == 0
cond2   = (-beta0 - beta1 + 1)  == 0
sol     = solve(cond1, cond2);
beta0   = sol.beta0
beta1   = sol.beta1

comment('Ecuacion De Estados')
x1_p    = eval(x1_p)
x2_p    = eval(x2_p)

comment('Matrices De Estado')
x       = [x1 x2];
xp      = [x1_p x2_p];
y       = [x1 + beta0*u];
matA    = jacobian(xp, x)
matB    = jacobian(xp, u)
matC    = jacobian(y, x)
matD    = jacobian(y, u)

comment('SUCCESS')

return 

pkg load control;
pkg load signal;

function y = edo_sim(u, up, t, y0)
    % resolucion
    dt  = t(2)-t(1);
    % condiciones iniciales
    y   = [y0(1) zeros(1, length(t))](end-1);
    yp  = [y0(2) zeros(1, length(t))](end-1);
    
    for ii = 1:length(t)-1
        % ! DEFINE EDO:
        % ! ypp + yp + y  == u1 + u1p
        ypp = -yp(ii) - y(ii) + u(ii) + up(ii);
        
        yp(ii+1)    = yp(ii)    + ypp*dt;
        y(ii+1)     = y(ii)     + yp(ii)*dt;
    endfor
endfunction

% ====================================================================================================================
T=10; Kmax=10000; At=T/Kmax;
u=zeros(1,Kmax);
% y=u;
% yp=y; 
y0  = [0 0];

t   = 0:At:T-At;
u   = [0 sin(5*t+2)](1:end-1);
up  = [0 diff(u)/At](1:end-1);

y   = edo_sim(u, up, t, y0);

figure;title('Sistema SISO');
subplot(2,2,1);plot(t,y,'.k');title('y'),hold on
subplot(2,2,3);plot(t,u(1:numel(t)),'k');title('u');xlabel('t [seg.]');

A=[0,1;-1,-1];
B=[1;0];
C=[1, 0];
D=[0];
Sis_ve=ss(A,B,C,D)
% [num, den]=ss2tf(Sis_ve.a,Sis_ve.b,Sis_ve.c,Sis_ve.d,1)

% x=[0;0];
[y t]   = lsim(Sis_ve, u, t);

% U=[0];y_1(1)=0;hh=At*1;tve(1)=0;
% for jj=1:Kmax-1
% U=u(jj);
% xp=A*x+B*U;
% Y =C*x+D*U;
% x=x+xp*At;
% y_1(jj+1)=Y(1);
% tve(jj+1)=tve(jj)+hh;
% end

subplot(2,2,1);plot(t,y(:,1),'r');
% subplot(2,2,1);plot(tve,y_1,'r');
legend('EDO','Evolución en VE');
legend("boxoff");