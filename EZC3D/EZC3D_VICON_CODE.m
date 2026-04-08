% set up
clear
clc

% testing
% import c3d file
[file,location] = uigetfile('*.c3d');
c3d = ezc3dRead(fullfile(location,file));
disp(c3d.parameters.POINT.USED.DATA); % Print the number of points used

% (X,Y,Z)x(# markers)x(# frames)
marker_data = c3d.data.points; % pulls data into workspace from struct

% time
framerate = c3d.header.points.frameRate;
numframes = c3d.header.points.lastFrame - c3d.header.points.firstFrame;
time = numframes/framerate;
disp(time); % Print the total time in seconds

% start time for syncronization
%framerate = c3d.header.

% % plot
fprintf('%% ---- DATA ---- %%\n');
fprintf('See figures\n');
frameToPlot = 1;
figure('Name', '3d-Points');
plot3(c3d.data.points(1,:,frameToPlot), ...
      c3d.data.points(2,:,frameToPlot), ...
      c3d.data.points(3,:,frameToPlot), 'k.'); 
axis equal

save c3d.mat