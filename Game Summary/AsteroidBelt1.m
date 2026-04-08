% AsteroidBelt1.m
%
% Function to plot:
% Average Velocity (1)
% Standard Deviation of Velocity (2)
% Maximum Velocity (3)
% Can also plot but is commented out:
% Frequency Spectrum of Velocity (9)
% Velocity over Time (10)
%
% Rachel Scheele
% Last Edited 11/13/2025

function [f1,f2,f3,ABstruct] = AsteroidBelt1(movement_path,movement_time,hand,handedness,visit,name,ABstruct)
    
    vel_max_L_1 = nan;
    vel_max_R_1 = nan;
    vel_L_1 = zeros(size(hand));
    vel_R_1 = zeros(size(hand));
    std_vel_L_1 = nan;
    std_vel_R_1 = nan;

    vel_max_L_2 = nan;
    vel_max_R_2 = nan;
    vel_L_2 = zeros(size(hand));
    vel_R_2 = zeros(size(hand));
    std_vel_L_2 = nan;
    std_vel_R_2 = nan;

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
            warning('Time and position lengths mismatch at index %d. Skipping.', j);
            continue
        end
        
        if range(time) == 0
            warning('Zero time range at index %d. Skipping.', j);
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
                velocity(i) = dist(i)/dtime(i); % mm/sec ???
            else
                dtime(i) = 0;
                dist(i) = 0;
                velocity(i) = 0;
            end
        end

        % % evaluate frequency spectrum
        % Y = fft(velocity);
        % 
        % figure(9)
        % hold on
        % plot(freq/t(end)*t,abs(Y))
        % title("Complex Magnitude of fft Spectrum")
        % xlabel("f (Hz)")
        % ylabel("|fft(X)|")
        % hold off

        [~,locs] = findpeaks(velocity);

        velocity(locs) = NaN;
        t(locs) = NaN;

        velocity = fillmissing(velocity, 'linear');
        t = fillmissing(t, 'linear');

        last = length(velocity);
        velocity(last-3:last) = [];
        t(last-3:last) = [];    %#ok<NASGU>

        % figure(10)
        % hold on
        % plot(t,velocity);
        % title('Velocity over Time Processed')
        % xlabel('Time (s)')
        % ylabel('Velocity (pixles/s)')
        % %legend(trial)
        % hold off

        if visit(j) == 1
            if isequal(hand{j},'Left')
                vel_max_L_1 = cat(1,vel_max_L_1,max(velocity));
                vel_L_1 = cat(1,vel_L_1,mean(velocity));
                std_vel_L_1 = cat(1,std_vel_L_1,std(velocity));
            elseif isequal(hand{j},'Right')
                vel_max_R_1 = cat(1,vel_max_R_1,max(velocity));
                vel_R_1 = cat(1,vel_R_1,mean(velocity));
                std_vel_R_1 = cat(1,std_vel_R_1,std(velocity));
            else
                fprintf('error 1\n');
            end
        elseif visit(j) == 2
            if isequal(hand{j},'Left')
                vel_max_L_2 = cat(1,vel_max_L_2,max(velocity));
                vel_L_2 = cat(1,vel_L_2,mean(velocity));
                std_vel_L_2 = cat(1,std_vel_L_2,std(velocity));
            elseif isequal(hand{j},'Right')
                vel_max_R_2 = cat(1,vel_max_R_2,max(velocity));
                vel_R_2 = cat(1,vel_R_2,mean(velocity));
                std_vel_R_2 = cat(1,std_vel_R_2,std(velocity));
            else
                fprintf('error 1\n');
            end
        else
            fprintf('error 1\n')
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

    % remove when velocity = 0 from velocity L being zero in R trial
    vel_L_1 = vel_L_1(vel_L_1~=0);
    vel_R_1 = vel_R_1(vel_R_1~=0);
    vel_L_2 = vel_L_2(vel_L_2~=0);
    vel_R_2 = vel_R_2(vel_R_2~=0);

    avg_L_1 = mean(vel_L_1);
    avg_R_1 = mean(vel_R_1);
    avg_L_2 = mean(vel_L_2);
    avg_R_2 = mean(vel_R_2);

    f1 = figure(1);
    hold on
    swarm = [vel_L_1; vel_R_1];
    count = categorical([repmat(l,length(vel_L_1),1);repmat(r,length(vel_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [vel_L_2; vel_R_2];
    count = categorical([repmat(l,length(vel_L_2),1);repmat(r,length(vel_R_2),1)]);
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

    swarm = [avg_L_1;avg_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_L_2;avg_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Belt: Average Velocity');
    title(graphname)
    ylabel('mm/ms')
    hold off

    % remove when  max velocity is NaN
    std_vel_L_1 = std_vel_L_1(~isnan(std_vel_L_1));
    std_vel_L_2 = std_vel_L_2(~isnan(std_vel_L_2));
    std_vel_R_1 = std_vel_R_1(~isnan(std_vel_R_1));
    std_vel_R_2 = std_vel_R_2(~isnan(std_vel_R_2));

    % Calculate average standard deviation
    std_L_1 = mean(std_vel_L_1);
    std_L_2 = mean(std_vel_L_2);
    std_R_1 = mean(std_vel_R_1);
    std_R_2 = mean(std_vel_R_2);

    f2 = figure(2);
    hold on
    swarm = [std_vel_L_1; std_vel_R_1];
    count = categorical([repmat(l,length(std_vel_L_1),1);repmat(r,length(std_vel_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [std_vel_L_2; std_vel_R_2];
    count = categorical([repmat(l,length(std_vel_L_2),1);repmat(r,length(std_vel_R_2),1)]);
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

    swarm = [std_L_1; std_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [std_L_2; std_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'r','_');
    
    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Belt: Standard Deviation of Velocity');
    title(graphname)
    ylabel('mm/ms')
    hold off

    % remove when  max velocity is NaN
    % vel_max_L = vel_max_L(vel_max_L~=0);
    % vel_max_R = vel_max_R(vel_max_R~=0); % to remove when it's 0
    vel_max_L_1 = vel_max_L_1(~isnan(vel_max_L_1));
    vel_max_R_1 = vel_max_R_1(~isnan(vel_max_R_1));
    vel_max_L_2 = vel_max_L_2(~isnan(vel_max_L_2));
    vel_max_R_2 = vel_max_R_2(~isnan(vel_max_R_2));

    avg_max_L_1 = mean(vel_max_L_1);
    avg_max_R_1 = mean(vel_max_R_1);
    avg_max_L_2 = mean(vel_max_L_2);
    avg_max_R_2 = mean(vel_max_R_2);

    f3 = figure(3);
    hold on
    swarm = [vel_max_L_1; vel_max_R_1];
    count = categorical([repmat(l,length(vel_max_L_1),1);repmat(r,length(vel_max_R_1),1)]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [vel_max_L_2; vel_max_R_2];
    count = categorical([repmat(l,length(vel_max_L_2),1);repmat(r,length(vel_max_R_2),1)]);
    s2 = swarmchart(count, swarm, 'r');
    
    for i = 1:numel(s1)
        s1(i).XJitter = 'randn';
        s1(i).XJitterWidth = 0.3;
    end
    
    for i = 1:numel(s2)
        s2(i).XJitter = 'randn';
        s2(i).XJitterWidth = 0.3;
    end

    set(gca,'fontsize',14)

    swarm = [avg_max_L_1; avg_max_R_1];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_max_L_2;avg_max_R_2];
    count = categorical([repmat(l,1,1);repmat(r,1,1)]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Belt: Maximum Velocity');
    title(graphname)
    ylabel('mm/ms')
    hold off
    
    % determine handedness
    ind = find(handedness == "Dominant" | handedness == "More Affected",1);
    if handedness(ind) == "Dominant"
        if hand(ind) == "Left"
            avg_vel_L_1 = "avg_vel_dom_1";
            avg_vel_L_2 = "avg_vel_dom_2";
            avg_vel_R_1 = "avg_vel_nondom_1";
            avg_vel_R_2 = "avg_vel_nondom_2";

            st_vel_L_1 = "std_vel_dom_1";
            st_vel_L_2 = "std_vel_dom_2";
            st_vel_R_1 = "std_vel_nondom_1";
            st_vel_R_2 = "std_vel_nondom_2";

            max_vel_L_1 = "max_vel_dom_1";
            max_vel_L_2 = "max_vel_dom_2";
            max_vel_R_1 = "max_vel_nondom_1";
            max_vel_R_2 = "max_vel_nondom_2";

        elseif hand(ind) == "Right"
            avg_vel_R_1 = "avg_vel_dom_1";
            avg_vel_R_2 = "avg_vel_dom_2";
            avg_vel_L_1 = "avg_vel_nondom_1";
            avg_vel_L_2 = "avg_vel_nondom_2";

            st_vel_R_1 = "std_vel_dom_1";
            st_vel_R_2 = "std_vel_dom_2";
            st_vel_L_1 = "std_vel_nondom_1";
            st_vel_L_2 = "std_vel_nondom_2";

            max_vel_R_1 = "max_vel_dom_1";
            max_vel_R_2 = "max_vel_dom_2";
            max_vel_L_1 = "max_vel_nondom_1";
            max_vel_L_2 = "max_vel_nondom_2";
        end

    elseif handedness(ind) == "More Affected"
        if hand(ind) == "Left"
            avg_vel_L_1 = "avg_vel_more_aff_1";
            avg_vel_L_2 = "avg_vel_more_aff_2";
            avg_vel_R_1 = "avg_vel_less_aff_1";
            avg_vel_R_2 = "avg_vel_less_aff_2";

            st_vel_L_1 = "std_vel_more_aff_1";
            st_vel_L_2 = "std_vel_more_aff_2";
            st_vel_R_1 = "std_vel_less_aff_1";
            st_vel_R_2 = "std_vel_less_aff_2";

            max_vel_L_1 = "max_vel_more_aff_1";
            max_vel_L_2 = "max_vel_more_aff_2";
            max_vel_R_1 = "max_vel_less_aff_1";
            max_vel_R_2 = "max_vel_less_aff_2";

        elseif hand(ind) == "Right"
            avg_vel_L_1 = "avg_vel_more_aff_1";
            avg_vel_L_2 = "avg_vel_more_aff_2";
            avg_vel_R_1 = "avg_vel_less_aff_1";
            avg_vel_R_2 = "avg_vel_less_aff_2";

            st_vel_L_1 = "std_vel_more_aff_1";
            st_vel_L_2 = "std_vel_more_aff_2";
            st_vel_R_1 = "std_vel_less_aff_1";
            st_vel_R_2 = "std_vel_less_aff_2";

            max_vel_L_1 = "max_vel_more_aff_1";
            max_vel_L_2 = "max_vel_more_aff_2";
            max_vel_R_1 = "max_vel_less_aff_1";
            max_vel_R_2 = "max_vel_less_aff_2";
        end
    end

    % fill structure
    ABstruct.(avg_vel_L_1) = vel_L_1;
    ABstruct.(avg_vel_R_1) = vel_R_1;
    ABstruct.(avg_vel_L_2) = vel_L_2;
    ABstruct.(avg_vel_R_2) = vel_R_2;

    ABstruct.(st_vel_L_1) = std_vel_L_1;
    ABstruct.(st_vel_R_1) = std_vel_R_1;
    ABstruct.(st_vel_L_2) = std_vel_L_2;
    ABstruct.(st_vel_R_2) = std_vel_R_2;

    ABstruct.(max_vel_L_1) = vel_max_L_1;
    ABstruct.(max_vel_R_1) = vel_max_R_1;
    ABstruct.(max_vel_L_2) = vel_max_L_2;
    ABstruct.(max_vel_R_2) = vel_max_R_2;

end