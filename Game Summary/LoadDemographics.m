% LoadDemographics.m
%
% Rachel Scheele
% Last Edited 5/14/2025

function LoadDemographics

    % Clean workspace and command window
    clear;
    close all;
    clc;
    
    % Load demographics and update .mat file containing demographics
    [filename, filepath] = uigetfile('*.xlsx');
    data = readtable(fullfile(filepath,filename));
    
    ID = char(table2cell(data(:,1)));
    cp = string(table2cell(data(:,2)));
    nonprefhand = string(table2cell(data(:,3)));
    prefhand = string(table2cell(data(:,4)));
    age = table2cell(data(:,5));
    
    hand_l = nan(length(ID),1);
    hand_r = nan(length(ID),1);
    
    for i = 1:length(ID)
        if cp(i) == "UCP"
            if prefhand(i) == "Left"
                hand_l(i) = "Less Affected";
                hand_r(i) = "More Affected";
            elseif prefhand(i) == "Right"
                hand_r(i) = "Less Affected";
                hand_l(i) = "More Affected";
            else
                fprintf("Missing Handedness data for %s\n",ID(i,:))
            end
        elseif cp(i) == "TD"
            if prefhand(i) == "Left"
                hand_l(i) = "Dominant";
                hand_r(i) = "Non-Dominant";
            elseif prefhand(i) == "Right"
                hand_r(i) = "Dominant";
                hand_l(i) = "Non-Dominant";
            else
                fprintf("Missing Handedness data for %s\n",ID(i,:))
            end
        else
            fprintf("Empty Row in %i\n",i)
        end
    
    hand_l = string(hand_l);
    hand_r = string(hand_r);
    
    end

end