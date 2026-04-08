% MarkerPlacement.m
%
% Rachel Scheele
% Last Edited 2/25/2025

% Need script to:
% Calculate ROM, min, max, and plot

% Clean workspace and command window
clear;
close all;
clc;

%% Load
user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
'University'], ['Documents - Pediatric Movement and ' ...
'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

filePF = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');

if exist(filepath, 'dir')==0
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    filePF = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');
end

fileDJ = fullfile(filepath,'Analysis\MATLAB scripts\MCdata_joints.mat');
load(fileDJ);

%% Selection
selection = menu('Select Joint', 'Shoulder Ab/Adduction', ...
    'Shoulder Flexion/Extension', 'Shoulder Horizontal Ab/Aduction', ...
    'Elbow Pronation/Supination', 'Elbow Flexion/Extension', ...
    'Wrist Flexion/Extension', 'Wrist Radial/Ulnar Deviation','ALL');

if selection == 8
    for k=1:7
        run_joint_case(MCdata_joints,k);
    end
else
    run_joint_case(MCdata_joints,selection);
end

function run_joint_case(MCdata_joints,selection)
    switch selection
        case 1 % Shoulder Ab/Adduction
            joint = 'sho_abduct';
            joint_name = 'Shoulder Ab/Adduction';
        case 2 % Shoulder Flex/Extend
            joint = 'sho_flex';
            joint_name = 'Shoulder Flexion/Extension';
        case 3 % Shoulder Horizontal Ab/Aduction
            joint = 'sho_horabduct';
            joint_name = 'Shoulder Horizontal Ab/Adduction';
        case 4 % Elbow Pronate/Supinate
            joint = 'elb_pronat';
            joint_name = 'Elbow Pronation/Supination';
        case 5 % Elbow Flex/Extend
            joint = 'elb_flex';
            joint_name = 'Elbow Flexion/Extension';
        case 6 % Wrist Flex/Extend
            joint = 'wr_flex';
            joint_name = 'Wrist Flexion/Extension';
        case 7 % Wrist Radial/Ulnar Dev
            joint = 'wr_rudev';
            joint_name = 'Wrist Radial/Ulnar Deviation';
    end

    %% Calculate ROM, min and max
    for i=1:length(MCdata_joints.(joint))
        
        % check
        if isempty(MCdata_joints.(joint)(i))
            continue
        end

        % CP/TD
        name = MCdata_joints.(joint)(i).ID;
        if str2num(name(8)) == 1
            cp(i) = false;

            % average
            avg_td_dR1(i,:) = mean(MCdata_joints.(joint)(i).dom_RL_1);
            avg_td_dR2(i,:) = mean(MCdata_joints.(joint)(i).dom_RL_2);
            avg_td_dL1(i,:) = mean(MCdata_joints.(joint)(i).dom_LR_1);
            avg_td_dL2(i,:) = mean(MCdata_joints.(joint)(i).dom_LR_2);
            avg_td_nR1(i,:) = mean(MCdata_joints.(joint)(i).non_RL_1);
            avg_td_nR2(i,:) = mean(MCdata_joints.(joint)(i).non_RL_2);
            avg_td_nL1(i,:) = mean(MCdata_joints.(joint)(i).non_LR_1);
            avg_td_nL2(i,:) = mean(MCdata_joints.(joint)(i).non_LR_2);
    
            % % Dominant R-L V1
            % min_td_dR1(i) = min(avg_td_dR1(i));
            % max_td_dR1(i) = max(avg_td_dR1(i));
            % rom_td_dR1(i) = max_td_dR1(i)-min_td_dR1(i);
            % % Dominant R-L V2
            % min_td_dR2(i) = min(avg_td_dR2(i));
            % max_td_dR2(i) = max(avg_td_dR2(i));
            % rom_td_dR2(i) = max_td_dR2(i)-min_td_dR2(i);
            % % Dominant L-R V1
            % min_td_dL1(i) = min(avg_td_dL1(i));
            % max_td_dL1(i) = max(avg_td_dL1(i));
            % rom_td_dL1(i) = max_td_dL1(i)-min_td_dL1(i);
            % % Dominant L-R V2
            % min_td_dL2(i) = min(avg_td_dL2(i));
            % max_td_dL2(i) = max(avg_td_dL2(i));
            % rom_td_dL2(i) = max_td_dL2(i)-min_td_dL2(i);
            % % Non-Dominant R-L V1
            % min_td_nR1(i) = min(avg_td_nR1(i));
            % max_td_nR1(i) = max(avg_td_nR1(i));
            % rom_td_nR1(i) = max_td_nR1(i)-min_td_nR1(i);
            % % Non-Dominant R-L V2
            % min_td_nR2(i) = min(avg_td_nR2(i));
            % max_td_nR2(i) = max(avg_td_nR2(i));
            % rom_td_nR2(i) = max_td_nR2(i)-min_td_nR2(i);
            % % Non-Dominant L-R V1
            % min_td_nL1(i) = min(avg_td_nL1(i));
            % max_td_nL1(i) = max(avg_td_nL1(i));
            % rom_td_nL1(i) = max_td_nL1(i)-min_td_nL1(i);
            % % Non-Dominant L-R V2
            % min_td_nL2(i) = min(avg_td_nL2(i));
            % max_td_nL2(i) = max(avg_td_nL2(i));
            % rom_td_nL2(i) = max_td_nL2(i)-min_td_nL2(i);

        elseif str2num(name(8)) == 2
            cp(i) = true;

            % average
            avg_cp_dR1(i,:) = mean(MCdata_joints.(joint)(i).dom_RL_1);
            avg_cp_dR2(i,:) = mean(MCdata_joints.(joint)(i).dom_RL_2);
            avg_cp_dL1(i,:) = mean(MCdata_joints.(joint)(i).dom_LR_1);
            avg_cp_dL2(i,:) = mean(MCdata_joints.(joint)(i).dom_LR_2);
            avg_cp_nR1(i,:) = mean(MCdata_joints.(joint)(i).non_RL_1);
            avg_cp_nR2(i,:) = mean(MCdata_joints.(joint)(i).non_RL_2);
            avg_cp_nL1(i,:) = mean(MCdata_joints.(joint)(i).non_LR_1);
            avg_cp_nL2(i,:) = mean(MCdata_joints.(joint)(i).non_LR_2);
    
            % % Dominant R-L V1
            % min_cp_dR1(i) = min(avg_cp_dR1(i));
            % max_cp_dR1(i) = max(avg_cp_dR1(i));
            % rom_cp_dR1(i) = max_cp_dR1(i)-min_cp_dR1(i);
            % % Dominant R-L V2
            % min_cp_dR2(i) = min(avg_cp_dR2(i));
            % max_cp_dR2(i) = max(avg_cp_dR2(i));
            % rom_cp_dR2(i) = max_cp_dR2(i)-min_cp_dR2(i);
            % % Dominant L-R V1
            % min_cp_dL1(i) = min(avg_cp_dL1(i));
            % max_cp_dL1(i) = max(avg_cp_dL1(i));
            % rom_cp_dL1(i) = max_cp_dL1(i)-min_cp_dL1(i);
            % % Dominant L-R V2
            % min_cp_dL2(i) = min(avg_cp_dL2(i));
            % max_cp_dL2(i) = max(avg_cp_dL2(i));
            % rom_cp_dL2(i) = max_cp_dL2(i)-min_cp_dL2(i);
            % % Non-Dominant R-L V1
            % min_cp_nR1(i) = min(avg_cp_nR1(i));
            % max_cp_nR1(i) = max(avg_cp_nR1(i));
            % rom_cp_nR1(i) = max_cp_nR1(i)-min_cp_nR1(i);
            % % Non-Dominant R-L V2
            % min_cp_nR2(i) = min(avg_cp_nR2(i));
            % max_cp_nR2(i) = max(avg_cp_nR2(i));
            % rom_cp_nR2(i) = max_cp_nR2(i)-min_cp_nR2(i);
            % % Non-Dominant L-R V1
            % min_cp_nL1(i) = min(avg_cp_nL1(i));
            % max_cp_nL1(i) = max(avg_cp_nL1(i));
            % rom_cp_nL1(i) = max_cp_nL1(i)-min_cp_nL1(i);
            % % Non-Dominant L-R V2
            % min_cp_nL2(i) = min(avg_cp_nL2(i));
            % max_cp_nL2(i) = max(avg_cp_nL2(i));
            % rom_cp_nL2(i) = max_cp_nL2(i)-min_cp_nL2(i);
        end

        
    end
    
    %% Plot
    p = 1;
    if p == 1
        x = linspace(0,100,length(avg_td_dR1));
    
        figure(1)
        plot(x,avg_td_dR1,Color='r')
        hold on
        plot(x,avg_td_dR2,Color='b')
        title(append(joint_name,' TD Dominant R>L'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(2)
        plot(x,avg_td_dL1,Color='r')
        hold on
        plot(x,avg_td_dL2,Color='b')
        title(append(joint_name,' TD Dominant L>R'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(3)
        plot(x,avg_td_nR1,Color='r')
        hold on
        plot(x,avg_td_nR2,Color='b')
        title(append(joint_name,' TD Non-Dominant R>L'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(4)
        plot(x,avg_td_nL1,Color='r')
        hold on
        plot(x,avg_td_nL2,Color='b')
        title(append(joint_name,' TD Non-Dominant L>R'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(5)
        plot(x,avg_cp_dR1,Color='r')
        hold on
        plot(x,avg_cp_dR2,Color='b')
        title(append(joint_name,' CP Dominant R>L'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(6)
        plot(x,avg_cp_dL1,Color='r')
        hold on
        plot(x,avg_cp_dL2,Color='b')
        title(append(joint_name,'CP Dominant L>R'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(7)
        plot(x,avg_cp_nR1,Color='r')
        hold on
        plot(x,avg_cp_nR2,Color='b')
        title(append(joint_name,' CP Non-Dominant R>L'))
        legend('Visit 1','Visit 2')
        hold off
    
        figure(8)
        plot(x,avg_cp_nL1,Color='r')
        hold on
        plot(x,avg_cp_nL2,Color='b')
        title(append(joint_name,' CP Non-Dominant L>R'))
        legend('Visit 1','Visit 2')
        hold off
    end
end