% RMSEtrajectories.m
%
% Rachel Scheele
% Last Edited 3/23/2025

% Need script to:
% plot RMSE of trajectory for all 10 TD and 7 UCP

% Clean workspace and command window
clear;
close all;
clc;

%% Load Game Data

addpath 'C:\Users\1637scheelr\OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Analysis\MATLAB scripts'
load("MC_RMSE")

data = rows2vars(MC_RMSE);

% 1 = finger, 2 = wrist, 3 = elbow, 4 = shoulder
swarmTD_MA = [data.MAfin_RMSE_avg(1:10) data.MAwr_RMSE_avg(1:10) data.MAelb_RMSE_avg(1:10) data.MAsho_RMSE_avg(1:10)];
swarmTD_LA = [data.LAfin_RMSE_avg(1:10) data.LEwr_RMSE_avg(1:10) data.LAelb_RMSE_avg(1:10) data.LAsho_RMSE_avg(1:10)];
swarmCP_MA = [data.MAfin_RMSE_avg(11:17) data.MAwr_RMSE_avg(11:17) data.MAelb_RMSE_avg(11:17) data.MAsho_RMSE_avg(11:17)];
swarmCP_LA = [data.LAfin_RMSE_avg(11:17) data.LEwr_RMSE_avg(11:17) data.LAelb_RMSE_avg(11:17) data.LAsho_RMSE_avg(11:17)];
%category = categorical([repmat("MA Finger",10,1);repmat("MA Wrist",10,1);repmat("MA Elbow",10,1);repmat("MA Shoulder",10,1)]);
catTD_MA = [2*ones(10,1) 4*ones(10,1) 6*ones(10,1) 8*ones(10,1)];
catTD_LA = [ones(10,1) 3*ones(10,1) 5*ones(10,1) 7*ones(10,1)];
catCP_MA = [2*ones(7,1) 4*ones(7,1) 6*ones(7,1) 8*ones(7,1)];
catCP_LA = [ones(7,1) 3*ones(7,1) 5*ones(7,1) 7*ones(7,1)];

% hold on
% swarmchart(catTD_MA,swarmTD_MA)
% swarmchart(catTD_LA,swarmTD_LA)
% swarmchart(catCP_MA,swarmCP_MA)
% swarmchart(catCP_LA,swarmCP_LA)
% 
% legend('TD MA','TD LA','UCP MA','UCP LA')
% hold off

%% Plot
colTD = '#008083';
colCP = '#F78104';

figure
hold on

% Swarm plots
swarmchart(catTD_MA,swarmTD_MA,'x','SizeData',50,'MarkerEdgeColor',colTD,'LineWidth',1.5)
swarmchart(catTD_LA,swarmTD_LA,'MarkerEdgeColor',colTD,'LineWidth',1.5)
swarmchart(catCP_MA,swarmCP_MA,'x','SizeData',50,'MarkerEdgeColor',colCP,'LineWidth',1.5)
swarmchart(catCP_LA,swarmCP_LA,'MarkerEdgeColor',colCP,'LineWidth',1.5)

% Means
for j = 1:4
    % TD LA
    m = mean(swarmTD_LA(:,j));
    plot([(2*j-1)-0.45 (2*j-1)+0.45], [m m], 'k', 'LineWidth', 1.5)

    % UCP LA
    m = mean(swarmCP_LA(:,j));
    plot([(2*j-1)-0.45 (2*j-1)+0.45], [m m], 'k', 'LineWidth', 1.5)

    % TD MA
    m = mean(swarmTD_MA(:,j));
    plot([(2*j)-0.45 (2*j)+0.45], [m m], 'k', 'LineWidth', 1.5)

    % UCP MA
    m = mean(swarmCP_MA(:,j));
    plot([(2*j)-0.45 (2*j)+0.45], [m m], 'k', 'LineWidth', 1.5)
end

% X-axis grouping
xline([2.5 4.5 6.5], '--', 'Color', [0.7 0.7 0.7])

xticks([1.5 3.5 5.5 7.5])
xticklabels({'Finger','Wrist','Elbow','Shoulder'})

xlim([0.5 8.5])

% Labels / legend
ylabel('RMSE')
xlabel('Joint')

h(1) = scatter(nan, nan, 'o', 'MarkerEdgeColor', colTD, 'LineWidth', 1.5);
h(2) = scatter(nan, nan, 'x','SizeData',50, 'MarkerEdgeColor', colTD, 'LineWidth', 1.5);
h(3) = scatter(nan, nan, 'o', 'MarkerEdgeColor', colCP, 'LineWidth', 1.5);
h(4) = scatter(nan, nan, 'x','SizeData',50, 'MarkerEdgeColor', colCP, 'LineWidth', 1.5);

legend(h, {'TD Preferred','TD Nonpreferred','UCP Preferred','UCP Nonpreferred'}, 'Location','northwest')

hold off

% ANOVA
tdla = swarmTD_LA(:);
tdma = swarmTD_MA(:);
cpla = swarmCP_LA(:);
cpma = swarmCP_MA(:);

all_data = [tdla;tdma;cpla;cpma];
g1 = [repmat("Pref",40,1);repmat("Nonpref",40,1);repmat("Pref",28,1);repmat("Nonpref",28,1)];
g2 = [repmat("TD",80,1);repmat("UCP",56,1)];
pattd = [repmat("Fin",10,1);repmat("Wr",10,1);repmat("Elb",10,1);repmat("Sho",10,1)];
patcp = [repmat("Fin",7,1);repmat("Wr",7,1);repmat("Elb",7,1);repmat("Sho",7,1)];
g3 = [repmat(pattd,2,1);repmat(patcp,2,1)];
[p_RMSE, tbl_RMSE, stats_RMSE] = anovan(all_data,{g1,g2,g3},'interaction');