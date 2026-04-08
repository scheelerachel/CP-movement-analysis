% GameGroupOR.m
%
% Rachel Scheele
% Last Edited 3/21/2025

% Need script to:
% plot group and hand differences the calculate ANOVA including visits

% Clean workspace and command window
clear;
close all;
clc;

%% Load Game Data

addpath 'C:\Users\1637scheelr\OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Analysis\MATLAB scripts'
load("population_game_data.mat")

TD_idx = [game_data_all.Diagnosis] == "TD";
UCP_idx = [game_data_all.Diagnosis] == "UCP";

TD = game_data_all(TD_idx);
UCP = game_data_all(UCP_idx);

a = [2 9 10 11 15];
UCP(a) = [];
TD(23) = [];

%% Define Variables
for i=1:length(TD)
    participant = string(append(TD(i).ID,'ORVariables'));

    TD(i).RMSE_non1 = mean(TD(i).Orbital_Reaching.(participant).RMS_nondom_1);
    TD(i).RMSE_dom1 = mean(TD(i).Orbital_Reaching.(participant).RMS_dom_1);
    TD(i).RMSE_non2 = mean(TD(i).Orbital_Reaching.(participant).RMS_nondom_2);
    TD(i).RMSE_dom2 = mean(TD(i).Orbital_Reaching.(participant).RMS_dom_2);

    TD(i).comtime_non1 = mean(TD(i).Orbital_Reaching.(participant).completion_time_nondom_1);
    TD(i).comtime_dom1 = mean(TD(i).Orbital_Reaching.(participant).completion_time_dom_1);
    TD(i).comtime_non2 = mean(TD(i).Orbital_Reaching.(participant).completion_time_nondom_2);
    TD(i).comtime_dom2 = mean(TD(i).Orbital_Reaching.(participant).completion_time_dom_2);
end

for i=1:length(UCP)
    participant = string(append(UCP(i).ID,'ORVariables'));

    UCP(i).RMSE_non1 = mean(UCP(i).Orbital_Reaching.(participant).RMS_more_aff_1);
    UCP(i).RMSE_dom1 = mean(UCP(i).Orbital_Reaching.(participant).RMS_less_aff_1);
    UCP(i).RMSE_non2 = mean(UCP(i).Orbital_Reaching.(participant).RMS_more_aff_2);
    UCP(i).RMSE_dom2 = mean(UCP(i).Orbital_Reaching.(participant).RMS_less_aff_2);

    UCP(i).comtime_non1 = mean(UCP(i).Orbital_Reaching.(participant).completion_time_more_aff_1);
    UCP(i).comtime_dom1 = mean(UCP(i).Orbital_Reaching.(participant).completion_time_less_aff_1);
    UCP(i).comtime_non2 = mean(UCP(i).Orbital_Reaching.(participant).completion_time_more_aff_2);
    UCP(i).comtime_dom2 = mean(UCP(i).Orbital_Reaching.(participant).completion_time_less_aff_2);
end

%% Plot
% RMSE
figure(1);
hold on

% TD Preferred
swarm = [TD.RMSE_dom1];
x1 = repmat(0.85, length(TD),1);
s1 = swarmchart(x1, swarm, 'o','MarkerEdgeColor','#008083','LineWidth',1.5);

