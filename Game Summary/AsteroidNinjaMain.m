% AsteroidNinjaMain.m
% Loads participant data from Asteroid Ninja - runs:
% AsteroidNinja1.m
% AsteroidNinja2.m
% AsteroidNinja3.m
%
% Rachel Scheele
% Last Edited 8/5/2025

function AsteroidNinjaMain(AN,left_hand,right_hand,fileGDA,filename)

% Check if extra trials exist    
if length(AN.study_day)>4
        usetrial=[];
        for i = 1:length(AN.study_day)
            if AN.asteroid_falls_right(i)>30
                usetrial=[usetrial;i];
            end
        end

else 
    usetrial=[1:4];
    end



    % extract remaining data from structure to individual cells
    study_day = AN.study_day(usetrial);
    num_asteroids_R = AN.asteroid_falls_right(usetrial);
    num_destroyed_R = AN.asteroid_destroyed_right(usetrial);
    movement_path_R = AN.movement_path_right(usetrial);
    movement_time_R = AN.movement_time_right_ss(usetrial);
    num_asteroids_L = AN.asteroid_falls_left(usetrial);
    num_destroyed_L = AN.asteroid_destroyed_left(usetrial);
    movement_path_L = AN.movement_path_left(usetrial);
    movement_time_L = AN.movement_time_left_ss(usetrial);
    collision_time_L = AN.collision_time_left(usetrial);
    collision_time_R = AN.collision_time_right(usetrial);
    touch_time_L = AN.touch_begin_left_time(usetrial);
    touch_time_R = AN.touch_begin_right_time(usetrial);
    lift_time_L = AN.touch_lift_left_time(usetrial);
    lift_time_R = AN.touch_lift_right_time(usetrial);
    trial_start_time=AN.trial_start_time(usetrial);
    trial_end_time=AN.trial_end_time(usetrial);



    
    % Seperate Day 1 and 2
    day = string(cell2mat(study_day));
    visit = zeros(size(day));
    for i = 1:length(study_day)
        if day(i) == "Day-1"
            visit(i) = 1;
        elseif day(i) == "Day-2"
            visit(i) = 2;
        else
            fprintf('error main\n')
        end
    end

    % Participant ID
    name = string(filename);
    
    % Note: Visit 1 = black, Visit 2 = red

    % set up structure to save variables
    ANstruct = struct();
    
    % Execute functions that build plots
    [f21,ANstruct] = AsteroidNinja1(num_asteroids_R,num_destroyed_R,num_asteroids_L,num_destroyed_L,right_hand,left_hand,visit,name,ANstruct);
    [f22,f23,f24,ANstruct] = AsteroidNinja2(movement_path_R,movement_time_R,movement_path_L,movement_time_L,right_hand,left_hand,visit,name,ANstruct);
    [f25,f26,f27,ANstruct] = AsteroidNinja3(movement_path_R,movement_time_R,movement_path_L,movement_time_L,right_hand,left_hand,visit,name,ANstruct);
    ANstruct=AsteroidNinja4(collision_time_L, collision_time_R, touch_time_L, touch_time_R, lift_time_L, lift_time_R, trial_start_time, trial_end_time, right_hand, left_hand, visit, name, ANstruct);
    
    % % Screen and figure size for figure positioning
    % screen = get(0, 'ScreenSize');
    % xsize = screen(3);
    % ysize = screen(4);
    % xfig = 560;
    % yfig = 420;
    % 
    % % Place ans size figures on screen
    % f21.Position(1:2) = [1 ysize-yfig-85];
    % f22.Position(1:2) = [(xsize-xfig)/3 ysize-yfig-85];
    % f23.Position(1:2) = [(xsize-xfig)/3*2 ysize-yfig-85];
    % f24.Position(1:2) = [1 1+44];
    % f25.Position(1:2) = [(xsize-xfig)/3 1+45];
    % f26.Position(1:2) = [(xsize-xfig)/3*2 1+45];
    % f27.Position(1:2) = [xsize-xfig ysize-yfig-85];
    % % f28.Position(1:2) = [xsize-xfig 1+45];

    % Export
    path = fullfile(fileGDA,'Asteroid Ninja Individual\');
    
    % Rename structure
    svas = append(name,'ANVariables');    

    % Build a temporary structure with a dynamic field name
    tempStruct.(svas) = ANstruct;

    % save structure
    filesv = append(svas,'.mat');
    filesvas = fullfile(path,filesv);

    % save structure
    save(filesvas, '-struct', 'tempStruct');

    % save figures
    saveas = append(path,name,'AsteroidNinja','.pdf');

    if isfile(saveas) == 1
        delete(saveas)
    end

    exportgraphics(f21, saveas, 'Append', true);
    exportgraphics(f22, saveas, 'Append', true);
    exportgraphics(f23, saveas, 'Append', true);
    exportgraphics(f24, saveas, 'Append', true);
    exportgraphics(f25, saveas, 'Append', true);
    exportgraphics(f26, saveas, 'Append', true);
    exportgraphics(f27, saveas, 'Append', true);
    % exportgraphics(f28, saveas, 'Append', true);

    pause(4)
    close all;
end