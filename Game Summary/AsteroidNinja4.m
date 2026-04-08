% AsteroidBelt4.m
%
% Outputs added to data structure:
% Inter-target interval: time between asteroid collisions
% Time in contact with screen (touch time): percentage 0-100%
%
% Sam Nemanich
% Last Edited 09/09/2025

function ANstruct = AsteroidNinja4(collision_time_L, collision_time_R, touch_time_L, touch_time_R, lift_time_L, lift_time_R, trial_start_time, trial_end_time, right_hand,left_hand,visit,name,ANstruct)
    

    % INTER-TARGET INTERVAL

    if length(collision_time_L) ~= length(collision_time_R)
        warning('Data arrays have different sizes. Execution stopped')
    else
       for ntrial=1:length(collision_time_L)
            for i=1:length(collision_time_R{ntrial}(:,1))-1        
                d=datetime(collision_time_R{ntrial}(i+1,:))-datetime(collision_time_R{ntrial}(i,:));
                ITI_R{ntrial,1}(i,1)=seconds(d);
            end
            
            
            for i=1:length(collision_time_L{ntrial}(:,1))-1        
                d=datetime(collision_time_L{ntrial}(i+1,:))-datetime(collision_time_L{ntrial}(i,:));
                ITI_L{ntrial,1}(i,1)=seconds(d);
            end
        

       end

    end


    % TIME TOUCHING SCREEN
    if length(touch_time_L)~=length(lift_time_R)
        warning('Data arrays have different sizes. Execution stopped');
    else 
       for ntrial=1:length(touch_time_L)
        if isempty(lift_time_L{ntrial}) && length(touch_time_L{ntrial}(:,1))>=1
            touchpct_L{ntrial,1}=100;
        else

            for i=1:length(lift_time_L{ntrial}(:,1))        
                d=datetime(lift_time_L{ntrial}(i,:))-datetime(touch_time_L{ntrial}(i,:));
                dur(i,1)=seconds(d);
                clear d;
            end
            if length(lift_time_L{ntrial}(:,1)) < length(touch_time_L{ntrial}(:,1)) 
                d=datetime(trial_end_time{ntrial})-datetime(touch_time_L{ntrial}(i+1,:));
                dur(i+1,1)=seconds(d);
            end

            totaltime=seconds(datetime(trial_end_time{ntrial})-datetime(trial_start_time{ntrial}));        
            touchpct_L{ntrial,1}=100*(sum(dur)/totaltime);
            if touchpct_L{ntrial,1}>100
                touchpct_L{ntrial,1}=100;
            end
            clear dur totaltime;
        end

        if isempty(lift_time_R{ntrial}) && length(touch_time_R{ntrial}(:,1))>=1
            touchpct_R{ntrial,1}=100;
        else

            for i=1:length(lift_time_R{ntrial}(:,1))        
                d=datetime(lift_time_R{ntrial}(i,:))-datetime(touch_time_R{ntrial}(i,:));
                dur(i,1)=seconds(d);
                clear d;
            end
            if length(lift_time_R{ntrial}(:,1)) < length(touch_time_R{ntrial}(:,1)) 
                d=datetime(trial_end_time{ntrial})-datetime(touch_time_R{ntrial}(i+1,:));
                dur(i+1,1)=seconds(d);
            end
            
            totaltime=seconds(datetime(trial_end_time{ntrial})-datetime(trial_start_time{ntrial}));        
            touchpct_R{ntrial,1}=100*(sum(dur)/totaltime);
            if touchpct_R{ntrial,1}>100
                touchpct_R{ntrial,1}=100;
            end
            clear d dur totaltime;
        end

       end

    end



    % determine handedness
    if right_hand == "Dominant"
        ITI_R_label="ITI_dom";
        ITI_L_label="ITI_nondom";
        touchpct_R_label="touchpct_dom";
        touchpct_L_label='touchpct_nondom';

    elseif right_hand == "Non-Dominant"
        ITI_L_label="ITI_dom";
        ITI_R_label="ITI_nondom";
        touchpct_L_label="touchpct_dom";
        touchpct_R_label='touchpct_nondom';
        
     

    elseif right_hand == "More Affected"

        ITI_R_label="ITI_more_affected";
        ITI_L_label="ITI_less_affected";
        touchpct_R_label="touchpct_more_affected";
        touchpct_L_label="touchpct_less_affected";
        

    elseif right_hand == "Less Affected"

        ITI_L_label="ITI_more_affected";
        ITI_R_label="ITI_less_affected";
        touchpct_L_label="touchpct_more_affected";
        touchpct_R_label="touchpct_less_affected";        
    
    end

    % fill structure
    ANstruct.(ITI_L_label) = ITI_L;
    ANstruct.(ITI_R_label) = ITI_R;
    ANstruct.(touchpct_L_label) = touchpct_L;
    ANstruct.(touchpct_R_label) = touchpct_R;


    
  
end