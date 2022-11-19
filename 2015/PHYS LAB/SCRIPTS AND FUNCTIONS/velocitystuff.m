%velocity stuff
close all
clear
clc
close all hidden
global n_bodies;


CelestialMechanics;
global tspan;
global y;
Y = y;
t = tspan./3.15569e7.';

p = 10*6;

vxi = Y(1,p-2);
vyi = Y(1,p-1);
vzi = Y(1,p-0);
vi = sqrt(vxi^2 + vyi^2 + vzi^2);

x = Y(:,p-2)-Y(:,1);
y = Y(:,p-1)-Y(:,2);
z = Y(:,p-0)-Y(:,3);

vx = Y(:,p-2);
vy = Y(:,p-1);
vz = Y(:,p);
Y = [x y z];
V = [vx vy vz];
hold on


pos_x = x;
pos_y = y;
pos_z = z;
u_vel = vx;
v_vel = vy;
z_vel = vz;

x = pos_x;
y = pos_y;
u = u_vel;
v = v_vel;
w = z_vel;


% Plot the velocity arrows:
%quiver(pos_x, pos_y, u_vel, v_vel)
scl = 5e1;
% Plot the particle positions:
%axes()
scatter3(pos_x(1:scl:end,1:scl:end),pos_y(1:scl:end,1:scl:end),pos_z(1:scl:end,1:scl:end),2,t(1:scl:end,1:scl:end),'filled')
%set(l,'MarkerEdgeColor','none')
hold on
grid on
box on

quiver3(x(1:scl:end,1:scl:end),y(1:scl:end,1:scl:end),z(1:scl:end,1:scl:end),u(1:scl:end,1:scl:end),v(1:scl:end,1:scl:end),w(1:scl:end,1:scl:end),2)
%grid on
%axis equal
%xlim([0 1])
%ylim([0 1])
%zlim([0 1])

%title('Quiver using scattered data') 
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')

colormap('winter')
cb = colorbar('Location','EastOutside');
ylabel(cb,'Time (yrs)')
set(cb,'position',[0.85 0.650 0.03 0.33]);