% TD Nonpreferred
swarm = [TD.RMSE_non1];
x2 = repmat(1.85, length(TD),1);
s2 = swarmchart(x2, swarm,'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5);

% UCP Preferred
swarm = [UCP.RMSE_dom1];
x3 = repmat(1.15, length(UCP),1);
s3 = swarmchart(x3, swarm, 'o','MarkerEdgeColor','#F78104','LineWidth',1.5);

% UCP Nonpreferred
swarm = [UCP.RMSE_non1];
x4 = repmat(2.15, length(UCP),1);
s4 = swarmchart(x4, swarm,'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5);

% Jitter
allSwarms = [s1, s2, s3, s4];
for i = 1:numel(allSwarms)
    allSwarms(i).XJitter = 'randn';
    allSwarms(i).XJitterWidth = 0.15;
end
set(gca,'fontsize',14)

% Means
plot([0.7 1],[mean([TD.RMSE_dom1]) mean([TD.RMSE_dom1])],'k','LineWidth',1.2)
plot([1.7 2],[mean([TD.RMSE_non1]) mean([TD.RMSE_non1])],'k','LineWidth',1.2)
plot([1 1.3],[mean([UCP.RMSE_dom1]) mean([UCP.RMSE_dom1])],'k','LineWidth',1.2)
plot([2 2.3],[mean([UCP.RMSE_non1]) mean([UCP.RMSE_non1])],'k','LineWidth',1.2)

% Axis formatting
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Preferred','Nonpreferred'})

% Legend
hTD  = scatter(nan,nan,40,'filled','MarkerEdgeColor','#008083','MarkerFaceColor','#008083');
hUCP = scatter(nan,nan,40,'filled','MarkerEdgeColor','#F78104','MarkerFaceColor','#F78104');
legend([hTD hUCP],{'TD','UCP'})
%title('Asteroid Belt: RMSE')
ylabel('RMSE')

hold off

% Completion Time
figure(2);
hold on

% TD Preferred
swarm = [TD.comtime_dom1];
x1 = repmat(0.85, length(TD),1);
s1 = swarmchart(x1, swarm, 'o','MarkerEdgeColor','#008083','LineWidth',1.5);

% TD Nonpreferred
swarm = [TD.comtime_non1];
x2 = repmat(1.85, length(TD),1);
s2 = swarmchart(x2, swarm,'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5);

% UCP Preferred
swarm = [UCP.comtime_dom1];
x3 = repmat(1.15, length(UCP),1);
s3 = swarmchart(x3, swarm, 'o','MarkerEdgeColor','#F78104','LineWidth',1.5);

% UCP Nonpreferred
swarm = [UCP.comtime_non1];
x4 = repmat(2.15, length(UCP),1);
s4 = swarmchart(x4, swarm,'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5);

% Jitter
allSwarms = [s1, s2, s3, s4];
for i = 1:numel(allSwarms)
    allSwarms(i).XJitter = 'randn';
    allSwarms(i).XJitterWidth = 0.15;
end
set(gca,'fontsize',14)
tick = get(gca, 'YTick');
set(gca, 'YTickLabel', tick/1000)

% Means
plot([0.7 1],[mean([TD.comtime_dom1]) mean([TD.comtime_dom1])],'k','LineWidth',1.2)
plot([1.7 2],[mean([TD.comtime_non1]) mean([TD.comtime_non1])],'k','LineWidth',1.2)
plot([1 1.3],[mean([UCP.comtime_dom1]) mean([UCP.comtime_dom1])],'k','LineWidth',1.2)
plot([2 2.3],[mean([UCP.comtime_non1]) mean([UCP.comtime_non1])],'k','LineWidth',1.2)

% Axis formatting
ylim([0 10000])
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'Preferred','Nonpreferred'})

% Legend
hTD  = scatter(nan,nan,40,'filled','MarkerEdgeColor','#008083','MarkerFaceColor','#008083');
hUCP = scatter(nan,nan,40,'filled','MarkerEdgeColor','#F78104','MarkerFaceColor','#F78104');
legend([hTD hUCP],{'TD','UCP'})
%title('Asteroid Belt: RMSE')
ylabel('Completion Time (s)')

hold off

%% Statistics
% RMSE
RMSE_data = [[TD.RMSE_dom1] [TD.RMSE_non1] [UCP.RMSE_dom1] [UCP.RMSE_non1]]';
g1 = [repmat("Pref",40,1);repmat("Nonpref",40,1);repmat("Pref",10,1);repmat("Nonpref",10,1)];
g2 = [repmat("TD",80,1);repmat("UCP",20,1)];
[p_RMSE, tbl_RMSE, stats_RMSE] = anovan(RMSE_data,{g1,g2});

% Completion Time
comtime_data = [[TD.comtime_dom1] [TD.comtime_non1] [UCP.comtime_dom1] [UCP.comtime_non1]]';
g1 = [repmat("Pref",40,1);repmat("Nonpref",40,1);repmat("Pref",10,1);repmat("Nonpref",10,1)];
g2 = [repmat("TD",80,1);repmat("UCP",20,1)];
[p_ct, tbl_ct, stats_ct] = anovan(comtime_data,{g1,g2});