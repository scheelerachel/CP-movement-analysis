% Rachel Scheele
% Last Edited 2/4/2025

function index = comparedisman(dis_game, dis_MC,~, graph_title)

    fs = 100;
    index = nan(1,size(dis_MC,2));

    time_game = (0:length(dis_game)-1)/fs;

    if time_game == 0
        index = nan;
        return
    end

    % Shared state for callbacks
    lag = 0;
    step = 1;
    confirmed = false;
    fig = [];
    hGame = [];
    hLine = [];
    time_MC = [];
    dis_MC_i = [];

    for i = 1:size(dis_MC,2)

        dis_MC_i = dis_MC(:,i);
        time_MC  = (0:length(dis_MC_i)-1)/fs;

        lag = 0;
        step = 1;
        confirmed = false;

        time_game_adjusted = time_game + lag/fs;

        fig = figure( ...
            'Name','Manual Alignment', ...
            'NumberTitle','off', ...
            'KeyPressFcn',@keyPress);

        hold on
        plot(time_MC, dis_MC_i, 'LineWidth', 1.5);
        hGame = plot(time_game_adjusted, dis_game, 'LineWidth', 1.5);
        hLine = xline(lag/fs,'--k');

        title(graph_title)
        xlabel('time (s)')
        ylabel('Amplitude of displacement (mm)')
        legend('MC','Game','Lag')
        grid on

        uiwait(fig);

        if confirmed
            index(i) = lag;
        else
            index(i) = NaN;
        end

        if isvalid(fig)
            close(fig)
        end
    end

    % Choose best if multiple MC signals
    [~, best_i] = min(abs(index));
    index = index(best_i);

    % ==================================================
    % Nested functions MUST be after all executable code
    % ==================================================

    function keyPress(~, event)
        switch event.Key
            case 'rightarrow'
                lag = lag + step;
                updateGamePlot()

            case 'leftarrow'
                lag = lag - step;
                updateGamePlot()

            case 'uparrow'
                step = step * 2;

            case 'downarrow'
                step = max(1, round(step/2));

            case {'return','space'}
                confirmed = true;
                uiresume(fig)

            case 'escape'
                confirmed = false;
                lag = NaN;
                uiresume(fig)
        end
    end

    function updateGamePlot()
        time_game_adjusted = time_game + lag/fs;
        set(hGame, 'XData', time_game_adjusted);
        set(hLine, 'Value', lag/fs);
        drawnow
    end
end
