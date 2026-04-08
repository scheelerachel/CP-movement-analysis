% AsteroidBeltMain.m
% Loads participant data from Asteroid Belt - runs:
% AsteroidBelt1.m
% AsteroidBelt2.m
% AsteroidBelt3.m
% AsteroidBelt4.m
% AsteroidBelt5.m
%
% Rachel Scheele
% Last Edited 11/13/2025

function AsteroidBeltMain(AB,left_hand,right_hand,fileGDA,filename)

    % extract remaining data from structure to individual cells
    study_day = AB.study_day;
    hand_used = AB.trial_hand;
    road_path = AB.road_path;
    movement_path = AB.RMov_path;
    movement_time = AB.RMov_time_step_ms;
    lift_pos = AB.RT_lift_pos;
    other_pos = AB.OT_lift_pos;
    
    % Seperate Day 1 and 2
    day = string(study_day);
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
    
    % handedness
    hand = string(hand_used);
    handedness = {nan};
    handedness = string(handedness);

    for i=1:length(hand)
        if hand(i) == "Left"
            handedness(i) = left_hand;
        elseif hand(i) == "Right"
            handedness(i) = right_hand;
        else
            fprintf('error main\n')
        end
    end

    % Participant ID
    name = string(filename);

    % Note: Visit 1 = black, Visit 2 = red

    % set up structure to save variables
    ABstruct = struct();
    
    % Execute functions that build plots
    [f1,f2,f3,ABstruct] = AsteroidBelt1(movement_path,movement_time,hand,handedness,visit,name,ABstruct);
    [f4,f5,f6,ABstruct] = AsteroidBelt2(movement_path,movement_time,hand,handedness,visit,name,ABstruct);
    [f7,ABstruct] = AsteroidBelt3(movement_path,road_path,hand,handedness,visit,name,ABstruct);
    [f8,ABstruct] = AsteroidBelt4(movement_time,hand,handedness,visit,name,ABstruct);
    [f9, ABstruct] = AsteroidBelt5(lift_pos,other_pos,hand,handedness,visit,name,ABstruct);
    
    % % Screen and figure size for figure positioning
    % screen = get(0, 'ScreenSize');
    % xsize = screen(3);
    % ysize = screen(4);
    % xfig = 560;
    % yfig = 420;
    % 
    % % Place and size figures on screen
    % f1.Position(1:2) = [1 ysize-yfig-85];
    % f2.Position(1:2) = [(xsize-xfig)/3 ysize-yfig-85];
    % f3.Position(1:2) = [(xsize-xfig)/3*2 ysize-yfig-85];
    % f4.Position(1:2) = [1 1+44];
    % f5.Position(1:2) = [(xsize-xfig)/3 1+45];
    % f6.Position(1:2) = [(xsize-xfig)/3*2 1+45];
    % f7.Position(1:2) = [xsize-xfig ysize-yfig-85];
    % f8.Position(1:2) = [xsize-xfig 1+45];
    
    % Export
    path = fullfile(fileGDA,'Asteroid Belt Individual\');

    % Rename structure
    svas = append(name,'ABVariables');

    % Build a temporary structure with a dynamic field name
    tempStruct.(svas) = ABstruct;

    % save structure
    filesv = append(svas,'.mat');
    filesvas = fullfile(path,filesv);

    % save structure
    save(filesvas, '-struct', 'tempStruct');

    % save figures
    saveas = append(path,name,'AsteroidBelt','.pdf');
    
    if isfile(saveas) == 1
        delete(saveas)
    end
    
    exportgraphics(f1, saveas, 'Append', true);
    exportgraphics(f2, saveas, 'Append', true);
    exportgraphics(f3, saveas, 'Append', true);
    exportgraphics(f4, saveas, 'Append', true);
    exportgraphics(f5, saveas, 'Append', true);
    exportgraphics(f6, saveas, 'Append', true);
    exportgraphics(f7, saveas, 'Append', true);
    exportgraphics(f8, saveas, 'Append', true);
    exportgraphics(f9, saveas, 'Append', true);
    
end