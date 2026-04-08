% OrbitalReaching3.m
%
% Function to plot:
% Average Acceleration (5)
% Maximum Difference of Acceleration or Range (6)
% Standard Deviation of Acceleration (7)
% Can also plot but is commented out:
% Frequency Spectrum of Acceleration (11)
% Acceleration over Time (12)
%
% Rachel Scheele
% Last Edited 11/13/2025

function [f15,f16,f17,ORstruct] = OrbitalReaching3(hand,planet,movement_path,movement_time,handedness,visit,name,ORstruct)

    max_acc_L_1 = nan;
    max_acc_R_1 = nan;
    min_acc_L_1 = nan;
    min_acc_R_1 = nan;
    avg_acc_L_1 = zeros(size(hand));
    avg_acc_R_1 = zeros(size(hand));
    std_acc_L_1 = zeros(size(hand));
    std_acc_R_1 = zeros(size(hand));
    
    max_acc_L_2 = nan;
    max_acc_R_2 = nan;
    min_acc_L_2 = nan;
    min_acc_R_2 = nan;
    avg_acc_L_2 = zeros(size(hand));
    avg_acc_R_2 = zeros(size(hand));
    std_acc_L_2 = zeros(size(hand));
    std_acc_R_2 = zeros(size(hand));

    planetplot = zeros(size(hand));
    pp_L_1 = [];
    pp_R_1 = [];
    pp_L_2 = [];
    pp_R_2 = [];
    
    for j=1:length(movement_path)

        time = movement_time{j}; % in ms

        dtime = zeros(size(movement_time(j)));
        dist = zeros(size(movement_path(j)));
        velocity = zeros(size(movement_path(j))); % preallocate

        position = cell2mat(movement_path(j));
        x = position(:,1);
        y = position(:,2);

        freq = 100;
        t = time(1):1/freq:time(end);
        qry = t;

        % Sanity checks
        if length(time) ~= length(x)
            warning('Time and position lengths mismatch at index %d Skipping', j);
            continue
        end
        
        if range(time) == 0
            warning('Zero time range at index %d Skipping', j);
            continue
        end
        
        [time, ia, ~] = unique(time, 'stable');
        x = x(ia);
        y = y(ia);

        xint = interp1(time, x, qry, 'spline');
        yint = interp1(time, y, qry, 'spline');
        %method: 'linear', 'nearest', 'next', 'previous', 'pchip', 'cubic',
        %'v5cubic', 'makima', or 'spline'. The default method is 'linear'.

        smoothx = smoothdata(xint,'gaussian',40);
        smoothy = smoothdata(yint,'gaussian',40);
        % smoothing methods: 'movmean' (default), 'movemedian', 'gaussian',
        % 'lowess', 'loess', 'rlowess', 'rloess', 'sgolay'

        for i=1:length(smoothx)
            if i~=1
                dtime(i) = (t(i)-t(i-1));
                dist(i) = sqrt(((smoothx(i)-smoothx(i-1))^2)+((smoothy(i)-smoothy(i-1))^2))*(127/660);
                velocity(i) = dist(i)/dtime(i); % mm/sec
            else
                dtime(i) = 0;
                dist(i) = 0;
                velocity(i) = 0;
            end
        end
      
        clear dtime;
        dtime = zeros(size(movement_time(j)));
        dvelocity = zeros(size(movement_time(j)));
        acceleration = zeros(size(movement_path(j)));
        velocity = velocity';
        
        for i=1:length(velocity)
            if i~=1
                dtime(i) = (t(i)-t(i-1));
                dvelocity(i) = velocity(i)-velocity(i-1);
                acceleration(i) = dvelocity(i)/dtime(i); % pixels/sec^2 
            else
                dtime(i) = 0;
                dvelocity(i) = 0;
                acceleration(i) = 0;
            end
        end

        % % evaluate frequency spectrum
        % Y = fft(acceleration);
        % 
        % figure(11)
        % hold on
        % plot(freq/t(end)*t,abs(Y))
        % title("Complex Magnitude of fft Spectrum")
        % xlabel("f (Hz)")
        % ylabel("|fft(X)|")
        % hold off

        [~,locs] = findpeaks(acceleration);

        acceleration(locs) = NaN;
        t(locs) = NaN;

        acceleration = fillmissing(acceleration, 'linear');
        t = fillmissing(t, 'linear');

        last = length(acceleration);
        acceleration(last-3:last) = []; % no matter how many points are removed still ends in spike?
        t(last-3:last) = []; %#ok<NASGU>

        % figure(12)
        % hold on
        % plot(t,acceleration);
        % title('Velocity over Time Processed')
        % xlabel('Time (s)')
        % ylabel('Velocity (pixles/s)')
        % %legend(trial)
        % hold off

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

        if visit(j) == 1
            if isequal(hand{j},'Left')
                max_acc_L_1 = cat(1,max_acc_L_1,max(acceleration));
                min_acc_L_1 = cat(1,min_acc_L_1,min(acceleration));
                avg_acc_L_1 = cat(1,avg_acc_L_1,mean(acceleration));
                std_acc_L_1 = cat(1,std_acc_L_1,std(acceleration));
                pp_L_1 = cat(1,pp_L_1,planetplot(j));
            elseif isequal(hand{j},'Right')
                max_acc_R_1 = cat(1,max_acc_R_1,max(acceleration));
                min_acc_R_1 = cat(1,min_acc_R_1,min(acceleration));
                avg_acc_R_1 = cat(1,avg_acc_R_1,mean(acceleration));
                std_acc_R_1 = cat(1,std_acc_R_1,std(acceleration));
                pp_R_1 = cat(1,pp_R_1,planetplot(j));
            else
                fprintf('error 3\n');
            end
        elseif visit(j) == 2
            if isequal(hand{j},'Left')
                max_acc_L_2 = cat(1,max_acc_L_2,max(acceleration));
                min_acc_L_2 = cat(1,min_acc_L_2,min(acceleration));
                avg_acc_L_2 = cat(1,avg_acc_L_2,mean(acceleration));
                std_acc_L_2 = cat(1,std_acc_L_2,std(acceleration));
                pp_L_2 = cat(1,pp_L_2,planetplot(j));
            elseif isequal(hand{j},'Right')
                max_acc_R_2 = cat(1,max_acc_R_2,max(acceleration));
                min_acc_R_2 = cat(1,min_acc_R_2,min(acceleration));
                avg_acc_R_2 = cat(1,avg_acc_R_2,mean(acceleration));
                std_acc_R_2 = cat(1,std_acc_R_2,std(acceleration));
                pp_R_2 = cat(1,pp_R_2,planetplot(j));
            else
                fprintf('error 3\n');
            end
        else
            fprintf('error 3\n');
        end

    end

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

    % remove when acceleration = 0
    avg_acc_L_1 = avg_acc_L_1(avg_acc_L_1~=0);
    avg_acc_R_1 = avg_acc_R_1(avg_acc_R_1~=0);
    avg_acc_L_2 = avg_acc_L_2(avg_acc_L_2~=0);
    avg_acc_R_2 = avg_acc_R_2(avg_acc_R_2~=0);

    avg_L_1 = mean(avg_acc_L_1);
    avg_R_1 = mean(avg_acc_R_1);
    avg_L_2 = mean(avg_acc_L_2);
    avg_R_2 = mean(avg_acc_R_2);

    f15 = figure(15);
    hold on
    swarm = [avg_acc_L_1; avg_acc_R_1];
    count = categorical([repmat(l,length(avg_acc_L_1),1);repmat(r,length(avg_acc_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [avg_acc_L_2; avg_acc_R_2];
    count = categorical([repmat(l,length(avg_acc_L_2),1);repmat(r,length(avg_acc_R_2),1)]);
    s2 = swarmchart(count,swarm,'r');
    
    % Jitter strength (tweak as needed)
    xjitter_strength = 0.075;

    for i = 1:length(avg_acc_L_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(i)) + xjitter, s1.YData(i), num2str(pp_L_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    offset = length(avg_acc_L_1); % index offset for right hand
    for i = 1:length(avg_acc_R_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(offset + i)) + xjitter, s1.YData(offset + i), num2str(pp_R_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    for i = 1:length(avg_acc_L_2)
        xjitter = xjitter_strength * randn();
        text(double(s2.XData(i)) + xjitter, s2.YData(i), num2str(pp_L_2(i)), ...
            'HorizontalAlignment','center', 'Color','r', 'FontSize', 8);
    end
    
    offset = length(avg_acc_L_2); % index offset for right hand
    for i = 1:length(avg_acc_R_2)
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

    set(gca,'fontsize',14)

    swarm = [avg_L_1; avg_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    p1 = swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_L_2; avg_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    p2 = swarmchart(count,swarm,7500,'r','_');

    legend([p1(1) p2(1)],{'Visit 1','Visit 2'})
    graphname = append(name,' ','Orbital Reaching: Average Acceleration');
    title(graphname)
    ylabel('mm/ms^2')

    s1.Marker = 'none';
    s2.Marker = 'none';
    hold off

    % remove when  max velocity is NaN
    % vel_max_L = vel_max_L(vel_max_L~=0);
    % vel_max_R = vel_max_R(vel_max_R~=0); % to remove when it's 0
    diff_L_1 = max_acc_L_1-min_acc_L_1;
    diff_R_1 = max_acc_R_1-min_acc_R_1;
    diff_L_2 = max_acc_L_2-min_acc_L_2;
    diff_R_2 = max_acc_R_2-min_acc_R_2;

    diff_L_1 = diff_L_1(~isnan(diff_L_1));
    diff_R_1 = diff_R_1(~isnan(diff_R_1));
    diff_L_2 = diff_L_2(~isnan(diff_L_2));
    diff_R_2 = diff_R_2(~isnan(diff_R_2));

    avg_diff_L_1 = mean(diff_L_1);
    avg_diff_R_1 = mean(diff_R_1);
    avg_diff_L_2 = mean(diff_L_2);
    avg_diff_R_2 = mean(diff_R_2);

    f16 = figure(16);
    hold on
    swarm = [diff_L_1; diff_R_1];
    count = categorical([repmat(l,length(diff_L_1),1);repmat(r,length(diff_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [diff_L_2; diff_R_2];
    count = categorical([repmat(l,length(diff_L_2),1);repmat(r,length(diff_R_2),1)]);
    s2 = swarmchart(count,swarm,'r');

    % Jitter strength (tweak as needed)
    xjitter_strength = 0.075;

    for i = 1:length(diff_L_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(i)) + xjitter, s1.YData(i), num2str(pp_L_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    offset = length(diff_L_1); % index offset for right hand
    for i = 1:length(diff_R_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(offset + i)) + xjitter, s1.YData(offset + i), num2str(pp_R_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    for i = 1:length(diff_L_2)
        xjitter = xjitter_strength * randn();
        text(double(s2.XData(i)) + xjitter, s2.YData(i), num2str(pp_L_2(i)), ...
            'HorizontalAlignment','center', 'Color','r', 'FontSize', 8);
    end
    
    offset = length(diff_L_2); % index offset for right hand
    for i = 1:length(diff_R_2)
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

    set(gca,'fontsize',14)

    swarm = [avg_diff_L_1; avg_diff_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    p1 = swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_diff_L_2; avg_diff_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    p2 = swarmchart(count,swarm,7500,'r','_');

    legend([p1(1) p2(1)],{'Visit 1','Visit 2'})
    graphname = append(name,' ','Orbital Reaching: Maximum Difference of Acceleration (Range)');
    title(graphname)
    ylabel('mm/ms^2')

    s1.Marker = 'none';
    s2.Marker = 'none';
    hold off

    % remove std = 0 and calculate average
    std_acc_L_1 = std_acc_L_1(std_acc_L_1~=0);
    std_acc_R_1 = std_acc_R_1(std_acc_R_1~=0);
    std_acc_L_2 = std_acc_L_2(std_acc_L_2~=0);
    std_acc_R_2 = std_acc_R_2(std_acc_R_2~=0);

    std_L_1 = mean(std_acc_L_1);
    std_R_1 = mean(std_acc_R_1);
    std_L_2 = mean(std_acc_L_2);
    std_R_2 = mean(std_acc_R_2);

    f17 = figure(17);
    hold on
    swarm = [std_acc_L_1; std_acc_R_1];
    count = categorical([repmat(l,length(std_acc_L_1),1);repmat(r,length(std_acc_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [std_acc_L_2; std_acc_R_2];
    count = categorical([repmat(l,length(std_acc_L_2),1);repmat(r,length(std_acc_R_2),1)]);
    s2 = swarmchart(count,swarm,'r');

    % Jitter strength (tweak as needed)
    xjitter_strength = 0.075;

    for i = 1:length(std_acc_L_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(i)) + xjitter, s1.YData(i), num2str(pp_L_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    offset = length(std_acc_L_1); % index offset for right hand
    for i = 1:length(std_acc_R_1)
        xjitter = xjitter_strength * randn();
        text(double(s1.XData(offset + i)) + xjitter, s1.YData(offset + i), num2str(pp_R_1(i)), ...
            'HorizontalAlignment','center', 'Color','k', 'FontSize', 8);
    end
    
    for i = 1:length(std_acc_L_2)
        xjitter = xjitter_strength * randn();
        text(double(s2.XData(i)) + xjitter, s2.YData(i), num2str(pp_L_2(i)), ...
            'HorizontalAlignment','center', 'Color','r', 'FontSize', 8);
    end
    
    offset = length(std_acc_L_2); % index offset for right hand
    for i = 1:length(std_acc_R_2)
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

    set(gca,'fontsize',14)

    swarm = [std_L_1; std_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    p1 = swarmchart(count,swarm,7500,'k','_');

    swarm = [std_L_2; std_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    p2 = swarmchart(count,swarm,7500,'r','_');

    legend([p1(1) p2(1)],{'Visit 1','Visit 2'})
    graphname = append(name,' ','Orbital Reaching: Standard Deviation of Acceleration');
    title(graphname)
    ylabel('mm/ms^2')

    s1.Marker = 'none';
    s2.Marker = 'none';
    hold off

    % determine handedness
    ind = find(handedness == "Dominant" | handedness == "More Affected",1);
    if handedness(ind) == "Dominant"
        if hand(ind) == "Left"
            acc_L_1 = "avg_acc_dom_1";
            acc_L_2 = "avg_acc_dom_2";
            acc_R_1 = "avg_acc_nondom_1";
            acc_R_2 = "avg_acc_nondom_2";

            st_acc_L_1 = "std_acc_dom_1";
            st_acc_L_2 = "std_acc_dom_2";
            st_acc_R_1 = "std_acc_nondom_1";
            st_acc_R_2 = "std_acc_nondom_2";

            diff_acc_L_1 = "diff_acc_dom_1";
            diff_acc_L_2 = "diff_acc_dom_2";
            diff_acc_R_1 = "diff_acc_nondom_1";
            diff_acc_R_2 = "diff_acc_nondom_2";

        elseif hand(ind) == "Right"
            acc_R_1 = "avg_acc_dom_1";
            acc_R_2 = "avg_acc_dom_2";
            acc_L_1 = "avg_acc_nondom_1";
            acc_L_2 = "avg_acc_nondom_2";

            st_acc_R_1 = "std_acc_dom_1";
            st_acc_R_2 = "std_acc_dom_2";
            st_acc_L_1 = "std_acc_nondom_1";
            st_acc_L_2 = "std_acc_nondom_2";

            diff_acc_R_1 = "diff_acc_dom_1";
            diff_acc_R_2 = "diff_acc_dom_2";
            diff_acc_L_1 = "diff_acc_nondom_1";
            diff_acc_L_2 = "diff_acc_nondom_2";
        end

    elseif handedness(ind) == "More Affected"
        if hand(ind) == "Left"
            acc_L_1 = "avg_acc_more_aff_1";
            acc_L_2 = "avg_acc_more_aff_2";
            acc_R_1 = "avg_acc_less_aff_1";
            acc_R_2 = "avg_acc_less_aff_2";

            st_acc_L_1 = "std_acc_more_aff_1";
            st_acc_L_2 = "std_acc_more_aff_2";
            st_acc_R_1 = "std_acc_less_aff_1";
            st_acc_R_2 = "std_acc_less_aff_2";

            diff_acc_L_1 = "diff_acc_more_aff_1";
            diff_acc_L_2 = "diff_acc_more_aff_2";
            diff_acc_R_1 = "diff_acc_less_aff_1";
            diff_acc_R_2 = "diff_acc_less_aff_2";

        elseif hand(ind) == "Right"
            acc_L_1 = "avg_acc_more_aff_1";
            acc_L_2 = "avg_acc_more_aff_2";
            acc_R_1 = "avg_acc_less_aff_1";
            acc_R_2 = "avg_acc_less_aff_2";

            st_acc_L_1 = "std_acc_more_aff_1";
            st_acc_L_2 = "std_acc_more_aff_2";
            st_acc_R_1 = "std_acc_less_aff_1";
            st_acc_R_2 = "std_acc_less_aff_2";

            diff_acc_L_1 = "diff_acc_more_aff_1";
            diff_acc_L_2 = "diff_acc_more_aff_2";
            diff_acc_R_1 = "diff_acc_less_aff_1";
            diff_acc_R_2 = "diff_acc_less_aff_2";
        end
    end

    % fill structure
    ORstruct.(acc_L_1) = avg_acc_L_1;
    ORstruct.(acc_R_1) = avg_acc_R_1;
    ORstruct.(acc_L_2) = avg_acc_L_2;
    ORstruct.(acc_R_2) = avg_acc_R_2;

    ORstruct.(st_acc_L_1) = std_acc_L_1;
    ORstruct.(st_acc_R_1) = std_acc_R_1;
    ORstruct.(st_acc_L_2) = std_acc_L_2;
    ORstruct.(st_acc_R_2) = std_acc_R_2;

    ORstruct.(diff_acc_L_1) = diff_L_1;
    ORstruct.(diff_acc_R_1) = diff_R_1;
    ORstruct.(diff_acc_L_2) = diff_L_2;
    ORstruct.(diff_acc_R_2) = diff_R_2;
    
end