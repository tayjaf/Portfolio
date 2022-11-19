% =========================================================================
% |  WELCOME TO THE SOLAR SYSTEM & JOVIAN GRAVITATIONAL ASSIST SIMULATOR  |
%        Tayyab Jafar [ 10052661 ]    -   Kevan Rayner [ 10055256 ]
% =========================================================================
function GravitationalAssist()
%This is a heap of mess, so our apologies in advance. We have done our best
%to explain each portion of the code, and there may also be some
%redundancy. There are so many different techniques used since Matlab isn't
%really meant for this type of computer analysis, we've done our best to
%reference those techniques as well, (eg. ring function). Hope you enjoy!


% -------------------------------------------------------------------------
clear
clc
close all
close all hidden
%These command clear the workspace of any pre-existing variables currently
%in the workspace, and in case other plots are open. This is required since
%MATLAB WILL eat up a lot of memory in the in the background if you run 
%this simulator multiple times. It's good practice as well.
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% used to begin global variables required to direct the script given a
% certain input in the menu
op=0; clc
% ends global variables
% -------------------------------------------------------------------------


% User Menu Begins
while op~=4
disp ('WELCOME TO THE SOLAR SYSTEM & JOVIAN GRAVITATIONAL ASSIST SIMULATOR')
disp ('by Tayyab Jafar and Kevan Rayner')
disp (' ')
disp (' ')
disp ('If you would like to see the gravitational assist in action, press 1.')
disp ('If you would like to see the solar system, press 2.')
disp ('If you would not like to see anything, stare at the sun, or hit 3.')
disp (' ')
disp('1)Gravity Assist')
disp('2)Solar System')
disp('3)Exit')
op = input ('Please choose an option: ');
disp (' ')
% User Menu Ends


% -------------------------------------------------------------------------
switch op
    case 1 %Default     
        main
break
    case 2 %Custom Orbit
        solar
        break
    case 3 %break
        return
    otherwise
        disp('THAT WAS NOT AN OPTION!')
        pause(2);
        disp('TRY AGAIN.')
        pause(3);
        GravitationalAssist
% if case 1 is inputted, it will run the default model function,
% and custom model for case 2. If any other options are chosen, it will end
% the function via the break command.
% -------------------------------------------------------------------------


end
end



end