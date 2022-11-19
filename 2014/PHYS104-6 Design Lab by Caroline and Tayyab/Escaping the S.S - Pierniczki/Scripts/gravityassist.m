% ========================================================================================================
%         WELCOME TO THE GRAVITY ASSIST MODEL-er
% ========================================================================================================
function gravityassist()
% calls upon the function


% -------------------------------------------------------------------------
% used to begin global variables required to direct the script given a
% certain input in the menu
op=0; clc
% ends global variables
% -------------------------------------------------------------------------


% User Menu Begins
while op~=4
disp ('Welcome to our Interactive Gravity Assist Model')
disp ('by Caroline Krzyszkowski and Tayyab Jafar')
disp (' ')
disp ('As the name suggests, this script will model a space colony, Colony Pierniczka (Polish: Gingerbread Cookie),')
disp ('escaping (or orbiting) the solar system to head towards Proxima Centauri, via a gravity assist from Jupiter.')
disp ('It plots the orbits of Jupiter and the trajectory of the colony.')
disp ('The orbit of the Earth (in blue) is also displayed as a reference, along with the Sun.')
disp (' ')
disp ('Please be aware that the script will not run given small or very large inputs.')
disp ('If the default model is not interactive, re-run the script.')
disp ('Furthermore, the custom model has a predefined theta value which places Jupiter at a certain position.')
disp ('To change Jupiters position at a time t, change theta inside the script.')
disp (' ')
disp ('If you would like to see the default model, press 1.')
disp ('If you would like to create your own model, press 2.')
disp ('If you do not like science, press 3 and please re-evaulate your life.')
disp (' ')
disp('1)Default')
disp('2)Custom')
disp('3)Exit')
op = input ('Please choose an option: ');
disp (' ')
% User Menu Ends


% -------------------------------------------------------------------------
switch op
    case 1 %Default     
        DefaultModel
break
    case 2 %Custom Orbit
        CustomModel
        break
    case 3 %break
        break
    otherwise
        disp('THAT WAS NOT AN OPTION!')
        pause(2);
        disp('TRY AGAIN.')
        pause(3);
        gravityassist
% if case 1 is inputted, it will run the default model function,
% and custom model for case 2. If any other options are chosen, it will end
% the function via the break command.
% -------------------------------------------------------------------------


end
end


% //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
% //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function DefaultModel()
% this function is the default model which contains nultiple functions
% responsible for calculating the ode45 and plotting the results.
 
% ========================================================================================================
%         CALCULATIONS AND DERIVATIONS
% ========================================================================================================
% rs represents the displacement between the colony and the sun.
% rj-rs represent the displacement between the colony and Jupiter
% F=ma           
% F=-G*M*m/r^2(r-vector for direction) gravitational force, x and y components will be part of an r vector so matlab will be able to calculate them from us
% Therefore, F due to sun=-G*MS*m*rs/(rs)^3    F due to Jupiter=-G*MJ*m*(rj-rs)/(rj-rs)^3
% Therefore, ma(sun)=-G*MS*m*rs/(rs)^3 so as=-G*MS*rs/(rs)^3 and a(jupiter)=-G*MJ*(rj-rj)/(rj-rs)^3
% Where G is the gravitational field constant, m is the mass of the colony, MS is the mass of the sun, and MJ is the mass of Jupiter
% With these steps done we can now look at using matlab


% ========================================================================================================
%             CONSTANTS
% ========================================================================================================
OMEGA = 1.68E-8; 
orbj = 7.785E11; 
G = 6.67E-11; 
MS = 1.9891E30;  
MJ = 1.9E27; 
ER = 1.5E11;
% defined constants required in the function
% OMEGA in rad/sec is the angular frequency of Jupiter
% orbj in m, is the orbit radius between jupiter and the sun
% G is the gravitational field constant, in m^3/kg*s^2 
% MS is the mass of the sun in kg


% ========================================================================================================
%         SPACE COLONY FUNCTION
% ========================================================================================================
function [sp]=satmod(t,s) % function responsible for setting up values required for the ode45 function
theta = .548632*pi;
THETA = (OMEGA*t)+theta; 
rs =  s(1:2); 
vs =  s(3:4);
% THETA in this function is used to calculate jupiters orbit
% theta in radians, is a calculated adjustment value for placing jupiter in the same location as space colony while it travels by
% rs is the position of the colony in m, broken into x and y from the relationship x^2 +y^2 = r^2
% it is then placed into the first and second column vectors in s (ie. x and y)
% vs is the velocity of the colony in m/s, broken into vx and vy
% just as rs, it is placed into the third and fourth column vectors in s (ie. vx and vy)
 

