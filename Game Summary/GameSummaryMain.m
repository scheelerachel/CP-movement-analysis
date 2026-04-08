% GameSummaryMain.m
%
% Rachel Scheele
% Last Edited 11/13/2025

% NOTES:
% 264 pixels per inch (ppi)
% 25.4 mm/in
% screen resolution: 2732 x 2048
% Conversion factor: (25.4/264)*(2732/1366) = (127/660)
%
% Maybe change figures save to png? <- might be better
% should calculate difference from ideal path raw number (accuracy) - in RMS
% run game summay for all participants
% orbital reaching systematic differences: planet location and crossing midline

% Clean workspace and command window
clear;
close all;
clc;

%% Load demographics
user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
    'University'], ['Documents - Pediatric Movement and ' ...
    'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

try
    fileBD = fullfile(filepath,'Data\R21_BehavioralData');
    data = readtable(fileBD);
catch
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    fileBD = fullfile(filepath,'Data\R21_BehavioralData');
    data = readtable(fileBD);
end

ID = string(table2cell(data(:,1)));
cp = string(table2cell(data(:,2)));
nonprefhand = string(table2cell(data(:,3)));
prefhand = string(table2cell(data(:,4)));
age = table2cell(data(:,5));

hand_l = string(length(ID));
hand_r = string(length(ID));

for i = 1:length(ID)
    if cp(i) == "UCP"
        if prefhand(i) == "Left"
            hand_l(i) = "Less Affected";
            hand_r(i) = "More Affected";
        elseif prefhand(i) == "Right"
            hand_r(i) = "Less Affected";
            hand_l(i) = "More Affected";
        else
            hand_r(i) = "NONE";
            hand_l(i) = "NONE";
            fprintf("No handedness data for %s\n",ID(i))
        end
    elseif cp(i) == "TD"
        if prefhand(i) == "Left"
            hand_l(i) = "Dominant";
            hand_r(i) = "Non-Dominant";
        elseif prefhand(i) == "Right"
            hand_r(i) = "Dominant";
            hand_l(i) = "Non-Dominant";
        else
            hand_r(i) = "NONE";
            hand_l(i) = "NONE";
            fprintf("No handedness data for %s\n",ID(i))
        end
    else
        hand_r(i) = "NONE";
        hand_l(i) = "NONE";
    end
end

hand_l = hand_l';
hand_r = hand_r';

%% Load game data
number = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
participant = append('MHEALTH',number);
matfile = append(participant,'.mat');
fileI = fullfile(filepath,'Data\Game Data\Individual\');
fileGDI = fullfile(fileI,matfile);
data = load(fileGDI);

AB = data.AsteroidBelt;
OR = data.SolarReaching;
AN = data.AsteroidNinja;
AE = data.AlienEncounter;

%% Select correct demographics for selected participant
for i = 1:length(ID)
    if ID(i) == participant
        left_hand = hand_l(i);
        right_hand = hand_r(i);
    end
end

% Filepath and filename
fileGDA = fullfile(filepath,'Analysis\Analyzed Game Data');
filename = participant;

%% Run game summary
% AsteroidBeltMain(AB,left_hand,right_hand,fileGDA,filename)
% OrbitalReachingMain(OR,left_hand,right_hand,fileGDA,filename)
% AsteroidNinjaMain(AN,left_hand,right_hand,fileGDA,filename)
AlienEncounterMain(AE,left_hand,right_hand,fileGDA,filename)

% close all figures
close all