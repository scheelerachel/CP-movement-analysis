% AsteroidNinja1.m
% Percent Successful
%
% Rachel Scheele
% Last Edited 8/1/2025

function [f21,ANstruct] = AsteroidNinja1(num_asteroids_R,num_destroyed_R,num_asteroids_L,num_destroyed_L,right_hand,left_hand,visit,name,ANstruct)
    
    total_R = double(num_asteroids_R);
    success_R = double(num_destroyed_R);
    total_L = double(num_asteroids_L);
    success_L = double(num_destroyed_L);
    percent_R = success_R./total_R;
    percent_L = success_L./total_L;

    l = left_hand;
    r = right_hand;

    f21 = figure(21);
    hold on
    count = categorical([l,r]);
    per = [percent_L'; percent_R'];
    b = bar(count,per,'FaceColor','flat');

    ylabel('Percent Successfully Destroyed');
    graphname = append(name,' ','Asteroid Ninja: Score');
    title(graphname)

    for i=1:length(percent_R)

        if visit(i) == 1
            b(i).CData = [0 0 0];
        elseif visit(i) == 2
            b(i).CData = [1 0 0];
        else
            fprintf('error 1\n')
        end
    end

    legend([b(1) b(end)],{'Visit 1','Visit 2'})

    hold off

    % determine handedness
    if right_hand == "Dominant"
        percent_successful_R = "percent_successful_dom";
        percent_successful_L = "percent_successful_nondom";
    elseif right_hand == "Non-Dominant"
        percent_successful_L = "percent_successful_dom";
        percent_successful_R = "percent_successful_nondom";
    elseif right_hand == "More Affected"
        percent_successful_R = "percent_successful_more_affected";
        percent_successful_L = "percent_successful_less_affected";
    elseif right_hand == "Less Affected"
        percent_successful_L = "percent_successful_more_affected";
        percent_successful_R = "percent_successful_less_affected";
    end

    % fill structure
    ANstruct.(percent_successful_L) = percent_L;
    ANstruct.(percent_successful_R) = percent_R;
   
end