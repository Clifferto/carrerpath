% ==========================================================================
clear all; close all; clc;

% 2d plots
[x,y] = meshgrid(-5:1:5);

f1 = sin(x(1,:));

figure
plot(x(1,:),f1,';Sin(x);')
xlabel('x axis'); ylabel('y axis');
title('PLOT (connects points)')

figure
scatter(x(1,:),f1,';Sin(x);')
xlabel('x axis'); ylabel('y axis');
title('SCATTER (isolated points)')

figure
h = quiver(x*0,y*0,x,y)
set (h, "maxheadsize", 0.033);
xlabel('x component'); ylabel('y component');
title('QUIVER')

% AX = Y
A = [1 1;0 1]
figure
scatter(x,y,'filled')
hold on
T = A*[x(1,:);transpose(y(:,1))]
scatter(T(1,:),T(2,:),'r')
hold off

xlabel('x axis'); ylabel('y axis');
title('SCATTER (isolated points)')

return

xx=[0;2];
   yy=[0;0];
   quiver(xx,yy,[0;1],[2;3],0,"linewidth",4);axis equal;xlim([-4 4]);ylim([0 5]);grid on;
   
clf
xs=[0 0 1 5 0]
ys=[0 0 7 1 0]
xe=[5 1 5 1 6]
ye=[1 7 1 7 8]
q=1;
h=quiver(xs(q),ys(q),xe(q),ye(q), 0,'b');
hold on
set (h, "maxheadsize", 0.033);
q=3;
h=quiver(xs(q),ys(q),xe(q),ye(q), 0,'--b');
set (h, "maxheadsize", 0.033);
q=2;
h=quiver(xs(q),ys(q),xe(q),ye(q), 0,'r');
set (h, "maxheadsize", 0.033);
q=4;
h=quiver(xs(q),ys(q),xe(q),ye(q), 0,'--r');
set (h, "maxheadsize", 0.033);
q=5;
h=quiver(xs(q),ys(q),xe(q),ye(q), 0,'g');
set (h, "maxheadsize", 0.033);
axis("square")
grid on
hold off

disp("======================================================================")
disp("SUCCESS");

return
