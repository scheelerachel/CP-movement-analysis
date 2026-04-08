% AsteroidBelt2.m
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
% Last Edited 8/4/2025

function [f22,f23,f24,ANstruct] = AsteroidNinja2(movement_path_R,movement_time_R,movement_path_L,movement_time_L,right_hand,left_hand,visit,name,ANstruct)
    
    vel_max_L_1 = nan;
    vel_max_R_1 = nan;
    vel_L_1 = zeros(size(movement_path_L));
    vel_R_1 = zeros(size(movement_path_R));
    std_vel_L_1 = nan;
    std_vel_R_1 = nan;

    vel_max_L_2 = nan;
    vel_max_R_2 = nan;
    vel_L_2 = zeros(size(movement_path_L));
    vel_R_2 = zeros(size(movement_path_R));
    std_vel_L_2 = nan;
    std_vel_R_2 = nan;

    for j=1:length(movement_path_R)

        time_R = movement_time_R{j};
        try
            time_R = time_R-time_R(1); % in ms
        catch
            continue
        end
        
        dtime_R = zeros(size(movement_time_R(j)));
        dist_R = zeros(size(movement_path_R(j)));
        velocity_R = zeros(size(movement_path_R(j))); % preallocate
        
        position_R = cell2mat(movement_path_R(j));
        xr = position_R(:,1);
        yr = position_R(:,2);

        time_L = movement_time_L{j};
        time_L = time_L-time_L(1); % in ms
        
        dtime_L = zeros(size(movement_time_L(j)));
        dist_L = zeros(size(movement_path_L(j)));
        velocity_L = zeros(size(movement_path_L(j))); % preallocate
    
        position_L = cell2mat(movement_path_L(j));
        xl = position_L(:,1);
        yl = position_L(:,2);

        freq = 100;
        t_r = time_R(1):1/freq:time_R(end);
        qry_r = t_r;

        t_l = time_L(1):1/freq:time_L(end);
        qry_l = t_l;

        % Sanity checks
        if length(time_R) ~= length(xr)
            warning('Time and position lengths (R) mismatch at index %d. Skipping.', j);
            continue
        end

        if length(time_L) ~= length(xl)
            warning('Time and position lengths (L) mismatch at index %d. Skipping.', j);
            continue
        end
        
        if range(time_R) == 0
            warning('Zero time range at index %d. Skipping.', j);
            continue
        end
        
        [time_R, ia, ~] = unique(time_R, 'stable');
        xr = xr(ia);
        yr = yr(ia);

        xint_r = interp1(time_R, xr, qry_r, 'linear');
        yint_r = interp1(time_R, yr, qry_r, 'linear');
        %method: 'linear', 'nearest', 'next', 'previous', 'pchip', 'cubic',
        %'v5cubic', 'makima', or 'spline'. The default method is 'linear'.

        smoothxr = smoothdata(xint_r,'gaussian',40);
        smoothyr = smoothdata(yint_r,'gaussian',40);
        % smoothing methods: 'movmean' (default), 'movemedian', 'gaussian',
        % 'lowess', 'loess', 'rlowess', 'rloess', 'sgolay'

        [time_L, ia, ~] = unique(time_L, 'stable');
        xl = xl(ia);
        yl = yl(ia);

        xint_l = interp1(time_L, xl, qry_l, 'linear');
        yint_l = interp1(time_L, yl, qry_l, 'linear');
        %method: 'linear', 'nearest', 'next', 'previous', 'pchip', 'cubic',
        %'v5cubic', 'makima', or 'spline'. The default method is 'linear'.

        smoothxl = smoothdata(xint_l,'gaussian',40);
        smoothyl = smoothdata(yint_l,'gaussian',40);
        % smoothing methods: 'movmean' (default), 'movemedian', 'gaussian',
        % 'lowess', 'loess', 'rlowess', 'rloess', 'sgolay'

        for i=1:length(smoothxr)
            if i~=1
                dtime_R(i) = (t_r(i)-t_r(i-1));
                dist_R(i) = sqrt(((smoothxr(i)-smoothxr(i-1))^2)+((smoothyr(i)-smoothyr(i-1))^2))*(25.4/96);
                velocity_R(i) = dist_R(i)/dtime_R(i);
            else
                dtime_R(i) = 0;
                dist_R(i) = 0;
                velocity_R(i) = 0;
            end
        end

        for i=1:length(smoothxl)
            if i~=1
                dtime_L(i) = (t_l(i)-t_l(i-1));
                dist_L(i) = sqrt(((smoothxl(i)-smoothxl(i-1))^2)+((smoothyl(i)-smoothyl(i-1))^2))*0.096;
                velocity_L(i) = dist_L(i)/dtime_L(i); % mm/sec 
            else
                dtime_L(i) = 0;
                dist_L(i) = 0;
                velocity_L(i) = 0;
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

        [~,locs] = findpeaks(velocity_R);

        velocity_R(locs) = NaN;
        t_r(locs) = NaN;

        velocity_R = fillmissing(velocity_R, 'linear');
        t_r = fillmissing(t_r, 'linear');

        last = length(velocity_R);
        velocity_R(last-3:last) = [];
        t_r(last-3:last) = [];    %#ok<NASGU>

        [~,locs] = findpeaks(velocity_L);

        velocity_L(locs) = NaN;
        t_l(locs) = NaN;

        velocity_L = fillmissing(velocity_L, 'linear');
        t_l = fillmissing(t_l, 'linear');

        last = length(velocity_L);
        velocity_L(last-3:last) = [];
        t_l(last-3:last) = [];    %#ok<NASGU>

        % figure(10)
        % hold on
        % plot(t,velocity);
        % title('Velocity over Time Processed')
        % xlabel('Time (s)')
        % ylabel('Velocity (pixles/s)')
        % %legend(trial)
        % hold off

        if visit(j) == 1
            vel_max_L_1 = cat(1,vel_max_L_1,max(velocity_L));
            vel_L_1 = cat(1,vel_L_1,mean(velocity_L));
            std_vel_L_1 = cat(1,std_vel_L_1,std(velocity_L));
            vel_max_R_1 = cat(1,vel_max_R_1,max(velocity_R));
            vel_R_1 = cat(1,vel_R_1,mean(velocity_R));
            std_vel_R_1 = cat(1,std_vel_R_1,std(velocity_R));
        elseif visit(j) == 2
            vel_max_L_2 = cat(1,vel_max_L_2,max(velocity_L));
            vel_L_2 = cat(1,vel_L_2,mean(velocity_L));
            std_vel_L_2 = cat(1,std_vel_L_2,std(velocity_L));
            vel_max_R_2 = cat(1,vel_max_R_2,max(velocity_R));
            vel_R_2 = cat(1,vel_R_2,mean(velocity_R));
            std_vel_R_2 = cat(1,std_vel_R_2,std(velocity_R));
        else
            fprintf('error 1\n')
        end

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

    f22 = figure(22);
    hold on
    swarm = [vel_L_1, vel_R_1];
    count = categorical([left_hand,right_hand]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [vel_L_2, vel_R_2];
    count = categorical([left_hand,right_hand]);
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

    swarm = [avg_L_1,avg_R_1];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_L_2,avg_R_2];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Ninja: Average Velocity');
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

    f23 = figure(23);
    hold on
    swarm = [std_vel_L_1, std_vel_R_1];
    count = categorical([left_hand,right_hand]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [std_vel_L_2, std_vel_R_2];
    count = categorical([left_hand,right_hand]);
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

    swarm = [std_L_1, std_R_1];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [std_L_2, std_R_2];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'r','_');
    
    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Ninja: Standard Deviation of Velocity');
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

    f24 = figure(24);
    hold on
    swarm = [vel_max_L_1, vel_max_R_1];
    count = categorical([left_hand,right_hand]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [vel_max_L_2, vel_max_R_2];
    count = categorical([left_hand,right_hand]);
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

    swarm = [avg_max_L_1, avg_max_R_1];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_max_L_2, avg_max_R_2];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Ninja: Maximum Velocity');
    title(graphname)
    ylabel('mm/ms')
    hold off

    % determine handedness
    if right_hand == "Dominant"
        avg_vel_R_1 = "avg_vel_dom_1";
        avg_vel_L_1 = "avg_vel_nondom_1";
        avg_vel_R_2 = "avg_vel_dom_2";
        avg_vel_L_2 = "avg_vel_nondom_2";

        st_vel_R_1 = "std_vel_dom_1";
        st_vel_L_1 = "std_vel_nondom_1";
        st_vel_R_2 = "std_vel_dom_2";
        st_vel_L_2 = "std_vel_nondom_2";

        max_vel_R_1 = "max_vel_dom_1";
        max_vel_L_1 = "max_vel_nondom_1";
        max_vel_R_2 = "max_vel_dom_2";
        max_vel_L_2 = "max_vel_nondom_2";

    elseif right_hand == "Non-Dominant"
        avg_vel_L_1 = "avg_vel_dom_1";
        avg_vel_R_1 = "avg_vel_nondom_1";
        avg_vel_L_2 = "avg_vel_dom_2";
        avg_vel_R_2 = "avg_vel_nondom_2";

        st_vel_L_1 = "std_vel_dom_1";
        st_vel_R_1 = "std_vel_nondom_1";
        st_vel_L_2 = "std_vel_dom_2";
        st_vel_R_2 = "std_vel_nondom_2";

        max_vel_L_1 = "max_vel_dom_1";
        max_vel_R_1 = "max_vel_nondom_1";
        max_vel_L_2 = "max_vel_dom_2";
        max_vel_R_2 = "max_vel_nondom_2";

    elseif right_hand == "More Affected"
        avg_vel_L_1 = "avg_vel_less_affected_1";
        avg_vel_R_1 = "avg_vel_more_affected_1";
        avg_vel_L_2 = "avg_vel_less_affected_2";
        avg_vel_R_2 = "avg_vel_more_affected_2";

        st_vel_L_1 = "std_vel_less_affected_1";
        st_vel_R_1 = "std_vel_more_affected_1";
        st_vel_L_2 = "std_vel_less_affected_2";
        st_vel_R_2 = "std_vel_more_affected_2";

        max_vel_L_1 = "max_vel_less_affected_1";
        max_vel_R_1 = "max_vel_more_affected_1";
        max_vel_L_2 = "max_vel_less_affected_2";
        max_vel_R_2 = "max_vel_more_affected_2";

    elseif right_hand == "Less Affected"
        avg_vel_R_1 = "avg_vel_less_affected_1";
        avg_vel_L_1 = "avg_vel_more_affected_1";
        avg_vel_R_2 = "avg_vel_less_affected_2";
        avg_vel_L_2 = "avg_vel_more_affected_2";

        st_vel_R_1 = "std_vel_less_affected_1";
        st_vel_L_1 = "std_vel_more_affected_1";
        st_vel_R_2 = "std_vel_less_affected_2";
        st_vel_L_2 = "std_vel_more_affected_2";

        max_vel_R_1 = "max_vel_less_affected_1";
        max_vel_L_1 = "max_vel_more_affected_1";
        max_vel_R_2 = "max_vel_less_affected_2";
        max_vel_L_2 = "max_vel_more_affected_2";

    end

    % fill structure
    ANstruct.(avg_vel_L_1) = vel_L_1;
    ANstruct.(avg_vel_R_1) = vel_R_1;
    ANstruct.(avg_vel_L_2) = vel_L_2;
    ANstruct.(avg_vel_R_2) = vel_R_2;

    ANstruct.(st_vel_L_1) = std_vel_L_1;
    ANstruct.(st_vel_R_1) = std_vel_R_1;
    ANstruct.(st_vel_L_2) = std_vel_L_2;
    ANstruct.(st_vel_R_2) = std_vel_R_2;

    ANstruct.(max_vel_L_1) = vel_max_L_1;
    ANstruct.(max_vel_R_1) = vel_max_R_1;
    ANstruct.(max_vel_L_2) = vel_max_L_2;
    ANstruct.(max_vel_R_2) = vel_max_R_2;
    
end