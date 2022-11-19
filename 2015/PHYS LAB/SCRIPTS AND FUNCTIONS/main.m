%==========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREDETERMINED ASSIST PATH: FUNCTION MAIN() %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main()

% INITIALIZE GLOBAL PARAMETERS AND SOLVE CALCULATIONS:   
global n_bodies;
CelestialMechanics;
global tspan;
global y;
Y = y;
t = tspan;

% Setting up global parameters to use throughout the entirety of the
% function. Calls upon CelestialMechanics function and sets up variables y
% and tspan from the solution.


%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% INITIALIZING AXIS AND FIGURES ///////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

% PREPARE FIGURE:
F = figure('Color',[0 0 0]); %SET UP A BLACK FIGURE, WITH HANDLE F
set(F,'Visible','off'); %HIDE FIGURE (UNTIL LATER USE)
whitebg([0 0 0]); %REPLACE WHITE BG WITH BLACK BG
set(F,'color','k'); %JUST IN CASE (ie. MATLAB)


% SET UP RENDERER SETTINGS:
set(gcf,'Renderer','OpenGL');
opengl('hardware');
% A lot of computing power is required... we need the best, and only the
% best.

% SET UP AXIS:
a=axes; %HANDLE A
lim=5e12; %LIMITS OF AXIS (metres)
axis([-lim lim -lim lim -lim lim]); %SET AXIS LIMITS
axis equal %EQUAL AXIS *
set(a,'XTick',[],'XColor',[0.2 0.2 0.2]); %**
set(a,'YTick',[],'YColor',[0.2 0.2 0.2]); %**
set(a,'ZTick',[],'ZColor',[0.2 0.2 0.2]); %**
xlabel('x'); %m
ylabel('y'); %m
zlabel('z'); %m
view(3)
% Setting up the axis, hiding the tickers and making them darker just to
% make it look much more cleaner. I could've removed the axis entirely, but
% then it would be hard to judge the orientation. 

% * Comment out this line if you would like to see the true scale.
% ** Comment out these lines if you would like to include the axis.

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
% END OF INITIALIZING AXIS AND FIGURES ////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%==========================================================================


%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% 3D-MODELLING ////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% SET UP MODEL HANDLES:
hsun = hgtransform; %SUN
hmer = hgtransform; %MERCURY
hven = hgtransform; %VENUS
hear = hgtransform; %EARTH
hmar = hgtransform; %MARS
hjup = hgtransform; %JUPITER
hsat = hgtransform; %SATURN
hura = hgtransform; %URANUS (heh)
hnep = hgtransform; %NEPTUNE
hspa = hgtransform; %SPACE COLONY
hring = hgtransform; %SATURN'S RINGS

% These lines creates transform object handles for each object.


% CREATE 2 SPHERES:
[x y z]=sphere; %FOR THE PLANETS
[sx sy sz]=sphere; %FOR THE SUN
% See heading. If you want more detail, try sphere(x) where x > 20. Try
% sphere(100) for example. If you want a true scale, try sphere(6e6).
% This however kills the computer. But really, anything under sphere(250) 
% is good enough. This will slow down the speed of the output.


% CREATE 2 RINGS:
[RX,RY,RZ] = ringfn((2*140270e3)/2*250,37,131070e3*250,1000e3*250,1); 
%Rings of Saturn: http://en.wikipedia.org/wiki/Rings_of_Saturn
%See ringfn.m for more information on creating the disk and rings.

[SX,SY,SZ] = ringfn(2.5e8,100,1.5e8,0.25,2); 
%Space Colony... not to be confused with [sx sy sz]... 
%yeah it's easy to run out of things to name with...



sun=surface('xdata',sx,'ydata',sy,'zdata',sz,'facecolor','y','edgecolor', 'none', ...
        'parent',hsun,'FaceLighting','none','FaceColor','interp','AmbientStrength',1); %SUN

mercury = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','r','edgecolor','none','parent',hmer); %MERCURY
venus   = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','w','edgecolor','none','Parent',hven); %VENUS
earth   = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','b','edgecolor','none','Parent',hear); %EARTH
mars    = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','r','edgecolor','none','Parent',hmar); %MARS
jupiter = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','y','edgecolor','none','Parent',hjup); %JUPITER
saturn  = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','g','edgecolor','none','Parent',hsat); %SATURN
uranus  = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','w','edgecolor','none','Parent',hura); %haha
neptune = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','b','edgecolor','none','Parent',hnep); %NEPTUNE