% -------------------------------------------------------------------------
rj =  [cos(THETA) sin(THETA)]'*orbj; 
% rj in m, is the position of jupiter in x and y
% -------------------------------------------------------------------------


aj = (-G*MJ/(norm(rj-rs)).^3*(rj-rs));
asun = (-G*MS/(norm(rs).^3))*(rs); 
as = asun + aj;
sp = [vs;as];
% aj is the accel. of colony due to the force from jupiter in m/s^2
% asun is the accel. of colony due to the force from sun in m/s^2
% as is the accel. of spacecraft from the addition of the two forces 
% from the sun and jupiter
% sp is the output of the function
end


% ========================================================================================================
%             INITIAL CONDITIONS
% ========================================================================================================
% IPx and IPy are the starting/initial positions of the colony in the x and y direction, in m
% IVx and IVy are the initial velocities of the colony in the x and y direction, in m/s
% tmin and tmax are used for the time elapsed from the beginning of the function to the end in seconds
IPx = 1.51E11;
IPy = 0;
IVx  = 0;
IVy = 40100;
tmin = 0;
tmax = 3.74265E8;


% ========================================================================================================
%             ODE45 FUNCTION
% ========================================================================================================
% [t,s]=ode45(@satmod,[tmin,tmax],[x(tmin),y(tmin),vx(tmin),vy(tmin)]);
% this returns the value of a system of 4 first-order ODEs.
[t,s]=ode45(@satmod,[tmin,tmax],[IPx,IPy,IVx,IVy]);
% where [tmin,tmax] represents the time elapsed (from zero seconds to one full jovian year in seconds: 3.74265E8).
% sidenote: the time for the space colony and jupiter to intersect = 4.396E7 seconds in this scenario.
% IPx = 1.51E11 which is the starting position of the satellite from the sun, in the y direction in meters. This can
% be changed, but we decided to start 0.01E9 meters above the Earth’s orbit
% in order to illustrate the escape, also since this would plot the center
% of the earth and not the surface. If this does change, the initial velocity 
% would have to increase if the starting position decreased (as it is closer to the sun), and vice-versa
% if it increases its starting position.
% IPy and IVx are the y position (m) and velocity (m/s) in the x position; these are starting at 0 in our scenario.
% IVy = 40100 which is the initial velocity in the y direction (m/s).


% -------------------------------------------------------------------------
THETA = (OMEGA*t)+theta; 
rj =  [cos(THETA) sin(THETA)]*orbj;
% these are the same expressions from the function above in order to call it when run outside of the function


% ========================================================================================================
%             PLOTTING THE ORBITS
% ========================================================================================================
function icantbelievethisworked()
% the function is only used for the 'default model'. since we have
% predetermined values from the model, we can make things look a bit nicer.
% it sets up a figure with a callback that executes on mouse motion, 
% essentially 'records' the mouse position and when it enters a
% certain range in the axes (X,Y), it will place information off to the
% side. in this case, when hovering over bodies, it will place the name,
% location and so forth on the side. this one is more about appearance than
% functionality.
% -------------------------------------------------------------------------


% these are just handles used in the function to display labels, positions, etc.
figHdl = figure('WindowButtonMotionFcn', @hoverCallback);
axesHdl = axes;
lineHdl = plot(0,0,'wo','MarkerFaceColor',[1 1 0],'Parent',axesHdl);
textHdl = text('Color', 'white','Position',[1.25E12 1E12]);
posXHdl = text('Color', 'white','Position',[1.25E12 0E12]);
posYHdl = text('Color', 'white','Position',[1.25E12 -0.25E12]);
% google 'function handles matlab' for more info...


% -------------------------------------------------------------------------
text(0.85E12,-1.5E12,'Time since Launch:','FontSize',8);
% displays the 'text' at a given position. featuring fontsize 8!
% -------------------------------------------------------------------------


tim = tmax./(60*60*24*365);
text(0.85E12,-1.75E12,[num2str(tim) '  years'],'FontSize',8);
% same as before, but in case someone wants to play around with the script
% and combine the custommodel with this, it saves a line by displaying the
% time inputted and displays it on the figure.


