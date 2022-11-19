function [ep]=earth_model(t,e)

%% Constants
G=6.67e-11 %m^3/kg*s^2 gravitational field constant
M= 1.9891e30  %mass of the sun

%% Variables
%Variables for Earth Calculations:
x=e(1);   %earth's position in x
y=e(2);   %earth's position in y
vx=e(3);  %earth's velocity in x
vy=e(4);  %earth's velocity in y

%% functions
%these four model the gravitational pull of the Sun-Earth
%e(1)=e(3); %these two functions model the velocity of the mass, (taken from the integration of yp3,4)
%e(2)=e(4);
%e(3)=-G*M*x/(x^2+y^2)^3/2; %these two model the acceleration in the x,y directions which gives us the velocity
%e(4)=-G*M*y/(x^2+y^2)^3/2;
ep=[vx;vy;-G*M*x/(x^2+y^2)^(3/2);-G*M*y/(x^2+y^2)^(3/2)]


%% Conclusions about this function
%This function is working and is modelling Earth's velocity/position
%therefore, this is the one we will be using for Earth.

end