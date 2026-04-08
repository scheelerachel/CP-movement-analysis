% Rachel Scheele
% Last Edited 11/4/2025

function index = comparedis(dis_game,dis_MC,prev,graph_title)
    
    run = true;
    while run

        correlation = nan;
        index = nan;
        time_game = (0:length(dis_game)-1)/100;
        time_MC = (0:length(dis_MC)-1)/100;

        ex_window = 100;
    
        if dis_game == 0
            % start_ind = nan;
            break
        end
    
        for i=1:size(dis_MC,2)
    
            % Normalize both signals
            dis_game_n = (dis_game - mean(dis_game));
            dis_MC_n = (dis_MC(:,i) - mean(dis_MC(:,i)));
            % dis_game_n = (dis_game - mean(dis_game)) / std(dis_game);
            % dis_MC_n = (dis_MC(:,i) - mean(dis_MC(:,i))) / std(dis_MC(:,i));

            % Cross-correlate
            [xc, lag] = xcorr(dis_MC_n,dis_game_n);

             % Find multiple correlation peaks
            [pks, locs] = findpeaks(xc, 'MinPeakDistance', 200);
            [pks_sorted, order] = sort(pks, 'descend');
            lags_sorted = lag(locs(order));

            too_close = abs(lags_sorted - prev) < ex_window;
            lags_sorted(too_close) = [];
            pks_sorted(too_close) = [];
           
            % Skip if no peaks
            if isempty(pks_sorted)
                best_lag = nan;
                best_corr = nan;
                index(i) = best_lag;
                break
            else
                best_lag = lags_sorted(prev+1);
                best_corr = pks_sorted(prev+1);
            end
          
            % % [corl, ind] = max(xc);
            % % lag_ind = lag(ind);
            % % 
            % % % Calculate time lag
            % % time_lag = lag_ind/100;
            % % 
            % % % start_ind = lag(ind) - length(dis_game);
            % % % time_lag = start_ind/100;
            % % 
            % % time_game_adjusted = time_game + time_lag;
    
            time_lag = best_lag/100;
            time_game_adjusted = time_game + time_lag;

            figure
            hold on
            plot(time_MC, dis_MC,'LineWidth', 1.5)
            plot(time_game_adjusted,dis_game,'LineWidth', 1.5)
            xline(time_lag)
            title(graph_title)
            xlabel('time (s)')
            ylabel('Amplitude of displacement (mm)')
            hold off

            % figure
            % hold on
            % plot(lag,xc)
            % title("Correlation")
            % hold off
    
            correlation(i) = best_corr;
            index(i) = best_lag;
        end

        run = false;
    end

    [~, best_i] = max(correlation);
    index = index(best_i);

end