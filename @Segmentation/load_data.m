function load_data(Seg, file, mode)
    %% External mode does not prompt user for mouse input of midpoint, typically
    %% called by Seg.load_data(Seg.filename, 'external');
    %% Read in stack
    if ischar(file{1})         %File is a cell array of file names
        Seg.filename = file;
        [Seg.channels, Seg.Merge] = Seg.read_stack(Seg.filename, ...
                                            Seg.merge_factor);
    elseif isnumeric(file{1})  %File is a stack
         %File dimensions are XxYxZ?
        if length(size(file{1})) == 3 || length(size(file{1})) == 2
            Seg.filename{1} = '';
            %Load channels (one or two)
            sz = size(file{1});
            if length(size(file{1})) == 2; sz(3) = 1; end %If no z stack
            for k = 1 : sz(3)  
                Seg.channels{1}{k}  = file{1}(:, :, k);
                if isequal(length(file), 2)
                    Seg.channels{2}{k}  = file{2}(:, :, k);
                end
            end
            %Prepare input for segmentation
            if isequal(length(file), 2)
                Seg.filename{2} = '';
                Seg.Merge = (file{1} + Seg.merge_factor*file{2}) / ...
                    (1 + Seg.merge_factor);
            else
                Seg.Merge = file{1};
            end
        else
            disp('Unknown input to Segmentation, returning.');
            return;
        end
    else 
        disp('Class Segmentation: wrong input format.');
        return;
    end
    %% Provide empty second channel, in case only one channel was given
    Seg.channels{2} = {};
    %% Set geometry (cursor input for mid point, radii)
    Seg.sz_all = size(Seg.Merge);
    if strcmp(mode, 'internal_no_project')
        Seg.set_geometry();
    elseif strcmp(mode, 'PROJECT')
        Seg.set_geometry('PROJECT');
    %% Only works in single z-stack, z/t stacks not supported 
    elseif strcmp(mode, 'external') 
    if Seg.sz_all(1) < Seg.sz_all(2)
        for i = 1 : Seg.sz_all(3)
            Seg.MergeBuff{i} = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                    Seg.Merge(:, :, i); zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
            Seg.channels{1}{i} = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                    Seg.channels{1}{i}(:, :); zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
            if length(Seg.filename) == 2
                Seg.channels{2}{i} = [ zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2));... 
                    Seg.channels{2}{i}(:, :); zeros(ceil((Seg.sz_all(2)-Seg.sz_all(1))/2), Seg.sz_all(2))];
            end
        end
    disp('Image padded with zeros to make square.');
    elseif Seg.sz_all(1) > Seg.sz_all(2)
        for i = 1 : Seg.sz_all(3)
            Seg.MergeBuff{i} = [  zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-...
                            Seg.sz_all(2))/2)), Seg.Merge(:, :, i), zeros(Seg.sz_all(1), ...
                            ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
            Seg.channels{1}{i} = [  zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-...
                            Seg.sz_all(2))/2)), Seg.channels{1}{i}(:, :), zeros(Seg.sz_all(1), ...
                            ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
            if length(Seg.filename) == 2
                Seg.channels{2}{i} = [  zeros(Seg.sz_all(1), ceil((Seg.sz_all(1)-...
                            Seg.sz_all(2))/2)), Seg.channels{2}{i}(:, :), zeros(Seg.sz_all(1), ...
                            ceil((Seg.sz_all(1)-Seg.sz_all(2))/2)) ];
            end
        end
        disp('Image padded with zeros to make square.');
    else 
        for i = 1 : Seg.sz_all(3)
            Seg.MergeBuff{i} = Seg.Merge(:, :, i);
        end
        disp('Image is square');
    end
    end
end