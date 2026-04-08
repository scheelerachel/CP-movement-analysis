% MCparse.m
%
% Rachel Scheele
% Last Edited 3/3/2025

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

fmtimes = readcell(fileVLMT,'Sheet','Frame Times');
behavior = readtable(fileBD);

number = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
participant = append('MHEALTH',number);
matfile = append(participant,'.mat');
fileGDI = fullfile(filepath,'Data\Game Data\Individual',matfile);
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
for i = 1:length(fmtimes(:,1))
    ind = strcmp(fmtimes{i,1}, participant);
    if ind == 1
        if strcmpi(fmtimes{i,3},'yes') == 1
            times = fmtimes(i,:);
            break
        end
        fprintf("Not done, please rerun with other participant\n")
    end
end

times(1:4) = [];
times(129) = [];
times(1:2:end) = [];
frames = zeros(size(times));

for i=1:length(times)
    if ~isnumeric(times{i})
        frames(i) = nan;
    else
        frames(i) = cell2mat(times(i));
    end
end

AN1_times = frames(1:2);
AE1_times = frames(3:4);
AB1_times = frames(5:16);
OR1_times = frames(17:64);
AN2_times = frames(65:66);
AE2_times = frames(67:68);
AB2_times = frames(69:80);
OR2_times = frames(81:128);

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
Cal = zeros(1,length(MCdata));
c = 1;

for i=1:length(MCdata)
    visit1 = str2double(MCdata(i).trial(13));
    if eq_ignore_num(MCdata(i).game,'Asteroid Belt')
        AB(i) = visit1;
    elseif eq_ignore_num(MCdata(i).game,'Orbital Reaching')
        OR(i) = visit1;
    elseif eq_ignore_num(MCdata(i).game,'Asteroid Ninja')
        AN(i) = visit1;
    elseif eq_ignore_num(MCdata(i).game,'Alien Encounter')
        AE(i) = visit1;
    elseif eq_ignore_num(MCdata(i).game,'Calibration')
        Cal(i) = c;
        c = c + 1;
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
inxCal1 = find(Cal == 1);
inxCal2 = find(Cal == 2);

AB1_MC = MCdata(inxAB1);
AB2_MC = MCdata(inxAB2);
OR1_MC = MCdata(inxOR1);
OR2_MC = MCdata(inxOR2);
AN1_MC = MCdata(inxAN1);
AN2_MC = MCdata(inxAN2);
AE1_MC = MCdata(inxAE1);
AE2_MC = MCdata(inxAE2);
Cal1_MC = MCdata(inxCal1);
Cal2_MC = MCdata(inxCal2);

%% Compare MC and Game data size for Asteroid Belt
AB1_frame_l = [];
AB1_frame_r = [];
AB1_frame_calc = [];
AB2_frame_l = [];
AB2_frame_r = [];
AB2_frame_calc = [];

day = ABdata.study_day;
seg = ABdata.trial_no;

trial = zeros(length(seg),1);
t = 0;
for i=1:length(seg)/2
    if seg(i)==1
        t = t + 1;
    end
    trial(i) = t;
end
t = 0;
for i=length(seg)/2+1:length(seg)
    if seg(i)==1
        t = t + 1;
    end
    trial(i) = t;
end

%% CHECK FOR NORMAL CAPTURE SEQUENCE
if length(AB1_MC) == 3
    if length(AB2_MC) == 3
        fprintf('Continue, check passed\n')
    else
        error('MC data is not formatted correctly, check by hand')
    end
else
    error('MC data is not formatted correctly, check by hand')
end

%% V1 or V2
for j=1:length(day)
    switch string(day(j))
            case 'Day-1'
                visit1(j) = 1;
            case 'Day-2'
                visit2(j) = 2;
    end
end

