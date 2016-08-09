classdef Z3D < handle
    %Z3D(data, resolution, numZSlices, numTPoints) Uses a segmentation to 
    %   display a z-Stack 3D reconstruction
    %   Can display membrane reconstruction or orthogonal views of cell
    %   data can be a disk location of a hyperstack or the hyperstack as a
    %   uint array.
        
    properties
        stackCell;          %Image stack, first element green, second red
        SegmentationCell;   %Array containing time course of Segmentations
        TriangulationCell;  %Cell array containing triangulation structures
        numTPoints;         %Number of timepoints
        numZSlices;         %Number of Z-slices
        resolution;         %Structure, contains .x, .y, .z values for microscope
        depthCorr;          %Contains vector of length numZSlices to correct for focal depth
        filename;           %filename if data contains disk location
        saveImagingData;    %Save imaging data
    end
    
    methods
        function this = Z3D(data, resolution)
            if nargin > 0  
                %Set parameters
                this.resolution.x = resolution(1);
                this.resolution.y = resolution(2);
                this.resolution.z = resolution(3);
                this.saveImagingData = 'off';
                %Load data, assign number of planes in Z and T
                this.load_Z3D_Data(data, 'internal')
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
                    stack = {this.stackCell{1}(:, :, :, tPoint), ...
                                this.stackCell{2}(:, :, :, tPoint)};
                    this.SegmentationCell{tPoint}  = Segmentation(stack,...
                                                            40, 10, 10, 20, 20);
                end
                %Create all triangulations. Not in previous for loop,
                %because triangulation takes time, which is annoying if one
                %segments a long movie. This way, all segs are done at
                %once.
                if isempty(gcp('nocreate')); parpool(8, 'IdleTimeout', 600); end 
                parfor tPoint = 1 : this.numTPoints
                    TriangulationCell_copy{tPoint} =this.zTriangulation(tPoint);
                end   
                this.TriangulationCell = TriangulationCell_copy;
                clear TriangulationCell_copy;
                %Delete imaging data to save space
                if strcmp(this.saveImagingData, 'off'); this.delete_Imaging_Data(); end
            end
        end
        
        Triangulation = zTriangulation(this, tPoint);
        plot_triangulation(this, tPoint, mode, showAll);
        show_movie(this, pauseTime, export);
        ortho(this, color, frame);
        load_Z3D_Data(this, data, mode);
        delete_Imaging_Data(this);
    end
    
end

