% biomechZoo_dataEval.m
%
% Rachel Scheele
% Last Edited 3/12/2025

% Need script to:
% Combine all MC participant data into one structure for further analysis

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

fileGDA = fullfile(filepath,'Analysis\MATLAB scripts\population_game_data.mat');
load(fileGDA);

number = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
participant = append('MHEALTH',number);
matfile = append(participant,'.mat');

fileGDI = fullfile(filepath,'Data\Game Data\Individual',participant);
game = load(fileGDI);

%% Organize data into structure
alldata = struct();
hand = game.AsteroidBelt.trial_hand;
num = game.AsteroidBelt.trial_no;

for i=1:length(hand)
    visit = sprintf('V%d',ceil(i/12));
    trialnum = mod(i-1,12) + 1;
    trial = sprintf('trial_%02d',trialnum);
    
    fileData = fullfile(filePF,participant,visit,trial);
    load(fileData);

    if isequal(visit,'V1')
        if isequal(hand(i),{'Right'})
            alldata1(i).rsho_abduct = data.RShoulderKinemat.line(:,1);
            alldata1(i).rsho_flex = data.RShoulderKinemat.line(:,2);
            alldata1(i).rsho_horabduct = data.RShoulderKinemat.line(:,3);
    
            alldata1(i).relb_pronat = data.RElbowKinemat.line(:,1);
            alldata1(i).relb_flex = sqrt(data.RElbowKinemat.line(:,2).^2 + data.RElbowKinemat.line(:,3).^2);
    
            alldata1(i).rwr_flex = data.RWristKinemat.line(:,2);
            alldata1(i).rwr_rudev = data.RWristKinemat.line(:,3);
    
        elseif isequal(hand(i),{'Left'})
            alldata1(i).lsho_abduct = data.LShoulderKinemat.line(:,1);
            alldata1(i).lsho_flex = data.LShoulderKinemat.line(:,2);
            alldata1(i).lsho_horabduct = data.LShoulderKinemat.line(:,3);
    
            alldata1(i).lelb_pronat = data.LElbowKinemat.line(:,1);
            alldata1(i).lelb_flex = sqrt(data.LElbowKinemat.line(:,2).^2 + data.LElbowKinemat.line(:,3).^2);
    
            alldata1(i).lwr_flex = data.LWristKinemat.line(:,2);
            alldata1(i).lwr_rudev = data.LWristKinemat.line(:,3);
        end
    elseif isequal(visit,'V2')
        if isequal(hand(i),{'Right'})
            alldata2(i).rsho_abduct = data.RShoulderKinemat.line(:,1);
            alldata2(i).rsho_flex = data.RShoulderKinemat.line(:,2);
            alldata2(i).rsho_horabduct = data.RShoulderKinemat.line(:,3);

            alldata2(i).relb_pronat = data.RElbowKinemat.line(:,1);
            alldata2(i).relb_flex = sqrt(data.RElbowKinemat.line(:,2).^2 + data.RElbowKinemat.line(:,3).^2);

            alldata2(i).rwr_flex = data.RWristKinemat.line(:,2);
            alldata2(i).rwr_rudev = data.RWristKinemat.line(:,3);

        elseif isequal(hand(i),{'Left'})
            alldata2(i).lsho_abduct = data.LShoulderKinemat.line(:,1);
            alldata2(i).lsho_flex = data.LShoulderKinemat.line(:,2);
            alldata2(i).lsho_horabduct = data.LShoulderKinemat.line(:,3);

            alldata2(i).lelb_pronat = data.LElbowKinemat.line(:,1);
            alldata2(i).lelb_flex = sqrt(data.LElbowKinemat.line(:,2).^2 + data.LElbowKinemat.line(:,3).^2);

            alldata2(i).lwr_flex = data.LWristKinemat.line(:,2);
            alldata2(i).lwr_rudev = data.LWristKinemat.line(:,3);
        end
    end
end

%% Determine Handedness
for i=1:length(game_data_all)
    if game_data_all(i).ID == participant
        age = game_data_all(i).Chron_Age;
        sex = game_data_all(i).Sex;
        diagnosis = game_data_all(i).Diagnosis;
        non_pref = game_data_all(i).NonPrefered_Hand;
        pref = game_data_all(i).Prefered_Hand;
    end
end

%% Select Joint
selection = menu('Select Joint', 'Shoulder Ab/Adduction', ...
    'Shoulder Flexion/Extension', 'Shoulder Horizontal Ab/Aduction', ...
    'Elbow Pronation/Supination', 'Elbow Flexion/Extension', ...
    'Wrist Flexion/Extension', 'Wrist Radial/Ulnar Deviation','ALL');

if selection == 8
    for k=1:7
        run_joint_case(k,pref,alldata1,alldata2,participant,filepath);
    end
