function [leftMat,rightMat,leftMean,rightMean,leftSD,rightSD] = processjoint(alldata,joint,nPoints)

    leftData  = {};
    rightData = {};
    
    for i = 1:length(alldata)
    
        y_raw = alldata(i).(joint)(:)';  
        y_raw = y_raw(~isnan(y_raw));
    
        if length(y_raw) < 2
            continue
        end
    
        x_raw = linspace(0,1,length(y_raw));
        x_new = linspace(0,1,nPoints);
        y = interp1(x_raw, y_raw, x_new, 'linear');
    
        if mod(i,2) == 0
            leftData{end+1} = y;
        else
            rightData{end+1} = y;
        end
    end
    
    leftMat  = vertcat(leftData{:}); % left to right
    rightMat = vertcat(rightData{:}); % right to left
    
    % Compute Mean ± SD
    leftMean = mean(leftMat,1);
    leftSD   = std(leftMat,0,1);
    
    rightMean = mean(rightMat,1);
    rightSD   = std(rightMat,0,1);
    
    x = linspace(0,1,nPoints);
end