%% Compare MC and Game data V1
for j=1:length(visit1)
    tms = ABdata.RMov_time_step_ms{j,1};
    path = ABdata.RMov_path{j,1};
    hand = ABdata.trial_hand{j,1};

    [gm_dis_l,gm_dis_r] = calcdisgame(tms,path,hand,j);

    switch trial(j)
        case 1
            [MC_dis_l,MC_dis_r] = calcdisMC(AB1_MC(1));
        case 2
            [MC_dis_l,MC_dis_r] = calcdisMC(AB1_MC(2));
        case 3
            [MC_dis_l,MC_dis_r] = calcdisMC(AB1_MC(3));
    end

    vts = "Visit-"+num2str(visit1(j))+" Trial-"+num2str(trial(j))+" Section-"+num2str(seg(j));
    prev_start = 0;

    start_l = comparedis(gm_dis_l,MC_dis_l,prev_start,vts);
    start_r = comparedis(gm_dis_r,MC_dis_r,prev_start,vts);

    if isnan(start_l)
        start1 = start_r;
    elseif isnan(start_r)
        start1 = start_l;
    else
        start1 = [];
        prev_start = 5;
        fprintf("Error in start tag\n")
    end

    window = 10;

    cont = 1;
    while cont == 1
        if isnan(start1)
            ask = 1;
        else
            ask = input("Does it match? Yes(1)/No(0)\n");
        end
        close all
        if ask == 0
            switch trial(j)
                case 1
                    [MC_dis_l,MC_dis_r] = calcdisMC(AB1_MC(1));
                case 2
                    [MC_dis_l,MC_dis_r] = calcdisMC(AB1_MC(2));
                case 3
                    [MC_dis_l,MC_dis_r] = calcdisMC(AB1_MC(3));
            end

            prev_start = prev_start + 1;

            start_l = comparedis(gm_dis_l,MC_dis_l,prev_start,vts);
            start_r = comparedis(gm_dis_r,MC_dis_r,prev_start,vts);

            if isnan(start_l)
                start1 = start_r;
            elseif isnan(start_r)
                start1 = start_l;
            else
                fprintf("Error in start tag\n")
            end

            if isequal(start1, prev_start)
                fprintf("Error: No further shift\n")
                window = window + 10;
            end

        elseif ask == 1
            fprintf("Passed\n")
            cont = 0;
        else
            fprintf("Invalid Input: ");
        end

        % Limit to 5 asks per section
        if prev_start >= 5
            cont = 0;
            start_l = nan;
            start_r = nan;
            start1 = nan;
        end
    end

    AB1_frame_l = cat(1,AB1_frame_l,start_l);
    AB1_frame_r = cat(1,AB1_frame_r,start_r);
    AB1_frame_calc = cat(1,AB1_frame_calc,start1);

end

%% Compare MC and Game data V2
for j=length(visit1)+1:length(visit2)
    tms = ABdata.RMov_time_step_ms{j,1};
    path = ABdata.RMov_path{j,1};
    hand = ABdata.trial_hand{j,1};

    [gm_dis_l,gm_dis_r] = calcdisgame(tms,path,hand,j);

    switch trial(j)
        case 1
            [MC_dis_l,MC_dis_r] = calcdisMC(AB2_MC(1));
        case 2
            [MC_dis_l,MC_dis_r] = calcdisMC(AB2_MC(2));
        case 3
            [MC_dis_l,MC_dis_r] = calcdisMC(AB2_MC(3));
    end

    vts = "Visit-"+num2str(visit2(j))+" Trial-"+num2str(trial(j))+" Section-"+num2str(seg(j));
    prev_start = 0;

    start_l = comparedis(gm_dis_l,MC_dis_l,prev_start,vts);
    start_r = comparedis(gm_dis_r,MC_dis_r,prev_start,vts);

    if isnan(start_l)
        start2 = start_r;
    elseif isnan(start_r)
        start2 = start_l;
    else
        start2 = [];
        prev_start = 5;
        fprintf("Error in start tag\n")
    end

    window = 10;

    cont = 1;
    while cont == 1
        if isnan(start2)
            ask = 1;
        else
            ask = input("Does it match? Yes(1)/No(0)\n");
        end
        close all
        if ask == 0
            switch trial(j)
                case 1
                    [MC_dis_l,MC_dis_r] = calcdisMC(AB2_MC(1));
                case 2
                    [MC_dis_l,MC_dis_r] = calcdisMC(AB2_MC(2));
                case 3
                    [MC_dis_l,MC_dis_r] = calcdisMC(AB2_MC(3));
            end

            prev_start = prev_start + 1;

            start_l = comparedis(gm_dis_l,MC_dis_l,prev_start,vts);
            start_r = comparedis(gm_dis_r,MC_dis_r,prev_start,vts);

            if isnan(start_l)
                start2 = start_r;
            elseif isnan(start_r)
                start2 = start_l;
            else
                fprintf("Error in start tag\n")
            end

            if isequal(start2, prev_start)
                fprintf("Error: No further shift\n")
                window = window + 10;
            end

        elseif ask == 1
            fprintf("Passed\n")
            cont = 0;
        else
            fprintf("Invalid Input: ");
        end

        % Limit to 5 asks per section
        if prev_start >= 5
            cont = 0;
            start_l = nan;
            start_r = nan;
            start2 = nan;
        end
    end

    AB2_frame_l = cat(1,AB2_frame_l,start_l);
    AB2_frame_r = cat(1,AB2_frame_r,start_r);
    AB2_frame_calc = cat(1,AB2_frame_calc,start2);

