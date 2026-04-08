% ROMcompGAME.m
%
% Rachel Scheele
% Last Edited 3/23/2025

% Need script to:
% plot RMSE and completion time vs joint ROM

% Clean workspace and command window
clear;
close all;
clc;

%% Load Game Data

addpath 'C:\Users\1637scheelr\OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Analysis\MATLAB scripts'
load("MCdata_joints.mat")
load("population_game_data.mat")

%% Organize Data Structure

sample = {'MHEALTH110','MHEALTH118','MHEALTH126','MHEALTH130',...
    'MHEALTH135','MHEALTH136','MHEALTH137','MHEALTH138',...
    'MHEALTH139','MHEALTH141','MHEALTH203','MHEALTH204',...
    'MHEALTH205','MHEALTH207','MHEALTH208','MHEALTH212','MHEALTH214'};

data = struct();

for i=1:length(sample)
    data(i).participant = sample(i);

    for j=1:length(game_data_all)
        if isequal(sample(i),game_data_all(j).ID)
            trial = string(append(sample(i),'ABVariables'));
            
            if ismember(i,1:10)
                data(i).RMSE_MA = mean(game_data_all(j).Asteroid_Belt.(trial).RMS_nondom_1);
                data(i).comptime_MA = mean(game_data_all(j).Asteroid_Belt.(trial).completion_time_nondom_1);
                data(i).RMSE_LA = mean(game_data_all(j).Asteroid_Belt.(trial).RMS_dom_1);
                data(i).comptime_LA = mean(game_data_all(j).Asteroid_Belt.(trial).completion_time_dom_1);
           
            elseif ismember(i,11:17)
                data(i).RMSE_MA = mean(game_data_all(j).Asteroid_Belt.(trial).RMS_more_aff_1);
                data(i).comptime_MA = mean(game_data_all(j).Asteroid_Belt.(trial).completion_time_more_aff_1);
                data(i).RMSE_LA = mean(game_data_all(j).Asteroid_Belt.(trial).RMS_less_aff_1);
                data(i).comptime_LA = mean(game_data_all(j).Asteroid_Belt.(trial).completion_time_less_aff_1);
            end
        end
    end

    data(i).ROM_sho_abduct_MA = MCdata_joints.ROM.sho_abduct(i).non_1;
    data(i).ROM_sho_flex_MA = MCdata_joints.ROM.sho_flex(i).non_1;
    data(i).ROM_sho_horabduct_MA = MCdata_joints.ROM.sho_horabduct(i).non_1;
    data(i).ROM_elb_pronat_MA = MCdata_joints.ROM.elb_pronat(i).non_1;
    data(i).ROM_elb_flex_MA = MCdata_joints.ROM.elb_flex(i).non_1;
    data(i).ROM_wr_flex_MA = MCdata_joints.ROM.wr_flex(i).non_1;
    data(i).ROM_wr_rudev_MA = MCdata_joints.ROM.wr_rudev(i).non_1;

    data(i).ROM_sho_abduct_LA = MCdata_joints.ROM.sho_abduct(i).dom_1;
    data(i).ROM_sho_flex_LA = MCdata_joints.ROM.sho_flex(i).dom_1;
    data(i).ROM_sho_horabduct_LA = MCdata_joints.ROM.sho_horabduct(i).dom_1;
    data(i).ROM_elb_pronat_LA = MCdata_joints.ROM.elb_pronat(i).dom_1;
    data(i).ROM_elb_flex_LA = MCdata_joints.ROM.elb_flex(i).dom_1;
    data(i).ROM_wr_flex_LA = MCdata_joints.ROM.wr_flex(i).dom_1;
    data(i).ROM_wr_rudev_LA = MCdata_joints.ROM.wr_rudev(i).dom_1;
end

TD = data(1:10);
CP = data(11:17);

%% Plot

joints = {'sho_abduct','sho_flex','sho_horabduct','elb_pronat','elb_flex','wr_flex','wr_rudev'};

% RMSE
figure
t = tiledlayout(4,2);

% Set title and spacing
t.TileSpacing = 'compact'; % Makes plots closer together
t.Padding = 'compact';     % Reduces outer margins