ring = surf(RX,RY,RZ,'Parent',hring); %SATURN'S RINGS
spa = surf(SX,SY,SZ,'Parent',hspa); %SPACE COLONY



%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% END OF 3D-MODELLING /////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%==========================================================================



%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% TEXTURES ////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
texSUN = imread('sun.jpg');
texMER = imread('mercury.jpg');
texVEN = imread('venus.jpg');
texEAR = imread('earth.jpg');
texMAR = imread('mars.jpg');
texJUP = imread('jupiter.jpg');
texSAT = imread('saturn.jpg');
texURA = imread('uranus.jpg');
texNEP = imread('neptune.jpg');

texRING = imread('SaturnRings.png');
texSPA = imread('colony.jpg');
%MOST CAME FROM NASA 3D RESOURCES
%http://nasa3d.arc.nasa.gov/images
%ONE OR TWO CAME FROM GOOGLE...



set(sun,'facecolor','texture','cdata',flipud(texSUN),'edgecolor','none');    
set(mercury,'facecolor','texture','cdata',flipud(texMER),'edgecolor','none');         
set(venus,'facecolor','texture','cdata',flipud(texVEN),'edgecolor','none');                      
set(earth,'facecolor','texture','cdata',flipud(texEAR),'edgecolor','none');           
set(mars,'facecolor','texture','cdata',flipud(texMAR),'edgecolor','none');         
set(jupiter,'facecolor','texture','cdata',flipud(texJUP),'edgecolor','none');                     
set(saturn,'facecolor','texture','cdata',flipud(texSAT),'edgecolor','none');                     
set(uranus,'facecolor','texture','cdata',flipud(texURA),'edgecolor','none');              
set(neptune,'facecolor','texture','cdata',flipud(texNEP),'edgecolor','none');  

set(ring,'facecolor','texture','cdata',flipud(texRING),'edgecolor','none','FaceAlpha',1,'EdgeAlpha',0.2); 
set(spa,'facecolor','texture','cdata',texSPA,'edgecolor','none','FaceAlpha',1,'EdgeAlpha',0.0); 
%Applies the textures (flips upsidedown first) onto each corresponding
%sphere/body.
   
hold on
%Better safe than sorry.

ann = light('Position',[0 0 0],'Style','local','Color',[1 0.8 0.6]);
%Throw in a light source at the sun for a nice effect. not sure why it was
%declared as ann...

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% END OF TEXTURES /////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
%==========================================================================




%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% THE GOOD STUFF //////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

yr = [0.241 0.615 1.0 1.881 11.862 29.457 84.011 164.79 1.0];
% Sidereal period of the planets from Mercury to Neptune, and the Space
% Colony.


scale = [0.3 5 5 5 5 1.5 2.5 2.5 2.5 2.5]*10^2;
% scale of the planets. if you remove this, you'll see the actual relative
% size of the planets... or rather not see... yeah the planets are small...


radius = scale.*[695800 2440 6052 6371 3390 71492 60268 25560 24765 1]*10^3; %m
% radius of the sun and planets.

edeg = [0.034 177.3 23.45 25.19 3.12 26.73 97.86 29.56 0]*(pi/180); %rad
% obliquity of planets (deg2rad)

siderealh = 23.9344696; %hr
% sidereal day in hours, relative to the earth.

srotateday = [58.6462 -243.0185 (23.93419/siderealh)...
         (24.622962/siderealh) ((9+(55.5/60))/siderealh)...
         ((10+(39/60))/siderealh) (17.24/siderealh) (16.11/siderealh)]; %day
     
sorbitday = [87.969257 224.70079922 365.25636 686.98 4332.820 10755.698 30687.153 60190.029]; %day
rotyear = sorbitday./srotateday;
% conversions and whatnot. This kind of works for some planets, but other
% planets rotate so quickly that they just look like they're rotating
% slowly since the refresh rate can't keep up. Eh, it's pretty neat though.


%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% END OF THE GOOD STUFF ///////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
%==========================================================================




%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% ORBITAL PLOTS ///////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

for j=1:(n_bodies - 1);
orbit = plot3(Y(:,1+j*6)-Y(:,1),Y(:,2+j*6)-Y(:,2),Y(:,3+j*6)-Y(:,3),'r.');

set(orbit, {'LineStyle'}, {'.'});
set(orbit, {'Marker'}, {'none'});

p  = patchline(Y(:,1+j*6)-Y(:,1),Y(:,2+j*6)-Y(:,2),Y(:,3+j*6)-Y(:,3),'linestyle','-','edgecolor',[0.5 0.5 0.5],'linewidth',0.5,'edgealpha',0.2);
    if j == 9;
        set(p,'edgecolor',[0.5 0 0],'edgealpha',0.3)
    end
