%% ORIGINAL DESCRIPTION
% UL_kinematics_main demonstrates how to compute lower-limb 
% (ankle, knee, hip) joint kinematics using the kinemat toolbox of Reinschmidt 
% and Van den Bogert
%
% Usage: Computing joint kinematics allows for an understanding of how body segments move in 
% relation to each other.  
%
% Example: The files in our example data folder (~/examples/example data) contain marker data 
% affixed to body segments. Use these markers to compute ankle kinematics using the kinemat 
% toolbox functions and compare to existing PiG angle outputs
%
%
% See also bmech_kinematicsRvdB,  bmech_kinematics, kinematicsRvdB_data, kinematics_data

%% NEW DESCRIPTION
% This file was modified to analyze kinematics of the upper limb (shoulder,
% elbow, wrist). Input data are .trc files of pre-processed Vicon marker
% data. 


% Initialization %
clc
close all
clear variables
initalpath = pwd;

try 
   mainpath='C:\Users\nemanichs\OneDrive - Marquette University\PMNL Teams Site\R21_mHealthApp\Analysis\biomechZoo\biomechZoo-master-UL';
   %addpath(mainpath);
    if ~exist('C:\Users\nemanichs\OneDrive - Marquette University\PMNL Teams Site\R21_mHealthApp\Analysis\biomechZoo\biomechZoo-master-UL')
        mainpath=fullfile('C:\Users\', user, 'OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Analysis\biomechZoo\biomechZoo-master-UL');
    end
    addpath(mainpath);

catch
    mainpath=uigetdir(pwd, 'Select the main biomech Zoo analysis path');
    addpath(mainpath);
end

startZoo;
addpath(mainpath);

time = 2; 
fld = uigetdir(pwd, 'Select directory containing motion capture data');
cd(fld);
pause(time)


% Info %
%
disp('Elbow kinematics represent the movement of the forearm relative to the upper arm')
disp(' ')
disp('We need to identify at least three markers to define each segment:')
disp('Define: ''Clavicle'':')
%Clavicle={'C7', 'SHO', 'UPA'};
Clavicle = {'UPA','SHO','CLAV'};
disp(Clavicle);
disp('Defnine ''Upper Arm'':')
UpperArm  = {'SHO','UPA','ELB'};                                            % for kinemat
disp(UpperArm);
disp('Define: ''ForeArm'':')
ForeArm = {'WristJC','FRM','ELB'};
disp(ForeArm)
disp('Define: ''Hand'':')
%Hand = {'HND', 'WristJC','FRM'};
Hand = {'HND', 'WristJC','WRB'};
disp(Hand)
pause(time)

% Convert .c3d files to .zoo files %
disp (' ');
disp ('Converting data from csv to zoo if necessary...  ');

Stac3dfiles=cellstr(ls('*Static*.c3d'));                                    % Note-change file naming convention as needed
Stazoofiles=cellstr(ls('*Static*.zoo'));

                    
tempfile=Stac3dfiles{1};
filesplit=split(tempfile, 'c3d');
filepre=filesplit{1};
if ~contains(Stazoofiles, filepre)
     disp(' ');
     disp(['Converting ', tempfile, 'to zoo..']);
     c3d2zoo(fld);
end


Dyncsvfiles=cellstr(ls('trial*.csv'));                                      % Note-change file naming convention as needed
Dynzoofiles=cellstr(ls('trial*.zoo'));

tempfile=Dyncsvfiles{1};
filesplit=split(tempfile, '.csv');
filepre=filesplit{1};


if ~any(contains(Dynzoofiles, filepre))
     disp(' ');
     disp(['Converting ', tempfile, 'to zoo..']);
     csv2zooVicon(fld);
end


disp(' ')
pause(time);


% Process %
%
disp('kinemat processing requires both static and dynamic trials to compute kinematics')
disp(' ')
disp('We will load a subject for which both these trials are available:')
pause(time)



% Load files and process per file % 

for nfile=1:length(Dynzoofiles)
    tempfile=Dynzoofiles{nfile};
    filesplit=split(tempfile, '.zoo');
    filepre=filesplit{1};

    flSta = engine('path',fld,'extension','zoo', 'search file', 'static_trial');
    
    if nfile<10
        flDyn = engine('path',fld,'extension','zoo', 'search file', ['trial_0', num2str(nfile)]);
    else
        flDyn = engine('path',fld,'extension','zoo', 'search file', ['trial_', num2str(nfile)]);
    end


    if exist(['trial_0', num2str(nfile), '_L side kinematics.fig'])>0 && nfile<10

    elseif exist(['trial_', num2str(nfile), '_L side kinematics.fig'])>0 && nfile>=10

    else

    batchdisp(flSta{1},' ')
    batchdisp(flDyn{1},' ')
    disp(' ')
    % Revise to do batch trial processing
    sdata = zload(flSta{1});
    data  = zload(flDyn{1});
    pause(time)
    
    % Process %
    % 
    
    addpath(initalpath);
    
    sequence = 'yxz';
    disp('We must define the cardan sequence to use for computation, we choose ''sequence = yxz'':')
    disp(' ')
    disp(' ')
    pause(time)
    
    disp('We call the function as ''kinematicsRvdB_data(sdata,data,Clavicle,UpperArm,ForeArm,Hand,sequence,test)''')
    test = true;
    disp('The function will produce plots when test = true')
    disp(' ')
    [data] = kinematicsRvdB_data_UL(sdata,data,Clavicle,UpperArm,ForeArm,Hand,sequence,test);
    disp(' ')
    pause(time)
    
    
    
    % Final output to user %
    disp('Explore the figures...')
    disp(' ')
    disp('A processed file was loaded into the workspace...')
    disp(' ')
    disp('Explore the file by double clicking on ''data'' or by typing ''data'' in the command window')
    
    [~,fname,~]=fileparts(flDyn{1});
    
    % Save data structure
    filesv = append(filepre,'.mat');
    save(filesv, 'data');
    
    
    clear flDyn flSta sdata data sequence fname

    end
      
    
end
