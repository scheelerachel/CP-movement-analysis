function exportSingleTRC(structure, frameRate, filename)

    % Extract numeric marker data
    data = structure.MC_data;      % size: 3 x markers x frames
    labels = structure.Labels;     % size: markers x 1 cell array

    % Validate
    if ~isnumeric(data) || ndims(data) ~= 3
        error('MC_data must be a 3 x markers x frames numeric array');
    end
    if ~iscell(labels)
        error('Labels must be a cell array');
    end

    [~, nMarkers, nFrames] = size(data);

    % TRC requires frames x (markers*3)
    dataPerm = permute(data, [3 2 1]);   % → (frames x markers x 3)
    data2D   = reshape(dataPerm, [nFrames, nMarkers*3]);

    time = (0:nFrames-1)' ./ frameRate;

    % Write TRC file
    fid = fopen(filename, 'w');
    if fid < 0
        error('Cannot open %s for writing', filename);
    end

    % Header
    fprintf(fid, 'PathFileType\t4\t(X/Y/Z)\t%s\n', filename);
    fprintf(fid, 'DataRate\tCameraRate\tNumFrames\tNumMarkers\tUnits\tOrigDataRate\tOrigDataStartFrame\tOrigNumFrames\n');
    fprintf(fid, '%d\t%d\t%d\t%d\tmm\t%d\t1\t%d\n', ...
            frameRate, frameRate, nFrames, nMarkers, frameRate, nFrames);

    % Marker names
    fprintf(fid, 'Frame#\tTime\t');
    for m = 1:nMarkers
        fprintf(fid, '%s\t\t\t', labels{m});
    end
    fprintf(fid, '\n');

    % XYZ headings
    fprintf(fid, '\t\t');
    for m = 1:nMarkers
        fprintf(fid, 'X%d\tY%d\tZ%d\t', m, m, m);
    end
    fprintf(fid, '\n');

    % Write data rows
    for f = 1:nFrames
        fprintf(fid, '%d\t%.5f\t', f, time(f));
        fprintf(fid, '%.5f\t', data2D(f, :));
        fprintf(fid, '\n');
    end

    fclose(fid);

    fprintf('Saved TRC: %s\n', filename);
end
