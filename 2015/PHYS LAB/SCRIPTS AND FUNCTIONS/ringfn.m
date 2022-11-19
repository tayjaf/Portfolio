function [X,Y,Z] = ringfn(ringradius,ringnDiv,cswidth,csheight,i)
% http://stackoverflow.com/questions/27668343/3d-ring-in-matlab-using-patch
% We initially made our own cylinders with the built in Matlab function,
% and plotted an image above, below and on the face of the cylinder. This
% however took up a lot of usage. Later on we found a much more effective
% method using the patch function, described in the link above. This just
% combined some of our code with the code exampled above and with some
% refining, introducing the space colony + saturns rings had minimal effect
% on the runtime of the simulation.


ring.theta  = linspace(0,2*pi,ringnDiv) ;
ring.X = cos(ring.theta) * ringradius;
ring.Y = sin(ring.theta) * ringradius;

if i == 1
    Npts = 4 ;

    %// first cross section is the the XZ plane
    AY0 = zeros(1,Npts) ;                        %// will be used as base for rotating cross sections
    AX = [-cswidth/2 cswidth/2 cswidth/2 -cswidth/2 ]  ;
    AZ = [-csheight/2 -csheight/2 csheight/2 csheight/2] ;


elseif i == 2

    A.radius = cswidth;
    A.rout = csheight;
    A.Ndiv = 100 ; % 
    A.theta = linspace(0,2*pi,A.Ndiv) ;
    Npts = length(A.theta) ;

    %// first cross section is the the XZ plane
    AY0 = zeros(1,Npts) ;  %// will be used as base for rotating cross sections
    AX = sin(A.theta) * A.radius ;
    AZ = cos(A.theta) * A.radius ;

end

nCS = length(ring.X) ; %// number of cross sections composing the surface

%// pre-allocation is always good
X = zeros( nCS , Npts ) ;
Y = zeros( nCS , Npts ) ;
Z = zeros( nCS , Npts ) ;

for ip = 1:nCS
   %// rotate the cross section (around Z axis, around origin)
   Rmat = [ cos(ring.theta(ip))  -sin(ring.theta(ip))    ; ...
            sin(ring.theta(ip))   cos(ring.theta(ip))   ] ;
   csTemp = Rmat * [AX ; AY0]  ;

   %// translate the coordinates of cross section to final position and store with others 
   X(ip,:) = csTemp(1,:) + ring.X(ip) ;
   Y(ip,:) = csTemp(2,:) + ring.Y(ip) ;
   Z(ip,:) = AZ  ;
end

end