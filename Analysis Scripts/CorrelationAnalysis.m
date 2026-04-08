% CorrelationAnalysis.m
%
% Rachel Scheele
% Last Edited 3/25/2025

% Need script to:
% load Asteroid Belt data and run population analysis

% Run PreprocessingCheck and GameData Grouping before running this
% (may make this automatic later)

% Clean workspace and command window
clear;
close all;
clc;

format long G
addpath 'C:\Users\1637scheelr\OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Analysis\MATLAB scripts'

%% load structures
load("game_data_check.mat")
load("population_game_data.mat")

% Extract data
for i=1:length(game_data_all)
    name = game_data_all(i).ID;
    
    temp = game_data_all(i).Asteroid_Belt;
    
    if isempty(temp)
        continue
    end

    % Skip -> outlier
    % if name == "MHEALTH132"
    %     continue
    % end

    if name == "MHEALTH202"
        continue
    end

    if name == "MHEALTH215"
        continue
    end
   
    sv = append(name,"ABVariables");
    data = temp.(sv);

    if isfield(data, 'avg_vel_more_aff_1')
        age_CP(i) = game_data_all(i).Age;
        cont_age_CP(i) = game_data_all(i).Chron_Age;

        vel_m_1(i) = mean(data.avg_vel_more_aff_1);
        vel_m_2(i) = mean(data.avg_vel_more_aff_2);
        vel_l_1(i) = mean(data.avg_vel_less_aff_1);
        vel_l_2(i) = mean(data.avg_vel_less_aff_2);

        std_m_1(i) = mean(data.std_vel_more_aff_1);
        std_m_2(i) = mean(data.std_vel_more_aff_2);
        std_l_1(i) = mean(data.std_vel_less_aff_1);
        std_l_2(i) = mean(data.std_vel_less_aff_2);

        max_m_1(i) = mean(data.max_vel_more_aff_1);
        max_m_2(i) = mean(data.max_vel_more_aff_2);
        max_l_1(i) = mean(data.max_vel_less_aff_1);
        max_l_2(i) = mean(data.max_vel_less_aff_2);

        comt_m_1(i) = mean(data.completion_time_more_aff_1);
        comt_m_2(i) = mean(data.completion_time_more_aff_2);
        comt_l_1(i) = mean(data.completion_time_less_aff_1);
        comt_l_2(i) = mean(data.completion_time_less_aff_2);

        rms_m_1(i) = mean(data.RMS_more_aff_1);
        rms_m_2(i) = mean(data.RMS_more_aff_2);
        rms_l_1(i) = mean(data.RMS_less_aff_1);
        rms_l_2(i) = mean(data.RMS_less_aff_2);

    elseif isfield(data, 'avg_vel_nondom_1')
        age_TD(i) = game_data_all(i).Age;
        cont_age_TD(i) = game_data_all(i).Chron_Age;

        vel_n_1(i) = mean(data.avg_vel_nondom_1);
        vel_n_2(i) = mean(data.avg_vel_nondom_2);
        vel_d_1(i) = mean(data.avg_vel_dom_1);
        vel_d_2(i) = mean(data.avg_vel_dom_2);

        std_n_1(i) = mean(data.std_vel_nondom_1);
        std_n_2(i) = mean(data.std_vel_nondom_2);
        std_d_1(i) = mean(data.std_vel_dom_1);
        std_d_2(i) = mean(data.std_vel_dom_2);

        max_n_1(i) = mean(data.max_vel_nondom_1);
        max_n_2(i) = mean(data.max_vel_nondom_2);
        max_d_1(i) = mean(data.max_vel_dom_1);
        max_d_2(i) = mean(data.max_vel_dom_2);

        comt_n_1(i) = mean(data.completion_time_nondom_1);
        comt_n_2(i) = mean(data.completion_time_nondom_2);
        comt_d_1(i) = mean(data.completion_time_dom_1);
        comt_d_2(i) = mean(data.completion_time_dom_2);

        rms_n_1(i) = mean(data.RMS_nondom_1);
        rms_n_2(i) = mean(data.RMS_nondom_2);
        rms_d_1(i) = mean(data.RMS_dom_1);
        rms_d_2(i) = mean(data.RMS_dom_2);
    else
        fprintf('error in %s\n', name)
    end
end

age_CP  = age_CP(age_CP ~= 0);
cont_age_CP = cont_age_CP(cont_age_CP ~= 0);
age_TD  = age_TD(age_TD ~= 0);
cont_age_TD = cont_age_TD(cont_age_TD ~= 0);

vel_m_1 = vel_m_1(vel_m_1 ~= 0);
vel_m_2 = vel_m_2(vel_m_2 ~= 0);
vel_l_1 = vel_l_1(vel_l_1 ~= 0);
vel_l_2 = vel_l_2(vel_l_2 ~= 0);

std_m_1 = std_m_1(std_m_1 ~= 0);
std_m_2 = std_m_2(std_m_2 ~= 0);
std_l_1 = std_l_1(std_l_1 ~= 0);
std_l_2 = std_l_2(std_l_2 ~= 0);