end

% This makes a plot of the orbits paths. Patchline function was found
% somewhere online, maybe here:
% http://www.mathworks.com/matlabcentral/fileexchange/36953-patchline
% Easier on the computer than plot, unless you're averaging the overall
% positions, then plot beats out patchline, which was used in the solar
% system function.



for j=1:(n_bodies - 1)
    planetx(:,j) = Y(:,1+j*6)-Y(:,1);
    planety(:,j) = Y(:,2+j*6)-Y(:,2);
    planetz(:,j) = Y(:,3+j*6)-Y(:,3);

    for i = 1:numel(planetx(:,j))-1;
    planx{j}(:,i) = linspace((planetx(i,j)),(planetx(i+1,j)));
	plany{j}(:,i) = linspace((planety(i,j)),(planety(i+1,j)));
    planz{j}(:,i) = linspace((planetz(i,j)),(planetz(i+1,j)));
    end
    
    planx{j} = reshape(planx{j},[],1);
    plany{j} = reshape(plany{j},[],1);
    planz{j} = reshape(planz{j},[],1);

    newsize = length(planx{j})*yr(j);
    oldsize = length(planx{j});

    cut = 500;

    planx{j} = planx{j}(1:cut:end);
    plany{j} = plany{j}(1:cut:end);
    planz{j} = planz{j}(1:cut:end);
end

% Alright so this is like a good chunk of the computation but I don't 100%
% recall the steps took. it's somewhere in the mess of files with the rough
% work, but from what I recall I had an issue with the inner planets
% orbiting too fast to see relative to the outer planets, since one orbit
% for say, Jupiter, would compare to at least 45 orbits for Mercury. Having
% them move at different speeds would kinda make things look pretty odd, so
% after some serious tweaking around, I found a way to get around this
% issue by essentially normalizing the number of indices of each planet(ie.
% solutions determined through the ode function indexes the [X,Y,Z] for
% each planet at each step t. It then reshapes the matrices all into the
% same size and tacks on the orbital period of each planet so that the
% resulting transform identity will be the same size for each planet,
% despite having different orbital period. This has them taking different 
% paths at different rates but fast enough that it is still accurate
% relative to each planet, but slow enough that you can actually see each
% planet.


%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% END OF ORBITAL PLOTS ////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
%==========================================================================




%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% VELOCITY CALCULATIONS ///////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% INITIAL VELOCITIES:
vxi = Y(1,end-2); %m/s
vyi = Y(1,end-1); %m/s
vzi = Y(1,end); %m/s
vi = sqrt(vxi^2 + vyi^2 + vzi^2); %resultant velocity, m/s

% vx = Y(:,end-2);
% vy = Y(:,end-1);
% vz = Y(:,end);

% FINAL VELOCITIES (@ t_final)
vxf = Y(end,end-2); %m/s
vyf = Y(end,end-1); %m/s
vzf = Y(end,end); %m/s
vf = sqrt(vxf^2 + vyf^2 + vzf^2); %resultant, m/s


% USING THE PREDETERMINDED PATH, DISPLAY THESE RESULTS:
disp(['Initial velocity at time t = ' num2str(tspan(1)) ' (years) = ' num2str(vi/1000) 'km/s']);
disp('');
disp('');
disp('');
disp('');
disp('                                                 vx            vy            vz             v_total')
disp(['Velocity just before gravitational assist:  -22.751km/s    -0.095km/s     0.631km/s        22.754km/s']);
disp('');
disp(['Velocity just after  gravitational assist:   51.940km/s    23.691km/s     0.358km/s        57.089km/s']);
disp('');
disp([char(916) 'V:                                          74.691km/s    23.786km/s    -273.3km/s        34.335km/s']);
disp('');
disp(' ');
disp(' ');
disp(['Final velocity ' num2str(tspan(end)/3.15569e7) ' years after launch: ' num2str(vf/1000) 'km/s'])

%pause(10) 
%uncomment pause if there are any issues seeing the display.

%Would have done energy calculations, but started running out of time, and
%I did get a bit carried away.

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% END OF VELOCITY CALCULATIONS ////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
%==========================================================================




%==========================================================================
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% ANIMATION ///////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

 set(F,'Visible','on'); 
 % to go fullscreen automatically, replace the ); above with the following:
 %,'units','normalized','outerposition',[0 0 1 1]);

    

