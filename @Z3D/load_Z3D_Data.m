function load_Z3D_Data(this, data, mode)
%RELOAD_SEGMENTATION_DATA Reloads imaging from filename
    %load stack, 'data' - input either numeric or disk location
    if ischar(data{1})
        this.filename = data;
        this.stackCell{1} = load_stack(data{1});
        if isequal(length(data), 2)
            this.stackCell{2} = load_stack(data{2});
        end
    elseif isnumeric(data{1})
        this.stackCell{1} = data{1};
        if isequal(length(data), 2)
            this.stackCell{2} = data{2};
        end

    else 
        disp('Z3D: wrong input format.');
    end
    if isequal(length(data), 2) &&...
            ~isequal(size(this.stackCell{1}), size(this.stackCell{2}))
        disp('Input stacks do not have equal dimensions.');
        return;
    end
    if strcmp(mode, 'external')
        for tPoint = 1 : this.numTPoints
            stack = {this.stackCell{1}(:, :, :, tPoint), ...
                        this.stackCell{2}(:, :, :, tPoint)};
            this.SegmentationCell{tPoint}.load_data(stack, 'external');
        end
    end
end

