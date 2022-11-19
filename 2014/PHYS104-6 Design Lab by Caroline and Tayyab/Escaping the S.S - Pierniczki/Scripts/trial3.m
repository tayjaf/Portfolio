%The following three functions represent the ODE45 that will map the three
%bodies.
[t,e]=ode45(@earth_model,[0,3.2e8],[1.5e11,0,0,29800]);
[t,j]=ode45(@jupiter_model,[0,3.2e9],[-7.785e11,0,0,13070]);
[t,s]=ode45(@satellite_model,[0,3.2e8],[1.51e11,0,0,40100]);

%These map the three bodies onto the graph
plot(e(:,1),e(:,2),1.5e11,0,'bo'),axis equal, grid on
hold on
plot(j(:,1),j(:,2),-7.785e11,0,'go'),axis equal, grid on
hold on
plot(s(:,1),s(:,2),1.51e11,0,'ko'),axis equal, grid on

%Adding titles to the graph
title('Satellite interacting with the sun'),xlabel('x position'),ylabel('y position')
hold on