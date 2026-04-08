% PopulationAnalysis.m
%
% Rachel Scheele
% Last Edited 8/25/2025

% Need script to:
% group all data in one structure

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
    dem = readtable(fileBD);
catch
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    fileBD = fullfile(filepath,'Data\R21_BehavioralData');
    dem = readtable(fileBD);
end

ID = string(table2cell(dem(:,1)));
cp = string(table2cell(dem(:,2)));
nonprefhand = string(table2cell(dem(:,3)));
prefhand = string(table2cell(dem(:,4)));
age = table2array(dem(:,5));
chronage = table2array(dem(:,31));
sex = string(table2cell(dem(:,19)));

%% create structure for all data
game_data_all = struct('ID',{},'Diagnosis',{},'NonPrefered_Hand',{}, ...
    'Prefered_Hand',{},'Age',{},'Chron_Age',{},'Sex',{},'Asteroid_Belt',{}, ...
    'Orbital_Reaching',{},'Asteroid_Ninja',{},'Alien_Encounter',{});

for i = 1:length(age)
    game_data_all(i).ID = ID(i);
    game_data_all(i).Diagnosis = cp(i);
    game_data_all(i).NonPrefered_Hand = nonprefhand(i);
    game_data_all(i).Prefered_Hand = prefhand(i);
    game_data_all(i).Age = age(i);
    game_data_all(i).Chron_Age = chronage(i);
    game_data_all(i).Sex = sex(i);
end

% Load AB data into whole population struct
folderAB = fullfile(filepath, 'Analysis\Analyzed Game Data\Asteroid Belt Individual');
filesAB = dir(fullfile(folderAB, '*.mat'));

for i = 1:length(filesAB)
    temp = load(fullfile(folderAB, filesAB(i).name));
    varName = fieldnames(temp);
    varName = varName{1};
    name = string(varName(1:10));
    ind = find(ID == name);
    game_data_all(ind).Asteroid_Belt = temp;
end

% Load OR data into whole population struct
folderOR = fullfile(filepath, 'Analysis\Analyzed Game Data\Orbital Reaching Individual');
filesOR = dir(fullfile(folderOR, '*.mat'));

for i = 1:length(filesOR)
    temp = load(fullfile(folderOR, filesOR(i).name));
    varName = fieldnames(temp);
    varName = varName{1};
    name = string(varName(1:10));
    ind = find(ID == name);
    game_data_all(ind).Orbital_Reaching = temp;
end

% Load AN data into whole population struct
folderAN = fullfile(filepath, 'Analysis\Analyzed Game Data\Asteroid Ninja Individual');
filesAN = dir(fullfile(folderAN, '*.mat'));

for i = 1:length(filesAN)
    temp = load(fullfile(folderAN, filesAN(i).name));
    varName = fieldnames(temp);
    varName = varName{1};
    name = string(varName(1:10));
    ind = find(ID == name);
    game_data_all(ind).Asteroid_Ninja = temp;
end

% Load AE data into whole population struct
folderAE = fullfile(filepath, 'Analysis\Analyzed Game Data\Alien Encounter Individual');
filesAE = dir(fullfile(folderAE, '*.mat'));

for i = 1:length(filesAE)
    temp = load(fullfile(folderAE, filesAE(i).name));
    varName = fieldnames(temp);
    varName = varName{1};
    name = string(varName(1:10));
    ind = find(ID == name);
    game_data_all(ind).Alien_Encounter = temp;
end

for i = length(game_data_all):-1:1
    if game_data_all(i).ID == ""
        game_data_all(i) = [];
    end
end

save('population_game_data.mat', 'game_data_all')