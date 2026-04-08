% MarkerTrajectories.m
%
% Rachel Scheele
% Last Edited 3/26/2025

% Need script to:
% determine and compare marker trajectories of the finger, hand, elbow, and
% sholder to the game data

% Clean workspace and command window
clear;
close all;
clc;

%% Load game data and MC data

user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
'University'], ['Documents - Pediatric Movement and ' ...
'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

fileMCfolder = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');

if exist(filepath, 'dir')==0
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    fileMCfolder = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');
end

number = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
participant = append('MHEALTH',number);
fileMC1 = append(participant,'_V1ParsedData');
%fileMC2 = append(participant,'_V2ParsedData');

MCdata = load(fullfile(fileMCfolder,fileMC1));
MCdata = MCdata.(fileMC1);

matfile = append(participant,'.mat');
fileGDI = fullfile(filepath,'Data\Game Data\Individual\',matfile);
data = load(fileGDI);

ABdata = data.AsteroidBelt;

filefolder = fullfile(filepath,'Analysis\MATLAB scripts\population_game_data.mat');
load(filefolder)

%% Compare Trajectories
traj = ABdata.RMov_path;
tm = ABdata.RMov_time_step_ms;
hand_used = ABdata.trial_hand;

comparestruct = struct([]);

for j=1:12
    % Determine Game Trajectory
    position = cell2mat(traj(j));
    time = cell2mat(tm(j));

    x = position(:,1);
    y = position(:,2);
    
    inx = isnan(x);
    
    freq = 100;
    t = time(1):(1/freq)*1000:time(end); % 10 ms steps
    qry = t;
    
    % Sanity checks
    if length(time) ~= length(x)
        warning('Time and position lengths mismatch at index %d. Skipping.', j);
        continue
    end
    
    if range(time) == 0
        warning('Zero time range at index %d. Skipping.', j);
        continue
    end
    
    [time, ia, ~] = unique(time, 'stable');
    x = x(ia);
    y = y(ia);
    
    xint = interp1(time, x, qry, 'spline');
    yint = interp1(time, y, qry, 'spline');
    %method: 'linear', 'nearest', 'next', 'previous', 'pchip', 'cubic',
    %'v5cubic', 'makima', or 'spline'. The default method is 'linear'.
    
    smoothx = smoothdata(xint,'gaussian',40)*(127/660);
    smoothy = smoothdata(yint,'gaussian',40)*(127/660);
    % smoothing methods: 'movmean' (default), 'movemedian', 'gaussian',
    % 'lowess', 'loess', 'rlowess', 'rloess', 'sgolay'
    
    dtime = zeros(size(smoothx));
    dist = zeros(size(smoothx));
    velocity = zeros(size(smoothx)); % preallocate
    
    for i=1:length(smoothx)
        if i~=1
            dtime(i) = (t(i)-t(i-1));
            dist(i) = sqrt(((smoothx(i)-smoothx(i-1))^2)+((smoothy(i)-smoothy(i-1))^2));
            velocity(i) = dist(i)/dtime(i); % mm/sec
        else
            dtime(i) = 0;
            dist(i) = 0;
            velocity(i) = 0;
        end
    end
    
    [~,locs] = findpeaks(velocity);
    
    velocity(locs) = NaN;
    t(locs) = NaN;
    
    velocity = fillmissing(velocity, 'linear');
    t = fillmissing(t, 'linear');
    
    last = length(velocity);
    dist(last-3:last) = [];
    smoothx(last-3:last) = [];
    smoothy(last-3:last) = [];
    velocity(last-3:last) = [];
    t(last-3:last) = [];
    
    dist(inx) = 0;
    
    dist_l = 0;
    dist_r = 0;
    velocity_l = 0;
    velocity_r = 0;

    game_x = smoothx-smoothx(1);
    game_y = smoothy-smoothy(1);
    
    hand = cell2mat(hand_used(j));

    switch hand
        case 'Left'
            dist_l = dist;
            velocity_l = velocity;
        case 'Right'
            dist_r = dist;
            velocity_r = velocity;
    end

    % Determine MC Trajectory
    MC_trial = MCdata(j+1);

    idx = find(strcmp(MC_trial.Labels,'LFIN'));
    LFIN = MC_trial.MC_data(:,idx,:);
    LFIN = squeeze(LFIN)';

    idx = find(strcmp(MC_trial.Labels,'RFIN'));
    RFIN = MC_trial.MC_data(:,idx,:);
    RFIN = squeeze(RFIN)';
    
    idx = find(strcmp(MC_trial.Labels,'LWRA'));
    LWRA = MC_trial.MC_data(:,idx,:);
    LWRA = squeeze(LWRA)';
    idx = find(strcmp(MC_trial.Labels,'LWRB'));
    LWRB = MC_trial.MC_data(:,idx,:);
    LWRB = squeeze(LWRB)';
    LWR = (LWRB+LWRA)/2;

    idx = find(strcmp(MC_trial.Labels,'RWRA'));
    RWRA = MC_trial.MC_data(:,idx,:);
    RWRA = squeeze(RWRA)';
    idx = find(strcmp(MC_trial.Labels,'RWRB'));
    RWRB = MC_trial.MC_data(:,idx,:);
    RWRB = squeeze(RWRB)';
    RWR = (RWRB+RWRA)/2;
    
    idx = find(strcmp(MC_trial.Labels,'LELB'));
    LELB = MC_trial.MC_data(:,idx,:);
    LELB = squeeze(LELB)';

    idx = find(strcmp(MC_trial.Labels,'RELB'));
    RELB = MC_trial.MC_data(:,idx,:);
    RELB = squeeze(RELB)';

    idx = find(strcmp(MC_trial.Labels,'LSHO'));
    LSHO = MC_trial.MC_data(:,idx,:);
    LSHO = squeeze(LSHO)';

    idx = find(strcmp(MC_trial.Labels,'RSHO'));
    RSHO = MC_trial.MC_data(:,idx,:);
    RSHO = squeeze(RSHO)';

    % x (first) represents to and from iPad
    % y (second) represents left and right - matches game x
    % z (third) represents up and down - matches game y
    
    %% Compare Game and MC Trajectories
    % Compare Trajectories - Finger
    switch hand
        case 'Left'
            x = LFIN(:,1);
            x_zero = x(1);
            fin_x = x-x_zero;
            y = LFIN(:,2);
            y_zero = y(1);
            fin_y = -(y-y_zero);
            z = LFIN(:,3);
            z_zero = z(1);
            fin_z = z-z_zero;
        case 'Right'
            x = RFIN(:,1);
            x_zero = x(1);
            fin_x = x-x_zero;
            y = RFIN(:,2);
            y_zero = y(1);
            fin_y = -(y-y_zero);
            z = RFIN(:,3);
            z_zero = z(1);
            fin_z = z-z_zero;
    end

    % dx = game_x - fin_y;
    % dy = game_y - fin_z;
    % dz = zeros(size(game_x)) - fin_x;
    % dfin = sqrt(mean(dx.^2 + dy.^2 + dz.^2));
    % fin_RMSE = mean(dfin);

    [fin2_x,fin2_y] = conv3Dto2D(fin_x,fin_y,fin_z);
    dx = game_x - fin2_x';
    dy = game_y - fin2_y';
    dfin = sqrt(mean(dx.^2 + dy.^2));
    
    game = [game_x;game_y];
    fin2 = [fin2_x';fin2_y'];
    fin_RMSE = mean(rmse(game,fin2));
    fin_corr = corr2(game,fin2);
    
    % Compare Trajectories - Wrist
    switch hand
        case 'Left'
            x = LWR(:,1);
            wr_x = x-x_zero;
            y = LWR(:,2);
            wr_y = -(y-y_zero);
            z = LWR(:,3);
            wr_z = z-z_zero;
        case 'Right'
            x = RWR(:,1);
            wr_x = x-x_zero;
            y = RWR(:,2);
            wr_y = -(y-y_zero);
            z = RWR(:,3);
            wr_z = z-z_zero;
    end

    % dx = game_x - wr_y;
    % dy = game_y - wr_z;
    % dz = zeros(size(game_x)) - wr_x;
    % dwr = sqrt(mean(dx.^2 + dy.^2 + dz.^2));
    % wr_RMSE = mean(dwr);

    [wr2_x,wr2_y] = conv3Dto2D(wr_x,wr_y,wr_z);
    dx = game_x - wr2_x';
    dy = game_y - wr2_y';
    dwr = sqrt(mean(dx.^2 + dy.^2));
    
    wr2 = [wr2_x';wr2_y'];
    wr_RMSE = mean(rmse(game,wr2));
    wr_corr = corr2(game,wr2);
    
    % Compare Trajectories - Elbow
    switch hand
        case 'Left'
            x = LELB(:,1);
            elb_x = x-x_zero;
            y = LELB(:,2);
            elb_y = -(y-y_zero);
            z = LELB(:,3);
            elb_z = z-z_zero;
        case 'Right'
            x = RELB(:,1);
            elb_x = x-x_zero;
            y = RELB(:,2);
            elb_y = -(y-y_zero);
            z = RELB(:,3);
            elb_z = z-z_zero;
    end

    % dx = game_x - elb_y;
    % dy = game_y - elb_z;
    % dz = zeros(size(game_x)) - elb_x;
    % delb = sqrt(mean(dx.^2 + dy.^2 + dz.^2));
    % elb_RMSE = mean(delb);
    
    [elb2_x,elb2_y] = conv3Dto2D(elb_x,elb_y,elb_z);
    dx = game_x - elb2_x';
    dy = game_y - elb2_y';
    delb = sqrt(mean(dx.^2 + dy.^2));

    elb2 = [elb2_x';elb2_y'];
    elb_RMSE = mean(rmse(game,elb2));
    elb_corr = corr2(game,elb2);

    % Compare Trajectories - Sholder
    switch hand
        case 'Left'
            x = LSHO(:,1);
            sho_x = x-x_zero;
            y = LSHO(:,2);
            sho_y = -(y-y_zero);
            z = LSHO(:,3);
            sho_z = z-z_zero;
        case 'Right'
            x = RSHO(:,1);
            sho_x = x-x_zero;
            y = RSHO(:,2);
            sho_y = -(y-y_zero);
            z = RSHO(:,3);
            sho_z = z-z_zero;
    end

    % dx = game_x - sho_y;
    % dy = game_y - sho_z;
    % dz = zeros(size(game_x)) - sho_x;
    % dsho = sqrt(mean(dx.^2 + dy.^2 + dz.^2));
    % sho_RMSE = mean(dsho);

    [sho2_x,sho2_y] = conv3Dto2D(sho_x,sho_y,sho_z);
    dx = game_x - sho2_x';
    dy = game_y - sho2_y';
    dsho = sqrt(mean(dx.^2 + dy.^2));

    sho2 = [sho2_x';sho2_y'];
    sho_RMSE = mean(rmse(game,sho2));
    sho_corr = corr2(game,sho2);

    %% Fill structure
    comparestruct(j).Hand = hand;
    % comparestruct(j).Time = t;
    % comparestruct(j).diff_Finger = dfin;
    % comparestruct(j).diff_Wrist = dwr;
    % comparestruct(j).diff_Elbow = delb;
    % comparestruct(j).diff_Shoulder = dsho;
    comparestruct(j).RMSE_Finger = fin_RMSE;
    comparestruct(j).RMSE_Wrist = wr_RMSE;
    comparestruct(j).RMSE_Elbow = elb_RMSE;
    comparestruct(j).RMSE_Shoulder = sho_RMSE;
    comparestruct(j).Correlation_Finger = fin_corr;
    comparestruct(j).Correlation_Wrist = wr_corr;
    comparestruct(j).Correlation_Elbow = elb_corr;
    comparestruct(j).Correlation_Shoulder = sho_corr;

    % %% Plot all
    % figure(j)
    % game_dem = zeros(size(game_y));
    % plot3(game_x,game_dem,game_y)
    % hold on
    % plot3(fin_y,fin_x,fin_z)
    % plot3(wr_y,wr_x,wr_z)
    % plot3(elb_y,elb_x,elb_z)
    % plot3(sho_y,sho_x,sho_z)
    % xlabel('Game x')
    % ylabel('No game data')
    % zlabel('Game y')
    % legend('Game','Finger','Wrist','Elbow','Shoulder')
    % hold off

    %% Plot all
    figure(j)
    plot(game_x,game_y,'Color','k','LineWidth',1.25)
    hold on
    plot(fin2_x,fin2_y,'Color',[254 127 156]/255,'LineWidth',1.5)
    plot(wr2_x,wr2_y,'Color',[57 106 177]/255,'LineWidth',1.5)
    plot(elb2_x,elb2_y,'Color',[107 76 154]/255,'LineWidth',1.5)
    plot(sho2_x,sho2_y,'Color',[62 150 81]/255,'LineWidth',1.5)
    xlabel('Game x')
    ylabel('Game y')
    legend('Game','Finger','Wrist','Elbow','Shoulder')
    hold off

end

%% Calculate Average RMSE and Correlation
Lfin_RMSE = nan;
Lwr_RMSE = nan;
Lelb_RMSE = nan;
Lsho_RMSE = nan;

Lfin_corr = nan;
Lwr_corr = nan;
Lelb_corr = nan;
Lsho_corr = nan;

Rfin_RMSE = nan;
Rwr_RMSE = nan;
Relb_RMSE = nan;
Rsho_RMSE = nan;

Rfin_corr = nan;
Rwr_corr = nan;
Relb_corr = nan;
Rsho_corr = nan;

l = 1;
r = 1;

for i=1:length(comparestruct)
    switch comparestruct(i).Hand
        case 'Left'
            Lfin_RMSE(l) = comparestruct(i).RMSE_Finger;
            Lwr_RMSE(l) = comparestruct(i).RMSE_Wrist;
            Lelb_RMSE(l) = comparestruct(i).RMSE_Elbow;
            Lsho_RMSE(l) = comparestruct(i).RMSE_Shoulder;

            Lfin_corr(l) = comparestruct(i).Correlation_Finger;
            Lwr_corr(l) = comparestruct(i).Correlation_Wrist;
            Lelb_corr(l) = comparestruct(i).Correlation_Elbow;
            Lsho_corr(l) = comparestruct(i).Correlation_Shoulder;
            l = l+1;
        case 'Right'
            Rfin_RMSE(r) = comparestruct(i).RMSE_Finger;
            Rwr_RMSE(r) = comparestruct(i).RMSE_Wrist;
            Relb_RMSE(r) = comparestruct(i).RMSE_Elbow;
            Rsho_RMSE(r) = comparestruct(i).RMSE_Shoulder;

            Rfin_corr(r) = comparestruct(i).Correlation_Finger;
            Rwr_corr(r) = comparestruct(i).Correlation_Wrist;
            Relb_corr(r) = comparestruct(i).Correlation_Elbow;
            Rsho_corr(r) = comparestruct(i).Correlation_Shoulder;
            r = r+1;
    end
end

for i=1:length(game_data_all)
    if game_data_all(i).ID == participant
        ind = i;
    end
end

hand = game_data_all(ind).NonPrefered_Hand;

summary = struct();

if hand == 'Left'
    summary.MAfin_RMSE_avg = mean(Lfin_RMSE,"omitnan");
    summary.LAfin_RMSE_avg = mean(Rfin_RMSE,"omitnan");
    summary.MAwr_RMSE_avg = mean(Lwr_RMSE,"omitnan");
    summary.LEwr_RMSE_avg = mean(Rwr_RMSE,"omitnan");
    summary.MAelb_RMSE_avg = mean(Lelb_RMSE,"omitnan");
    summary.LAelb_RMSE_avg = mean(Relb_RMSE,"omitnan");
    summary.MAsho_RMSE_avg = mean(Lsho_RMSE,"omitnan");
    summary.LAsho_RMSE_avg = mean(Rsho_RMSE,"omitnan");
    
    summary.MAfin_corr_avg = mean(Lfin_corr,"omitnan");
    summary.LAfin_corr_avg = mean(Rfin_corr,"omitnan");
    summary.MAwr_corr_avg = mean(Lwr_corr,"omitnan");
    summary.LAwr_corr_avg = mean(Rwr_corr,"omitnan");
    summary.MAelb_corr_avg = mean(Lelb_corr,"omitnan");
    summary.LAelb_corr_avg = mean(Relb_corr,"omitnan");
    summary.MAsho_corr_avg = mean(Lsho_corr,"omitnan");
    summary.LAsho_corr_avg = mean(Rsho_corr,"omitnan");
elseif hand == 'Right'
    summary.MAfin_RMSE_avg = mean(Rfin_RMSE,"omitnan");
    summary.LAfin_RMSE_avg = mean(Lfin_RMSE,"omitnan");
    summary.MAwr_RMSE_avg = mean(Rwr_RMSE,"omitnan");
    summary.LAwr_RMSE_avg = mean(Lwr_RMSE,"omitnan");
    summary.MAelb_RMSE_avg = mean(Relb_RMSE,"omitnan");
    summary.LAelb_RMSE_avg = mean(Lelb_RMSE,"omitnan");
    summary.MAsho_RMSE_avg = mean(Rsho_RMSE,"omitnan");
    summary.LAsho_RMSE_avg = mean(Lsho_RMSE,"omitnan");
    
    summary.MAfin_corr_avg = mean(Rfin_corr,"omitnan");
    summary.LAfin_corr_avg = mean(Lfin_corr,"omitnan");
    summary.MAwr_corr_avg = mean(Rwr_corr,"omitnan");
    summary.LAwr_corr_avg = mean(Lwr_corr,"omitnan");
    summary.MAelb_corr_avg = mean(Relb_corr,"omitnan");
    summary.LAelb_corr_avg = mean(Lelb_corr,"omitnan");
    summary.MAsho_corr_avg = mean(Rsho_corr,"omitnan");
    summary.LAsho_corr_avg = mean(Lsho_corr,"omitnan");
else
    fprintf('error')
end

summary = struct2table(summary);
summary = rows2vars(summary);

sample = {'MHEALTH110','MHEALTH118','MHEALTH126','MHEALTH130',...
        'MHEALTH135','MHEALTH136','MHEALTH137','MHEALTH138',...
        'MHEALTH139','MHEALTH141','MHEALTH203','MHEALTH204',...
        'MHEALTH205','MHEALTH207','MHEALTH208','MHEALTH212','MHEALTH214'};

metrics = {'MAfin_RMSE_avg','LAfin_RMSE_avg','MAwr_RMSE_avg','LEwr_RMSE_avg',...
           'MAelb_RMSE_avg','LAelb_RMSE_avg','MAsho_RMSE_avg','LAsho_RMSE_avg',...
           'MAfin_corr_avg','LAfin_corr_avg','MAwr_corr_avg','LAwr_corr_avg',...
           'MAelb_corr_avg','LAelb_corr_avg','MAsho_corr_avg','LAsho_corr_avg'};

filesv = fullfile(filepath,'Analysis\MATLAB scripts\MC_RMSE.mat');

if exist(filesv,'file')
    load(filesv)   % loads MC_RMSE
else
    MC_RMSE = array2table(nan(length(metrics),length(sample)), ...
        'RowNames',metrics, ...
        'VariableNames',sample);
end

MC_RMSE{:,participant} = summary.Var1;
save(filesv,'MC_RMSE')