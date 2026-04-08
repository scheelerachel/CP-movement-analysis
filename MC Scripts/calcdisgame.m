% Rachel Scheele
% Last Edited 11/24/2025

function [dist_l,dist_r]=calcdisgame(time,position,hand,j)

% time in ms (val X 1 double)
% position in x y (val X 2 double)
    run = true;

    while run == true
        
        x = position(:,1);
        y = position(:,2);

        inx = isnan(x);
        
        freq = 100;
        t = time(1):(1/freq)*1000:time(end); % 10 ms steps
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
        
        dtime = zeros(size(smoothx));
        dist = zeros(size(smoothx));
        velocity = zeros(size(smoothx)); % preallocate
        
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
        
        [~,locs] = findpeaks(velocity);
        
        velocity(locs) = NaN;
        t(locs) = NaN;
        
        velocity = fillmissing(velocity, 'linear');
        t = fillmissing(t, 'linear');
        
        last = length(velocity);
        dist(last-3:last) = [];
        velocity(last-3:last) = [];
        t(last-3:last) = [];    %#ok<NASGU>

        dist(inx) = 0;
        
        dist_l = 0;
        dist_r = 0;
        velocity_l = 0;
        velocity_r = 0;
        
        switch hand
            case 'Left'
                dist_l = dist;
                velocity_l = velocity;
            case 'Right'
                dist_r = dist;
                velocity_r = velocity;
        end
        
        run = false;
    end
end