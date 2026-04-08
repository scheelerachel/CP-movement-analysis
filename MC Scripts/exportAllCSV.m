function exportAllCSV(structure, outFolder)

    if ~exist(outFolder, 'dir')
        mkdir(outFolder);
    end

    for i = 1:numel(structure)
        if i == 1
            filename = fullfile(outFolder, 'static_trial.csv');
        else
            filename = fullfile(outFolder, sprintf('trial_%02d.csv', i-1));
        end
        exportSingleCSV(structure(i), filename);
    end
end

function exportSingleCSV(structure, filename)

    % Extract numeric marker data
    data = structure.MC_data;   % 3 x markers x frames
    labels = structure.Labels;    % markers x 1 cell array

    % Basic validation
    if ~isnumeric(data) || ndims(data) ~= 3
        error('MC_data must be a 3 x markers x frames numeric array');
    end
    if ~iscell(labels)
        error('Labels must be a cell array');
    end

    [~, nMarkers, nFrames] = size(data);

    % Convert to frames x markers
    dataPerm = permute(data, [3 1 2]);   % frames x markers x XYZ
    data2D = reshape(dataPerm, nFrames, nMarkers*3);

    % Build headers
    header1 = cell(1,nMarkers*3+1);
    header1{1} = '';
    col = 2;
    for m = 1:nMarkers
        header1{col}   = labels{m};
        header1{col+1} = '';
        header1{col+2} = '';
        col = col + 3;
    end

    header2 = cell(1,nMarkers*3+1);
    header2{1} = 'Frame';
    col = 2;
    for m = 1:nMarkers
        header2{col}   = 'X';
        header2{col+1} = 'Y';
        header2{col+2} = 'Z';
        col = col + 3;
    end

    % Build table
    frame = (1:nFrames)';
    numblock = [frame data2D];
    numcell = num2cell(numblock);

    % Match size of cells for concatination 
    sz = size(numcell,2);
    header0 = cell(1,sz);
    header0{1} = 'TRAJECTORIES';
    header00 = cell(1,sz);
    header00{1} = '100';
    header00{2} = 'Hz';
    
    output = [header0;header00;header1;header2;numcell];

    % Write CSV
    [fid,msg] = fopen(filename, 'w');
    
    if fid == -1
        error('Could not open file: %s\nReason: %s', filename, msg);
    end

    for r = 1:size(output, 1)
        for c = 1:size(output, 2)

            cellval = output{r,c};

            if isnumeric(cellval)
                fprintf(fid, '%g', cellval);
            elseif isstring(cellval) || ischar(cellval)
                fprintf(fid, '%s', cellval);
            else
                fprintf(fid, '');
            end

            if c < size(output,2)
                fprintf(fid, ',');
            end
        end

        fprintf(fid, '\n');
    end

    fclose(fid);

    fprintf('Saved CSV: %s\n', filename);
end
