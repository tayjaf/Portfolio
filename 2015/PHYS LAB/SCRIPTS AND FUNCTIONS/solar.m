%==========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOLAR SYSTEM MODEL: FUNCTION SOLAR() %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function solar()
   

%Straight up copy off of the main function but the runtime for the ode is
%for one full Neptune year, which is saved into the .mat file that is read
%so it skips the process of running the ode solver and saves a lot of time.
%The other model is simply for a year or two so it's not too taxing on the
%computer. See function main() for comments.


n_bodies = 9;


%t = importdata('tsolar.mat'); %Not needed.
y = importdata('ysolar.mat');
Y = y;
tspan=[0:0.001:164.79]; 
t = tspan;


F = figure('Color',[0 0 0]);
set(F,'Visible','off');
whitebg([0 0 0]);
set(gcf,'color','k');
lim=5e12;

set(gcf,'Renderer','OpenGL');
opengl('hardware')
a=axes;
axis([-lim lim -lim lim -lim lim]);
axis equal
set(a,'XTick',[],'XColor',[0 0 0])
set(a,'YTick',[],'YColor',[0 0 0])
set(a,'ZTick',[],'ZColor',[0 0 0])
xlabel('x');
ylabel('y');
zlabel('z');
view(3)



hsun = hgtransform;
hmer = hgtransform;
hven = hgtransform;
hear = hgtransform;
hmar = hgtransform;
hjup = hgtransform;
hsat = hgtransform;
hura = hgtransform;
hnep = hgtransform;
hring = hgtransform;



scale=[0.3 5 5 5 5 1.5 2.5 2.5 2.5]*10^2;


radius = scale.*[695800 2440 6052 6371 3390 71492 60268 25560 24765]*10^3; %m


[x y z]=sphere;
[sx sy sz]=sphere;


[RX,RY,RZ] = ringfn((2*140270e3)/2*250,37,131070e3*250,1000e3*250,1); 



sun=surface('xdata',sx,'ydata',sy,'zdata',sz,'facecolor','y','edgecolor', 'none', ...
        'parent',hsun,'FaceLighting','none','FaceColor','interp','AmbientStrength',1); %sun

mercury = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','r','edgecolor','none','parent',hmer); %mercury
venus   = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','w','edgecolor','none','Parent',hven); %venus
earth   = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','b','edgecolor','none','Parent',hear); %earth
mars    = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','r','edgecolor','none','Parent',hmar); %mars
jupiter = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','y','edgecolor','none','Parent',hjup); %jupiter
saturn  = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','g','edgecolor','none','Parent',hsat); %saturn
uranus  = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','w','edgecolor','none','Parent',hura); %haha
neptune = surface('xdata',x,'ydata',y,'zdata',z,'facecolor','b','edgecolor','none','Parent',hnep); %neptune

ring = surf(RX,RY,RZ,'Parent',hring); %saturns rings



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

   
hold on


ann = light('Position',[0 0 0],'Style','local','Color',[1 0.8 0.6]);



yr = [0.241 0.615 1.0 1.881 11.862 29.457 84.011 164.79];



for j=1:(n_bodies - 1);
orbit = plot3(Y(:,1+j*6)-Y(:,1),Y(:,2+j*6)-Y(:,2),Y(:,3+j*6)-Y(:,3),'Color',[0.1 0.1 0.1]);
end



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


set(F,'Visible','on'); 

     
edeg = [0.034 177.3 23.45 25.19 3.12 26.73 97.86 29.56 0]*(pi/180);


siderealh = 23.9344696;

srotateday = [58.6462 -243.0185 (23.93419/siderealh)...
         (24.622962/siderealh) ((9+(55.5/60))/siderealh)...
         ((10+(39/60))/siderealh) (17.24/siderealh) (16.11/siderealh)];
     
sorbitday = [87.969257 224.70079922 365.25636 686.98 4332.820 10755.698 30687.153 60190.029];
rotyear = sorbitday./srotateday;


handles.pausebutton = uicontrol(F,'Style', 'togglebutton','String','Pause');
     set(F,'toolbar','figure')
     zoom(512)
for i = 1:length(planx{1});
    for j = 1:(n_bodies - 1)
    trans{j} = makehgtform('translate',[planx{j}(i) plany{j}(i) planz{j}(i)]);
    rotz{j} = makehgtform('xrotate',edeg(j));
    scal{j} = makehgtform('scale',radius(j+1));
    end
    
     set(hsun,'Matrix',makehgtform('scale',radius(1)));
     set(hmer,'Matrix',trans{1}*rotz{1}*scal{1});
     set(hven,'Matrix',trans{2}*rotz{2}*scal{2});
     set(hear,'Matrix',trans{3}*rotz{3}*scal{3});
     set(hmar,'Matrix',trans{4}*rotz{4}*scal{4});
     set(hjup,'Matrix',trans{5}*rotz{5}*scal{5});
     set(hsat,'Matrix',trans{6}*rotz{6}*scal{6});
     set(hura,'Matrix',trans{7}*rotz{7}*scal{7});
     set(hnep,'Matrix',trans{8}*rotz{8}*scal{8});
     set(hring,'Matrix',trans{6}*rotz{6});
     

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

drawnow

needpause = get(handles.pausebutton,'Value');
  if needpause
    unpause = input('Type "r" and hit enter to resume:   ','s');
    set(handles.pausebutton,'Value',0)
  end

end







end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF FUNCTION SOLAR() %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==========================================================================