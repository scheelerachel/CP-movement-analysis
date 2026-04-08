% AsteroidNinja3.m
%
% Function to plot:
% Average Acceleration (4)
% Maximum Difference of Acceleration or Range (5)
% Standard Deviation of Acceleration (6)
% Can also plot but is commented out:
% Frequency Spectrum of Acceleration (9)
% Acceleration over Time (10)
%
% Rachel Scheele
% Last Edited 8/4/2025

function [f25,f26,f27,ANstruct] = AsteroidNinja3(movement_path_R,movement_time_R,movement_path_L,movement_time_L,right_hand,left_hand,visit,name,ANstruct)
    
    acc_max_L_1 = nan;
    acc_min_L_1 = nan;
    acc_std_L_1 = nan;
    acc_avg_L_1 = nan;
    acc_max_R_1 = nan;
    acc_min_R_1 = nan;
    acc_std_R_1 = nan;
    acc_avg_R_1 = nan;

    acc_max_L_2 = nan;
    acc_min_L_2 = nan;
    acc_std_L_2 = nan;
    acc_avg_L_2 = nan;
    acc_max_R_2 = nan;
    acc_min_R_2 = nan;
    acc_std_R_2 = nan;
    acc_avg_R_2 = nan;

    for j=1:length(movement_path_R)

        time_R = movement_time_R{j};
        try
            time_R = time_R-time_R(1); % in ms
        catch
            continue
        end
        
        time_R = time_R-time_R(1); % in ss
        
        dtime_R = zeros(size(movement_time_R(j)));
        dist_R = zeros(size(movement_path_R(j)));
        velocity_R = zeros(size(movement_path_R(j))); % preallocate
    
        position_R = cell2mat(movement_path_R(j));
        xr = position_R(:,1);
        yr = position_R(:,2);

        time_L = movement_time_L{j};
        time_L = time_L-time_L(1); % in ss
        
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
                velocity_R(i) = dist_R(i)/dtime_R(i); % pixels/sec ???I think???
            else
                dtime_R(i) = 0;
                dist_R(i) = 0;
                velocity_R(i) = 0;
            end
        end

        for i=1:length(smoothxl)
            if i~=1
                dtime_L(i) = (t_l(i)-t_l(i-1));
                dist_L(i) = sqrt(((smoothxl(i)-smoothxl(i-1))^2)+((smoothyl(i)-smoothyl(i-1))^2))*(25.4/96);
                velocity_L(i) = dist_L(i)/dtime_L(i);
            else
                dtime_L(i) = 0;
                dist_L(i) = 0;
                velocity_L(i) = 0;
            end
        end

        clear dtime_R;
        dtime_R = zeros(size(movement_time_R(j)));
        dvelocity_R = zeros(size(movement_time_R(j)));
        acceleration_R = zeros(size(movement_path_R(j)));
        velocity_R = velocity_R';
        
        for i=1:length(velocity_R)
            if i~=1
                dtime_R(i) = (t_r(i)-t_r(i-1));
                dvelocity_R(i) = velocity_R(i)-velocity_R(i-1);
                acceleration_R(i) = dvelocity_R(i)/dtime_R(i); % mm/sec^2 
            else
                dtime_R(i) = 0;
                dvelocity_R(i) = 0;
                acceleration_R(i) = 0;
            end
        end

        clear dtime_L;
        dtime_L = zeros(size(movement_time_L(j)));
        dvelocity_L = zeros(size(movement_time_L(j)));
        acceleration_L = zeros(size(movement_path_L(j)));
        velocity_L = velocity_L';
        
        for i=1:length(velocity_L)
            if i~=1
                dtime_L(i) = (t_l(i)-t_l(i-1));
                dvelocity_L(i) = velocity_L(i)-velocity_L(i-1);
                acceleration_L(i) = dvelocity_L(i)/dtime_L(i);
            else
                dtime_L(i) = 0;
                dvelocity_L(i) = 0;
                acceleration_L(i) = 0;
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

        [~,locs] = findpeaks(acceleration_R);

        acceleration_R(locs) = NaN;
        t_r(locs) = NaN;

        acceleration_R = fillmissing(acceleration_R, 'linear');
        t_r = fillmissing(t_r, 'linear');

        last = length(acceleration_R);
        acceleration_R(last-3:last) = [];
        t_r(last-3:last) = [];    %#ok<NASGU>

        [~,locs] = findpeaks(acceleration_L);

        acceleration_L(locs) = NaN;
        t_l(locs) = NaN;

        acceleration_L = fillmissing(acceleration_L, 'linear');
        t_l = fillmissing(t_l, 'linear');

        last = length(acceleration_L);
        acceleration_L(last-3:last) = [];
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
            acc_max_L_1 = cat(1,acc_max_L_1,max(acceleration_L));
            acc_min_L_1 = cat(1,acc_min_L_1,min(acceleration_L));
            acc_std_L_1 = cat(1,acc_std_L_1,std(acceleration_L));
            acc_avg_L_1 = cat(1,acc_avg_L_1,mean(acceleration_L));
            acc_max_R_1 = cat(1,acc_max_R_1,max(acceleration_L));
            acc_min_R_1 = cat(1,acc_min_R_1,min(acceleration_L));
            acc_std_R_1 = cat(1,acc_std_R_1,std(acceleration_L));
            acc_avg_R_1 = cat(1,acc_avg_R_1,mean(acceleration_L));
        elseif visit(j) == 2
            acc_max_L_2 = cat(1,acc_max_L_2,max(acceleration_L));
            acc_min_L_2 = cat(1,acc_min_L_2,min(acceleration_L));
            acc_std_L_2 = cat(1,acc_std_L_2,std(acceleration_L));
            acc_avg_L_2 = cat(1,acc_avg_L_2,mean(acceleration_L));
            acc_max_R_2 = cat(1,acc_max_R_2,max(acceleration_L));
            acc_min_R_2 = cat(1,acc_min_R_2,min(acceleration_L));
            acc_std_R_2 = cat(1,acc_std_R_2,std(acceleration_L));
            acc_avg_R_2 = cat(1,acc_avg_R_2,mean(acceleration_L));
        else
            fprintf('error 1\n')
        end

    end
    
    % remove when velocity = 0 from velocity L being zero in R trial
    acc_avg_L_1 = acc_avg_L_1(acc_avg_L_1~=0);
    acc_avg_R_1 = acc_avg_R_1(acc_avg_R_1~=0);
    acc_avg_L_2 = acc_avg_L_2(acc_avg_L_2~=0);
    acc_avg_R_2 = acc_avg_R_2(acc_avg_R_2~=0);

    avg_L_1 = mean(acc_avg_L_1);
    avg_R_1 = mean(acc_avg_R_1);
    avg_L_2 = mean(acc_avg_L_2);
    avg_R_2 = mean(acc_avg_R_2);

    f25 = figure(25);
    hold on
    swarm = [acc_avg_L_1, acc_avg_R_1];
    count = categorical([left_hand,right_hand]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [acc_avg_L_2, acc_avg_R_2];
    count = categorical([left_hand,right_hand]);
    s2 = swarmchart(count,swarm,'k');

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
    graphname = append(name, ' ','Asteroid Ninja: Average Acceleration');
    title(graphname)
    ylabel('mm/ms^2')
    hold off

    % remove when acceleration is NaN
    diff_L_1 = acc_max_L_1-acc_min_L_1;
    diff_R_1 = acc_max_R_1-acc_min_R_1;
    diff_L_2 = acc_max_L_2-acc_min_L_2;
    diff_R_2 = acc_max_R_2-acc_min_R_2;

    diff_L_1 = diff_L_1(~isnan(diff_L_1));
    diff_R_1 = diff_R_1(~isnan(diff_R_1));
    diff_L_2 = diff_L_2(~isnan(diff_L_2));
    diff_R_2 = diff_R_2(~isnan(diff_R_2));

    avg_diff_L_1 = mean(diff_L_1);
    avg_diff_R_1 = mean(diff_R_1);
    avg_diff_L_2 = mean(diff_L_2);
    avg_diff_R_2 = mean(diff_R_2);

    f26 = figure(26);
    hold on
    swarm = [diff_L_1, diff_R_1];
    count = categorical([left_hand,right_hand]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [diff_L_2, diff_R_2];
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

    swarm = [avg_diff_L_1, avg_diff_R_1];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [avg_diff_L_2, avg_diff_R_2];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'r','_');
    
    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Ninja: Maximum Difference of Acceleration (Range)');
    title(graphname)
    ylabel('mm/ms^2')
    hold off

    % remove when  max velocity is NaN
    % vel_max_L = vel_max_L(vel_max_L~=0);
    % vel_max_R = vel_max_R(vel_max_R~=0); % to remove when it's 0

    acc_std_L_1 = acc_std_L_1(acc_std_L_1~=0);
    acc_std_R_1 = acc_std_R_1(acc_std_R_1~=0);
    acc_std_L_2 = acc_std_L_2(acc_std_L_2~=0);
    acc_std_R_2 = acc_std_R_2(acc_std_R_2~=0);

    std_L_1 = mean(acc_std_L_1);
    std_R_1 = mean(acc_std_R_1);
    std_L_2 = mean(acc_std_L_2);
    std_R_2 = mean(acc_std_R_2);

    f27 = figure(27);
    hold on
    swarm = [acc_std_L_1, acc_std_R_1];
    count = categorical([left_hand,right_hand]);
    s1 = swarmchart(count,swarm,'k');

    swarm = [acc_std_L_2, acc_std_R_2];
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

    swarm = [std_L_1, std_R_1];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'k','_');

    swarm = [std_L_2, std_R_2];
    count = categorical([left_hand,right_hand]);
    swarmchart(count,swarm,7500,'r','_');

    legend([s1(1) s2(1)],{'Visit 1','Visit 2'})
    graphname = append(name, ' ','Asteroid Ninja: Standard Deviation of Acceleration');
    title(graphname)
    ylabel('mm/ms^2')
    hold off

    % determine handedness
    if right_hand == "Dominant"
        acc_R_1 = "avg_acc_dom_1";
        acc_L_1 = "avg_acc_nondom_1";
        acc_R_2 = "avg_acc_dom_2";
        acc_L_2 = "avg_acc_nondom_2";

        st_acc_R_1 = "std_acc_dom_1";
        st_acc_L_1 = "std_acc_nondom_1";
        st_acc_R_2 = "std_acc_dom_2";
        st_acc_L_2 = "std_acc_nondom_2";

        diff_acc_R_1 = "diff_acc_dom_1";
        diff_acc_L_1 = "diff_acc_nondom_1";
        diff_acc_R_2 = "diff_acc_dom_2";
        diff_acc_L_2 = "diff_acc_nondom_2";

    elseif right_hand == "Non-Dominant"
        acc_L_1 = "avg_acc_dom_1";
        acc_R_1 = "avg_acc_nondom_1";
        acc_L_2 = "avg_acc_dom_2";
        acc_R_2 = "avg_acc_nondom_2";

        st_acc_L_1 = "std_acc_dom_1";
        st_acc_R_1 = "std_acc_nondom_1";
        st_acc_L_2 = "std_acc_dom_2";
        st_acc_R_2 = "std_acc_nondom_2";

        diff_acc_L_1 = "diff_acc_dom_1";
        diff_acc_R_1 = "diff_acc_nondom_1";
        diff_acc_L_2 = "diff_acc_dom_2";
        diff_acc_R_2 = "diff_acc_nondom_2";

    elseif right_hand == "More Affected"
        acc_L_1 = "avg_acc_less_affected_1";
        acc_R_1 = "avg_acc_more_affected_1";
        acc_L_2 = "avg_acc_less_affected_2";
        acc_R_2 = "avg_acc_more_affected_2";

        st_acc_L_1 = "std_acc_less_affected_1";
        st_acc_R_1 = "std_acc_more_affected_1";
        st_acc_L_2 = "std_acc_less_affected_2";
        st_acc_R_2 = "std_acc_more_affected_2";

        diff_acc_L_1 = "diff_acc_less_affected_1";
        diff_acc_R_1 = "diff_acc_more_affected_1";
        diff_acc_L_2 = "diff_acc_less_affected_2";
        diff_acc_R_2 = "diff_acc_more_affected_2";

    elseif right_hand == "Less Affected"
        acc_R_1 = "avg_acc_less_affected_1";
        acc_L_1 = "avg_acc_more_affected_1";
        acc_R_2 = "avg_acc_less_affected_2";
        acc_L_2 = "avg_acc_more_affected_2";

        st_acc_R_1 = "std_acc_less_affected_1";
        st_acc_L_1 = "std_acc_more_affected_1";
        st_acc_R_2 = "std_acc_less_affected_2";
        st_acc_L_2 = "std_acc_more_affected_2";

        diff_acc_R_1 = "diff_acc_less_affected_1";
        diff_acc_L_1 = "diff_acc_more_affected_1";
        diff_acc_R_2 = "diff_acc_less_affected_2";
        diff_acc_L_2 = "diff_acc_more_affected_2";

    end

    % fill structure
    ANstruct.(acc_L_1) = acc_avg_L_1;
    ANstruct.(acc_R_1) = acc_avg_R_1;
    ANstruct.(acc_L_2) = acc_avg_L_2;
    ANstruct.(acc_R_2) = acc_avg_R_2;

    ANstruct.(st_acc_L_1) = acc_std_L_1;
    ANstruct.(st_acc_R_1) = acc_std_R_1;
    ANstruct.(st_acc_L_2) = acc_std_L_2;
    ANstruct.(st_acc_R_2) = acc_std_R_2;

    ANstruct.(diff_acc_L_1) = diff_L_1;
    ANstruct.(diff_acc_R_1) = diff_R_1;
    ANstruct.(diff_acc_L_2) = diff_L_2;
    ANstruct.(diff_acc_R_2) = diff_R_2;

end