max_m_1 = max_m_1(max_m_1 ~= 0);
max_m_2 = max_m_2(max_m_2 ~= 0);
max_l_1 = max_l_1(max_l_1 ~= 0);
max_l_2 = max_l_2(max_l_2 ~= 0);

comt_m_1 = comt_m_1(comt_m_1 ~= 0);
comt_m_2 = comt_m_2(comt_m_2 ~= 0);
comt_l_1 = comt_l_1(comt_l_1 ~= 0);
comt_l_2 = comt_l_2(comt_l_2 ~= 0);

rms_m_1 = rms_m_1(rms_m_1 ~= 0);
rms_m_2 = rms_m_2(rms_m_2 ~= 0);
rms_l_1 = rms_l_1(rms_l_1 ~= 0);
rms_l_2 = rms_l_2(rms_l_2 ~= 0);

vel_n_1 = vel_n_1(vel_n_1 ~= 0);
vel_n_2 = vel_n_2(vel_n_2 ~= 0);
vel_d_1 = vel_d_1(vel_d_1 ~= 0);
vel_d_2 = vel_d_2(vel_d_2 ~= 0);

std_n_1 = std_n_1(std_n_1 ~= 0);
std_n_2 = std_n_2(std_n_2 ~= 0);
std_d_1 = std_d_1(std_d_1 ~= 0);
std_d_2 = std_d_2(std_d_2 ~= 0);

max_n_1 = max_n_1(max_n_1 ~= 0);
max_n_2 = max_n_2(max_n_2 ~= 0);
max_d_1 = max_d_1(max_d_1 ~= 0);
max_d_2 = max_d_2(max_d_2 ~= 0);

comt_n_1 = comt_n_1(comt_n_1 ~= 0);
comt_n_2 = comt_n_2(comt_n_2 ~= 0);
comt_d_1 = comt_d_1(comt_d_1 ~= 0);
comt_d_2 = comt_d_2(comt_d_2 ~= 0);

rms_n_1 = rms_n_1(rms_n_1 ~= 0);
rms_n_2 = rms_n_2(rms_n_2 ~= 0);
rms_d_1 = rms_d_1(rms_d_1 ~= 0);
rms_d_2 = rms_d_2(rms_d_2 ~= 0);

