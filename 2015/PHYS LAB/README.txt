Google Drive has been an issue, so the html format isn't happening.

============================================================================================
WHAT SHOULD YOU KNOW?
I am rushing this last bit to hand in, since I feel like I've gone a little too far with this assignment. You can start to tell where this happens in the write-up. My apologies! Feel free to take off marks for disorganization!

I also like to write in first person, but I promise Kevan did help! Just assume I = we.

============================================================================================

BEFORE YOU USE:

1) You've already unzipped the folder, so good start.
2) Open up the scripts and functions folder, and open up MATLAB.
3) Type into the command window:
	opengl('hardware')
Once Busy... disappears, type this next:
	opengl info

You should then see a few lines, Version, Vender, etc. 

Third or fourth line down will say "MaxTextureSize". 

Grab a calculator and divide that number by 1024. If the result is greater than 8, you should be good to run the script. If it is less than 8, there may be a possibility the simulator will not run on your computer. In that case, let me know and I'll do my best to fix it up for you.

============================================================================================

HOW TO USE:


HIERARCHY OVERVIEW:
Gravitational Assist ---> CelestialMechanics ---> main/solar
	|			|
 	|---> ringfn		|---> velocitystuff
	|---> rotate
	|---> patchline

Hope this helps to understand.

1) Open up the SCRIPTS AND FUNCTIONS folder in MATLAB
2) Run GravitationalAssist.m
3) Follow the prompt.

tsolar/ysolar.mat are precalculations if you choose to open the solar system model. This is because it takes a long time, so that 60MB of data has been done for you. It may take a minute or two to run, don't click anything in the mean time.

ringfn, patchline and rotate were found online to do their respective jobs. Rotate.m is included because the built-in MATLAB rotation is bugged.

VelocityStuff just has things I was doing but didn't have time to progress any further. 

============================================================================================
"Process" images are just some examples of what I have done in chronological order. Not everything is included, since my MATLAB folder is now over 1GB (mostly from the animations but a lot of scipt testing as well).

Parts 1-4.gif are just examples of the model so you don't have to run it several times.
============================================================================================

Hope you enjoy! I've also included 2014's lab last year if you're curious! :)