else
    run_joint_case(selection,pref,alldata1,alldata2,participant,filepath);
end

function run_joint_case(selection,pref,alldata1,alldata2,participant,filepath)
    switch selection
        case 1 % Shoulder Ab/Adduction
            joint = 'sho_abduct';
            joint_name = 'Shoulder Ab/Adduction';
            joint_letter = 'a';
        case 2 % Shoulder Flex/Extend
            joint = 'sho_flex';
            joint_name = 'Shoulder Flexion/Extension';
            joint_letter = 'b';
        case 3 % Shoulder Horizontal Ab/Aduction
            joint = 'sho_horabduct';
            joint_name = 'Shoulder Horizontal Ab/Adduction';
            joint_letter = 'c';
        case 4 % Elbow Pronate/Supinate
            joint = 'elb_pronat';
            joint_name = 'Elbow Pronation/Supination';
            joint_letter = 'd';
        case 5 % Elbow Flex/Extend
            joint = 'elb_flex';
            joint_name = 'Elbow Flexion/Extension';
            joint_letter = 'e';
        case 6 % Wrist Flex/Extend
            joint = 'wr_flex';
            joint_name = 'Wrist Flexion/Extension';
            joint_letter = 'f';
        case 7 % Wrist Radial/Ulnar Dev
            joint = 'wr_rudev';
            joint_name = 'Wrist Radial/Ulnar Deviation';
            joint_letter = 'g';
    end
    
    %% Calculate Average and standardize
    if isequal(pref,'Left')
        njoint = append('r',joint);
        djoint = append('l',joint);
    elseif isequal(pref,'Right')
        djoint = append('r',joint);
        njoint = append('l',joint);
    else
        fprintf('Error in handedness\n')
    end
    
    nPoints = 2000;
    
    [dom_leftMat1,dom_rightMat1,dom_leftMean1,dom_rightMean1,dom_leftSD1,dom_rightSD1] = processjoint(alldata1,djoint,nPoints);
    [non_leftMat1,non_rightMat1,non_leftMean1,non_rightMean1,non_leftSD1,non_rightSD1] = processjoint(alldata1,njoint,nPoints);
    
    % [dom_leftMat2,dom_rightMat2,dom_leftMean2,dom_rightMean2,dom_leftSD2,dom_rightSD2] = processjoint(alldata2,djoint,nPoints);
    % [non_leftMat2,non_rightMat2,non_leftMean2,non_rightMean2,non_leftSD2,non_rightSD2] = processjoint(alldata2,njoint,nPoints);
    
    %% Range of motion
    % Print ROM Dominant V1
    dom_lowbd = min([dom_leftMean1,dom_rightMean1]);
    dom_upbd = max([dom_leftMean1,dom_rightMean1]);
    dom_diff1 = abs(dom_upbd - dom_lowbd);
    fprintf('\nROM for Dominant V1 %s: %2.2f degrees\n',joint_name,dom_diff1)
    
    % Print ROM Non-Dominant V1
    non_lowbd = min([non_leftMean1,non_rightMean1]);
    non_upbd = max([non_leftMean1,non_rightMean1]);
    non_diff1 = abs(non_upbd - non_lowbd);
    fprintf('ROM for Non-Dominant V1 %s: %2.2f degrees\n',joint_name,non_diff1)

    % % Print ROM Dominant V2
    % dom_lowbd = min([dom_leftMean2,dom_rightMean2]);
    % dom_upbd = max([dom_leftMean2,dom_rightMean2]);
    % dom_diff2 = abs(dom_upbd - dom_lowbd);
    % fprintf('ROM for Dominant V2 %s: %2.2f degrees\n',joint_name,dom_diff2)
    % 
    % % Print ROM Non-Dominant V2
    % non_lowbd = min([non_leftMean2,non_rightMean2]);
    % non_upbd = max([non_leftMean2,non_rightMean2]);
    % non_diff2 = abs(non_upbd - non_lowbd);
    % fprintf('ROM for Non-Dominant V2 %s: %2.2f degrees\n',joint_name,non_diff2)

    %% Save data in Structure
    joints = {'sho_abduct','sho_flex','sho_horabduct', ...
        'elb_pronat','elb_flex','wr_flex','wr_rudev','ROM'};
    
    sample = {'MHEALTH110','MHEALTH118','MHEALTH126','MHEALTH130',...
        'MHEALTH135','MHEALTH136','MHEALTH137','MHEALTH138',...
        'MHEALTH139','MHEALTH141','MHEALTH203','MHEALTH204',...
        'MHEALTH205','MHEALTH207','MHEALTH208','MHEALTH212','MHEALTH214'};
    
    filesv = fullfile(filepath,'Analysis\MATLAB scripts\MCdata_joints.mat');
   
    if exist(filesv,'file')
        load(filesv)
    else
        for i=1:numel(joints)-1
            MCdata_joints.(joints{i}) = repmat(struct('ID', "", ...
                'dom_LR_1', [],'dom_RL_1', [],'non_LR_1', [], ...
                'non_RL_1'), numel(sample), 1);

            MCdata_joints.ROM.(joints{i}) = repmat(struct('ID', "", ...
                'dom_1', [], 'non_1'), numel(sample), 1);

            for j=1:numel(sample)
                MCdata_joints.(joints{i})(j).ID = sample{j};
                MCdata_joints.ROM.(joints{i})(j).ID = sample{j};
            end
        end
    end % only runs on first iteration
    
    ind = find(strcmp({MCdata_joints.(joint).ID},participant));

    MCdata_joints.(joint)(ind).dom_LR_1 = dom_leftMat1;
    MCdata_joints.(joint)(ind).dom_RL_1 = dom_rightMat1;
    MCdata_joints.(joint)(ind).non_LR_1 = non_leftMat1;
    MCdata_joints.(joint)(ind).non_RL_1 = non_rightMat1;
    
    % MCdata_joints.(joint)(ind).dom_LR_2 = dom_leftMat2;
    % MCdata_joints.(joint)(ind).dom_RL_2 = dom_rightMat2;
    % MCdata_joints.(joint)(ind).non_LR_2 = non_leftMat2;
    % MCdata_joints.(joint)(ind).non_RL_2 = non_rightMat2;

    MCdata_joints.ROM.(joint)(ind).dom_1 = dom_diff1;
    MCdata_joints.ROM.(joint)(ind).non_1 = non_diff1;
    % MCdata_joints.ROM.(joint)(ind).dom_2 = dom_diff2;
    % MCdata_joints.ROM.(joint)(ind).non_2 = non_diff2;

    save(filesv,'MCdata_joints');
    
    %% Plot Individual
    fig = 1;
    if fig == 1
        figure
        x = linspace(0,1,nPoints);
        x = x(:)';  % ensure row
        
        % Force row vectors and compute all bounds
        dL = dom_leftMean1(:)';  dLs = dom_leftSD1(:)';
        dR = dom_rightMean1(:)'; dRs = dom_rightSD1(:)';
        nL = non_leftMean1(:)';  nLs = non_leftSD1(:)';
        nR = non_rightMean1(:)'; nRs = non_rightSD1(:)';
    
        % Compute global y-axis limits
        allMin = min([dL-dLs, dR-dRs, nL-nLs, nR-nRs]);
        allMax = max([dL+dLs, dR+dRs, nL+nLs, nR+nRs]);
        pad = 0.05 * (allMax - allMin);
        
        % Colors
        left_mean   = [0 0.4470 0.7410];
        right_mean = [0.4940 0.1840 0.5560];
        
        tiledlayout(1,2);
    
        % Dominant Limb
        nexttile; hold on
        title('Preferred Limb')
        xlabel('Normalized Time'); ylabel('Degrees')
        
        plot(x, dom_leftMat1','Color',left_mean)  % light trial lines
        plot(x, dom_rightMat1','Color',right_mean)
        
        % SD shaded regions
        fill([x fliplr(x)], [(dL-dLs) fliplr(dL+dLs)], left_mean, 'FaceAlpha',0.15,'EdgeColor','none');
        fill([x fliplr(x)], [(dR-dRs) fliplr(dR+dRs)], right_mean, 'FaceAlpha',0.15,'EdgeColor','none');
    
        % Mean lines
        h1 = plot(x, dL, 'Color', left_mean, 'LineWidth',3);
        h2 = plot(x, dR, 'Color', right_mean, 'LineWidth',3);
        
        %legend([h1 h2],{'L→R Mean','R→L Mean'})
        ylim([allMin-pad, allMax+pad])
    
        % Non-Dominant Limb
        nexttile; hold on
        title('Nonpreferrred Limb')
        xlabel('Normalized Time'); ylabel('Degrees')
        
        plot(x, non_leftMat1','Color',left_mean)
        plot(x, non_rightMat1','Color',right_mean)
        
        fill([x fliplr(x)], [(nL-nLs) fliplr(nL+nLs)], left_mean, 'FaceAlpha',0.15,'EdgeColor','none');
        fill([x fliplr(x)], [(nR-nRs) fliplr(nR+nRs)], right_mean, 'FaceAlpha',0.15,'EdgeColor','none');
    
        h1 = plot(x, nL, 'Color', left_mean, 'LineWidth',3);
        h2 = plot(x, nR, 'Color', right_mean, 'LineWidth',3);
        
        legend([h1 h2],{'L→R Mean','R→L Mean'})
        ylim([allMin-pad, allMax+pad])
    
        sgtitle(joint_letter)
    end
end