end

%% Fill skipped sections
close all

start_time = datetime(ABdata.trial_start_time);
start_time.Format = 'yyyy-MM-dd HH:mm:ss.SSS';
s = milliseconds(start_time - start_time(1))/10; % 10 ms unit
s1 = s(1:12);
s2 = s(13:24);

for j=1:3
    group = (j-1)*4+(1:4);
    t = round(s1(group));
    f = AB1_frame_calc(group);

    if all(isnan(f))
        warning('All values are missing')
        continue
    end

    val = ~isnan(f);

    offset = t(val) - f(val);
    a = mean(offset);
    f(~val)=t(~val)-a;
    f = round(f);

    AB1_frame_calc(group) = f;
end

for j=1:3
    group = (j-1)*4+(1:4);
    t = round(s2(group));
    f = AB2_frame_calc(group);

    if all(isnan(f))
        warning('All values are missing')
        continue
    end

    val = ~isnan(f);

    offset = t(val) - f(val);
    a = mean(offset);
    f(~val)=t(~val)-a;
    f = round(f);

    AB2_frame_calc(group) = f;
end

%% Compare manual frame times to calculated frame times
AB_frame_man = [AB1_times, AB2_times];
AB_frame_calc = [AB1_frame_calc', AB2_frame_calc'];

diff = AB_frame_man-AB_frame_calc;
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

%% Parse MC capture to match size of game V1
AB1_parsed = struct('Game_data',[],'MC_data',[],'Labels',[], ...
    'Visit',[],'Hand',[],'Path',[],'Start_time',[], ...
    'Frame_time_calculated',[],'Frame_time_manual',[]);

AB1_parsed(1).Game_data = nan;
AB1_parsed(1).MC_data = Cal1_MC.position_data_interpolated;
AB1_parsed(1).Labels = Cal1_MC.labels;

AB1_parsed(1).Visit = 'Day-1';
AB1_parsed(1).Hand = nan;
AB1_parsed(1).Path = nan;
AB1_parsed(1).Start_time = nan;

AB1_parsed(1).Frame_time_calculated = nan;
AB1_parsed(1).Frame_time_manual = nan;