%% Three sets of graphs using group, handedness, and visit
% 
% % split by TD and UCP
% figure
% tiledlayout(1,2)
% 
% s1 = nexttile;
% hold on
% h1 = scatter(s1, vel_m_1, rms_m_1, 'o', 'red');
% h2 = scatter(s1, vel_m_2, rms_m_2, 'filled', 'red');
% h3 = scatter(s1, vel_l_1, rms_l_1, 'o', 'black');
% h4 = scatter(s1, vel_l_2, rms_l_2, 'filled', 'black');
% xlabel(s1, 'Speed (Velocity - m/s)')
% ylabel(s1, 'Accuracy (RMSE)')
% title(s1, 'CP')
% legend(s1, [h1, h2, h3, h4], {'More Affected V1','More Affected V2','Less Affected V1','Less Affected V2'})
% hold off
% 
% s2 = nexttile;
% hold on
% h5 = scatter(s2, vel_n_1, rms_n_1, 'o', 'red');
% h6 = scatter(s2, vel_n_2, rms_n_2, 'filled', 'red');
% h7 = scatter(s2, vel_d_1, rms_d_1, 'o', 'black');
% h8 = scatter(s2, vel_d_2, rms_d_2, 'filled', 'black');
% xlabel(s2, 'Speed (Velocity - m/s)')
% ylabel(s2, 'Accuracy (RMSE)')
% title(s2, 'TD')
% legend(s2, [h5, h6, h7, h8], {'Non-dominant V1','Non-dominant V2','Dominant V1','Dominant V2'})
% hold off
% 
% % Stats
% vel1 = [vel_m_1,vel_m_2,vel_l_1,vel_l_2];
% rms1 = [rms_m_1,rms_m_2,rms_l_1,rms_l_2];
% 
% corcoeff1 = corrcoef(vel1,rms1);
% fprintf('CP\n')
% disp(corcoeff1)
% 
% vel2 = [vel_n_1,vel_n_2,vel_d_1,vel_d_2];
% rms2 = [rms_n_1,rms_n_2,rms_d_1,rms_d_2];
% 
% corcoeff2 = corrcoef(vel2,rms2);
% fprintf('TD\n')
% disp(corcoeff2)
% 
% % split by V1 and V2
% figure
% tiledlayout(1,2)
% 
% s3 = nexttile;
% hold on
% h1 = scatter(s3, vel_m_1, rms_m_1, 'o', 'red');
% h2 = scatter(s3, vel_l_1, rms_l_1, 'filled', 'red');
% h3 = scatter(s3, vel_n_1, rms_n_1, 'o', 'black');
% h4 = scatter(s3, vel_d_1, rms_d_1, 'filled', 'black');
% xlabel(s3, 'Speed (Velocity - m/s)')
% ylabel(s3, 'Accuracy (RMSE)')
% title(s3, 'V1')
% legend(s3, [h1, h2, h3, h4], {'More Affected','Less Affected','Non-dominant','Dominant'})
% hold off
% 
% s4 = nexttile;
% hold on
% h5 = scatter(s4, vel_m_2, rms_m_2, 'o', 'red');
% h6 = scatter(s4, vel_l_2, rms_l_2, 'filled', 'red');
% h7 = scatter(s4, vel_n_2, rms_n_2, 'o', 'black');
% h8 = scatter(s4, vel_d_2, rms_d_2, 'filled', 'black');
% xlabel(s4, 'Speed (Velocity - m/s)')
% ylabel(s4, 'Accuracy (RMSE)')
% title(s4, 'V2')
% legend(s4, [h5, h6, h7, h8], {'More Affected','Less Affected','Non-dominant','Dominant'})
% hold off
% 
% % Stats
% vel1 = [vel_m_1,vel_l_1,vel_n_1,vel_d_1];
% rms1 = [rms_m_1,rms_l_1,rms_n_1,rms_d_1];
% 
% corcoeff1 = corrcoef(vel1,rms1);
% fprintf('V1\n')
% disp(corcoeff1)
% 
% vel2 = [vel_m_2,vel_l_2,vel_n_2,vel_d_2];
% rms2 = [rms_m_2,rms_l_2,rms_n_2,rms_d_2];
% 
% corcoeff2 = corrcoef(vel2,rms2);
% fprintf('V2\n')
% disp(corcoeff2)
% 
% % split by handedness
% figure
% tiledlayout(1,2)
% 
% s5 = nexttile;
% hold on
% h1 = scatter(s5, vel_m_1, rms_m_1, 'o', 'red');
% h2 = scatter(s5, vel_m_2, rms_m_2, 'filled', 'red');
% h3 = scatter(s5, vel_n_1, rms_n_1, 'o', 'black');
% h4 = scatter(s5, vel_n_2, rms_n_2, 'filled', 'black');
% xlabel(s5, 'Speed (Velocity - m/s)')
% ylabel(s5, 'Accuracy (RMSE)')
% title(s5, 'More Affected/Non-dominant')
% legend(s5, [h1, h2, h3, h4], {'More Affected V1','More Affected V2','Non-dominant V1','Non-dominant V2'})
% hold off
% 
% s6 = nexttile;
% hold on
% h5 = scatter(s6, vel_l_1, rms_l_1, 'o', 'red');
% h6 = scatter(s6, vel_l_2, rms_l_2, 'filled', 'red');
% h7 = scatter(s6, vel_d_1, rms_d_1, 'o', 'black');
% h8 = scatter(s6, vel_d_2, rms_d_2, 'filled', 'black');
% xlabel(s6, 'Speed (Velocity - m/s)')
% ylabel(s6, 'Accuracy (RMSE)')
% title(s6, 'Less Affected/Dominant')
% legend(s6, [h5, h6, h7, h8], {'Less Affected V1','Less Affected V2','Dominant V1','Dominant V2'})
% hold off
% 
% % Stats
% vel1 = [vel_m_1,vel_m_2,vel_n_1,vel_n_2];
% rms1 = [rms_m_1,rms_m_2,rms_n_1,rms_n_2];
% 
% corcoeff1 = corrcoef(vel1,rms1);
% fprintf('More Affected/Non-dominant\n')
% disp(corcoeff1)
% 
% vel2 = [vel_l_1,vel_l_2,vel_d_1,vel_d_2];
% rms2 = [rms_l_1,rms_l_2,rms_d_1,rms_d_2];
% 
% corcoeff2 = corrcoef(vel2,rms2);
% fprintf('Less Affected/Dominant\n')
% disp(corcoeff2)


DV=menu('Select what variable to plot', 'Completion Time', 'RMSE', 'Average Velocity', 'Standard Deviation Velocity', 'Maximum Velocity');
plottype=menu('Select what variable to plot', 'V1-V2', 'Speed-Accuracy', 'Comparison with Age (discrete)','Comparison with Age (continuous)');

switch plottype

    case 1 % V1-V2
        switch DV
            case 1
%% V1-V2 comparison Completion Time

% TD Dominant Completion Time
figure
hold on
scatter(comt_d_1,comt_d_2,'o','MarkerEdgeColor','#008083','LineWidth',1.5)
scatter(comt_l_1, comt_l_2,'o','MarkerEdgeColor','#F78104','LineWidth',1.5);
%maximum = max(cat(2,comt_d_1,comt_d_2,comt_l_1, comt_l_2));
%plot([0,maximum],[0,maximum],'k')
plot([0,33000],[0,33000],'k')
tick = get(gca, 'YTick');
set(gca, 'XTickLabel', tick/1000)
set(gca, 'YTickLabel', tick/1000)
%title('Orbital Reaching: Completion Time Comparing Visits for Dominant/Less-Affected')
xlabel('Visit 1 Completion Time (ms)')
ylabel('Visit 2 Completion Time (ms)')
legend({'TD Preferred','UCP Preferred'},'Location','best')
hold off