% -------------------------------------------------------------------------
text(0.85E12,1.25E12,'Name of Object:','FontSize',8);
text(1E12,1E12,'\rightarrow','FontSize',8);
text(0.85E12,0.25E12,'Position (X,Y):','FontSize',8);
text(1E12,0E12,'\rightarrow','FontSize',8);
text(1E12,-0.25E12,'\rightarrow','FontSize',8);
% I hate commenting.
% -------------------------------------------------------------------------


function hoverCallback(~, ~)
        % grab the x & y axes coordinate where the mouse is
        mousePoint = get(axesHdl, 'CurrentPoint');
        mouseX = mousePoint(1,1);
        mouseY = mousePoint(1,2);
        % if the distance is between a given threshold, set the text
        % object's string to show the data at that point.
        if mousePoint(1,1) < 1E11 && mousePoint(1,1) > -1E11 && mousePoint(1,2) < 1E11 && mousePoint(1,2) > -1E11
            set(textHdl,'String', {'Sun'});
            set(posXHdl,'String','0  m');
            set(posYHdl,'String','0  m');
        elseif mousePoint(1,1) < -0.5E11 && mousePoint(1,1) > -2E11 && mousePoint(1,2) < 9E11 && mousePoint(1,2) > 7E11
                set(textHdl, 'String', {'Jupiter'});
                precision = 3;
                XPOS = num2str(rj(end,1),precision);
                YPOS = num2str(rj(end,2),precision);
                set(posXHdl,'String',[XPOS ' m']);
                set(posYHdl,'String',[YPOS ' m']);
        elseif  mousePoint(1,1) < -3.5E12 && mousePoint(1,1) > -4E12 && mousePoint(1,2) < -1E12 && mousePoint(1,2) > -1.25E12
            set(textHdl, 'String', {'Pierniczka'});
            precision = 3;
            XPOS = num2str(s(end,1),precision);
            YPOS = num2str(s(end,2),precision);
            set(posXHdl,'String',[XPOS ' m']);
            set(posYHdl,'String',[YPOS ' m']);
        else
            set(textHdl, 'String', 'None')
            set(posXHdl, 'String', '')
            set(posYHdl, 'String', '')
        end
    end
end
icantbelievethisworked; %calls the function to run
% it took me hours of figuring out an error before this thing stopped crashing.


% -------------------------------------------------------------------------
set(gcf,'units','normalized','outerposition',[0 0 1 1])
% this makes the figure fullscreen when it opens. I did this because when
% the figure is small, it tends to squish labels together. I don't know any
% other methods to fix this, so fullscreen it is!
% -------------------------------------------------------------------------


whitebg([0 0 0]),axis vis3d, grid on;
% this sets up the figure to be black, to sort of simulate the "blackness"
% of space. the figure is not 3D but it restricts text from being stretched.


% -------------------------------------------------------------------------
set(gcf,'Color',[0 0 0]);
set(gca, 'XColor', [0.5 0.5 0.5], 'YColor', [0.5 0.5 0.5], 'ZColor', [0.5 0.5 0.5])
% these sets the color of the background and axes of the plot, to black and grey in
% this case.
% -------------------------------------------------------------------------


title('Model of Colony Leaving the Solar System','Color','w');
xlabel('x-position (m)','Color','w');
ylabel('y-position (m)','Color','w');
box on;
hold on
% these lines just set up the figure with the proper labels. box displays
% the boundary of the graph; all just visual features.


