function [t,y,object] = CelestialMechanics(varargin)
% this function is responsible for setting up planet parameters and is
% responsible for calculating the ode113 system of equations.


%--------------------------------------------------------------------------
% GLOBAL PARAMETERS (NO PUN INTENDED)
% This creates global variables that span across different functions. If
% you change anything here... CTRL+Z.
global n_bodies;
global MU;
global hill;
global tspan;
global y;
%--------------------------------------------------------------------------


% =========================================================================
%         CALCULATIONS AND DERIVATIONS
% =========================================================================
tspan=[0:0.001:2]*3.15569e7; 
% This is (usually) the only thing that needs to be changed. This is your
% time span for the calculation. 

% tspan = [t_i : t_step : t_f] * (365d*24h*60min*60sec)

% Where t_i and t_f are start and end time, and t_step is the number of
% steps in between.
% Units are measured in years (which are then converted back to seconds, 
% just for convenience).
% If you decide to lower the t_step, please make sure your t_f is
% reasonable. For example, trying to get MATLAB to do calculations from 0
% to 100 years with a time step every 0.000001 of a year is going to
% probably take quite some time.

% Arrays can be considered to contain the elements ordered as followed:
% [Sun, Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune,
% Space Colony].


n_bodies=10; system = ones(n_bodies,1);
%This refers to the number of bodies included in the system.

hill=1:n_bodies; index = ones(n_bodies,1);
% this indexes the bodies.



G = 6.67384E-11; %m^3 kg^-1 s^-2
%This is the gravitational constant.
%If you change this value to anything else, prepare to wait for some long 
%calculations, but the effects are pretty interesting.


mass = [1.9891e30; ...
    3.302e23; 4.8685e24; 5.97219e24; ...
    6.4185e23; 1.89813e27; 5.68319e26; ...
    8.68103e25; 1.0241e26; 1.0e6]; %kg
%The mass of the sun, planets and the space colony.


MU = G*mass; %(km^3 s^-2)
% the product of G and m for the bodies in the solar system, otherwise
% known as the standard gravitational parameter.
% These values were listed in the Horizons Ephemeris System, but the
% calculation used, just to clean things up.

% The positions (x,y,z) and the velocities (vx,vy,vz) of all the planets.
% This data was taken from Ephemeris to use as initial conditions. The date
% of request was on February 17th, 2015. I requested the data for the day
% of January 17th, 2015 (my birthday!). The Horizons database is very
% interesting, and is worth checking out. http://ssd.jpl.nasa.gov/?horizons

x = [0; ...
    32028780.3515120; 104655057.124614; -65264378.3456380; ...
    207858587.919590; -570902947.517129; -798546799.526449; ...
    2885234498.93953; 4120861902.96630; -65264378.3456380].*1e3; %m

y = [0; ...
    34535186.0133494; -29109732.2049674; 131905567.309967; ... 
    -5027589.35561678; 555629850.245176; -1256286654.50108; ...
    794221748.444278; -1764736895.56866; 132905567.309967].*1e3; %m

z = [0; ... 
    -116685.027536338; -6438504.19064046; -4486.90076783871; ...
    -5207099.75688958; 10467263.2289453; 53629953.6592323; ...
    -34414632.5507802; -58614958.1578692; -4486.90076783871].*1e3; %m

vx = [0; ...
     -45.3598379805404; 9.20288058404566; -27.1956839200485; ...
     1.51788623962461; -9.27886907126676; 7.61866018779092; ...
     -1.86325709475884; 2.09637836269396; -36.78].*1e3; %m/s


vy = [0; ...
     35.1631788814636; 33.5857789779081; -13.3197183589181; ... 
     26.2941026543713; -8.75387047856117; -5.21695615208945; ... 
     6.23921499000590; 5.01869717381452; 15.6].*1e3; %m/s


vz = [0; ... 
     7.03471056417896; -0.0707735768444587; -5.01494192442107e-05; ... 
     0.513689283491029; 0.243960706462081; -0.212163133532694; ...
     0.0473572653360190; -0.152262959360013; 0.68215].*1e3; %m/s

% Range (distance from coordinate center).
RG = [0; ...
    4.710133181957486E+07; 1.088187108314280E+08; 1.471683314722944E+08; ...
    2.079845742225441E+08; 7.967209483669461E+08; 1.489566823355348E+09; ...
    2.992749683235527E+09; 4.483217019866444E+09; 1.471683314722944E+08].*10^3; %m


Y0=[];
% Y0 sets up a vector of initial conditions [x,y,z,vx,vy,vz] for each
% planet.
for i=1:n_bodies
    Y0 = [Y0; x(i); y(i); z(i); vx(i); vy(i); vz(i)];
end


options = odeset('RelTol',1e-5); 
% Relative error tolerance that applies to all components of the solution
% vector y. - MATLAB DOCUMENTATION.
% Do not change. This sets the relative tolerance of the ode solver.
% "help odeset" will give you a better explanation of this, as well as:
% http://www.mathworks.com/matlabcentral/answers/34237-abstol-reltol

[t,y]=ode45(@evalsoln,tspan,Y0,options);
% Solve this problem using ODE45. tspan converted from years into seconds.
% ODE45 alone can technically solve this, but given tolerance levels,
% it is much faster at calculating the results and is more accurate in the
% long run. See "help ode45" for more information or at the following:
% http://www.mathworks.com/help/matlab/ref/ode45.html



function DX = evalsoln(t,x)
% See write-up background for a more detailed analysis of the math and process of
% this function.

DX = zeros(6.*(n_bodies),1);
% where DX = [x, y, z, vx, vy, vz];
% this sets up our solution vector.

for i=1:n_bodies
    j=hill; null=find(j==i); j(null)=[];
    % this finds our indexed bodies that are being incorporated. 

    % this calculates r between this planet et al.
    RX = [(x((i-1).*6+1)-x((j-1).*6+1)), ...
          (x((i-1).*6+2)-x((j-1).*6+2)), ...
          (x((i-1).*6+3)-x((j-1).*6+3))];
      
    dx = RX(:,1).^2;
    dy = RX(:,2).^2;
    dz = RX(:,3).^2;
    
    R = sqrt(dx + dy + dz);
    
    % a = dv/dt 
    % This is where the gravity comes in,  a = F/m = GM|x1-x2|/r^3).
    dvx = DX((i-1).*6+4)-sum(MU(j)./R.^2.*(x((i-1).*6+1)-x((j-1).*6+1))./R);
    dvy = DX((i-1).*6+5)-sum(MU(j)./R.^2.*(x((i-1).*6+2)-x((j-1).*6+2))./R);
    dvz = DX((i-1).*6+6)-sum(MU(j)./R.^2.*(x((i-1).*6+3)-x((j-1).*6+3))./R);
    
    DX((i-1).*6+4) = dvx;
    DX((i-1).*6+5) = dvy;
    DX((i-1).*6+6) = dvz;
    
    DX((i-1).*6+1) = x((i-1).*6+4);
    DX((i-1).*6+2) = x((i-1).*6+5);
    DX((i-1).*6+3) = x((i-1).*6+6);
end

end



end