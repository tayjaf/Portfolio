function [jp]=jupiter_model(t,j)

%% Constants
G=6.67e-11 %m^3/kg*s^2 gravitational field constant
M= 1.9891e30  %mass of the sun

%Variables for Jupiter Calculations:
x=j(1);   %jupiters position in x
y=j(2);   %jupiters position in y
vx=j(3);  %jupiters velocity in x
vy=j(4);  %jupiters velocity in y

%these four model the gravitational pull of Jupiter
%jp(5)=j(7);
%jp(6)=j(8);
%jp(7)=-G*M*x/(x^2+y^2)^(3/2);
%jp(8)=-G*M*x/(x^2+y^2)^(3/2);
jp=[vx;vy;-G*M*x/(x^2+y^2)^(3/2);-G*M*y/(x^2+y^2)^(3/2)]

%% Conclusions about this function
%This function is working and is modelling Jupiter's velocity/position
%therefore, this is the one we will be using for Jupiter.

end