for i = 1:length(planx{1}); % animate over total time period
    
% SET UP TRANSFORM MATRICES:
    for j = 1:(n_bodies - 1) % consider each body
    trans{j} = makehgtform('translate',[planx{j}(i) plany{j}(i) planz{j}(i)]); %translation
    rotz{j} = makehgtform('xrotate',edeg(j)); %rotation
    scal{j} = makehgtform('scale',radius(j+1)); %scale up the spheres
    end
    %See: http://matlab.izmiran.ru/help/techdoc/ref/hgtransform.html
    
% APPLY TRANSFORM MATRICES:
     set(hsun,'Matrix',makehgtform('scale',radius(1))); %SUN
     set(hmer,'Matrix',trans{1}*rotz{1}*scal{1}); %MERCURY
     set(hven,'Matrix',trans{2}*rotz{2}*scal{2}); %VENUS
     set(hear,'Matrix',trans{3}*rotz{3}*scal{3}); %EARTH
     set(hmar,'Matrix',trans{4}*rotz{4}*scal{4}); %MARS
     set(hjup,'Matrix',trans{5}*rotz{5}*scal{5}); %JUPITER
     set(hsat,'Matrix',trans{6}*rotz{6}*scal{6}); %SATURN
     set(hura,'Matrix',trans{7}*rotz{7}*scal{7}); %IMMATURITY
     set(hnep,'Matrix',trans{8}*rotz{8}*scal{8}); %NEPTUNE
     set(hspa,'Matrix',trans{9}*rotz{9}); %SPACE COLONY
     set(hring,'Matrix',trans{6}*rotz{6}); %SATURN'S RINGS
     
% ROTATATION OF THE OBJECTS:
     rotate(sun,[0 0 1],1,[0 0 0]); 
     rotate(mercury,[0,0,1],rotyear(1),[0 0 0]);
     rotate(venus,[0,0,1],rotyear(2),[0 0 0]);   
     rotate(earth,[0,0,1],rotyear(3),[0 0 0]);
     rotate(mars,[0,0,1],rotyear(4),[0 0 0]);   
     rotate(jupiter,[0,0,1],rotyear(5),[0 0 0]);
     rotate(saturn,[0,0,1],rotyear(6),[0 0 0]);   
     rotate(uranus,[0,0,1],rotyear(7),[0 0 0]);
     rotate(neptune,[0,0,1],rotyear(8),[0 0 0]);   
     rotate(ring,[0,0,1],rotyear(6),[0 0 0]);   
     rotate(spa,[0,0,1],5,[0 0 0]);

% FOLLOW THE SPACE COLONY DURING FLIGHT:
         camtarget([planx{9}(i) plany{9}(i) planz{9}(i)])
        if i == 1
            zoom(4092) %Zoom!
        end    

% DISPLAY TIME STATISTICS:
timer(i) = tspan(i)/3.15569e7*(cut/100);
str = {'Time since Launch:' num2str(timer(i),'%0.2f years')};
ann = annotation('textbox',[0.75 0.0 0.1 0.1],'String',str,'HorizontalAlignment','center');

% LIFTOFF!
         drawnow
         
% and redraw timer...
         if i < length(planx{1});
          delete(ann)
         end
end



% ROTATE OBJECTS IN PLACE FOREVER:
% HIT CTRL+C IN THE COMMAND WINDOW TO KILL ANIMATION.
% DID MAKE A UICONTROL BUTTON, BUT BUGGY & I'VE ALREADY DONE TOO MUCH...
for ang = 1:0.1:inf
     rotate(sun,[0 0 1],1,[0 0 0]); 
     rotate(mercury,[0,0,1],rotyear(1),[0 0 0]);
     rotate(venus,[0,0,1],rotyear(2),[0 0 0]);   
     rotate(earth,[0,0,1],rotyear(3),[0 0 0]);
     rotate(mars,[0,0,1],rotyear(4),[0 0 0]);   
     rotate(jupiter,[0,0,1],rotyear(5),[0 0 0]);
     rotate(saturn,[0,0,1],rotyear(6),[0 0 0]);   
     rotate(uranus,[0,0,1],rotyear(7),[0 0 0]);
     rotate(neptune,[0,0,1],rotyear(8),[0 0 0]);   
     rotate(ring,[0,0,1],rotyear(6),[0 0 0]);   
     rotate(spa,[0,0,1],5,[0 0 0]);
     drawnow
end
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
% END OF ANIMATION ////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
%==========================================================================
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF FUNCTION MAIN() %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==========================================================================


