% OrbitalReaching5.m
%
% Function to plot:
% Number of taps (19)
%
% Rachel Scheele
% Last Edited 9/4/2025

function [f19, ORstruct] = OrbitalReaching5(lift_pos,other_pos,hand,handedness,visit,name,ORstruct)

% SHOULD I DISTINGUISH BETWEEN TAPING THE TARGET INSTEAD OF THE PLANET?
    lift_L_1 = nan;
    lift_R_1 = nan;
    lift_L_2 = nan;
    lift_R_2 = nan;

    other_L_1 = nan;
    other_R_1 = nan;
    other_L_2 = nan;
    other_R_2 = nan;

    tap_L_1 = nan;
    tap_R_1 = nan;
    tap_L_2 = nan;
    tap_R_2 = nan;

    tap_planets_L_1 = nan;
    tap_planets_R_1 = nan;
    tap_planets_L_2 = nan;
    tap_planets_R_2 = nan;

    for i=1:length(lift_pos)

        lifts = cell2mat(lift_pos(i));
        other = cell2mat(other_pos(i));

        count_lifts = (length(lifts))/2;
        count_other = (length(other))/2;
        count_taps = count_lifts + count_other;
        
        if visit(i) == 1
            if isequal(hand{i},'Left')
                lift_L_1 = cat(1,lift_L_1,count_lifts);
                other_L_1 = cat(1,other_L_1,count_other);
                tap_L_1 = cat(1,tap_L_1,count_taps);
            elseif isequal(hand{i},'Right')
                lift_R_1 = cat(1,lift_R_1,count_lifts);
                other_R_1 = cat(1,other_R_1,count_other);
                tap_R_1 = cat(1,tap_R_1,count_taps);
            else
                fprintf('error 5\n');
            end
        elseif visit(i) == 2
            if isequal(hand{i},'Left')
                lift_L_2 = cat(1,lift_L_2,count_lifts);
                other_L_2 = cat(1,other_L_2,count_other);
                tap_L_2 = cat(1,tap_L_2,count_taps);
            elseif isequal(hand{i},'Right')
                lift_R_2 = cat(1,lift_R_2,count_lifts);
                other_R_2 = cat(1,other_R_2,count_other);
                tap_R_2 = cat(1,tap_R_2,count_taps);
            else
                fprintf('error 5\n');
            end
        else
            fprintf('error 5\n')
        end

    end

    % lift_L_1 = lift_L_1(~isnan(lift_L_1));
    % lift_R_1 = lift_R_1(~isnan(lift_R_1));
    % lift_L_2 = lift_L_2(~isnan(lift_L_2));
    % lift_R_2 = lift_R_2(~isnan(lift_R_2));
    % 
    % other_L_1 = other_L_1(~isnan(other_L_1));
    % other_R_1 = other_R_1(~isnan(other_R_1));
    % other_L_2 = other_L_2(~isnan(other_L_2));
    % other_R_2 = other_R_2(~isnan(other_R_2));

    tap_L_1 = tap_L_1(~isnan(tap_L_1));
    tap_R_1 = tap_R_1(~isnan(tap_R_1));
    tap_L_2 = tap_L_2(~isnan(tap_L_2));
    tap_R_2 = tap_R_2(~isnan(tap_R_2));

    for i=1:(length(tap_L_1)/8)
        first = (i*8)-7;
        last = (i*8);
        tap_planets_L_1(i) = sum(tap_L_1(first:last));
    end

    for i=1:(length(tap_R_1)/8)
        first = (i*8)-7;
        last = (i*8);
        tap_planets_R_1(i) = sum(tap_R_1(first:last));
    end

    for i=1:(length(tap_L_2)/8)
        first = (i*8)-7;
        last = (i*8);
        tap_planets_L_2(i) = sum(tap_L_2(first:last));
    end

    for i=1:(length(tap_R_2)/8)
        first = (i*8)-7;
        last = (i*8);
        tap_planets_R_2(i) = sum(tap_R_2(first:last));
    end

    % tap_planets_L_1 = tap_planets_L_1(~isnan(tap_planets_L_1));
    % tap_planets_R_1 = tap_planets_R_1(~isnan(tap_planets_R_1));
    % tap_planets_L_2 = tap_planets_L_2(~isnan(tap_planets_L_2));
    % tap_planets_R_2 = tap_planets_R_2(~isnan(tap_planets_R_2));

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
            fprintf('error 1\n')
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
            fprintf('error 1\n')
        end
    else
        fprintf('error 1\n')
    end

    avg_tap_L_1 = mean(tap_planets_L_1);
    avg_tap_R_1 = mean(tap_planets_R_1);
    avg_tap_L_2 = mean(tap_planets_L_2);
    avg_tap_R_2 = mean(tap_planets_R_2);

    f19 = figure(19);
    hold on
    label = [l,r];
    avgs_taps = [avg_tap_L_1,avg_tap_R_1;avg_tap_L_2,avg_tap_R_2];
    b1 = bar(label,avgs_taps);

    set(b1(1), 'FaceColor','k')
    set(b1(2), 'FaceColor','r')
    set(gca,'fontsize',14)

    legend(b1,{'Visit 1','Visit 2'})
    graphname = append(name,' ','Orbital Reaching: Lifts per 8 Planets');
    title(graphname)
    ylabel('Number of Lifts')
    hold off

    % determine handedness
    ind = find(handedness == "Dominant" | handedness == "More Affected",1);
    if handedness(ind) == "Dominant"
        if hand(ind) == "Left"
            label_L_1 = "taps_dom_1";
            label_L_2 = "taps_dom_2";
            label_R_1 = "taps_nondom_1";
            label_R_2 = "taps_nondom_2";

        elseif hand(ind) == "Right"
            label_R_1 = "taps_dom_1";
            label_R_2 = "taps_dom_2";
            label_L_1 = "taps_nondom_1";
            label_L_2 = "taps_nondom_2";
        end

    elseif handedness(ind) == "More Affected"
        if hand(ind) == "Left"
            label_L_1 = "taps_more_aff_1";
            label_L_2 = "taps_more_aff_2";
            label_R_1 = "taps_less_aff_1";
            label_R_2 = "taps_less_aff_2";

        elseif hand(ind) == "Right"
            label_L_1 = "taps_more_aff_1";
            label_L_2 = "taps_more_aff_2";
            label_R_1 = "taps_less_aff_1";
            label_R_2 = "taps_less_aff_2";
        end
    end

    % fill structure
    ORstruct.(label_L_1) = avg_tap_L_1;
    ORstruct.(label_R_1) = avg_tap_R_1;
    ORstruct.(label_L_2) = avg_tap_L_2;
    ORstruct.(label_R_2) = avg_tap_R_2;

end