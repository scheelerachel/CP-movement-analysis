% MCgroupplot.m
%
% Rachel Scheele
% Last Edited 3/12/2025

% Need script to:
% plot MC group data

% Clean workspace and command window
clear;
close all;
clc;

%% Load
user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
'University'], ['Documents - Pediatric Movement and ' ...
'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

file = fullfile(filepath,'Analysis\MATLAB scripts\MCdata_joints.mat');

if exist(filepath, 'dir')==0
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    file = fullfile(filepath,'Analysis\MATLAB scripts\MCdata_joints.mat');
end

load(file)

%% Plot
joints = {'sho_abduct','sho_flex','sho_horabduct', ...
          'elb_pronat','elb_flex','wr_flex','wr_rudev'};

figure
t = tiledlayout(4,2);

% Set title and spacing
t.TileSpacing = 'compact'; % Makes plots closer together
t.Padding = 'compact';     % Reduces outer margins

for j = 1:numel(joints)
    nexttile;

    joint = joints{j};
    data = MCdata_joints.ROM.(joint);

    dom1 = [data.dom_1];
    non1 = [data.non_1];

    hold on
    % TD
    s1 = swarmchart((ones(size(1:10))-.15),dom1(1:10),'MarkerEdgeColor','#008083','LineWidth',1.5);
    s2 = swarmchart((2*ones(size(1:10))-.15),non1(1:10),'x','SizeData',50,'MarkerEdgeColor','#008083','LineWidth',1.5);

    % CP
    s3 = swarmchart((ones(size(11:17))+.15),dom1(11:17),'MarkerEdgeColor','#F78104','LineWidth',1.5);
    s4 = swarmchart((2*ones(size(11:17))+.15),non1(11:17),'x','SizeData',50,'MarkerEdgeColor','#F78104','LineWidth',1.5);

    % Jitter
    allSwarms = [s1, s2, s3, s4];
    for i = 1:numel(allSwarms)
        allSwarms(i).XJitter = 'randn';
        allSwarms(i).XJitterWidth = 0.15;
    end
    %set(gca,'fontsize',14)

    % Means
    plot([0.7 1],[mean(dom1(1:10)) mean(dom1(1:10))],'k','LineWidth',1.2)
    plot([1 1.3],[mean(dom1(11:17)) mean(dom1(11:17))],'k','LineWidth',1.2)
    plot([1.7 2],[mean(non1(1:10)) mean(non1(1:10))],'k','LineWidth',1.2)
    plot([2 2.3],[mean(non1(11:17)) mean(non1(11:17))],'k','LineWidth',1.2)

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

    % Axis formatting
    xticks([1 2])
    xticklabels({'Preferred','Nonpreferred'})

    ylabel('ROM (degrees)')
    
    if j==1
        nexttile;
        plot(nan,nan)
    end

end

legend({'TD Preferred','TD Nonpreferred','UCP Preferred','UCP Nonpreferred'},'Location','best')
hold off

%% Stats (ANOVA)
SHOa = cat(2,[MCdata_joints.ROM.sho_abduct.dom_1],[MCdata_joints.ROM.sho_abduct.non_1]);
SHOf = cat(2,[MCdata_joints.ROM.sho_flex.dom_1],[MCdata_joints.ROM.sho_flex.non_1]);
SHOh = cat(2,[MCdata_joints.ROM.sho_horabduct.dom_1],[MCdata_joints.ROM.sho_horabduct.non_1]);
ELBp = cat(2,[MCdata_joints.ROM.elb_pronat.dom_1],[MCdata_joints.ROM.elb_pronat.non_1]);
ELBf = cat(2,[MCdata_joints.ROM.elb_flex.dom_1],[MCdata_joints.ROM.elb_flex.non_1]);
WRf = cat(2,[MCdata_joints.ROM.wr_flex.dom_1],[MCdata_joints.ROM.wr_flex.non_1]);
WRr = cat(2,[MCdata_joints.ROM.wr_rudev.dom_1],[MCdata_joints.ROM.wr_rudev.non_1]);

allROM = [SHOa SHOf SHOh ELBp ELBf WRf WRr]';

pat1 = [repmat("Pref",17,1);repmat("Nonpref",17,1)];
g1 = [repmat(pat1,7,1)];

pat2 = [repmat("TD",10,1);repmat("UCP",7,1)];
g2 = [repmat(pat2,14,1)];

g3 = [repmat("SHOa",34,1);repmat("SHOf",34,1);repmat("SHOh",34,1);...
    repmat("ELBp",34,1);repmat("ELBf",34,1);repmat("WRf",34,1);repmat("WRr",34,1);];

[p_RMSE, tbl_RMSE, stats_RMSE] = anovan(allROM,{g1,g2,g3},'interaction');

figure
mc3 = multcompare(stats_RMSE,'Dimension',[1 2 3],'CType','bonferroni');
%mc = multcompare(stats_RMSE, 'Joints','By','Group','CType','bonferroni');

SHOa = mean([MCdata_joints.ROM.sho_abduct.dom_1;MCdata_joints.ROM.sho_abduct.non_1], 1);
SHOf = mean([MCdata_joints.ROM.sho_flex.dom_1;MCdata_joints.ROM.sho_flex.non_1], 1);
SHOh = mean([MCdata_joints.ROM.sho_horabduct.dom_1;MCdata_joints.ROM.sho_horabduct.non_1], 1);
ELBp = mean([MCdata_joints.ROM.elb_pronat.dom_1;MCdata_joints.ROM.elb_pronat.non_1], 1);
ELBf = mean([MCdata_joints.ROM.elb_flex.dom_1;MCdata_joints.ROM.elb_flex.non_1], 1);
WRf = mean([MCdata_joints.ROM.wr_flex.dom_1;MCdata_joints.ROM.wr_flex.non_1], 1);
WRr = mean([MCdata_joints.ROM.wr_rudev.dom_1;MCdata_joints.ROM.wr_rudev.non_1], 1);

allROM = [SHOa SHOf SHOh ELBp ELBf WRf WRr]';

pat2 = [repmat("TD",10,1); repmat("UCP",7,1)];
g2 = repmat(pat2, 7, 1);
g3 = [repmat("SHOa",17,1);repmat("SHOf",17,1);repmat("SHOh",17,1);...
    repmat("ELBp",17,1);repmat("ELBf",17,1);repmat("WRf",17,1);repmat("WRr",17,1)];

[p, tbl, stats] = anovan(allROM, {g2, g3}, 'interaction');

figure;
mc2_within = multcompare(stats, 'Dimension', [1 2], 'CType', 'bonferroni');