function orbittrial_1()
%This script combines the function we will put in the ODE45, and then the
%ODE45 after it to keep it all in one script.

function [yp] = Orbit_model( t,z )
%Function to model the Earth's orbit as well as Jupiter's and their
%gravitational pull between them


%% What we know: 
%Do not worry about Earth's gravity, assume circular
%orbits, assume once we have left the solar system we are heading to
%Proxima Centauri, assume that once Earth reaches its escape velocity it
%will interact directly with jupiter and so little time will pass that it
%will head on a path that is perpendicular to both orbits

%What is it doing?
%Leaving Earth's gravitational field and then using
%Jupiter's gravitational field for a gravity assist to increase the
%velocity to further propel it out of the solar system

%How is it doing it? 
%Through a model that will change in velocity
%initially and then interact with Earth's gravitational fields

%Next we need to figure out the forces on Earth and Jupiter that will allow
%us to determine the velocity it is travelling at
%Since we are using ODE45 deriving the acceleration from the force will
%allow us to solve for velocity, which will then allow us to solve for
%position

%% Givens:
%Distance of Earth to Sun: 1.5ell m.
%Distance of Earth to Jupiter: 6.2e11 m
%Mass of the sun (M1): 1.9891e30 kg
%Mass of the Earth: 5.97e24 kg
%Mass of Jupiter (M2): 1.8986e27 kg
%gravitational field constant: G= 6.67e-11 m^3/kg*s^2


%% Deriving the equations:
% F=ma           
% F=-G*M*m/r^2   gravitational force, x and y components need to be found
% r=(x+y)^1/2    this can be obtained by plotting Earth at a coordinate and
% the sun at the origin, we want to simplify the variables so they would
% only be in terms of x and y, and then find the x and y components of the
% force
% cos(theta)=x/r     sin(theta)=y/r   these are the x,y components
% Therefore, Fx=-G*M*m*x/(x+y)^3/2    Fy=-G*M*m*y/(x+y)^3/2
% Therefore, ma=-G*M*m*x/(x+y)^3/2 so ax=-G*M*x/(x+y)^3/2 and ay=-G*M*y/(x+y)^3/2
% Where m is the mass of either the sun when modelling Earths orbit, or
% Jupiter when modelling Jupiter's orbit because we are looking for the
% orbit of Earth
% With these steps done we can now look at using matlab


%% Constants
G=6.67e-11 %m^3/kg*s^2 gravitational field constant
M= 1.9891e30  %mass of the sun



%% Variables
%Variables for Earth Calculations:
x=z(1);   %earth's position in x
y=z(2);   %earth's position in y
vx=z(3);  %earth's velocity in x
vy=z(4);  %earth's velocity in y
%Variables for Jupiter Calculations:
x=z(5);   %jupiters position in x
y=z(6);   %jupiters position in y
vx=z(7);  %jupiters velocity in x
vy=z(8);  %jupiters velocity in y



%% functions
%these four model the gravitational pull of the Sun-Earth
%yp(1)=z(3); %these two functions model the velocity of the mass, (taken from the integration of yp3,4)
%p(2)=z(4);
%yp(3)=-G*M*x/(x^2+y^2)^(3/2); %these two model the acceleration in the x,y directions which gives us the velocity
%yp(4)=-G*M*y/(x^2+y^2)^(3/2);
%these four model the gravitational pull of Jupiter
%p(5)=z(7);
%yp(6)=z(8);
%yp(7)=-G*M*x/(x^2+y^2)^(3/2);
%yp(8)=-G*M*x/(x^2+y^2)^(3/2);
%yp=[yp(1);yp(2);yp(3);yp(4);yp(5);yp(6);yp(7);yp(8)]
yp=[z(3);z(4);-G*M*x/(x^2+y^2)^(3/2);-G*M*y/(x^2+y^2)^(3/2);z(7);z(8);-G*M*x/(x^2+y^2)^(3/2);-G*M*y/(x^2+y^2)^(3/2)]

%% Conclusion about this function
%It was not working to make a function of 8 variable therefore, this ended
%up not being used. We however, will use the ideas at the beginning of this
%function to continue with our next functions where we break it up:
%earth_model and jupiter_model.


end

%The following is the ODE45 that will model the above function
%[t,y]=ode45(@orbit_model,[tmin,tmax],[x(tmin),y(tmin),vx(tmin),vy(tmin)]);
[t,z]=ode45(@Orbit_model,[0,3.2e8],[1.5e11,0,0,41000,7.7e30,0,0,420]);

%The following is the plot for the graph
plot(z(:,1),z(:,2),0,0,z(:,3),z(:,4),7.785e11,7.785e11,'bo'),axis equal, grid on
hold on
%These are the graph's labels
title('Earth Orbit'),xlabel('x position (m.)'),ylabel('y position (m.)')
hold on
end
