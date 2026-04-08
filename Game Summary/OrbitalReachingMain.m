% OrbitalReachingMain.m
% Loads participant data from Orbital Reaching - runs:
% OrbitalReaching1.m
% OrbitalReaching2.m
% OrbitalReaching3.m
% OrbitalReaching4.m
% OrbitalReaching5.m

% Rachel Scheele
% Last Edited 11/13/2025

function OrbitalReachingMain(OR,left_hand,right_hand,fileGDA,filename)
    
    % extract remaining data from structure to individual cells
    study_day = OR.study_day;
    hand_used = OR.trial_hand;
    planet = OR.planet;
    initial_position = OR.planet_pos;
    target_position = OR.target_pos;
    movement_path = OR.PMov_path;
    movement_time = OR.PMov_time_step_ms;
    lift_pos = OR.PT_lift_pos;
    other_pos = OR.OT_begin_pos;
    
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
    ORstruct = struct();
    
    % Execute functions that build plots
    [f11,ORstruct] = OrbitalReaching1(movement_path,initial_position,target_position,hand,planet,handedness,visit,name,ORstruct);
    [f12,f13,f14,ORstruct] = OrbitalReaching2(hand,planet,movement_path,movement_time,handedness,visit,name,ORstruct);
    [f15,f16,f17,ORstruct] = OrbitalReaching3(hand,planet,movement_path,movement_time,handedness,visit,name,ORstruct);
    [f18,ORstruct] = OrbitalReaching4(hand,planet,movement_time,handedness,visit,name,ORstruct);
    [f19, ORstruct] = OrbitalReaching5(lift_pos,other_pos,hand,handedness,visit,name,ORstruct);
    
    % % Screen and figure size for figure positioning
    % screen = get(0, 'ScreenSize');
    % xsize = screen(3);
    % ysize = screen(4);
    % xfig = 560;
    % yfig = 420;
    % 
    % % Place and size figures on screen
    % f11.Position(1:2) = [xsize-xfig ysize-yfig-85];
    % f12.Position(1:2) = [1 ysize-yfig-85];
    % f13.Position(1:2) = [(xsize-xfig)/3 ysize-yfig-85];
    % f14.Position(1:2) = [(xsize-xfig)/3*2 ysize-yfig-85];
    % f15.Position(1:2) = [1 1+44];
    % f16.Position(1:2) = [(xsize-xfig)/3 1+45];
    % f17.Position(1:2) = [(xsize-xfig)/3*2 1+45];
    % f18.Position(1:2) = [xsize-xfig 1+45];
    
    % Export stucture and figures
    path = fullfile(fileGDA,'Orbital Reaching Individual\');

    % Rename structure
    svas = append(name,'ORVariables');

    % Build a temporary structure with a dynamic field name
    tempStruct.(svas) = ORstruct;

    % save structure
    filesv = append(svas,'.mat');
    filesvas = fullfile(path,filesv);
    
    % Save using -struct so the variable is named correctly inside the file
    save(filesvas, '-struct', 'tempStruct');

    % save figures
    saveas = append(path,name,'OrbitalReaching','.pdf');
    
    if isfile(saveas) == 1
        delete(saveas)
    end
    
    exportgraphics(f11, saveas, 'Append', true);
    exportgraphics(f12, saveas, 'Append', true);
    exportgraphics(f13, saveas, 'Append', true);
    exportgraphics(f14, saveas, 'Append', true);
    exportgraphics(f15, saveas, 'Append', true);
    exportgraphics(f16, saveas, 'Append', true);
    exportgraphics(f17, saveas, 'Append', true);
    exportgraphics(f18, saveas, 'Append', true);
    exportgraphics(f19, saveas, 'Append', true);