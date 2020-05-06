classdef Z3D < handle
    %Z3D(data, resolution) Uses a segmentation to 
    %   display a z-Stack 3D reconstruction
    %   Can display membrane reconstruction or orthogonal views of cell
    %   data can be a disk location of a hyperstack or the hyperstack as a
    %   uint array.
        
properties
    Ang;                %Rotation angles for maximum/minimum polarity
    depthCorr;          %Contains vector of length numZSlices to correct for focal depth
    filename;           %filename if data contains disk location
    lineThick = 16;     %line thickness used for segmentations
    numTPoints;         %Number of timepoints
    numZSlices;         %Number of Z-slices
    overlap;            %Overlap between histograms in find_polarity
    parallel = 0;       %1 - use parfor, 0 - don't use parfor
    resolution;         %Structure, contains .x, .y, .z values for microscope
    saveImagingData;    %Save imaging data
    SegmentationCell;   %Array containing time course of Segmentations
    stackCell;          %Image stack, first element green, second red
    TriangulationCell;  %Cell array containing triangulation structures
end

methods
    function this = Z3D(filename, resolution)
        if nargin > 0  
            %Set parameters
            this.filename = filename;
            if isnumeric(resolution)
                this.resolution.x = resolution(1);
                this.resolution.y = resolution(2);
                this.resolution.z = resolution(3);
            elseif resolution == 'auto'
                this.read_resolution();
            end
            this.saveImagingData = 'on';
            %Load data, assign number of planes in Z and T
            this.load_Z3D_Data('internal')
            sz = size(this.stackCell{1});
            this.numZSlices = sz(3);
            try 
                this.numTPoints = sz(4);
            catch 
                this.numTPoints = 1;
            end
            %Create all segmentations
            this.SegmentationCell{this.numTPoints} = Segmentation();
            for tPoint = 1 : this.numTPoints
                if length(this.stackCell)==1
                    stack = {this.stackCell{1}(:, :, :, tPoint)};
                elseif length(this.stackCell)==2
                    stack = {this.stackCell{1}(:, :, :, tPoint), ...
                                this.stackCell{2}(:, :, :, tPoint)};
                end
                this.SegmentationCell{tPoint} = Segmentation(stack, 40, 16);
            end
            %Create all triangulations. Not in previous for loop,
            %because triangulation takes time, which is annoying if one
            %segments a long movie. This way, all segs are done at
            %once.
            this.triangulate_Z3D();
            %Delete imaging data to save space
            if strcmp(this.saveImagingData, 'off'); this.delete_Imaging_Data(); end
        end
    end
    
    delete_Imaging_Data(this);
    find_polarity(this, tPoint, channel, PLOTTING);
    load_Z3D_Data(this, mode);
    plot_triangulation(this, tPoint, PLOTHIST);
    ortho(this, color, frame);
    read_resolution(this);
    show_movie(this, pauseTime, export);
    triangulate_Z3D(this);
    Triangulation = zTriangulation(this, tPoint);
end
    
end

