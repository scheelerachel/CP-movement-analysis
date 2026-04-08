% OrbitalReaching1.m
%
% Function to plot:
% RMS (1)
% Can also plot but is commented out:
% Deviation from Path with all points plotted (13)
%
% Rachel Scheele
% Last Edited 11/13/2025

function [f11,ORstruct] = OrbitalReaching1(movement_path,initial_position,target_position,hand,planet,handedness,visit,name,ORstruct)

    start = cell2mat(initial_position);
    last = cell2mat(target_position);

    all_L_1 = nan;
    all_R_1 = nan;
    all_L_2 = nan;
    all_R_2 = nan;
    rms_L_1 = zeros(size(hand));
    rms_R_1 = zeros(size(hand));
    rms_L_2 = zeros(size(hand));
    rms_R_2 = zeros(size(hand));

    planetplot = zeros(size(hand));
    pp_L_1 = [];
    pp_R_1 = [];
    pp_L_2 = [];
    pp_R_2 = [];
    
    for j=1:length(movement_path)
            
        position = cell2mat(movement_path(j));
        x = position(:,1);
        y = position(:,2);

        sz = length(x);
        xideal = linspace(start(j,1),last(j,1),sz);
        yideal = linspace(start(j,2),last(j,2),sz);

        diffx = zeros(size(x));
        diffy = zeros(size(y));
        diff = zeros(size(y));
        error = zeros(size(x));
    
        for i=1:length(x)

            for k=1:length(xideal)
                diffx(k) = abs(x(i)-xideal(k));
                diffy(k) = abs(y(i)-yideal(k));
                diff(k) = sqrt(diffx(k)^2 + diffy(k)^2)*(127/660);
            end

            error(i) = min(diff);
        end
    
        if isequal(planet{j},'mercury')
            planetplot(j) = 1;
        elseif isequal(planet{j},'venus')
            planetplot(j) = 2;
        elseif isequal(planet{j},'earth')
            planetplot(j) = 3;
        elseif isequal(planet{j},'mars')
            planetplot(j) = 4;
        elseif isequal(planet{j},'jupiter')
            planetplot(j) = 5;
        elseif isequal(planet{j},'saturn')
            planetplot(j) = 6;
        elseif isequal(planet{j},'uranus')
            planetplot(j) = 7;
        elseif isequal(planet{j},'neptune')
            planetplot(j) = 8;
        else
                    fprintf('error')
        end

        if isequal(hand{j},'Left')
            if visit(j) == 1
                all_L_1 = cat(1,all_L_1,error);
                rms_L_1(j) = rms(error);
                pp_L_1 = cat(1,pp_L_1,planetplot(j));
            elseif visit(j) == 2
                all_L_2 = cat(1,all_L_2,error);
                rms_L_2(j) = rms(error);
                pp_L_2 = cat(1,pp_L_2,planetplot(j));
            else
                fprintf('error 4\n');
            end
        elseif isequal(hand{j},'Right')
            if visit(j) == 1
                all_R_1 = cat(1,all_R_1,error);
                rms_R_1(j) = rms(error);
                pp_R_1 = cat(1,pp_R_1,planetplot(j));
            elseif visit(j) == 2
                all_R_2 = cat(1,all_R_2,error);
                rms_R_2(j) = rms(error);
                pp_R_2 = cat(1,pp_R_2,planetplot(j));
            else
                fprintf('error 4\n');
            end
        else
            fprintf('error 4\n');
        end
         
    end

    % remove when RMS = 0
    rms_L_1 = rms_L_1(rms_L_1~=0);
    rms_R_1 = rms_R_1(rms_R_1~=0);
    rms_L_2 = rms_L_2(rms_L_2~=0);
    rms_R_2 = rms_R_2(rms_R_2~=0);

    avg_rms_L_1 = mean(rms_L_1);
    avg_rms_R_1 = mean(rms_R_1);
    avg_rms_L_2 = mean(rms_L_2);
    avg_rms_R_2 = mean(rms_R_2);

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
            fprintf('error 3\n')
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
            fprintf('error 3\n')
        end
    else
        fprintf('error 3\n')
    end

    f11 = figure(11);
    hold on
    set(gca,'fontsize',14)

    swarm = [rms_L_1; rms_R_1];
    count = categorical([repmat(l,length(rms_L_1),1);repmat(r,length(rms_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [rms_L_2; rms_R_2];
    count = categorical([repmat(l,length(rms_L_2),1);repmat(r,length(rms_R_2),1)]);
    s2 = swarmchart(count,swarm,'r');

    % Jitter strength (tweak as needed)
    xjitter_strength = 0.075;

    for i = 1:length(rms_L_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(i)) + xjitter, s1.YData(i), num2str(pp_L_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    offset = length(rms_L_1); % index offset for right hand
    for i = 1:length(rms_R_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(offset + i)) + xjitter, s1.YData(offset + i), num2str(pp_R_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    for i = 1:length(rms_L_2)
        xjitter = xjitter_strength * randn();
        text(double(s2.XData(i)) + xjitter, s2.YData(i), num2str(pp_L_2(i)), ...
            'HorizontalAlignment','center', 'Color','r', 'FontSize', 8);
    end
    
    offset = length(rms_L_2); % index offset for right hand
    for i = 1:length(rms_R_2)
        xjitter = xjitter_strength * randn();
        text(double(s2.XData(offset + i)) + xjitter, s2.YData(offset + i), num2str(pp_R_2(i)), ...
            'HorizontalAlignment','center', 'Color','r', 'FontSize', 8);
    end

    for i = 1:numel(s1)
        s1(i).XJitter = 'randn';
        s1(i).XJitterWidth = 0.3;
    end
    
    for i = 1:numel(s2)
        s2(i).XJitter = 'randn';
        s2(i).XJitterWidth = 0.3;
    end

    swarm = [avg_rms_L_1; avg_rms_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_rms_L_2; avg_rms_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name,' ','Orbital Reaching: RMS');
    title(graphname)
    ylabel('mm')

    s1.Marker = 'none';
    s2.Marker = 'none';
    hold off

    ind = find(handedness == "Dominant" | handedness == "More Affected",1);
    if handedness(ind) == "Dominant"
        if hand(ind) == "Left"
            RMS_L_1 = "RMS_dom_1";
            RMS_L_2 = "RMS_dom_2";
            RMS_R_1 = "RMS_nondom_1";
            RMS_R_2 = "RMS_nondom_2";
        elseif hand(ind) == "Right"
            RMS_R_1 = "RMS_dom_1";
            RMS_R_2 = "RMS_dom_2";
            RMS_L_1 = "RMS_nondom_1";
            RMS_L_2 = "RMS_nondom_2";
        end
    elseif handedness(ind) == "More Affected"
        if hand(ind) == "Left"
            RMS_L_1 = "RMS_more_aff_1";
            RMS_L_2 = "RMS_more_aff_2";
            RMS_R_1 = "RMS_less_aff_1";
            RMS_R_2 = "RMS_less_aff_2";
        elseif hand(ind) == "Right"
            RMS_L_1 = "RMS_more_aff_1";
            RMS_L_2 = "RMS_more_aff_2";
            RMS_R_1 = "RMS_less_aff_1";
            RMS_R_2 = "RMS_less_aff_2";
        end
    end

    % fill structure
    ORstruct.(RMS_L_1) = rms_L_1;
    ORstruct.(RMS_R_1) = rms_R_1;
    ORstruct.(RMS_L_2) = rms_L_2;
    ORstruct.(RMS_R_2) = rms_R_2;
    
    % all_L_1(1) = [];
    % all_R_1(1) = [];
    % all_L_2(1) = [];
    % all_R_2(1) = [];
    % 
    % avg_left_1 = mean(all_L_1);
    % avg_right_1 = mean(all_R_1);
    % avg_left_2 = mean(all_L_2);
    % avg_right_2 = mean(all_R_2);
    %
    % figure (13)
    % hold on
    % set(gca,'xtick',1:2)
    % set(gca,'xticklabel',labels)
    % 
    % swarm = [all_L_1' all_R_1'];
    % count = [ones(size(all_L_1')) 2*ones(size(all_R_1'))];
    % swarmchart(count,swarm,'k');
    % 
    % swarm = [all_L_2' all_R_2'];
    % count = [ones(size(all_L_2')) 2*ones(size(all_R_2'))];
    % swarmchart(count,swarm,'r');
    % 
    % xl = [0.55 1.45];
    % xr = [1.55 2.45];
    %
    % yl = [avg_left_1 avg_left_1];
    % yr = [avg_right_1 avg_right_1];
    % p1 = plot(xl,yl,"k",xr,yr,"k");
    % 
    % yl = [avg_left_2 avg_left_2];
    % yr = [avg_right_2 avg_right_2];
    % p2 = plot(xl,yl,"r",xr,yr,"r");
    % 
    % legend([p1(1) p2(1)],{'Visit 1','Visit 2'})
    % title('Error')
    % ylabel('Deviation from Path (Pixels)')
    % hold off

end