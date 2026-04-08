% StatisticalOutliers.m
%
% Rachel Scheele
% Last Edited 9/22/2025

% Need script to:
% calculate mean and SD -> outliers
% calculate median and IQR -> outliers

% Run PreprocessingCheck and GameData Grouping before running this

% Clean workspace and command window
clear;
close all;
clc;

%% load structures
load("game_data_check.mat")
load("population_game_data.mat")

for i=1:length(game_data_all)
    name = game_data_all(i).ID;
    temp = game_data_all(i).Orbital_Reaching;

    if isempty(temp)
        continue
    end

    sv = append(name,"ORVariables");
    stct = temp.(sv);

    %% calculate outliers via mean/stdev
    flds = fieldnames(stct);
    for j=1:length(flds)
        data = stct.(flds{j});
        avg = mean(data);
        sd = std(data);
        maxbnd = avg + 3*sd;
        minbnd = avg - 3*sd;
        maxout = find(data>maxbnd);
        minout = find(data<minbnd);
        out = cat(1,maxout,minout);

        planets = (1:length(data))';
        data(out) = [];
        planets(out) = [];
        arry = cat(2,data,planets);
        tempstct.(flds{j}) = arry;
    end
    game_data_all(i).OR_OutliersRemovedMean = tempstct;

    %% calculate outliers via median/IQR
    flds = fieldnames(stct);

    for j=1:length(flds)

        data = stct.(flds{j});
        med = median(data);
        IQR = iqr(data);
        maxbnd = med + 1.5*IQR;
        minbnd = med - 1.5*IQR;
        maxout = find(data>maxbnd);
        minout = find(data<minbnd);
        out = cat(1,maxout,minout);

        planets = (1:length(data))';
        data(out) = [];
        planets(out) = [];
        arry = cat(2,data,planets);
        tempstct.(flds{j}) = arry;
    end
    game_data_all(i).OR_OutliersRemovedMedian = tempstct;

end