coeff = corrcoef([comt_d_1,comt_l_1],[comt_d_2,comt_l_2]);
fprintf('Visits Comparison Dominant Completion Time\n')
disp(coeff)

% TD Non-Dominant Completion Time
figure
hold on
scatter(comt_n_1,comt_n_2,'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5)
scatter(comt_m_1,comt_m_2,'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5);
% maximum = max(cat(2,comt_n_1,comt_n_2,comt_m_1,comt_m_2));
% plot([0,maximum],[0,maximum],'k')
plot([0,33000],[0,33000],'k')
tick = get(gca, 'YTick');
set(gca, 'XTickLabel', tick/1000)
set(gca, 'YTickLabel', tick/1000)
%title('Orbital Reaching: Completion Time Comparing Visits for Non-Dominant/More-Affected')
xlabel('Visit 1 Completion Time (ms)')
ylabel('Visit 2 Completion Time (ms)')
legend({'TD Nonpreferred','UCP Nonpreferred'},'Location','best')
hold off

coeff = corrcoef([comt_n_1,comt_m_1],[comt_n_2,comt_m_2]);
fprintf('Visits Comparison Non-Dominant Completion Time\n')
disp(coeff)


            case 2
%% V1-V2 comparison RMSE

% TD Dominant RMSE
figure
hold on
scatter(rms_d_1,rms_d_2,'o','MarkerEdgeColor','#008083','LineWidth',1.5)
scatter(rms_l_1,rms_l_2,'o','MarkerEdgeColor','#F78104','LineWidth',1.5);
% maximum = max(cat(2,rms_d_1,rms_d_2,rms_l_1,rms_l_2));
% plot([0,maximum],[0,maximum],'k')
plot([0,24],[0,24],'k')
%title('Orbital Reaching: RMSE Comparing Visits for Dominant/Less-Affected')
xlabel('Visit 1 RMSE')
ylabel('Visit 2 RMSE')
legend({'TD Preferred','UCP Preferred'},'Location','best')
hold off

coeff = corrcoef([rms_d_1,rms_l_1],[rms_d_2,rms_l_2]);
fprintf('Visits Comparison Dominant RMSE\n')
disp(coeff)

% TD Non-Dominant RMSE
figure
hold on
scatter(rms_n_1,rms_n_2,'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5)
scatter(rms_m_1,rms_m_2,'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5);
% maximum = max(cat(2,rms_n_1,rms_n_2,rms_m_1,rms_m_2));
% plot([0,maximum],[0,maximum],'k')
plot([0,24],[0,24],'k')
%title('Orbital Reaching: RMSE Comparing Visits for Non-Dominant/More-Affected')
xlabel('Visit 1 RMSE')
ylabel('Visit 2 RMSE')
legend({'TD Nonpreferred','UCP Nonpreferred'},'Location','best')
hold off

coeff = corrcoef([rms_n_1,rms_m_1],[rms_n_2,rms_m_2]);
fprintf('Visits Comparison Non-Dominant RMSE\n')
disp(coeff)

            case 3
%% V1-V2 comparison Avg Velocity

% TD Dominant Avg Velocity
figure
hold on
scatter(vel_d_1,vel_d_2)
plot([0,max(cat(2,vel_d_1,vel_d_2))],[0,max(cat(2,vel_d_1,vel_d_2))])
title('Average Velocity Comparing Visits for TD Dominant')
xlabel('Visit 1 Average Velocity')
ylabel('Visit 2 Average Velocity')
hold off

coeff = corrcoef(vel_d_1,vel_d_2);
fprintf('Visits Comparison Dominant Average Velocity\n')
disp(coeff)

% TD Non-Dominant Avg Velocity
figure
hold on
scatter(vel_n_1,vel_n_2)
plot([0,max(cat(2,vel_n_1,vel_n_2))],[0,max(cat(2,vel_n_1,vel_n_2))])
title('Average Velocity Comparing Visits for TD Non-Dominant')
xlabel('Visit 1 Average Velocity')
ylabel('Visit 2 Average Velocity')
hold off

coeff = corrcoef(vel_n_1,vel_n_2);
fprintf('Visits Comparison Non-Dominant Average Velocity\n')
disp(coeff)

            case 4

%% V1-V2 comparison STDev Velocity

% TD Dominant STDev Velocity
figure
hold on
scatter(std_d_1,std_d_2)
plot([0,max(cat(2,std_d_1,std_d_2))],[0,max(cat(2,std_d_1,std_d_2))])
title('Standard Deviation of Velocity Comparing Visits for TD Dominant')
xlabel('Visit 1 Standard Deviation of Velocity')
ylabel('Visit 2 Standard Deviation of Velocity')
hold off

coeff = corrcoef(std_d_1,std_d_2);
fprintf('Visits Comparison Dominant Standard Deviation of Velocity\n')
disp(coeff)

% TD Non-Dominant STDev Velocity
figure
hold on
scatter(std_n_1,std_n_2)
plot([0,max(cat(2,std_n_1,std_n_2))],[0,max(cat(2,std_n_1,std_n_2))])
title('Standard Deviation of Velocity Comparing Visits for TD Non-Dominant')
xlabel('Visit 1 Standard Deviation of Velocity')
ylabel('Visit 2 Standard Deviation of Velocity')
hold off

coeff = corrcoef(std_n_1,std_n_2);
fprintf('Visits Comparison Non-Dominant Standard Deviation of Velocity\n')
disp(coeff)


            case 5
%% V1-V2 comparison Max Velocity

% TD Dominant max Velocity
figure
hold on
scatter(max_d_1,max_d_2)
plot([0,max(cat(2,max_d_1,max_d_2))],[0,max(cat(2,max_d_1,max_d_2))])
title('Maximum Velocity Comparing Visits for TD Dominant')
xlabel('Visit 1 Max Velocity')
ylabel('Visit 2 Max Velocity')
hold off

coeff = corrcoef(max_d_1,max_d_2);
fprintf('Visits Comparison Dominant Max Velocity\n')
disp(coeff)

% TD Non-Dominant max Velocity
figure
hold on
scatter(max_n_1,max_n_2)
plot([0,max(cat(2,max_n_1,max_n_2))],[0,max(cat(2,max_n_1,max_n_2))])
title('Maximum Velocity Comparing Visits for TD Non-Dominant')
xlabel('Visit 1 Max Velocity')
ylabel('Visit 2 Max Velocity')
hold off

coeff = corrcoef(max_n_1,max_n_2);
fprintf('Visits Comparison Non-Dominant Max Velocity\n')
disp(coeff)


        end

    case 2 % speed/accuracy

                   
%% TD speed/accuracy plots

% % Velocity/RMSE
% figure
% t = tiledlayout(2,2);
% 
% title(t,'Speed Accuracy Relationship for TD Cohort')
% 
% nexttile;
% hold on
% scatter(vel_d_1, rms_d_1);
% xlabel('Speed (Velocity - m/s)')
% ylabel('Accuracy (RMSE)')
% title('Dominant Visit 1')
% hold off
% 
% nexttile;
% hold on
% scatter(vel_d_2, rms_d_2);
% xlabel('Speed (Velocity - m/s)')
% ylabel('Accuracy (RMSE)')
% title('Dominant Visit 2')
% hold off
% 
% nexttile;
% hold on
% scatter(vel_n_1, rms_n_1);
% xlabel('Speed (Velocity - m/s)')
% ylabel('Accuracy (RMSE)')
% title('Non-Dominant Visit 1')
% hold off
% 
% nexttile;
% hold on
% scatter(vel_n_2, rms_n_2);
% xlabel('Speed (Velocity - m/s)')
% ylabel('Accuracy (RMSE)')
% title('Non-Dominant Visit 2')
% hold off
% 
% coeff = corrcoef(vel_d_1,rms_d_1);
% fprintf('Speed/Accuracy Dominant Visit 1\n')
% disp(coeff)
% 
% coeff = corrcoef(vel_d_2,rms_d_2);
% fprintf('Speed/Accuracy Dominant Visit 2\n')
% disp(coeff)
% 
% coeff = corrcoef(vel_n_1,rms_n_1);
% fprintf('Speed/Accuracy Non-Dominant Visit 1\n')
% disp(coeff)
% 
% coeff = corrcoef(vel_n_2,rms_n_2);
% fprintf('Speed/Accuracy Non-Dominant Visit 2\n')
% disp(coeff)

% Completion Time/RMSE
figure
t = tiledlayout(1,2);

%title(t,'Asteroid Belt: Speed Accuracy Relationship for TD Cohort')

nexttile;
hold on
scatter(comt_d_1/1000, rms_d_1,'o','MarkerEdgeColor','#008083','LineWidth',1.5)
scatter(comt_l_1/1000, rms_l_1,'o','MarkerEdgeColor','#F78104','LineWidth',1.5)
xlabel('Completion Time (s)')
ylabel('RMSE')
title('a')
hold off

nexttile;
hold on
scatter(comt_n_1/1000, rms_n_1,'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5)
scatter(comt_m_1/1000, rms_m_1,'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5)
xlabel('Completion Time (s)')
ylabel('RMSE')
title('b')

hTD  = scatter(nan,nan,40,'filled','MarkerEdgeColor','#008083','MarkerFaceColor','#008083');
hUCP = scatter(nan,nan,40,'filled','MarkerEdgeColor','#F78104','MarkerFaceColor','#F78104');
legend([hTD hUCP],{'TD','UCP'})
hold off

[coeff,p] = corrcoef(comt_d_1,rms_d_1);
fprintf('ComT/Accuracy Dominant Visit 1\n')
disp(coeff)
disp(p)

[coeff,p] = corrcoef(comt_n_1,rms_n_1);
fprintf('ComT/Accuracy Non-Dominant Visit 1\n')
disp(coeff)
disp(p)


    case 3 % Relationship with age (discrete)

%% Age - Discrete

for i=1:length(age_TD)
    age = age_TD(i);
    fdnm = ['age_' num2str(age)];

    vel_n_v1.(fdnm) = vel_n_1(age_TD == age);
    vel_n_v2.(fdnm) = vel_n_2(age_TD == age);
    vel_d_v1.(fdnm) = vel_d_1(age_TD == age);
    vel_d_v2.(fdnm) = vel_d_2(age_TD == age);

    avg_vel_n_v1.(fdnm) = mean(vel_n_v1.(fdnm));
    avg_vel_n_v2.(fdnm) = mean(vel_n_v2.(fdnm));
    avg_vel_d_v1.(fdnm) = mean(vel_d_v1.(fdnm));
    avg_vel_d_v2.(fdnm) = mean(vel_d_v2.(fdnm));

    std_n_v1.(fdnm) = std_n_1(age_TD == age);
    std_n_v2.(fdnm) = std_n_2(age_TD == age);
    std_d_v1.(fdnm) = std_d_1(age_TD == age);
    std_d_v2.(fdnm) = std_d_2(age_TD == age);

    avg_std_n_v1.(fdnm) = mean(std_n_v1.(fdnm));
    avg_std_n_v2.(fdnm) = mean(std_n_v2.(fdnm));
    avg_std_d_v1.(fdnm) = mean(std_d_v1.(fdnm));
    avg_std_d_v2.(fdnm) = mean(std_d_v2.(fdnm));

    max_n_v1.(fdnm) = max_n_1(age_TD == age);
    max_n_v2.(fdnm) = max_n_2(age_TD == age);
    max_d_v1.(fdnm) = max_d_1(age_TD == age);
    max_d_v2.(fdnm) = max_d_2(age_TD == age);

    avg_max_n_v1.(fdnm) = mean(max_n_v1.(fdnm));
    avg_max_n_v2.(fdnm) = mean(max_n_v2.(fdnm));
    avg_max_d_v1.(fdnm) = mean(max_d_v1.(fdnm));
    avg_max_d_v2.(fdnm) = mean(max_d_v2.(fdnm));

    comt_n_v1.(fdnm) = comt_n_1(age_TD == age);
    comt_n_v2.(fdnm) = comt_n_2(age_TD == age);
    comt_d_v1.(fdnm) = comt_d_1(age_TD == age);
    comt_d_v2.(fdnm) = comt_d_2(age_TD == age);

    avg_comt_n_v1.(fdnm) = mean(comt_n_v1.(fdnm));
    avg_comt_n_v2.(fdnm) = mean(comt_n_v2.(fdnm));
    avg_comt_d_v1.(fdnm) = mean(comt_d_v1.(fdnm));
    avg_comt_d_v2.(fdnm) = mean(comt_d_v2.(fdnm));

    rms_n_v1.(fdnm) = rms_n_1(age_TD == age);
    rms_n_v2.(fdnm) = rms_n_2(age_TD == age);
    rms_d_v1.(fdnm) = rms_d_1(age_TD == age);
    rms_d_v2.(fdnm) = rms_d_2(age_TD == age);

    avg_rms_n_v1.(fdnm) = mean(rms_n_v1.(fdnm));
    avg_rms_n_v2.(fdnm) = mean(rms_n_v2.(fdnm));
    avg_rms_d_v1.(fdnm) = mean(rms_d_v1.(fdnm));
    avg_rms_d_v2.(fdnm) = mean(rms_d_v2.(fdnm));
end

% sort into proper order
ages = fieldnames(avg_vel_n_v1);
num = cellfun(@(x) sscanf(x, 'age_%d'), ages);

[sorted, idx] = sort(num);
ages = ages(idx);

% extract values from structure into array
for i=1:8
    veln1(i) = avg_vel_n_v1.(ages{i});
    veln2(i) = avg_vel_n_v2.(ages{i});
    veld1(i) = avg_vel_d_v1.(ages{i});
    veld2(i) = avg_vel_d_v2.(ages{i});

    stdn1(i) = avg_std_n_v1.(ages{i});
    stdn2(i) = avg_std_n_v2.(ages{i});
    stdd1(i) = avg_std_d_v1.(ages{i});
    stdd2(i) = avg_std_d_v2.(ages{i});

    maxn1(i) = avg_max_n_v1.(ages{i});
    maxn2(i) = avg_max_n_v2.(ages{i});
    maxd1(i) = avg_max_d_v1.(ages{i});
    maxd2(i) = avg_max_d_v2.(ages{i});

    comtn1(i) = avg_comt_n_v1.(ages{i});
    comtn2(i) = avg_comt_n_v2.(ages{i});
    comtd1(i) = avg_comt_d_v1.(ages{i});
    comtd2(i) = avg_comt_d_v2.(ages{i});

    rmsn1(i) = avg_rms_n_v1.(ages{i});
    rmsn2(i) = avg_rms_n_v2.(ages{i});
    rmsd1(i) = avg_rms_d_v1.(ages{i});
    rmsd2(i) = avg_rms_d_v2.(ages{i});
end

% sort by visits and hand dominance
ages = [5 6 7 8 9 10 11 12];

vel_n = [veln1;veln2];
vel_d = [veld1;veld2];
std_n = [stdn1;stdn2];
std_d = [stdd1;stdd2];
max_n = [maxn1;maxn2];
max_d = [maxd1;maxd2];
comt_n = [comtn1;comtn2];
comt_d = [comtd1;comtd2];
rms_n = [rmsn1;rmsn2];
rms_d = [rmsd1;rmsd2];

vel_1 = [veln1;veld1];
vel_2 = [veln2;veld2];
std_1 = [stdn1;stdd1];
std_2 = [stdn2;stdd2];
max_1 = [maxn1;maxd1];
max_2 = [maxn2;maxd2];
comt_1 = [comtn1;comtd1];
comt_2 = [comtn2;comtd2];
rms_1 = [rmsn1;rmsd1];
rms_2 = [rmsn2;rmsd2];


    switch DV

        case 1
%% Completion Time

% By Handedness
figure
t = tiledlayout(1,2);

title(t,'Average Completion Time By Hand Dominance')

nexttile;
hold on
bar(ages,comt_n)
xlabel('Age')
ylabel('Completion Time')
legend({'Visit 1','Visit 2'})
title('Average Completion Time of Non-Dominant Hand')
hold off

nexttile;
hold on
bar(ages,comt_d)
xlabel('Age')
ylabel('Completion Time')
legend({'Visit 1','Visit 2'})
title('Average Completion Time of Dominant Hand')
hold off

% By Visit
figure
t = tiledlayout(1,2);

title(t,'Average Completion Time By Visit')

nexttile;
hold on
bar(ages,comt_1)
xlabel('Age')
ylabel('Completion Time')
legend({'Non-Dominant','Dominant'})
title('Average Completion Time of Visit 1')
hold off

nexttile;
hold on
bar(ages,comt_1)
xlabel('Age')
ylabel('Completion Time')
legend({'Non-Dominant','Dominant'})
title('Average Completion Time of Visit 2')
hold off


        case 2
%% RMSE

% By Handedness
figure
t = tiledlayout(1,2);

title(t,'RMSE By Hand Dominance')

nexttile;
hold on
bar(ages,rms_n)
xlabel('Age')
ylabel('RMSE')
legend({'Visit 1','Visit 2'})
title('RMSE of Non-Dominant Hand')
hold off

nexttile;
hold on
bar(ages,rms_d)
xlabel('Age')
ylabel('RMSE')
legend({'Visit 1','Visit 2'})
title('RMSE of Dominant Hand')
hold off

% By Visit
figure
t = tiledlayout(1,2);

title(t,'RMSE By Visit')

nexttile;
hold on
bar(ages,rms_1)
xlabel('Age')
ylabel('RMSE')
legend({'Non-Dominant','Dominant'})
title('RMSE of Visit 1')
hold off

nexttile;
hold on
bar(ages,rms_1)
xlabel('Age')
ylabel('RMSE')
legend({'Non-Dominant','Dominant'})
title('RMSE of Visit 2')
hold off


        case 3
%% Velocity

% By Handedness
figure
t = tiledlayout(1,2);

title(t,'Average Velocity By Hand Dominance')

nexttile;
hold on
bar(ages,vel_n)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Visit 1','Visit 2'})
title('Average Velocity of Non-Dominant Hand')
hold off

nexttile;
hold on
bar(ages,vel_d)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Visit 1','Visit 2'})
title('Average Velocity of Dominant Hand')
hold off

% By Visit
figure
t = tiledlayout(1,2);

title(t,'Average Velocity By Visit')

nexttile;
hold on
bar(ages,vel_1)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Non-Dominant','Dominant'})
title('Average Velocity of Visit 1')
hold off

nexttile;
hold on
bar(ages,vel_1)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Non-Dominant','Dominant'})
title('Average Velocity of Visit 2')
hold off


        case 4
%% Standard Deviation

% By Handedness
figure
t = tiledlayout(1,2);

title(t,'Average Standard Deviation By Hand Dominance')

nexttile;
hold on
bar(ages,std_n)
xlabel('Age')
ylabel('Standard Deviation (m/s)')
legend({'Visit 1','Visit 2'})
title('Average Standard Deviation of Non-Dominant Hand')
hold off

nexttile;
hold on
bar(ages,std_d)
xlabel('Age')
ylabel('Standard Deviation (m/s)')
legend({'Visit 1','Visit 2'})
title('Average Standard Deviation of Dominant Hand')
hold off

% By Visit
figure
t = tiledlayout(1,2);

title(t,'Average Standard Deviation By Visit')

nexttile;
hold on
bar(ages,std_1)
xlabel('Age')
ylabel('Standard Deviation (m/s)')
legend({'Non-Dominant','Dominant'})
title('Average Standard Deviation of Visit 1')
hold off

nexttile;
hold on
bar(ages,std_2)
xlabel('Age')
ylabel('Standard Deviation (m/s)')
legend({'Non-Dominant','Dominant'})
title('Average Standard Deviation of Visit 2')
hold off


        case 5
%% Max Velocity

% By Handedness
figure
t = tiledlayout(1,2);

title(t,'Maximum Velocity By Hand Dominance')

nexttile;
hold on
bar(ages,max_n)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Visit 1','Visit 2'})
title('Maximum Velocity of Non-Dominant Hand')
hold off

nexttile;
hold on
bar(ages,max_d)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Visit 1','Visit 2'})
title('Maximum Velocity of Dominant Hand')
hold off

% By Visit
figure
t = tiledlayout(1,2);

title(t,'Maximum Velocity By Visit')

nexttile;
hold on
bar(ages,max_1)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Non-Dominant','Dominant'})
title('Maximum Velocity of Visit 1')
hold off

nexttile;
hold on
bar(ages,max_2)
xlabel('Age')
ylabel('Velocity (m/s)')
legend({'Non-Dominant','Dominant'})
title('Maximum Velocity of Visit 2')
hold off


    end

    case 4 % Relationship with age (continuous)

        switch DV
            case 1
%% Age - Continuous

% Completion Time
figure
hold on

scatter(cont_age_TD,comt_n_1,'k','o','filled')
scatter(cont_age_TD,comt_n_2,'k','o','MarkerFaceColor', 'none')
scatter(cont_age_TD,comt_d_1,'r','o','filled')
scatter(cont_age_TD,comt_d_2,'r','o','MarkerFaceColor', 'none')

xlabel('Age');
ylabel('Completion Time (s)');
title('Dominant vs Non-Dominant Completion Time Across Visits by Age');
legend('Non-dom V1', 'Non-dom V2', 'Dom V1', 'Dom V2');
hold off

            case 2
% RMSE
figure
hold on

scatter(cont_age_TD,rms_n_1,'k','o','filled')
scatter(cont_age_TD,rms_n_2,'k','o','MarkerFaceColor', 'none')
scatter(cont_age_TD,rms_d_1,'r','o','filled')
scatter(cont_age_TD,rms_d_2,'r','o','MarkerFaceColor', 'none')

xlabel('Age');
ylabel('RMSE');
title('Dominant vs Non-Dominant RMSE Across Visits by Age');
legend('Non-dom V1', 'Non-dom V2', 'Dom V1', 'Dom V2');
hold off

            case 3
% Velocity
figure
hold on

scatter(cont_age_TD,vel_n_1,'k','o','filled')
scatter(cont_age_TD,vel_n_2,'k','o','MarkerFaceColor', 'none')
scatter(cont_age_TD,vel_d_1,'r','o','filled')
scatter(cont_age_TD,vel_d_2,'r','o','MarkerFaceColor', 'none')

xlabel('Age');
ylabel('Velocity (m/s)');
title('Dominant vs Non-Dominant Velocity Across Visits by Age');
legend('Non-dom V1', 'Non-dom V2', 'Dom V1', 'Dom V2');
hold off

            case 4
% StDev of Velocity
figure
hold on

scatter(cont_age_TD,std_n_1,'k','o','filled')
scatter(cont_age_TD,std_n_2,'k','o','MarkerFaceColor', 'none')
scatter(cont_age_TD,std_d_1,'r','o','filled')
scatter(cont_age_TD,std_d_2,'r','o','MarkerFaceColor', 'none')

xlabel('Age');
ylabel('StDev of Velocity (m/s)');
title('Dominant vs Non-Dominant StDev of Velocity Across Visits by Age');
legend('Non-dom V1', 'Non-dom V2', 'Dom V1', 'Dom V2');
hold off

            case 5
% Max Velocity
figure
hold on

scatter(cont_age_TD,max_n_1,'k','o','filled')
scatter(cont_age_TD,max_n_2,'k','o','MarkerFaceColor', 'none')
scatter(cont_age_TD,max_d_1,'r','o','filled')
scatter(cont_age_TD,max_d_2,'r','o','MarkerFaceColor', 'none')

xlabel('Age');
ylabel('Maximum Velocity (m/s)');
title('Dominant vs Non-Dominant Max Velocity Across Visits by Age');
legend('Non-dom V1', 'Non-dom V2', 'Dom V1', 'Dom V2');
hold off
        end
end

%% t-tests
rms1 = [rms_n_1,rms_d_1,rms_m_1,rms_l_1];
rms2 = [rms_n_2,rms_d_2,rms_m_2,rms_l_2];

[~,p_rms_1] = ttest(rms1,rms2,"Alpha",0.05);
fprintf("t-test results for RMSE: %2.4f\n", p_rms_1)

comt1 = [comt_n_1,comt_d_1,comt_m_1,comt_l_1];
comt2 = [comt_n_2,comt_d_2,comt_m_2,comt_l_2];

[~,p_comt_1] = ttest(comt1,comt2,"Alpha",0.05);
fprintf("t-test results for Completion Time: %2.4f\n", p_comt_1)

%cat(2,V1_dom,V2_dom,V1_non,V2_non...)
TDhalf = cat(2,rms_d_1',rms_d_2',rms_n_1',rms_n_2',comt_d_1',comt_d_2',comt_n_1',comt_n_2');
CPhalf = cat(2,rms_l_1',rms_l_2',rms_m_1',rms_m_2',comt_l_1',comt_l_2',comt_m_1',comt_m_2');
dataformat = cat(1,TDhalf,CPhalf);
% to SPSS!