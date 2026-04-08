% MCgamecheckOR.m
%
% Rachel Scheele
% Last Edited 2/4/2025

% Need script to:
% break up MC data by frame times to match the game data

% Clean workspace and command window
clear;
close all;
clc;

%% Load Demographics and Frame Times
user = getenv('username');

filepath = fullfile('C:\Users\', user, ['OneDrive - Marquette ' ...
'University'], ['Documents - Pediatric Movement and ' ...
'Neuroscience Lab (PMNL)'], 'R21_mHealthApp');

fileVLMT = fullfile(filepath,'Data\Vicon Label Marker Tracker');

if exist(filepath, 'dir')==0
    fprintf('Open R21_mHealthApp folder')
    pause(3)
    filepath = uigetdir;
    fileVLMT = fullfile(filepath,'Data\Vicon Label Marker Tracker');
end


fileBD = fullfile(filepath,'Data\R21_BehavioralData');

xlsxft = readcell(fileVLMT,'Sheet','Frame Times');
behavior = readtable(fileBD);

number = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
participant = append('MHEALTH',number);
matfile = append(participant,'.mat');
fileGDI = fullfile(filepath,'Data\Game Data\Individual\',matfile);
data = load(fileGDI);

ABdata = data.AsteroidBelt;
ORdata = data.SolarReaching;
ANdata = data.AsteroidNinja;
AEdata = data.AlienEncounter;

ID = string(table2cell(behavior(:,1)));
ind = find(ID == participant);
cp = string(table2cell(behavior(ind,2)));
nonprefhand = string(table2cell(behavior(ind,3)));
prefhand = string(table2cell(behavior(ind,4)));
age = table2cell(behavior(ind,5));

%% extract data from Time Frames
for i = 1:length(xlsxft(:,1))
    ind = strcmp(xlsxft{i,1}, participant);
    if ind == 1
        if strcmpi(xlsxft{i,3},'yes') == 1
            manft = xlsxft(i,:);
            break
        end
        fprintf("Not done, please rerun with another participant\n")
    end
end

manft(1:4) = [];
manft(129) = [];
manft(1:2:end) = [];
frames = zeros(size(manft));

for i=1:length(manft)
    if ~isnumeric(manft{i})
        frames(i) = nan;
    else
        frames(i) = cell2mat(manft(i));
    end
end

AN1_ftimes = frames(1:2);
AE1_ftimes = frames(3:4);
AB1_ftimes = frames(5:16);
OR1_ftimes = frames(17:64);
AN2_ftimes = frames(65:66);
AE2_ftimes = frames(67:68);
AB2_ftimes = frames(69:80);
OR2_ftimes = frames(81:128);

filename = append(participant,'_VICON');
fileMC = fullfile(filepath,'Analysis\ViconMCdata\Extracted',filename);
MCdata = load(fileMC);
MCdata = MCdata.(filename);

%% Seperate MC data
eq_ignore_num = @(x, y) strcmp(regexprep(x, '\s*\d+$', ''), regexprep(y, '\s*\d+$', ''));

AB = zeros(1,length(MCdata));
OR = zeros(1,length(MCdata));
AN = zeros(1,length(MCdata));
AE = zeros(1,length(MCdata));

for i=1:length(MCdata)
    visit = str2double(MCdata(i).trial(13));
    if eq_ignore_num(MCdata(i).game,'Asteroid Belt')
        AB(i) = visit;
    elseif eq_ignore_num(MCdata(i).game,'Orbital Reaching')
        OR(i) = visit;
    elseif eq_ignore_num(MCdata(i).game,'Asteroid Ninja')
        AN(i) = visit;
    elseif eq_ignore_num(MCdata(i).game,'Alien Encounter')
        AE(i) = visit;
    end
end

inxAB1 = find(AB == 1);
inxAB2 = find(AB == 2);
inxOR1 = find(OR == 1);
inxOR2 = find(OR == 2);
inxAN1 = find(AN == 1);
inxAN2 = find(AN == 2);
inxAE1 = find(AE == 1);
inxAE2 = find(AE == 2);

AB1_MC = MCdata(inxAB1);
AB2_MC = MCdata(inxAB2);
OR1_MC = MCdata(inxOR1);
OR2_MC = MCdata(inxOR2);
AN1_MC = MCdata(inxAN1);
AN2_MC = MCdata(inxAN2);
AE1_MC = MCdata(inxAE1);
AE2_MC = MCdata(inxAE2);

%% Compare MC and Game data size for Orbital Reaching
OR_frame_l = [];
OR_frame_r = [];
OR_frame_calc = [];
day = ORdata.study_day;
seg = ORdata.planet;

trial = zeros(length(seg),1);
t = 0;
for i=1:length(seg)
    if isequal(seg(i),{'mercury'})
        t = t + 1;
    end
    trial(i) = t;
end

%% CHECK FOR NORMAL CAPTURE SEQUENCE
if length(OR1_MC) == 3
    if length(OR2_MC) == 3
        fprintf('Continue, check passed\n')
    else
        error('MC data is not formatted correctly, check by hand\n')
    end
else
    error('MC data is not formatted correctly, check by hand\n')
end

%% Combine groups of 8 planets
seg_mvtimes = ORdata.PMov_time;
s = zeros(length(seg_mvtimes)-1,1);

for i=1:length(s)
    seg_times_end = seg_mvtimes{i,1};
    seg_end = datetime(seg_times_end(end,:));
    seg_end.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    seg_times_start = seg_mvtimes{i+1,1};
    seg_start = datetime(seg_times_start(1,:));
    seg_start.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
    s(i) = milliseconds(seg_start - seg_end); % ms
end

%% Compare MC and Game data
for j=1:length(day)/8

    time = 0;
    disp = [0 0];

    for i=1:8
        tms = ORdata.PMov_time_step_ms{(8*(j-1))+i,1}+time(end);
        path = ORdata.PMov_path{(8*(j-1))+i,1};
        hand = ORdata.trial_hand{(8*(j-1))+i,1};
        bwn_tms = 0;
        bwn_path = [0,0];

        if i<8
            bwn_tms = ((flip(s(8*(j-1)+i):-10:1))+tms(end))';
            bwn_path = nan(length(bwn_tms),2);
        end

        time = cat(1,time,tms,bwn_tms);
        disp = cat(1,disp,path,bwn_path);
    end

    time(end) = [];
    disp(end,:) = [];

    [gm_dis_l,gm_dis_r] = calcdisgame(time,disp,hand,j);

    switch string(day(j*8))
        case 'Day-1'
            visit = 1;
            switch trial(j*8)
                case {1,2}
                    itt = 1;
                    [MC_dis_l,MC_dis_r] = calcdisMC(OR1_MC(1));
                case {3,4}
                    itt = 2;
                    [MC_dis_l,MC_dis_r] = calcdisMC(OR1_MC(2));
                case {5,6}
                    itt = 3;
                    [MC_dis_l,MC_dis_r] = calcdisMC(OR1_MC(3));
            end

        case 'Day-2'
            visit = 2;
            switch trial(j*8)
                case {7,8}
                    itt = 1;
                    [MC_dis_l,MC_dis_r] = calcdisMC(OR2_MC(1));
                case {9,10}
                    itt = 2;
                    [MC_dis_l,MC_dis_r] = calcdisMC(OR2_MC(2));
                case {11,12}
                    itt = 3;
                    [MC_dis_l,MC_dis_r] = calcdisMC(OR2_MC(3));
            end
    end

    vts = "Visit-"+num2str(visit)+" Trial-"+num2str(itt);
    %vts = "Visit-"+num2str(visit)+" Trial-"+num2str(trial(j))+" Section-"+num2str(seg(j));
    prev_start = 0;

    start_l = comparedisman(gm_dis_l,MC_dis_l,prev_start,vts);
    start_r = comparedisman(gm_dis_r,MC_dis_r,prev_start,vts);

    if isnan(start_l)
        start = start_r;
    elseif isnan(start_r)
        start = start_l;
    else
        start = [];
        prev_start = 5;
        fprintf("Error in start tag\n")
    end

    window = 10;

    % cont = 1;
    % while cont == 1
    %     if isnan(start)
    %         ask = 1;
    %     else
    %         ask = input("Is it good? Yes(1)/No(0)\n");
    %     end
    %     close all
    %     if ask == 0
    %         switch string(day(j))
    %             case 'Day-1'
    %                 switch trial(j)
    %                     case 1
    %                         [MC_dis_l,MC_dis_r] = calcdisMC(OR1_MC(1));
    %                     case 2
    %                         [MC_dis_l,MC_dis_r] = calcdisMC(OR1_MC(2));
    %                     case 3
    %                         [MC_dis_l,MC_dis_r] = calcdisMC(OR1_MC(3));
    %                 end
    % 
    %             case 'Day-2'
    %                 switch trial(j)
    %                     case 1
    %                         [MC_dis_l,MC_dis_r] = calcdisMC(OR2_MC(1));
    %                     case 2
    %                         [MC_dis_l,MC_dis_r] = calcdisMC(OR2_MC(2));
    %                     case 3
    %                         [MC_dis_l,MC_dis_r] = calcdisMC(OR2_MC(3));
    %                 end
    %         end
    % 
    %         prev_start = prev_start + 1;
    % 
    %         start_l = comparedisman(gm_dis_l,MC_dis_l,prev_start,vts);
    %         start_r = comparedisman(gm_dis_r,MC_dis_r,prev_start,vts);
    % 
    %         if isnan(start_l)
    %             start = start_r;
    %         elseif isnan(start_r)
    %             start = start_l;
    %         else
    %             fprintf("Error in start tag\n")
    %         end
    % 
    %         if isequal(start, prev_start)
    %             fprintf("Error: No further shift\n")
    %             window = window + 10;
    %         end
    % 
    %     elseif ask == 1
    %         fprintf("Passed\n")
    %         cont = 0;
    %     else
    %         fprintf("Invalid Input: ");
    %     end
    % 
    %     % % Limit to 5 asks per section
    %     % if prev_start >= 5
    %     %     cont = 0;
    %     %     start_l = nan;
    %     %     start_r = nan;
    %     %     start = nan;
    %     % end
    % end

    OR_frame_l = cat(1,OR_frame_l,start_l);
    OR_frame_r = cat(1,OR_frame_r,start_r);
    OR_frame_calc = cat(1,OR_frame_calc,start);

end

% %% Fill skipped sections
% % start_time = datetime(ORdata.trial_start_time);
% % start_time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
% % s = milliseconds(start_time - start_time(1))/10; % 10 ms unit
% 
% for j=1:6
%     group = (j-1)*4+(1:4);
%     t = round(s(group));
%     f = OR_frame_calc(group);
% 
%     if all(isnan(f))
%         warning('All values are missing')
%         continue
%     end
% 
%     val = ~isnan(f);
% 
%     offset = t(val) - f(val);
%     a = mean(offset);
%     f(~val)=t(~val)-a;
%     f = round(f);
% 
%     OR_frame_calc(group) = f;
% end

%% Compare manual frame times to calculated frame times
OR_frame_man = [OR1_ftimes, OR2_ftimes];

for i = 1:(length(s)+1)/8
    for j = 1:8
        idx = i*8 + j - 8;
        OR_frames(idx) = OR_frame_calc(i) + sum(s(idx-(j-1):idx-1));
    end
end

diff = OR_frame_man-OR_frames;
avg_diff = mean(diff,'omitnan');
std_diff = std(diff,'omitnan');
tolerance = 25;

j = 1;
for i = 1:length(diff)
    if diff(i) >= tolerance
        out_ind = i;
        out_val = diff(i);
        fprintf('Outside Threshold - Index: %d   Difference: %.4f\n', out_ind, out_val);
        j = 0;
    end
end

if j==1
    fprintf('There are no selections outside the threshold window\n')
end

%% Parse MC capture to match size of game
OR_parsed = struct('Game_data',[],'MC_data',[],'Labels',[], ...
    'Visit',[],'Hand',[],'Path',[],'Start_time',[], ...
    'Frame_time_calculated',[],'Frame_time_manual',[]);

for j=1:length(OR_frame_calc)
    switch string(day(j))
        case 'Day-1'
            switch trial(j)
                case 1
                    MC_whole = OR1_MC(1).position_data_interpolated;
                    labels = OR1_MC(1).labels;
                case 2
                    MC_whole = OR1_MC(2).position_data_interpolated;
                    labels = OR1_MC(2).labels;
                case 3
                    MC_whole = OR1_MC(3).position_data_interpolated;
                    labels = OR1_MC(3).labels;
            end

        case 'Day-2'
            switch trial(j)
                case 1
                    MC_whole = OR2_MC(1).position_data_interpolated;
                    labels = OR2_MC(1).labels;
                case 2
                    MC_whole = OR2_MC(2).position_data_interpolated;
                    labels = OR2_MC(2).labels;
                case 3
                    MC_whole = OR2_MC(3).position_data_interpolated;
                    labels = OR2_MC(3).labels;
            end
    end
    % Determine length and start time of game
    tms = ORdata.PMov_time_step_ms{j,1};
    path = ORdata.PMov_path{j,1};
    hand = ORdata.trial_hand{j,1};
    [gm_dis_l,gm_dis_r] = calcdisgame(tms,path,hand,j);

    if gm_dis_l == 0
        game_dis = gm_dis_r;
        lgth = length(gm_dis_r);
    elseif gm_dis_r == 0
        game_dis = gm_dis_l;
        lgth = length(gm_dis_l);
    else
        fprintf('Error: Game data is empty\n')
    end

    % Parse
    lab = length(labels);
    parse = zeros(3,lab,lgth);
    for i=1:lgth
        time_selected = OR_frame_calc(j)+i-1;
        if time_selected <= 0
            parse(:,:,i) = nan;
        elseif time_selected >= length(MC_whole)
            parse(:,:,i) = nan;
        else
            parse(:,:,i) = MC_whole(:,:,time_selected);
        end
    end

    OR_parsed(j).Game_data = game_dis;
    OR_parsed(j).MC_data = parse;
    OR_parsed(j).Labels = labels;

    OR_parsed(j).Visit = day(j);
    OR_parsed(j).Hand = ORdata.trial_hand(j);
    OR_parsed(j).Path = ORdata.PMov_path{j,1};
    OR_parsed(j).Start_time = ORdata.trial_start_time(j);

    OR_parsed(j).Frame_time_calculated = OR_frame_calc(j);
    OR_parsed(j).Frame_time_manual = OR_frame_man(j);

end

%% Save
svas = append(participant,'_ParsedDataOR');
tempStruct.(svas) = OR_parsed;
filepath = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');
filesv = append(svas,'.mat');
filesvas = fullfile(filepath,filesv);
save(filesvas, '-struct', 'tempStruct');