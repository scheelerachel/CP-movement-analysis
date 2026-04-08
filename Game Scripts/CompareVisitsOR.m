% CompareVisitsOR.m
%
% Rachel Scheele
% Last Edited 10/8/2025

% Need script to:
% apply Bland-Altman to compare V1 and V2
% apply Fitt's Law for speed accuracy

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

    % Skip -> outlier
    if name == "MHEALTH132"
        continue
    end

    %% Romove Section Eventually
    % TEMPORARY!!!
    if name == "MHEALTH113"
        continue
    end
    if name == "MHEALTH116"
        continue
    end
    if name == "MHEALTH117"
        continue
    end
    if name == "MHEALTH138"
        continue
    end
    if name == "MHEALTH203"
        continue
    end

    %% Resume
    sv = append(name,"ORVariables");
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

%% Bland-Altman Velocity
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

yline(0,'green')
text(min(vel_mean_n),0.05,"V2 > V1")
text(min(vel_mean_n),-0.05,"V1 > V2")

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

yline(0,'green')
text(min(vel_mean_d),0.06,"V2 > V1")
text(min(vel_mean_d),-0.06,"V1 > V2")

title('Bland-Altman Plot for Velocity Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

%% Bland-Altman StDev Velocity
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

yline(0,'green')
text(max(std_mean_n)-0.15,0.03,"V2 > V1")
text(max(std_mean_n)-0.15,-0.03,"V1 > V2")

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

yline(0,'green')
text(min(std_mean_d),0.05,"V2 > V1")
text(min(std_mean_d),-0.05,"V1 > V2")

title('Bland-Altman Plot for StDev Velocity Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

%% Bland-Altman Max Velocity
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

yline(0,'green')
text(min(max_mean_n),0.08,"V2 > V1")
text(min(max_mean_n),-0.08,"V1 > V2")

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

yline(0,'green')
text(min(max_mean_d),0.12,"V2 > V1")
text(min(max_mean_d),-0.12,"V1 > V2")

title('Bland-Altman Plot for Max Velocity Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

%% Bland-Altman Completion Time
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

yline(0,'green')
text(max(comt_mean_n)-300,70,"V2 > V1")
text(max(comt_mean_n)-300,-70,"V1 > V2")

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

yline(0,'green')
text(max(comt_mean_d)-300,50,"V2 > V1")
text(max(comt_mean_d)-300,-50,"V1 > V2")

title('Bland-Altman Plot for Completion Time Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

%% Bland-Altman RMSE
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

yline(0,'green')
text(max(rms_mean_n)-15,8,"V2 > V1")
text(max(rms_mean_n)-15,-8,"V1 > V2")

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

yline(0,'green')
text(max(rms_mean_n)-20,7,"V2 > V1")
text(max(rms_mean_n)-20,-7,"V1 > V2")

title('Bland-Altman Plot for RMS Comparing Visits for Dominant')
xlabel('Average of Visit 1 and 2')
ylabel('Difference of Visit 1 and 2')
hold off

%% Fitts Law
%
% % T = a + b*(log_2(2*(D/W)))
% % where:
% % T = time
% % a and b are coefficients
% % D = distance to target
% % W = width of target
% % InxD = (log_2(2*(D/W)))
% 
% T_p1 = all_comt_n_1([1 9 17],:);
% T_p2 = all_comt_n_1([2 10 18],:);
% T_p3 = all_comt_n_1([3 11 19],:);
% T_p4 = all_comt_n_1([4 12 20],:);
% T_p5 = all_comt_n_1([5 13 21],:);
% T_p6 = all_comt_n_1([6 14 22],:);
% T_p7 = all_comt_n_1([7 15 23],:);
% T_p8 = all_comt_n_1([8 16 24],:);
% 
% T_p1 = reshape(T_p1,[],1);
% T_p2 = reshape(T_p2,[],1);
% T_p3 = reshape(T_p3,[],1);
% T_p4 = reshape(T_p4,[],1);
% T_p5 = reshape(T_p5,[],1);
% T_p6 = reshape(T_p6,[],1);
% T_p7 = reshape(T_p7,[],1);
% T_p8 = reshape(T_p8,[],1);
% T_n_v1 = cat(2,T_p1,T_p2,T_p3,T_p4, ...
%     T_p5,T_p6,T_p7,T_p8);
% 
% T_p1 = all_comt_n_2([1 9 17],:);
% T_p2 = all_comt_n_2([2 10 18],:);
% T_p3 = all_comt_n_2([3 11 19],:);
% T_p4 = all_comt_n_2([4 12 20],:);
% T_p5 = all_comt_n_2([5 13 21],:);
% T_p6 = all_comt_n_2([6 14 22],:);
% T_p7 = all_comt_n_2([7 15 23],:);
% T_p8 = all_comt_n_2([8 16 24],:);
% 
% T_p1 = reshape(T_p1,[],1);
% T_p2 = reshape(T_p2,[],1);
% T_p3 = reshape(T_p3,[],1);
% T_p4 = reshape(T_p4,[],1);
% T_p5 = reshape(T_p5,[],1);
% T_p6 = reshape(T_p6,[],1);
% T_p7 = reshape(T_p7,[],1);
% T_p8 = reshape(T_p8,[],1);
% T_n_v2 = cat(2,T_p1,T_p2,T_p3,T_p4, ...
%     T_p5,T_p6,T_p7,T_p8);
% 
% T_p1 = all_comt_d_1([1 9 17],:);
% T_p2 = all_comt_d_1([2 10 18],:);
% T_p3 = all_comt_d_1([3 11 19],:);
% T_p4 = all_comt_d_1([4 12 20],:);
% T_p5 = all_comt_d_1([5 13 21],:);
% T_p6 = all_comt_d_1([6 14 22],:);
% T_p7 = all_comt_d_1([7 15 23],:);
% T_p8 = all_comt_d_1([8 16 24],:);
% 
% T_p1 = reshape(T_p1,[],1);
% T_p2 = reshape(T_p2,[],1);
% T_p3 = reshape(T_p3,[],1);
% T_p4 = reshape(T_p4,[],1);
% T_p5 = reshape(T_p5,[],1);
% T_p6 = reshape(T_p6,[],1);
% T_p7 = reshape(T_p7,[],1);
% T_p8 = reshape(T_p8,[],1);
% T_d_v1 = cat(2,T_p1,T_p2,T_p3,T_p4, ...
%     T_p5,T_p6,T_p7,T_p8);
% 
% T_p1 = all_comt_d_2([1 9 17],:);
% T_p2 = all_comt_d_2([2 10 18],:);
% T_p3 = all_comt_d_2([3 11 19],:);
% T_p4 = all_comt_d_2([4 12 20],:);
% T_p5 = all_comt_d_2([5 13 21],:);
% T_p6 = all_comt_d_2([6 14 22],:);
% T_p7 = all_comt_d_2([7 15 23],:);
% T_p8 = all_comt_d_2([8 16 24],:);
% 
% T_p1 = reshape(T_p1,[],1);
% T_p2 = reshape(T_p2,[],1);
% T_p3 = reshape(T_p3,[],1);
% T_p4 = reshape(T_p4,[],1);
% T_p5 = reshape(T_p5,[],1);
% T_p6 = reshape(T_p6,[],1);
% T_p7 = reshape(T_p7,[],1);
% T_p8 = reshape(T_p8,[],1);
% T_d_v2 = cat(2,T_p1,T_p2,T_p3,T_p4, ...
%     T_p5,T_p6,T_p7,T_p8);
% 
% start = {[-597.6250,256];[-597.6250,341.3333];
%     [-597.6250,-341.3333];[-597.6250,-256];
%     [597.6250,256];[597.6250,341.3333];
%     [597.6250,-341.3333];[597.6250,-256]};
% target = {[48.2954,-48.2954];[6.8560e-15,-111.9672];
%     [9.8404e-15,160.7059];[155.7916,155.7916];
%     [-262.6923,3.2171e-14];[-229.9781,-229.9781];
%     [2.3898e-14,390.2857];[-321.9693,321.9693]};
% 
% start = cell2mat(start);
% target = cell2mat(target);
% diff = target - start;
% 
% D = sqrt(diff(:,1).^2 + diff(:,2).^2);
% W = 0.4; % TEMPORARY VALUE! NEED REAL ONE FROM RAIHAN
% 
% inxD = log2(2*(D/W));
% 
% %% Non-Dominant V1
% a = zeros(1,length(T_n_v1));
% b = zeros(1,length(T_n_v1));
% 
% for i=1:length(T_n_v1)
%     T = T_n_v1(i,:)';
% 
%     % Build regression design matrix: [1, ID]
%     X = [ones(size(inxD)), inxD];  % 8x2
% 
%     % Solve least-squares for [a; b]
%     params = X \ T;
% 
%     a(i) = params(1);
%     b(i) = params(2);
% end
% 
% c = {"#DE4323","#E08E36","#E0C02F","#1CA312","#3DD1A0","#2D9AD1","#7D3DD1","#D160BB"};
% figure
% for i=1:8
%     % Preallocate
%     ID = zeros(1,length(T_n_v1));
%     MT = zeros(1,length(T_n_v1));
% 
%     for j=1:length(T_n_v1)
%         ID(j) = a(j) + (b(j)*inxD(i));
%         MT(j) = T_n_v1(j,i);
%     end
%     hold on
%     scatter(ID,MT,'MarkerEdgeColor',c{i},'LineWidth',2)
% end
% legend('p1','p2','p3','p4','p5','p6','p7','p8')
% xlabel('Index of Difficulty (a + b(log_2(2D/W))')
% ylabel('Movement Time (T)')
% title('Visit 1 Non-Dominant Fitts Law')
% hold off
% 
% %% Dominant V1
% a = zeros(1,length(T_d_v1));
% b = zeros(1,length(T_d_v1));
% 
% for i=1:length(T_d_v1)
%     T = T_d_v1(i,:)';
% 
%     % Build regression design matrix: [1, ID]
%     X = [ones(size(inxD)), inxD];  % 8x2
% 
%     % Solve least-squares for [a; b]
%     params = X \ T;
% 
%     a(i) = params(1);
%     b(i) = params(2);
% end
% 
% c = {"#DE4323","#E08E36","#E0C02F","#1CA312","#3DD1A0","#2D9AD1","#7D3DD1","#D160BB"};
% figure
% for i=1:8
%     % Preallocate
%     ID = zeros(1,length(T_d_v1));
%     MT = zeros(1,length(T_d_v1));
% 
%     for j=1:length(T_d_v1)
%         ID(j) = a(j) + (b(j)*inxD(i));
%         MT(j) = T_d_v1(j,i);
%     end
%     hold on
%     scatter(ID,MT,'MarkerEdgeColor',c{i},'LineWidth',2)
% end
% legend('p1','p2','p3','p4','p5','p6','p7','p8')
% xlabel('Index of Difficulty (a + b(log_2(2D/W))')
% ylabel('Movement Time (T)')
% title('Visit 1 Dominant Fitts Law')
% hold off
% 
% %% Non-Dominant V2
% a = zeros(1,length(T_n_v2));
% b = zeros(1,length(T_n_v2));
% 
% for i=1:length(T_n_v2)
%     T = T_n_v2(i,:)';
% 
%     % Build regression design matrix: [1, ID]
%     X = [ones(size(inxD)), inxD];  % 8x2
% 
%     % Solve least-squares for [a; b]
%     params = X \ T;
% 
%     a(i) = params(1);
%     b(i) = params(2);
% end
% 
% c = {"#DE4323","#E08E36","#E0C02F","#1CA312","#3DD1A0","#2D9AD1","#7D3DD1","#D160BB"};
% figure
% for i=1:8
%     % Preallocate
%     ID = zeros(1,length(T_n_v2));
%     MT = zeros(1,length(T_n_v2));
% 
%     for j=1:length(T_n_v2)
%         ID(j) = a(j) + (b(j)*inxD(i));
%         MT(j) = T_n_v2(j,i);
%     end
%     hold on
%     scatter(ID,MT,'MarkerEdgeColor',c{i},'LineWidth',2)
% end
% legend('p1','p2','p3','p4','p5','p6','p7','p8')
% xlabel('Index of Difficulty (a + b(log_2(2D/W))')
% ylabel('Movement Time (T)')
% title('Visit 2 Non-Dominant Fitts Law')
% hold off
% 
% %% Dominant V1
% a = zeros(1,length(T_d_v2));
% b = zeros(1,length(T_d_v2));
% 
% for i=1:length(T_d_v2)
%     T = T_d_v2(i,:)';
% 
%     % Build regression design matrix: [1, ID]
%     X = [ones(size(inxD)), inxD];  % 8x2
% 
%     % Solve least-squares for [a; b]
%     params = X \ T;
% 
%     a(i) = params(1);
%     b(i) = params(2);
% end
% 
% c = {"#DE4323","#E08E36","#E0C02F","#1CA312","#3DD1A0","#2D9AD1","#7D3DD1","#D160BB"};
% figure
% for i=1:8
%     % Preallocate
%     ID = zeros(1,length(T_d_v2));
%     MT = zeros(1,length(T_d_v2));
% 
%     for j=1:length(T_d_v2)
%         ID(j) = a(j) + (b(j)*inxD(i));
%         MT(j) = T_d_v1(j,i);
%     end
%     hold on
%     scatter(ID,MT,'MarkerEdgeColor',c{i},'LineWidth',2)
% end
% legend('p1','p2','p3','p4','p5','p6','p7','p8')
% xlabel('Index of Difficulty (a + b(log_2(2D/W))')
% ylabel('Movement Time (T)')
% title('Visit 2 Dominant Fitts Law')
% hold off
