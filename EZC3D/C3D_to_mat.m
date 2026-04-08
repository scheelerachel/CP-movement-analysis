% c3d2mat.m
%
% Converts a C3D file to .mat as a structure
%
% Input - C3D file after fixing labeling
% Output - Structure with 10 fields including: tial, game, number of
% markers, position data, labels, time, frome rate, total number of frames,
% total time, and interpolated/smoothed position data
% 
% Must be ran on the computer with the C3D files saved!
%
% Rachel Scheele
% Last Edited 6/23/2025

% clean workspace and command window
clear;
close all;
clc;

% data input
user = getenv('username');

numstr = input("\nParticipant ID (case sensitive)\nMHEALTH",'s');
num = str2double(numstr);
participant = append('MHEALTH',numstr);

% Determine UCP or TD
if num < 200 && num > 100
    class = 'TD';
elseif num > 200 && num < 300
    class = 'UCP';
else
    fprintf('error')
end

% read games and match to trials
fileread = fullfile('C:\Users',user,'OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Data','Vicon Label Marker Tracker.xlsx');
game_table = readtable(fileread);

ID = string(table2cell(game_table(:,1)));
tV1_arr = string(table2cell(game_table(:,2)));
gameV1_arr = string(table2cell(game_table(:,3)));
tV2_arr = string(table2cell(game_table(:,11)));
gameV2_arr = string(table2cell(game_table(:,12)));

loc_start = find(ID==participant);
bkV1 = find(tV1_arr=="");
loc_end1 = min(bkV1(bkV1>loc_start));
bkV2 = find(tV2_arr=="");
loc_end2 = min(bkV2(bkV2>loc_start));

length1 = loc_end1-loc_start;
i = 1:length1;
gameV1(i) = gameV1_arr(loc_start-1+i);
gameV1 = gameV1';

length2 = loc_end2-loc_start;
i = 1:length2;
gameV2(i) = gameV2_arr(loc_start-1+i);
gameV2 = gameV2';

all_game = cat(1,gameV1,gameV2);

% create structure for data entry
s = struct();
val = 1;

% repeat for both visits
for j = 1:2

    % find files
    visit = char(string(j));
    visit = append('Visit',visit);
    ff = fullfile('C:\Vicon Database\R21',class,participant,visit);
    fileget = dir(fullfile('C:\Vicon Database\R21',class,participant,visit,'*.c3d'));

    % repeate for all trial
    for i = 1:length(fileget)
    
        % import and extract c3d files
        file = fileget(i).name;
        trial = file(1:end-4);
        c3d = ezc3dRead(fullfile(ff,file));
        num_markers = c3d.parameters.POINT.USED.DATA;
        
        % (X,Y,Z)x(# markers)x(# frames)
        marker_data = c3d.data.points; % pulls data into workspace from struct
        
        % time
        framerate = c3d.header.points.frameRate;
        numframes = c3d.header.points.lastFrame - c3d.header.points.firstFrame;
        time = numframes/framerate;

        % labels
        labels = c3d.parameters.POINT.LABELS.DATA;
    
        % game played
        game = char(all_game(val));

        % time calculated in seconds
        time_step = zeros(length(marker_data),1);
        for j=1:length(time_step)-1
            time_step(j+1) = time_step(j)+1/framerate;
        end

        % save to structure
        s(val).trial = trial;
        s(val).game = game;
        s(val).num_markers = num_markers;
        s(val).position_data = marker_data;
        s(val).labels = labels;
        s(val).time = time_step;
        s(val).framerate = framerate;
        s(val).total_frames = numframes;
        s(val).total_time = time;

        val = val+1;
    end

end

% analysis
for k=1:length(s)

    time = s(k).time;
    data = s(k).position_data;
    sz = size(data);
    xyz = zeros(sz(3),sz(1),sz(2));
    qry = time;
    labelxyz = [];

    for j=1:sz(2)

        position = squeeze(data(:,j,:));
        x = position(1,:)';
        y = position(2,:)';
        z = position(3,:)';
        ttemp = time;

        % delete empty values
        for i=length(x):-1:1
            if isnan(x(i)) || isnan(y(i)) || isnan(z(i))
                x(i) = [];
                y(i) = [];
                z(i) = [];
                ttemp(i) = [];
            end
        end

        if length(x) > 200
            % interpolation
            xint = interp1(ttemp, x, qry, 'linear');
            yint = interp1(ttemp, y, qry, 'linear');
            zint = interp1(ttemp, z, qry, 'linear');
            %method: 'linear', 'nearest', 'next', 'previous', 'pchip', 'cubic',
            %'v5cubic', 'makima', or 'spline'. The default method is 'linear'.
    
            % filtering
            smoothx = smoothdata(xint,'gaussian',40);
            smoothy = smoothdata(yint,'gaussian',40);
            smoothz = smoothdata(zint,'gaussian',40);
            % smoothing methods: 'movmean' (default), 'movemedian', 'gaussian',
            % 'lowess', 'loess', 'rlowess', 'rloess', 'sgolay'
    
            % compile to array
            xyz(:,:,j) = [smoothx,smoothy,smoothz];
        else
            xset = nan(size(time));
            yset = nan(size(time));
            zset = nan(size(time));
            xyz(:,:,j) = [xset,yset,zset];
        end

    end

    % put all data back together and save to structure
    allxyz = permute(xyz,[2 3 1]);
    s(k).position_data_interpolated = allxyz;

    % sanity check
    check = sum(isnan(s(k).position_data_interpolated),'all');
    if check == 0
        fprintf('Perfect: 0 missing frames\n')
    elseif check > 0
        sz = size(s(k).position_data_interpolated);
        frames = sz(1)*sz(2)*sz(3);
        perframe = (check/frames)*100;
        fprintf('Error: %i missing frames (%4.2f%%)\n',check, perframe)
    end
end

% rename structure
svas = append(participant,'_VICON');
assignin('base',svas,s)

% save
filename = append(svas,'.mat');
filesave = fullfile('C:\Users',user,'OneDrive - Marquette University\Documents - Pediatric Movement and Neuroscience Lab (PMNL)\R21_mHealthApp\Analysis\ViconMCdata\Extracted',filename);

save(filesave,svas)