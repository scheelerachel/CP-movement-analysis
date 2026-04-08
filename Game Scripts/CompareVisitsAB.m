% CompareVisitsAB.m
%
% Rachel Scheele
% Last Edited 9/25/2025

% Need script to:
% apply Bland-Altman to compare V1 and V2

% Run PreprocessingCheck and GameDataGrouping before running this

% Clean workspace and command window
clear;
close all;
clc;

%% load structures
load("game_data_check.mat")
load("population_game_data.mat")

for i=1:length(game_data_all)
    name = game_data_all(i).ID;
    temp = game_data_all(i).Asteroid_Belt;

    if isempty(temp)
        continue
    end

    % Skip -> outlier
    if name == "MHEALTH132"
        continue
    end

    %% Romove Section Eventually
    % TEMPORARY!!!
    if name == "MHEALTH103"
        continue
    end
    if name == "MHEALTH114"
        continue
    end
    if name == "MHEALTH121"
        continue
    end
    if name == "MHEALTH203"
        continue
    end

    %% Resume
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

        all_comt_m_1(:,i) = data.completion_time_more_aff_1;
        all_comt_m_2(:,i) = data.completion_time_more_aff_2;
        all_comt_l_1(:,i) = data.completion_time_less_aff_1;
        all_comt_l_2(:,i) = data.completion_time_less_aff_2;

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

        all_comt_n_1(:,i) = data.completion_time_nondom_1;
        all_comt_n_2(:,i) = data.completion_time_nondom_2;
        all_comt_d_1(:,i) = data.completion_time_dom_1;
        all_comt_d_2(:,i) = data.completion_time_dom_2;

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

all_comt_m_1(:, all(all_comt_m_1 == 0,1)) = [];
all_comt_m_2(:, all(all_comt_m_2 == 0,1)) = [];
all_comt_l_1(:, all(all_comt_l_1 == 0,1)) = [];
all_comt_l_2(:, all(all_comt_l_2 == 0,1)) = [];

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

all_comt_n_1(:, all(all_comt_n_1 == 0,1)) = [];
all_comt_n_2(:, all(all_comt_n_2 == 0,1)) = [];
all_comt_d_1(:, all(all_comt_d_1 == 0,1)) = [];
all_comt_d_2(:, all(all_comt_d_2 == 0,1)) = [];

rms_n_1 = rms_n_1(rms_n_1 ~= 0);
rms_n_2 = rms_n_2(rms_n_2 ~= 0);
rms_d_1 = rms_d_1(rms_d_1 ~= 0);
rms_d_2 = rms_d_2(rms_d_2 ~= 0);

%% Bland-Altman
% Velocity Non-Dominant
vel_mean_n = (vel_n_1 + vel_n_2)/2;
vel_diff_n = (vel_n_2 - vel_n_1);
y = mean(vel_diff_n);
stdev = std(vel_diff_n);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(vel_mean_n,vel_diff_n)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for Velocity Comparing Visits for Non-Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% Velocity Dominant
vel_mean_d = (vel_d_1 + vel_d_2)/2;
vel_diff_d = (vel_d_2 - vel_d_1);
y = mean(vel_diff_d);
stdev = std(vel_diff_d);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(vel_mean_d,vel_diff_d)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for Velocity Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% StDev Velocity Non-Dominant
std_mean_n = (std_n_1 + std_n_2)/2;
std_diff_n = (std_n_2 - std_n_1);
y = mean(std_diff_n);
stdev = std(std_diff_n);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(std_mean_n,std_diff_n)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for StDev Velocity Comparing Visits for Non-Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% StDev Velocity Dominant
std_mean_d = (std_d_1 + std_d_2)/2;
std_diff_d = (std_d_2 - std_d_1);
y = mean(std_diff_d);
stdev = std(std_diff_d);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(std_mean_d,std_diff_d)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for StDev Velocity Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% Max Velocity Non-Dominant
max_mean_n = (max_n_1 + max_n_2)/2;
rms_diff_n = (max_n_2 - max_n_1);
y = mean(rms_diff_n);
stdev = std(rms_diff_n);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(max_mean_n,rms_diff_n)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for Max Velocity Comparing Visits for Non-Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% Max Velocity Dominant
max_mean_d = (max_d_1 + max_d_2)/2;
max_diff_d = (max_d_2 - max_d_1);
y = mean(max_diff_d);
stdev = std(max_diff_d);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(max_mean_d,max_diff_d)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for Max Velocity Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% Completion Time Non-Dominant
comt_mean_n = (comt_n_1 + comt_n_2)/2;
comt_diff_n = (comt_n_2 - comt_n_1);
y = mean(comt_diff_n);
stdev = std(comt_diff_n);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(comt_mean_n,comt_diff_n)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for Completion Time Comparing Visits for Non-Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% Completion Time Dominant
comt_mean_d = (comt_d_1 + comt_d_2)/2;
comt_diff_d = (comt_d_2 - comt_d_1);
y = mean(comt_diff_d);
stdev = std(comt_diff_d);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(comt_mean_d,comt_diff_d)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for Completion Time Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% RMS Non-Dominant
rms_mean_n = (rms_n_1 + rms_n_2)/2;
rms_diff_n = (rms_n_2 - rms_n_1);
y = mean(rms_diff_n);
stdev = std(rms_diff_n);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(rms_mean_n,rms_diff_n)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for RMS Comparing Visits for Non-Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

% RMS Dominant
rms_mean_d = (rms_d_1 + rms_d_2)/2;
rms_diff_d = (rms_d_2 - rms_d_1);
y = mean(rms_diff_d);
stdev = std(rms_diff_d);
high = y + 2*stdev;
low = y - 2*stdev;

figure
hold on
scatter(rms_mean_d,rms_diff_d)
yline(y)
yline(high)
yline(low)
title('Bland-Altman Plot for RMS Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off