for j=1:length(AB1_frame_calc)
    switch trial(j)
        case 1
            MC_whole = AB1_MC(1).position_data_interpolated;
            labels = AB1_MC(1).labels;
        case 2
            MC_whole = AB1_MC(2).position_data_interpolated;
            labels = AB1_MC(2).labels;
        case 3
            MC_whole = AB1_MC(3).position_data_interpolated;
            labels = AB1_MC(3).labels;
    end

    % Determine length and start time of game
    tms = ABdata.RMov_time_step_ms{j,1};
    path = ABdata.RMov_path{j,1};
    hand = ABdata.trial_hand{j,1};
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
        time_selected = AB1_frame_calc(j)+i-1;
        if time_selected <= 0
            parse(:,:,i) = nan;
        elseif time_selected >= length(MC_whole)
            parse(:,:,i) = nan;
        else
            parse(:,:,i) = MC_whole(:,:,time_selected);
        end
    end

    AB1_parsed(j+1).Game_data = game_dis;
    AB1_parsed(j+1).MC_data = parse;
    AB1_parsed(j+1).Labels = labels;

    AB1_parsed(j+1).Visit = day(j);
    AB1_parsed(j+1).Hand = ABdata.trial_hand(j);
    AB1_parsed(j+1).Path = ABdata.road_path{j,1};
    AB1_parsed(j+1).Start_time = ABdata.trial_start_time(j);

    AB1_parsed(j+1).Frame_time_calculated = AB1_frame_calc(j);
    AB1_parsed(j+1).Frame_time_manual = AB_frame_man(j);

end

%% Parse MC capture to match size of game V2
AB2_parsed = struct('Game_data',[],'MC_data',[],'Labels',[], ...
    'Visit',[],'Hand',[],'Path',[],'Start_time',[], ...
    'Frame_time_calculated',[],'Frame_time_manual',[]);

AB2_parsed(1).Game_data = nan;
AB2_parsed(1).MC_data = Cal2_MC.position_data_interpolated;
AB2_parsed(1).Labels = Cal2_MC.labels;

AB2_parsed(1).Visit = 'Day-2';
AB2_parsed(1).Hand = nan;
AB2_parsed(1).Path = nan;
AB2_parsed(1).Start_time = nan;

AB2_parsed(1).Frame_time_calculated = nan;
AB2_parsed(1).Frame_time_manual = nan;

for j=1:length(AB2_frame_calc)
    switch trial(j)
        case 1
            MC_whole = AB2_MC(1).position_data_interpolated;
            labels = AB2_MC(1).labels;
        case 2
            MC_whole = AB2_MC(2).position_data_interpolated;
            labels = AB2_MC(2).labels;
        case 3
            MC_whole = AB2_MC(3).position_data_interpolated;
            labels = AB2_MC(3).labels;
    end

    % Determine length and start time of game
    k = j+12;

    tms = ABdata.RMov_time_step_ms{k,1};
    path = ABdata.RMov_path{k,1};
    hand = ABdata.trial_hand{k,1};
    [gm_dis_l,gm_dis_r] = calcdisgame(tms,path,hand,k);

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
        time_selected = AB2_frame_calc(j)+i-1;
        if time_selected <= 0
            parse(:,:,i) = nan;
        elseif time_selected >= length(MC_whole)
            parse(:,:,i) = nan;
        else
            parse(:,:,i) = MC_whole(:,:,time_selected);
        end
    end

    AB2_parsed(j+1).Game_data = game_dis;
    AB2_parsed(j+1).MC_data = parse;
    AB2_parsed(j+1).Labels = labels;

    AB2_parsed(j+1).Visit = day(k);
    AB2_parsed(j+1).Hand = ABdata.trial_hand(k);
    AB2_parsed(j+1).Path = ABdata.road_path{k,1};
    AB2_parsed(j+1).Start_time = ABdata.trial_start_time(k);

    AB2_parsed(j+1).Frame_time_calculated = AB2_frame_calc(j);
    AB2_parsed(j+1).Frame_time_manual = AB_frame_man(k);

end

%% Save
filesvas = fullfile(filepath,'Analysis\ViconMCdata\ParsedFrame');
svas1 = append(participant,'_V1ParsedData');
svas2 = append(participant,'_V2ParsedData');

tempStruct1.(svas1) = AB1_parsed;
tempStruct2.(svas2) = AB2_parsed;
filesv1 = append(svas1,'.mat');
filesv2 = append(svas2,'.mat');

filesvas1 = fullfile(filesvas,filesv1);
save(filesvas1, '-struct', 'tempStruct1');

filesvas2 = fullfile(filesvas,filesv2);
save(filesvas2, '-struct', 'tempStruct2');