% -------------------------------------------------------------------------
plot(s(:,1),s(:,2),s(end,1),s(end,2),'wo','MarkerFaceColor',[1 1 1],'Color',[0 0.5 0.5]);
% plots the orbit of the space colony
% s(:,1) and s(:,2) call upon all values 
% from the first and second column (x and y) of the space colony. 
% s(end,') returns the final X and Y Position of the colony, and plots a
% circle representing it.
% -------------------------------------------------------------------------


plot(orbj*cos(THETA),orbj*sin(THETA),'Color',[0.8 0.7 0.3]);
plot(rj(end,1),rj(end,2),'wo','MarkerFaceColor',[0.8 0.7 0.3]);
plot(0,0,'wo','MarkerFaceColor',[1 1 0]);
plot(ER*cos(THETA),ER*sin(THETA),'Color',[0 0.5 1]);
% plots the orbit of Jupiter and its location at the end of tmax
% where rj(end,1),rj(end,2),’go’ represent the final values at the end of its calculated
% vector in order to define an x and y coordinate, plotting a green circle
% to indicate jupiter at the end of tmax


% ========================================================================================================
%            FINAL VELOCITY
% ========================================================================================================
velocityx = s(end,3);
velocityy = s(end,4);
v = sqrt(velocityx^2 + velocityy^2);
disp(['Final velocity = ' num2str(v) 'm/s'])
% this calculates the final velocity in the x and y direction, in m/s
% and throws out the number in the command window. can be hidden
% by placing a semicolon at the end if not required.
end


% //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
% //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function CustomModel()
% this function is the custom model which contains functions required to
% calculate the ode45 command and plot its results, given initial values
% inputted by the user.
 

% ========================================================================================================
%         CALCULATIONS AND DERIVATIONS
% ========================================================================================================
% rs represents the displacement between the colony and the sun.
% rj-rs represent the displacement between the colony and Jupiter
% F=ma           
% F=-G*M*m/r^2(r-vector for direction) gravitational force, x and y components will be part of an r vector so matlab will be able to calculate them from us
% Therefore, F due to sun=-G*MS*m*rs/(rs)^3    F due to Jupiter=-G*MJ*m*(rj-rs)/(rj-rs)^3
% Therefore, ma(sun)=-G*MS*m*rs/(rs)^3 so as=-G*MS*rs/(rs)^3 and a(jupiter)=-G*MJ*(rj-rj)/(rj-rs)^3
% Where G is the gravitational field constant, m is the mass of the colony, MS is the mass of the sun, and MJ is the mass of Jupiter
% With these steps done we can now look at using matlab


% ========================================================================================================
%             CONSTANTS
% ========================================================================================================
OMEGA = 1.68E-8; 
orbj = 7.785E11; 
G = 6.67E-11; 
MS = 1.9891E30;  
MJ = 1.9E27; 
ME = 5.9736E24;
ER = 1.5E11;
% defined constants required in the function
% OMEGA in rad/sec is the angular frequency of Jupiter
% orbj in m, is the orbit radius between jupiter and the sun
% G is the gravitational field constant, in m^3/kg*s^2 
% MS is the mass of the sun in kg


% ========================================================================================================
%         SPACE COLONY FUNCTION
% ========================================================================================================
function [sp]=satmod(t,s) % function responsible for setting up values required for the ode45 function
theta = .548632*pi;
THETA = (OMEGA*t)+theta; 
rs =  s(1:2); 
vs =  s(3:4);
% THETA in this function is used to calculate jupiters orbit
% theta in radians, is a calculated adjustment value for placing jupiter in the same location as space colony while it travels by
% rs is the position of the colony in m, broken into x and y from the relationship x^2 +y^2 = r^2
% it is then placed into the first and second column vectors in s (ie. x and y)
% vs is the velocity of the colony in m/s, broken into vx and vy
% just as rs, it is placed into the third and fourth column vectors in s (ie. vx and vy)
 

% -------------------------------------------------------------------------
rj =  [cos(THETA) sin(THETA)]'*orbj; 
% rj in m, is the position of jupiter in x and y
% -------------------------------------------------------------------------


aj = (-G*MJ/(norm(rj-rs)).^3*(rj-rs));
asun = (-G*MS/(norm(rs).^3))*(rs); 
as = asun + aj;
sp = [vs;as];
% aj is the accel. of colony due to the force from jupiter in m/s^2
% asun is the accel. of colony due to the force from sun in m/s^2
% as is the accel. of spacecraft from the addition of the two forces 
% from the sun and jupiter
% sp is the output of the function
end


% ========================================================================================================
%             INITIAL CONDITIONS
% ======================================================================================================== 
% IPx and IPy are the starting/initial positions of the colony in the x and y direction, in m
% IVx and IVy are the initial velocities of the colony in the x and y direction, in m/s
% tmin and tmax are used for the time elapsed from the beginning of the function to the end in seconds


%these will allow the user to input their own initial values
disp('Please choose the initial starting variables for the model');
disp (' ')
IPx  = input('type your starting x position in m (recommended 1.51E11): ');
IPy = input('type your starting y position in m (recommended 0): ');
IVx = input('type your initial x velocity in m/s (recommended 0): ');
IVy = input(['type your initial y velocity in m/s (recommended 40100): ']);
tmin = input('type your initial time in s (recommended 0): ');
tmax = input('type your final time in s (recommended 3.74E8): ');


% ========================================================================================================
%             ODE45 FUNCTION
% ========================================================================================================
% [t,s]=ode45(@satmod,[tmin,tmax],[x(tmin),y(tmin),vx(tmin),vy(tmin)]);
% this returns the value of a system of 4 first-order ODEs.
[t,s]=ode45(@satmod,[tmin,tmax],[IPx,IPy,IVx,IVy]);
% where [tmin,tmax] represents the time elapsed (from zero seconds to one full jovian year in seconds: 3.74265E8).
% sidenote: the time for the space colony and jupiter to intersect = 4.396E7 seconds in this scenario.
% IPx = 1.51E11 which is the starting position of the satellite from the sun, in the y direction in meters. This can
% be changed, but we decided to start 0.01E9 meters above the Earth’s orbit
% in order to illustrate the escape, also since this would plot the center
% of the earth and not the surface. If this does change, the initial velocity 
% would have to increase if the starting position decreased (as it is closer to the sun), and vice-versa
% if it increases its starting position.
% IPy and IVx are the y position (m) and velocity (m/s) in the x position; these are starting at 0 in our scenario.
% IVy = 40100 which is the initial velocity in the y direction (m/s).



% -------------------------------------------------------------------------
THETA = (OMEGA*t)+theta; 
rj =  [cos(THETA) sin(THETA)]*orbj;
% these are the same expressions from the function above in order to call it when run outside of the function


% ======================================================================================================== 
%             PLOTTING THE ORBITS
% ======================================================================================================== 
whitebg([0 0 0]),axis vis3d, grid on;
%this sets up the figure to be black, to sort of simulate the "blackness"
%of space. the figure is not 3D but it restricts text from being stretched.


% -------------------------------------------------------------------------
set(gcf,'Color',[0 0 0]);
set(gca, 'XColor', [0.5 0.5 0.5], 'YColor', [0.5 0.5 0.5], 'ZColor', [0.5 0.5 0.5])
%these sets the color of the background and axes of the plot, to grey in
%this case.
% -------------------------------------------------------------------------


title('Model of Colony Leaving the Solar System','Color','w');
xlabel('x-position (m)','Color','w');
ylabel('y-position (m)','Color','w');
box on;
%these lines just set up the figure with the proper labels. box on displays
%the boundary of the graph, just a visual feature.


% -------------------------------------------------------------------------
hold on %TO YOUR HORSES
% -------------------------------------------------------------------------


plot(s(:,1),s(:,2),s(end,1),s(end,2),'wo','MarkerFaceColor',[1 1 1],'Color',[0 0.5 0.5]),axis equal, grid on;
% plots the orbit of the space colony with axis having the
% same aspect ratio in each direction. 
% s(:,1) and s(:,2) call upon all values 
% from the first and second column (x and y) of the space colony. 
% IPx,IPy, ‘ko’ define the x and y coordinate to plot a key (black) circle
% to indicate the starting position of the space colony.


% -------------------------------------------------------------------------
plot(orbj*cos(THETA),orbj*sin(THETA),'Color',[0.8 0.7 0.3]);
plot(rj(end,1),rj(end,2),'wo','MarkerFaceColor',[0.8 0.7 0.3]);
plot(ER*cos(THETA),ER*sin(THETA),'Color',[0 0.5 1]);
plot(0,0,'wo','MarkerFaceColor',[1 1 0]);
% plots the orbit of Jupiter and its location at the end of tmax
% where rj(end,1),rj(end,2),’go’ represent the final values at the end of its calculated
% vector in order to define an x and y coordinate, plotting a circle
% to indicate jupiter at the end of tmax
% along with a circle to indicate the sun
% -------------------------------------------------------------------------


text(rj(end,1),rj(end,2),' \leftarrowJupiter','FontSize',8);
text(s(end,1),s(end,2),' \leftarrowPierniczka','FontSize',8);
text(0,0,' \leftarrowSun','FontSize',8);
%the lines here labels the objects/plots above, just for reference.


% ========================================================================================================
%            FINAL VELOCITY
% ========================================================================================================
velocityx = s(end,3);
velocityy = s(end,4);
v = sqrt(velocityx^2 + velocityy^2);
disp(['Final velocity = ' num2str(v) 'm/s'])
% this calculates the final velocity in the x and y direction, in m/s
% and throws out the number in the command window. can be hidden
% by placing a semicolon at the end if not required.

% Captain Obvious: this ends the function
end
end


