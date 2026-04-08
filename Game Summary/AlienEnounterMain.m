% AlienEncounterMain.m
% Loads participant data to plot useful aspects of the data
%
% Rachel Scheele
% Last Edited 6/19/2025

function AlienEncounterMain(AE,left_hand,right_hand,filepath,filename)

    % extract remaining data from structure to individual cells
    study_day = AE.study_day;
    
    % will need for datetime but I'm not sure what that will be yet...
    movement_time_R = cell(length(movement_path_R), 1); % preallocate
    for i = 1:length(movement_path_R)
        movement_time_R{i} = cellstr(char([data.trials(i,10)]));
    end
    
    movement_time_L = cell(length(movement_path_L), 1); % preallocate
    for i = 1:length(movement_path_L)
        movement_time_L{i} = cellstr(char([data.trials(i,16)]));
    end
    
    % Display participant ID and day
    disp(data.id)
    display(cell2mat(study_day(1)))
    
    % Execute functions that build plots
    AsteroidNinja1(num_asteroids_R, num_destroyed_R, num_asteroids_L, num_destroyed_L)
    AsteroidNinja2(movement_path_R,movement_time_R,movement_path_L,movement_time_L)
end