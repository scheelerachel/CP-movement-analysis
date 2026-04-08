% AsteroidBelt4.m
%
% Function to plot:
% Completion Time (8)
%
% Rachel Scheele
% Last Edited 8/1/2025

function [f8,ABstruct] = AsteroidBelt4(movement_time,hand,handedness,visit,name,ABstruct)

    a = 1;
    b = 1;
    completion_left = zeros(size(hand));
    completion_right = zeros(size(hand));

    for j=1:length(movement_time)
    
        time = movement_time{j}; % in ms
        completion_time = max(time);

        if isequal(hand{j},'Left')
            completion_left(a) = completion_time;
            a = a + 1;
        elseif isequal(hand{j},'Right')
            completion_right(b) = completion_time;
            b = b + 1;
        else
            fprintf('error 5\n');
        end
            
    end

    completion_left = completion_left(completion_left~=0);
    completion_right = completion_right(completion_right~=0);

    if isequal(hand{1},'Left')
        if isequal(handedness{1},'More Affected')
            l = "More Affected";
            r = "Less Affected";
        elseif isequal(handedness{1},'Less Affected')
            r = "More Affected";
            l = "Less Affected";
        elseif isequal(handedness{1},'Dominant')
            l = "Dominant";
            r = "Non-Dominant";
        elseif isequal(handedness{1},'Non-Dominant')
            r = "Dominant";
            l = "Non-Dominant";
        else
            fprintf('error 4\n')
        end
    elseif isequal(hand{1},'Right')
        if isequal(handedness{1},'More Affected')
            r = "More Affected";
            l = "Less Affected";
        elseif isequal(handedness{1},'Less Affected')
            l = "More Affected";
            r = "Less Affected";
        elseif isequal(handedness{1},'Dominant')
            r = "Dominant";
            l = "Non-Dominant";
        elseif isequal(handedness{1},'Non-Dominant')
            l = "Dominant";
            r = "Non-Dominant";
        else
            fprintf('error 4\n')
        end
    else
        fprintf('error 4\n')
    end

    % Seperate Visit 1 and 2
    com_L_1 = zeros(size(completion_left));
    com_L_2 = zeros(size(completion_left));
    com_R_1 = zeros(size(completion_right));
    com_R_2 = zeros(size(completion_right));

    a = 1;
    b = 1;

    for i=1:length(visit)
        if visit(i) == 1
            if isequal(hand{i},'Left')
                com_L_1(a) = completion_left(a);
                a = a + 1;
            elseif isequal(hand{i},'Right')
                com_R_1(b) = completion_right(b);
                b = b + 1;
            else
                fprintf('error 5\n');
            end
        elseif visit(i) == 2
            if isequal(hand{i},'Left')
                com_L_2(a) = completion_left(a);
                a = a + 1;
            elseif isequal(hand{i},'Right')
                com_R_2(b) = completion_right(b);
                b = b + 1;
            else
                fprintf('error 5\n');
            end
        else
            fprintf('error 5\n')
        end
    end

    com_L_1 = com_L_1(com_L_1~=0);
    com_R_1 = com_R_1(com_R_1~=0);
    com_L_2 = com_L_2(com_L_2~=0);
    com_R_2 = com_R_2(com_R_2~=0);

    avg_left_1 = mean(com_L_1);
    avg_right_1 = mean(com_R_1);
    avg_left_2 = mean(com_L_2);
    avg_right_2 = mean(com_R_2);

    f8 = figure(8);
    hold on
    swarm = [com_L_1; com_R_1];
    count = categorical([repmat(l,length(com_L_1),1);repmat(r,length(com_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [com_L_2; com_R_2];
    count = categorical([repmat(l,length(com_L_2),1);repmat(r,length(com_R_2),1)]);
    s2 = swarmchart(count,swarm,'r');

    for i = 1:numel(s1)
        s1(i).XJitter = 'randn';
        s1(i).XJitterWidth = 0.3;
    end
    
    for i = 1:numel(s2)
        s2(i).XJitter = 'randn';
        s2(i).XJitterWidth = 0.3;
    end
    
    set(gca,'fontsize',14)

    swarm = [avg_left_1; avg_right_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_left_2; avg_right_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name,' ','Asteroid Belt: Average Completion Time');
    title(graphname)
    ylabel('Time (ms)')
    hold off

    ind = find(handedness == "Dominant" | handedness == "More Affected",1);
    if handedness(ind) == "Dominant"
        if hand(ind) == "Left"
            com_time_L_1 = "completion_time_dom_1";
            com_time_L_2 = "completion_time_dom_2";
            com_time_R_1 = "completion_time_nondom_1";
            com_time_R_2 = "completion_time_nondom_2";
        elseif hand(ind) == "Right"
            com_time_R_1 = "completion_time_dom_1";
            com_time_R_2 = "completion_time_dom_2";
            com_time_L_1 = "completion_time_nondom_1";
            com_time_L_2 = "completion_time_nondom_2";
        end
    elseif handedness(ind) == "More Affected"
        if hand(ind) == "Left"
            com_time_L_1 = "completion_time_more_aff_1";
            com_time_L_2 = "completion_time_more_aff_2";
            com_time_R_1 = "completion_time_less_aff_1";
            com_time_R_2 = "completion_time_less_aff_2";
        elseif hand(ind) == "Right"
            com_time_L_1 = "completion_time_more_aff_1";
            com_time_L_2 = "completion_time_more_aff_2";
            com_time_R_1 = "completion_time_less_aff_1";
            com_time_R_2 = "completion_time_less_aff_2";
        end
    end

    % fill structure
    ABstruct.(com_time_L_1) = com_L_1;
    ABstruct.(com_time_R_1) = com_R_1;
    ABstruct.(com_time_L_2) = com_L_2;
    ABstruct.(com_time_R_2) = com_R_2;

end