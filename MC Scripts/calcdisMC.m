% Rachel Scheele
% Last Edited 11/3/2025

function [dis_left,dis_right]=calcdisMC(data)

    % time in ms (val X 1 double)
    % position in mm: x y z (val X 2 double)
        
    labels = data.labels;
    left = find(strcmp(labels,'LFIN'));
    right = find(strcmp(labels,'RFIN'));

    time = data.time;
    position = data.position_data_interpolated;

    x_left = squeeze(position(1,left,:));
    y_left = squeeze(position(2,left,:));
    z_left = squeeze(position(3,left,:));
    x_right = squeeze(position(1,right,:));
    y_right = squeeze(position(2,right,:));
    z_right = squeeze(position(3,right,:));

    dtime = zeros(size(time));
    dis_left = zeros(size(time));
    velocity_l = zeros(size(time));
    dis_right = zeros(size(time));
    velocity_r = zeros(size(time));

    for j=1:length(time)
        if j~=1
            dtime(j) = (time(j)-time(j-1));
            %dis_left(j) = sqrt(((x_left(j)-x_left(j-1))^2)+((y_left(j)-y_left(j-1))^2)+((z_left(j)-z_left(j-1))^2));
            dis_left(j) = sqrt(((y_left(j)-y_left(j-1))^2)+((z_left(j)-z_left(j-1))^2));
            % x_angle_l = acos(x_left(i)/dist_left(i));
            % y_angle_l = acos(y_left(i)/dist_left(i));
            % z_angle_l = acos(z_left(i)/dist_left(i));
            velocity_l(j) = dis_left(j)/dtime(j); % m/sec
            %dis_right(j) = sqrt(((x_right(j)-x_right(j-1))^2)+((y_right(j)-y_right(j-1))^2)+((z_right(j)-z_right(j-1))^2));
            dis_right(j) = sqrt(+((y_right(j)-y_right(j-1))^2)+((z_right(j)-z_right(j-1))^2));
            velocity_r(j) = dis_right(j)/dtime(j); % m/sec
            % x_angle_r = acos(x_right(i)/dist_right(i));
            % y_angle_r = acos(y_right(i)/dist_right(i));
            % z_angle_r = acos(z_right(i)/dist_right(i));
        else
            dtime(j) = 0;
            dis_left(j) = 0;
            velocity_l(j) = 0;
            dis_right(j) = 0;
            velocity_r(j) = 0;
        end % if
    end % for length time

    % Find and remove peaks
    window = 40;  % number of samples before/after to remove

    % Left
    thresh = mean(dis_left)+3*std(dis_left);
    [~,loc_l] = findpeaks(dis_left, 'MinPeakHeight', thresh);
    mask_l = false(size(dis_left));

    for k=1:length(loc_l)
        idx = max(1, loc_l(k)-window):min(length(dis_left), loc_l(k)+window);
        mask_l(idx) = true;
    end
    dis_left(mask_l) = 0;

    % Right
    thresh = mean(dis_right)+3*std(dis_right);
    [~,loc_r] = findpeaks(dis_right, 'MinPeakHeight', thresh);
    mask_r = false(size(dis_right));
    
    for k=1:length(loc_r)
        idx = max(1, loc_r(k)-window):min(length(dis_right), loc_r(k)+window);
        mask_r(idx) = true;
    end
    dis_right(mask_r) = 0;
    
end % function