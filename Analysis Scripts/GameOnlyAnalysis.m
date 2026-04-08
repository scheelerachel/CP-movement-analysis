% MarkerTrajectories.m
%
% Rachel Scheele
% Last Edited 1/19/2025

% Need script to:
% determine and compare marker trajectories of the finger, hand, elbow, and
% sholder to the game data

% Clean workspace and command window
clear;
close all;
clc;

%% Load game data into structure

user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
'University'], ['Documents - Pediatric Movement and ' ...
'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

filefolder = fullfile(filepath,'Analysis\MATLAB scripts\population_game_data.mat');

if exist(filepath, 'dir')==0
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    filefolder = fullfile(filepath,'Analysis\MATLAB scripts\population_game_data.mat');
end

load(filefolder)

CPgroup = struct();
TDgroup = struct();

% Compare nondom to more aff (nondom) and dom to less aff (dom)

% 201-130, 203-115, 204-103, 205-101, 206-106,
% 207-122, 208-110, 212-111, 213-134, 214-126
% If any of these are bad matches check for next best match

CPlist = ["201", "203", "204", "205", "206", "207", "208", "212", "213", "214"];
CPage = [111 123 73 86 93 145 98 138 155 151];
CPavgage = mean(CPage)/12;
CPsdage = std(CPage)/12;
TDlist = ["130", "115", "103", "101", "106", "122", "110", "111", "134", "126"];
TDage = [112 128 73 90 95 142 96 136, 150 148];
TDavgage = mean(TDage)/12;
TDstage = std(TDage)/12;

for j=1:length(CPlist)

    CPname = append("MHEALTH",CPlist(j));
    extCP = append(CPname,"ABVariables");
    TDname = append("MHEALTH",TDlist(j));
    extTD = append(TDname,"ABVariables");

    for i=1:length(game_data_all)
        if game_data_all(i).ID == CPname
            data_CP = game_data_all(i).Asteroid_Belt.(extCP);
        elseif game_data_all(i).ID == TDname
            data_TD = game_data_all(i).Asteroid_Belt.(extTD);
        end
    end
    
    % CP group
    CPgroup(j).RMSE_nonpref = mean([data_CP.RMS_more_aff_1;data_CP.RMS_more_aff_2]);
    CPgroup(j).RMSE_pref = mean([data_CP.RMS_less_aff_1;data_CP.RMS_less_aff_2]);
    CPgroup(j).RMSE_v1 = mean([data_CP.RMS_more_aff_1;data_CP.RMS_less_aff_1]);
    CPgroup(j).RMSE_v2 = mean([data_CP.RMS_more_aff_2;data_CP.RMS_less_aff_2]);
    
    CPgroup(j).comptime_nonpref = mean([data_CP.completion_time_more_aff_1;data_CP.completion_time_more_aff_2]);
    CPgroup(j).comptime_pref = mean([data_CP.completion_time_less_aff_1;data_CP.completion_time_less_aff_2]);
    CPgroup(j).comptime_v1 = mean([data_CP.completion_time_more_aff_1;data_CP.completion_time_less_aff_1]);
    CPgroup(j).comptime_v2 = mean([data_CP.completion_time_more_aff_2;data_CP.completion_time_less_aff_2]);

    CPgroup(j).avgvel_nonpref = mean([data_CP.avg_vel_more_aff_1;data_CP.avg_vel_more_aff_2]);
    CPgroup(j).avgvel_pref = mean([data_CP.avg_vel_less_aff_1;data_CP.avg_vel_less_aff_2]);
    CPgroup(j).avgvel_v1 = mean([data_CP.avg_vel_more_aff_1;data_CP.avg_vel_less_aff_1]);
    CPgroup(j).avgvel_v2 = mean([data_CP.avg_vel_more_aff_2;data_CP.avg_vel_less_aff_2]);

    CPgroup(j).stdvel_nonpref = mean([data_CP.std_vel_more_aff_1;data_CP.std_vel_more_aff_2]);
    CPgroup(j).stdvel_pref = mean([data_CP.std_vel_less_aff_1;data_CP.std_vel_less_aff_2]);
    CPgroup(j).stdvel_v1 = mean([data_CP.std_vel_more_aff_1;data_CP.std_vel_less_aff_1]);
    CPgroup(j).stdvel_v2 = mean([data_CP.std_vel_more_aff_2;data_CP.std_vel_less_aff_2]);

    CPgroup(j).maxvel_nonpref = mean([data_CP.max_vel_more_aff_1;data_CP.max_vel_more_aff_2]);
    CPgroup(j).maxvel_pref = mean([data_CP.max_vel_less_aff_1;data_CP.max_vel_less_aff_2]);
    CPgroup(j).maxvel_v1 = mean([data_CP.max_vel_more_aff_1;data_CP.max_vel_less_aff_1]);
    CPgroup(j).maxvel_v2 = mean([data_CP.max_vel_more_aff_2;data_CP.max_vel_less_aff_2]);

    CPgroup(j).diffacc_nonpref = mean([data_CP.diff_acc_more_aff_1;data_CP.diff_acc_more_aff_2]);
    CPgroup(j).diffacc_pref = mean([data_CP.diff_acc_less_aff_1;data_CP.diff_acc_less_aff_2]);
    CPgroup(j).diffacc_v1 = mean([data_CP.diff_acc_more_aff_1;data_CP.diff_acc_less_aff_1]);
    CPgroup(j).diffacc_v2 = mean([data_CP.diff_acc_more_aff_2;data_CP.diff_acc_less_aff_2]);
    
    % TD group
    TDgroup(j).RMSE_nonpref = mean([data_TD.RMS_nondom_1;data_TD.RMS_nondom_2]);
    TDgroup(j).RMSE_pref = mean([data_TD.RMS_dom_1;data_TD.RMS_dom_2]);
    TDgroup(j).RMSE_v1 = mean([data_TD.RMS_nondom_1;data_TD.RMS_dom_1]);
    TDgroup(j).RMSE_v2 = mean([data_TD.RMS_nondom_2;data_TD.RMS_dom_2]);
    
    TDgroup(j).comptime_nonpref = mean([data_TD.completion_time_nondom_1;data_TD.completion_time_nondom_2]);
    TDgroup(j).comptime_pref = mean([data_TD.completion_time_dom_1;data_TD.completion_time_dom_2]);
    TDgroup(j).comptime_v1 = mean([data_TD.completion_time_nondom_1;data_TD.completion_time_dom_1]);
    TDgroup(j).comptime_v2 = mean([data_TD.completion_time_nondom_2;data_TD.completion_time_dom_2]);

    TDgroup(j).avgvel_nonpref = mean([data_TD.avg_vel_nondom_1;data_TD.avg_vel_nondom_2]);
    TDgroup(j).avgvel_pref = mean([data_TD.avg_vel_dom_1;data_TD.avg_vel_dom_2]);
    TDgroup(j).avgvel_v1 = mean([data_TD.avg_vel_nondom_1;data_TD.avg_vel_dom_1]);
    TDgroup(j).avgvel_v2 = mean([data_TD.avg_vel_nondom_2;data_TD.avg_vel_dom_2]);

    TDgroup(j).stdvel_nonpref = mean([data_TD.std_vel_nondom_1;data_TD.std_vel_nondom_2]);
    TDgroup(j).stdvel_pref = mean([data_TD.std_vel_dom_1;data_TD.std_vel_dom_2]);
    TDgroup(j).stdvel_v1 = mean([data_TD.std_vel_nondom_1;data_TD.std_vel_dom_1]);
    TDgroup(j).stdvel_v2 = mean([data_TD.std_vel_nondom_2;data_TD.std_vel_dom_2]);

    TDgroup(j).maxvel_nonpref = mean([data_TD.max_vel_nondom_1;data_TD.max_vel_nondom_2]);
    TDgroup(j).maxvel_pref = mean([data_TD.max_vel_dom_1;data_TD.max_vel_dom_2]);
    TDgroup(j).maxvel_v1 = mean([data_TD.max_vel_nondom_1;data_TD.max_vel_dom_1]);
    TDgroup(j).maxvel_v2 = mean([data_TD.max_vel_nondom_2;data_TD.max_vel_dom_2]);

    TDgroup(j).diffacc_nonpref = mean([data_TD.diff_acc_nondom_1;data_TD.diff_acc_nondom_2]);
    TDgroup(j).diffacc_pref = mean([data_TD.diff_acc_dom_1;data_TD.diff_acc_dom_2]);
    TDgroup(j).diffacc_v1 = mean([data_TD.diff_acc_nondom_1;data_TD.diff_acc_dom_1]);
    TDgroup(j).diffacc_v2 = mean([data_TD.diff_acc_nondom_2;data_TD.diff_acc_dom_2]);
end

%% Data Analysis

[~,p_RMSE_nonpref] = ttest([CPgroup.RMSE_nonpref],[TDgroup.RMSE_nonpref],"Alpha",0.05);
[~,p_RMSE_pref] = ttest([CPgroup.RMSE_pref],[TDgroup.RMSE_pref],"Alpha",0.05);
[~,p_RMSE_v1] = ttest([CPgroup.RMSE_v1],[TDgroup.RMSE_v1],"Alpha",0.05);
[~,p_RMSE_v2] = ttest([CPgroup.RMSE_v2],[TDgroup.RMSE_v2],"Alpha",0.05);

[~,p_comptime_nonpref] = ttest([CPgroup.comptime_nonpref],[TDgroup.comptime_nonpref],"Alpha",0.05);
[~,p_comptime_pref] = ttest([CPgroup.comptime_pref],[TDgroup.comptime_pref],"Alpha",0.05);
[~,p_comptime_v1] = ttest([CPgroup.comptime_v1],[TDgroup.comptime_v1],"Alpha",0.05);
[~,p_comptime_v2] = ttest([CPgroup.comptime_v2],[TDgroup.comptime_v2],"Alpha",0.05);

[~,p_avgvel_nonpref] = ttest([CPgroup.avgvel_nonpref],[TDgroup.avgvel_nonpref],"Alpha",0.05);
[~,p_avgvel_pref] = ttest([CPgroup.avgvel_pref],[TDgroup.avgvel_pref],"Alpha",0.05);
[~,p_avgvel_v1] = ttest([CPgroup.avgvel_v1],[TDgroup.avgvel_v1],"Alpha",0.05);
[~,p_avgvel_v2] = ttest([CPgroup.avgvel_v2],[TDgroup.avgvel_v2],"Alpha",0.05);

[~,p_stdvel_nonpref] = ttest([CPgroup.stdvel_nonpref],[TDgroup.stdvel_nonpref],"Alpha",0.05);
[~,p_stdvel_pref] = ttest([CPgroup.stdvel_pref],[TDgroup.stdvel_pref],"Alpha",0.05);
[~,p_stdvel_v1] = ttest([CPgroup.stdvel_v1],[TDgroup.stdvel_v1],"Alpha",0.05);
[~,p_stdvel_v2] = ttest([CPgroup.stdvel_v2],[TDgroup.stdvel_v2],"Alpha",0.05);

[~,p_maxvel_nonpref] = ttest([CPgroup.maxvel_nonpref],[TDgroup.maxvel_nonpref],"Alpha",0.05);
[~,p_maxvel_pref] = ttest([CPgroup.maxvel_pref],[TDgroup.maxvel_pref],"Alpha",0.05);
[~,p_maxvel_v1] = ttest([CPgroup.maxvel_v1],[TDgroup.maxvel_v1],"Alpha",0.05);
[~,p_maxvel_v2] = ttest([CPgroup.maxvel_v2],[TDgroup.maxvel_v2],"Alpha",0.05);

[~,p_diffacc_nonpref] = ttest([CPgroup.diffacc_nonpref],[TDgroup.diffacc_nonpref],"Alpha",0.05);
[~,p_diffacc_pref] = ttest([CPgroup.diffacc_pref],[TDgroup.diffacc_pref],"Alpha",0.05);
[~,p_diffacc_v1] = ttest([CPgroup.diffacc_v1],[TDgroup.diffacc_v1],"Alpha",0.05);
[~,p_diffacc_v2] = ttest([CPgroup.diffacc_v2],[TDgroup.diffacc_v2],"Alpha",0.05);

summary = struct('test',[],'nonpref', [],'pref', [],'v1', [],'v2', []);

summary(1).test = 'RMSE';
summary(1).avg_CP = mean([CPgroup.RMSE_nonpref,CPgroup.RMSE_pref]);
summary(1).std_CP = std([CPgroup.RMSE_nonpref,CPgroup.RMSE_pref]);
summary(1).avg_TD = mean([TDgroup.RMSE_nonpref,TDgroup.RMSE_pref]);
summary(1).std_TD = std([TDgroup.RMSE_nonpref,TDgroup.RMSE_pref]);
summary(1).nonpref = p_RMSE_nonpref;
summary(1).pref = p_RMSE_pref;
summary(1).v1 = p_RMSE_v1;
summary(1).v2 = p_RMSE_v2;

summary(2).test = 'Completion Time';
summary(2).avg_CP = mean([CPgroup.comptime_nonpref,CPgroup.comptime_pref]);
summary(2).std_CP = std([CPgroup.comptime_nonpref,CPgroup.comptime_pref]);
summary(2).avg_TD = mean([TDgroup.comptime_nonpref,TDgroup.comptime_pref]);
summary(2).std_TD = std([TDgroup.comptime_nonpref,TDgroup.comptime_pref]);
summary(2).nonpref = p_comptime_nonpref;
summary(2).pref = p_comptime_pref;
summary(2).v1 = p_comptime_v1;
summary(2).v2 = p_comptime_v2;

% summary(3).test = 'Average Velocity';
% summary(3).nonpref = p_avgvel_nonpref;
% summary(3).pref = p_avgvel_pref;
% summary(3).v1 = p_avgvel_v1;
% summary(3).v2 = p_avgvel_v2;
% 
% summary(4).test = 'St Dev Velocity';
% summary(4).nonpref = p_stdvel_nonpref;
% summary(4).pref = p_stdvel_pref;
% summary(4).v1 = p_stdvel_v1;
% summary(4).v2 = p_stdvel_v2;
% 
% summary(5).test = 'Max Velocity';
% summary(5).nonpref = p_maxvel_nonpref;
% summary(5).pref = p_maxvel_pref;
% summary(5).v1 = p_maxvel_v1;
% summary(5).v2 = p_maxvel_v2;
% 
% summary(6).test = 'Difference Acceleration';
% summary(6).nonpref = p_diffacc_nonpref;
% summary(6).pref = p_diffacc_pref;
% summary(6).v1 = p_diffacc_v1;
% summary(6).v2 = p_diffacc_v2;