for k = 1:length(joints)
    
    nexttile;
    joint = joints{k};
    
    hold on
    field_MA = ['ROM_' joint '_MA'];
    field_LA = ['ROM_' joint '_LA'];
    
    % TD data
    scatter([TD.RMSE_MA], [TD.(field_MA)],'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5)
    scatter([TD.RMSE_LA], [TD.(field_LA)],'MarkerEdgeColor','#008083','LineWidth',1.5)
    
    % CP data
    scatter([CP.RMSE_MA], [CP.(field_MA)],'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5)
    scatter([CP.RMSE_LA], [CP.(field_LA)],'MarkerEdgeColor','#F78104','LineWidth',1.5)
    
    xlabel('RMSE')
    ylabel('ROM (degrees)')

    % Title
    if strcmp(joint,'sho_abduct')
        title('a')
    elseif strcmp(joint,'sho_flex')
        title('b')
    elseif strcmp(joint,'sho_horabduct')
        title('c')
    elseif strcmp(joint,'elb_pronat')
        title('d')
    elseif strcmp(joint,'elb_flex')
        title('e')
    elseif strcmp(joint,'wr_flex')
        title('f')
    elseif strcmp(joint,'wr_rudev')
        title('g')
    end
    
    if k==1
        nexttile;
        plot(nan,nan)
    end
end

legend({'TD Preferred','TD Nonpreferred','CP Preferred','CP Nonpreferred'}, 'Location','best')
hold off

% Completion Time
figure
t = tiledlayout(4,2);

% Set title and spacing
t.TileSpacing = 'compact'; % Makes plots closer together
t.Padding = 'compact';     % Reduces outer margins

for k = 1:length(joints)
    
    nexttile;
    joint = joints{k};
    
    hold on
    field_MA = ['ROM_' joint '_MA'];
    field_LA = ['ROM_' joint '_LA'];
    
    % TD data
    scatter([TD.comptime_MA], [TD.(field_MA)],'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5)
    scatter([TD.comptime_LA], [TD.(field_LA)],'MarkerEdgeColor','#008083','LineWidth',1.5)
    
    % CP data
    scatter([CP.comptime_MA], [CP.(field_MA)],'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5)
    scatter([CP.comptime_LA], [CP.(field_LA)],'MarkerEdgeColor','#F78104','LineWidth',1.5)
    
    tick = get(gca, 'XTick');
    set(gca, 'XTickLabel', tick/1000)
    xlabel('Completion Time (s)')
    ylabel('ROM (degrees)')

    % Title
    if strcmp(joint,'sho_abduct')
        title('a')
    elseif strcmp(joint,'sho_flex')
        title('b')
    elseif strcmp(joint,'sho_horabduct')
        title('c')
    elseif strcmp(joint,'elb_pronat')
        title('d')
    elseif strcmp(joint,'elb_flex')
        title('e')
    elseif strcmp(joint,'wr_flex')
        title('f')
    elseif strcmp(joint,'wr_rudev')
        title('g')
    end
    
    if k==1
        nexttile;
        plot(nan,nan)
    end
end

legend({'TD Preferred','TD Nonpreferred','CP Preferred','CP Nonpreferred'}, 'Location','best')
hold off

%% Descriptive Statistics
TD(11).RMSE_MA = mean([TD.RMSE_MA]);
CP(8).RMSE_MA = mean([CP.RMSE_MA]);
TD(11).RMSE_LA = mean([TD.RMSE_LA]);
CP(8).RMSE_LA = mean([CP.RMSE_LA]);

TD(12).RMSE_MA = std([TD.RMSE_MA]);
CP(9).RMSE_MA = std([CP.RMSE_MA]);
TD(12).RMSE_LA = std([TD.RMSE_LA]);
CP(9).RMSE_LA = std([CP.RMSE_LA]);

TD(11).comptime_MA = mean([TD.comptime_MA])/1000;
CP(8).comptime_MA = mean([CP.comptime_MA])/1000;
TD(11).comptime_LA = mean([TD.comptime_LA])/1000;
CP(8).comptime_LA = mean([CP.comptime_LA])/1000;

TD(12).comptime_MA = mean([TD.comptime_MA])/1000;
CP(9).comptime_MA = mean([CP.comptime_MA])/1000;
TD(12).comptime_LA = mean([TD.comptime_LA])/1000;
CP(9).comptime_LA = mean([CP.comptime_LA])/1000;

for k = 1:length(joints)
    
    joint = joints{k};
    
    field_MA = ['ROM_' joint '_MA'];
    field_LA = ['ROM_' joint '_LA'];

    TD(11).(field_MA) = mean([TD.(field_MA)]);
    CP(8).(field_MA) = mean([CP.(field_MA)]);
    TD(11).(field_LA) = mean([TD.(field_LA)]);
    CP(8).(field_LA) = mean([CP.(field_LA)]);

    TD(12).(field_MA) = std([TD.(field_MA)]);
    CP(9).(field_MA) = std([CP.(field_MA)]);
    TD(12).(field_LA) = std([TD.(field_LA)]);
    CP(9).(field_LA) = std([CP.(field_LA)]);
end