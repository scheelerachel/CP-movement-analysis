% AlienEncounter1.m
% Function to plot velocity over time
%
% Rachel Scheele
% Last Edited 3/27/2025

function AlienEncounter1(movement_path_R,movement_time_R,movement_path_L,movement_time_L)
    
    for j=1:length(movement_path_R)
    
        position_R = cell2mat(movement_path_R(j));
        xr = position_R(:,1);
        yr = position_R(:,2);

        time_mat_R = movement_time_R{j};
        time_format_R = datetime(time_mat_R,'Format','HH:mm:ss.SSSS');
        tsec_R = second(time_format_R);
        tmin_R = minute(time_format_R);
        thour_R = hour(time_format_R);
        tsecnorm_R = (tsec_R-tsec_R(1));
        tminnorm_R = (tmin_R-tmin_R(1))*60;
        thournorm_R = (thour_R-thour_R(1))*60*60;
        time_arr_R = tsecnorm_R + tminnorm_R + thournorm_R;
        
        dtime_R = zeros(size(movement_time_R(j)));
        dist_R = zeros(size(movement_path_R(j)));
        velocity_R = zeros(size(movement_path_R(j))); % preallocate
        
        for i=1:size(xr)
            if i~=1
                dtime_R(i) = (time_arr_R(i)-time_arr_R(i-1))*60*60*24*365;
                dist_R(i) = sqrt((xr(i)-xr(i-1))^2+(yr(i)-yr(i-1))^2);
                velocity_R(i) = dist_R(i)/dtime_R(i); % pixels/sec ???I think???
            else
                dtime_R(i) = 0;
                dist_R(i) = 0;
                velocity_R(i) = 0;
            end
        end

        time = time_arr_R - time_arr_R(1);
        
        hold on
        figure(2)
        plot(time,velocity_R);
        title('Velocity over Time')
        xlabel('Time (s)')
        ylabel('Velocity (pixles/s)')
    
    end

    for j=1:length(movement_path_L)
    
        position_L = cell2mat(movement_path_L(j));
        xl = position_L(:,1);
        yl = position_L(:,2);

        time_mat_L = movement_time_L{j};
        time_format_L = datetime(time_mat_L,'Format','HH:mm:ss.SSSS');
        tsec_L = second(time_format_L);
        tmin_L = minute(time_format_L);
        thour_L = hour(time_format_L);
        tsecnorm_L = (tsec_L-tsec_L(1));
        tminnorm_L = (tmin_L-tmin_L(1))*60;
        thournorm_L = (thour_L-thour_L(1))*60*60;
        time_arr_L = tsecnorm_L + tminnorm_L + thournorm_L;
        
        dtime_L = zeros(size(movement_time_L(j)));
        dist_L = zeros(size(movement_path_L(j)));
        velocity_L = zeros(size(movement_path_L(j))); % preallocate
        
        for i=1:size(xl)
            if i~=1
                dtime_L(i) = (time_arr_L(i)-time_arr_L(i-1))*60*60*24*365;
                dist_L(i) = sqrt((xl(i)-xl(i-1))^2+(yl(i)-yl(i-1))^2);
                velocity_L(i) = dist_L(i)/dtime_L(i); % pixels/sec ???I think???
            else
                dtime_L(i) = 0;
                dist_L(i) = 0;
                velocity_L(i) = 0;
            end
        end

        time = time_arr_L - time_arr_L(1);
        
        hold on
        figure(2)
        plot(time,velocity_L);
        title('Velocity over Time')
        xlabel('Time (s)')
        ylabel('Velocity (pixles/s)')
    
    end

    hold off

end