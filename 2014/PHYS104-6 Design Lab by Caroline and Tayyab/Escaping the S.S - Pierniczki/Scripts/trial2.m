%This is the second trial of modelling Earth and Jupiter's orbits

%This following circle will model Jupiter's orbit as a circle
%circle(0,0,7.785e11);
hold on

%Model Earth's orbit
%[t,y]=ode45(@earth_model,[tmin,tmax],[x(tmin),y(tmin),vx(tmin),vy(tmin)]);
[t,e]=ode45(@earth_model,[0,3.2e8],[1.5e11,0,0,29900]);

%Model Jupiter's Orbit
%[t,y]=ode45(@Jupiter_model,[tmin,tmax],[x(tmin),y(tmin),vx(tmin),vy(tmin)]);
[t,j]=ode45(@jupiter_model,[0,3.2e9],[7.785e11,0,0,-13070]);

%plot of both ODE45 functions and the circle
plot(e(:,1),e(:,2),0,0,'bo'),axis equal,grid on
plot(j(:,1),j(:,2),7.785e11,7.785e11,'go'),axis equal,grid on
hold on
%Adding titles to the graph
title('Earth and Jupiter Orbit'),xlabel('x position (m.)'),ylabel('y position (m.)')
hold on