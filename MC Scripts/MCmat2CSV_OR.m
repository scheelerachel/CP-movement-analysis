% MCmat2CSV_OR.m
%
% Rachel Scheele
% Last Edited 3/19/2026

% Need script to:
% Convert the .mat MC data into CSV to import into Vicon Nexus and turn
% into c3d file for kinematic evaluation with biomechZoo

% Clean workspace and command window
clear;
close all;
clc;

%% Load File
user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
'University'], ['Documents - Pediatric Movement and ' ...
'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

if exist(filepath, 'dir')==0
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
end

number = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
participant = append('MHEALTH',number);

folder = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');

%% Run function and save V1
parsefile = append(participant,'_ParsedDataOR');
matfile = append(parsefile,'.mat');
MCPfile = fullfile(folder,matfile);
data = load(MCPfile);

svas = fullfile(folder,participant,'OR');
%exportAllTRC(data.(parsefile), frameRate, svas)
exportAllCSV(data.(parsefile), svas);

% %% Run function and save V2
% parsefile = append(participant,'_V2ParsedDataOR');
% matfile = append(parsefile,'.mat');
% MCPfile = fullfile(folder,matfile);
% data = load(MCPfile);
% 
% svas = fullfile(folder,participant,'OR','V2');
% %exportAllTRC(data.(parsefile), frameRate, svas)
% exportAllCSV(data.(parsefile), svas);