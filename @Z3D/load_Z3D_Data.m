function load_Z3D_Data(this, mode)
%RELOAD_SEGMENTATION_DATA Reloads imaging from filename or as numeric
%load stack, this.filename can either be numeric or disk location, variable
%name 'filename' used for historical reasons. If renamed, old files might
%not reload properly.

if ischar(this.filename{1})
    this.stackCell{1} = load_stack(this.filename{1});
    if isequal(length(this.filename), 2)
        this.stackCell{2} = load_stack(this.filename{2});
    end
elseif isnumeric(this.filename{1})
    this.stackCell{1} = this.filename{1};
    this.filename{1} = 'Input was numeric, copied to this.stackCell{1}';
    if isequal(length(this.filename), 2)
        this.stackCell{2} = this.filename{2};
        this.filename{2} = 'Input was numeric, copied to this.stackCell{2}';
    end
else 
    disp('Z3D: wrong input format.');
end

if isequal(length(this.filename), 2) &&...
        ~isequal(size(this.stackCell{1}), size(this.stackCell{2}))
    disp('Input stacks do not have equal dimensions.');
    return;
end

if strcmp(mode, 'external')
    if isequal(length(this.filename), 1)
        for tPoint = 1 : this.numTPoints
                stack = {this.stackCell{1}(:, :, :, tPoint)};
                this.SegmentationCell{tPoint}.load_data(stack, 'external');
        end
    elseif isequal(length(this.filename), 2)
        for tPoint = 1 : this.numTPoints
            stack = {this.stackCell{1}(:, :, :, tPoint), ...
                        this.stackCell{2}(:, :, :, tPoint)};
            this.SegmentationCell{tPoint}.load_data(stack, 'external');
        end
    end
end
end

