function [sp]=satellite_model(t,s)

%% Deriving the equations for the satellite

%F=ma           
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
M1= 1.9891e30  %mass of the sun
M2= 1.9e27 %kg  mass of the jupiter
M3= 5.97e24  %kg  mass of the earth

%Variables for satellites Calculations:
x=s(1);   %satellites position in x
y=s(2);   %satellites position in y
vx=s(3);  %satellites velocity in x
vy=s(4);  %satellitesvelocity in y

%these four model the gravitational pull on the satellite from the three
%bodies around it (sun, earth, jupiter)
%sp(5)=s(3);
%sp(6)=s(4);
%sp(7)=(-G*x(M1+M2+M3))/(x^2+y^2)^(3/2);
%sp(8)=(-G*y(M1+M2+M3))/(x^2+y^2)^(3/2);
sp=[vx;vy;(-G*x*(M1+M2+M3))/(x^2+y^2)^(3/2);(-G*y*(M1+M2+M3))/(x^2+y^2)^(3/2)]

%% Conclusions about this function
%This function is not working and we need to come up with another solution.

end