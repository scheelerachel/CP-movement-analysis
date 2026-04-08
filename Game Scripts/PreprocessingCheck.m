% PreprocessingCheck.m
%
% Rachel Scheele
% Last Edited 8/25/2025

% Need script to:
% Determine if any participant has missing/incomplete/extra/wrong data

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

%% create structure for data check
game_data_check = struct('ID',{},'Asteroid_Belt',{}, ...
    'Orbital_Reaching',{},'Asteroid_Ninja',{},'Alien_Encounter',{});
ID = ID(ID ~= "");
for i = 1:length(ID)
    game_data_check(i).ID = ID(i);
end

% For each game - good/review/not imported

%% Load data into cell array for AB
folderAB = fullfile(filepath, 'Analysis\Analyzed Game Data\Asteroid Belt Individual');
filesAB = dir(fullfile(folderAB, '*.mat'));

ABdata = cell(1, length(filesAB));

for i = 1:length(filesAB)
    temp = load(fullfile(folderAB, filesAB(i).name));
    varName = fieldnames(temp);
    ABdata{i} = temp.(varName{1});  % Store struct inside cell
end

% Check AB
for i = 1:length(ABdata)
    name = filesAB(i).name;
    name = string(name(1:10));
    fields = fieldnames(ABdata{i});
    y = 0;
    for j = 1:length(fields)
        fldnm = fields{j};
        fldval = ABdata{i}.(fldnm);
        x = 0;
        if isempty(fldval)
            idx = find(string({game_data_check.ID}) == name);
            game_data_check(idx).Asteroid_Belt = "review - empty";
            x = 1;
        elseif isnumeric(fldval)
            if any(isnan(fldval), 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Asteroid_Belt = "review - NAN";
                x = 1;
            elseif any(fldval == 0, 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Asteroid_Belt = "review - zero";
                x = 1;
            end
            if x == 1
                y = 1;
            end
        end
    end
    if y == 0
        idx = find(string({game_data_check.ID}) == name);
        game_data_check(idx).Asteroid_Belt = "good";
    end
end

for i = 1:length(game_data_check)
    if isempty(game_data_check(i).Asteroid_Belt)
        game_data_check(i).Asteroid_Belt = "not imported";
    end
end


%% Load data into cell array for OR
folderOR = fullfile(filepath, 'Analysis\Analyzed Game Data\Orbital Reaching Individual');
filesOR = dir(fullfile(folderOR, '*.mat'));

ORdata = cell(1, length(filesOR));

for i = 1:length(filesOR)
    temp = load(fullfile(folderOR, filesOR(i).name));
    varName = fieldnames(temp);
    ORdata{i} = temp.(varName{1});  % Store struct inside cell
end

% Check OR
for i = 1:length(ORdata)
    name = filesOR(i).name;
    name = name(1:10);
    fields = fieldnames(ORdata{i});
    y = 0;
    for j = 1:length(fields)
        fldnm = fields{j};
        fldval = ORdata{i}.(fldnm);
        x = 0;
        if isempty(fldval)
            idx = find(string({game_data_check.ID}) == name);
            game_data_check(idx).Orbital_Reaching = "review - empty";
            x = 1;
        elseif isnumeric(fldval)
            if any(isnan(fldval), 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Orbital_Reaching = "review - NAN";
                x = 1;
            % elseif any(fldval == 0, 'all')
            %     idx = find(string({game_data_check.ID}) == name);
            %     game_data_check(idx).Orbital_Reaching = "review - zero";
            %     x = 1;
            end
            if x == 1
                y = 1;
            end
        end
    end
    if y == 0
        idx = find(string({game_data_check.ID}) == name);
        game_data_check(idx).Orbital_Reaching = "good";
    end
end

for i = 1:length(game_data_check)
    if isempty(game_data_check(i).Orbital_Reaching)
        game_data_check(i).Orbital_Reaching = "not imported";
    end
end

%% Load data into cell array for AN
folderAN = fullfile(filepath, 'Analysis\Analyzed Game Data\Asteroid Ninja Individual');
filesAN = dir(fullfile(folderAN, '*.mat'));

ANdata = cell(1, length(filesAN));

for i = 1:length(filesAN)
    temp = load(fullfile(folderAN, filesAN(i).name));
    varName = fieldnames(temp);
    ANdata{i} = temp.(varName{1});  % Store struct inside cell
end

% Check AN
for i = 1:length(ANdata)
    name = filesAN(i).name;
    name = name(1:10);
    fields = fieldnames(ANdata{i});
    y = 0;
    for j = 1:length(fields)
        fldnm = fields{j};
        fldval = ANdata{i}.(fldnm);
        x = 0;
        if isempty(fldval)
            idx = find(string({game_data_check.ID}) == name);
            game_data_check(idx).Asteroid_Ninja = "review - empty";
            x = 1;
        elseif isnumeric(fldval)
            if any(isnan(fldval), 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Asteroid_Ninja = "review - NAN";
                x = 1;
            elseif any(fldval == 0, 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Asteroid_Ninja = "review - zero";
                x = 1;
            end
            if x == 1
                y = 1;
            end
        end
    end
    if y == 0
        idx = find(string({game_data_check.ID}) == name);
        game_data_check(idx).Asteroid_Ninja = "good";
    end
end

for i = 1:length(game_data_check)
    if isempty(game_data_check(i).Asteroid_Ninja)
        game_data_check(i).Asteroid_Ninja = "not imported";
    end
end

%% Load data into cell array for AE
folderAE = fullfile(filepath, 'Analysis\Analyzed Game Data\Alien Enconter Individual');
filesAE = dir(fullfile(folderAE, '*.mat'));

AEdata = cell(1, length(filesAE));

for i = 1:length(filesAE)
    temp = load(fullfile(folderAE, filesAE(i).name));
    varName = fieldnames(temp);
    AEdata{i} = temp.(varName{1});  % Store struct inside cell
end

% Check AE
for i = 1:length(AEdata)
    name = filesAE(i).name;
    name = name(1:10);
    fields = fieldnames(AEdata{i});
    y = 0;
    for j = 1:length(fields)
        fldnm = fields{j};
        fldval = AEdata{i}.(fldnm);
        x = 0;
        if isempty(fldval)
            idx = find(string({game_data_check.ID}) == name);
            game_data_check(idx).Alien_Encounter = "review - empty";
            x = 1;
        elseif isnumeric(fldval)
            if any(isnan(fldval), 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Alien_Encounter = "review - NAN";
                x = 1;
            elseif any(fldval == 0, 'all')
                idx = find(string({game_data_check.ID}) == name);
                game_data_check(idx).Alien_Encounter = "review - zero";
                x = 1;
            end
            if x == 1
                y = 1;
            end
        end
    end
    if y == 0
        idx = find(string({game_data_check.ID}) == name);
        game_data_check(idx).Alien_Encounter = "good";
    end
end

for i = 1:length(game_data_check)
    if isempty(game_data_check(i).Alien_Encounter)
        game_data_check(i).Alien_Encounter = "not imported";
    end
end

save('game_data_check.mat', 'game_data_check')