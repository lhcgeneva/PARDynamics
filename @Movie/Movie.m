classdef Movie < handle 
    %Movie Combines all profiles of one movie
    %   Each movie contains frames each of which is analysed in a "Profile"
    %   object. All these profile objects for one movie are collected in
    %   this class.
    
    properties 
        folder;             %Base folder for Profile
        segmentationMode;   %Straightening, FIJI or MAT2 (legacy: MAT Peter's code)
        showGraphs;         %Show graphs during fitting
        Seg;        %Segmentation for specific Movie when segmentationMode == MAT2
        Side1;      %Single GradientData object or array of GradientData objects
        Side2;      %Single GradientData object or array of GradientData objects
        bothName;   %Name of file containing entire circumference
        side1Name;  %Name of file or folder containing Side1
        side2Name;  %Name of file or folder containing Side2
        pixelSize;  %Size of pixel for experiment depending on microscope/lense used
        cellSize;   %Size of one cell or array of cell sizes in mum!
        channel;    %Which channel of Seg to use, when using MAT2; 1-green, 2-red
        retrievedSigmas; %Sigmas retrieved from Fits in Side1/Side2
        retrievingRange; %Array with indices determining 
        retrievedSigmasAv; %Average of retrievedSigmas (across both sides)
        retrievedLengths; %lengths of cells which were fit in retrieved Sigmas
        retrievedLengthsAv; %Average for above
        retrievedSlopes;    %Slopes retrieved from Fits in Side1/Side2
        retrievedSlopesAv   %Average of retrievedSlopes
    end
    
    methods
        %Takes inputs (folder, segmentationMode), varargin is used, so the
        %class can be called with zero arguments for preallocation
        function Mo = Movie(folder, segmentationMode, showGraphs, pixelSize, channel)
            %If condition allows for no arguments, making preallocation
            %in methods (e.g. compute_profiles) possible
            if nargin ~= 0
                Mo.folder = folder;
                Mo.segmentationMode = segmentationMode;
                Mo.showGraphs = showGraphs;
                Mo.pixelSize = pixelSize;
                if strcmp(Mo.segmentationMode, 'SIMU')
                    Mo.Side1    = Mo.compute_gradients(folder{1}{1});
                    Mo.Side2    = Mo.compute_gradients(folder{2}{1});
                elseif strcmp(Mo.segmentationMode, 'MAT2')
                    Mo.channel = channel; %1 for green, two for red
                    Mo.Seg = folder;
                    centered_stack = Mo.center_stack(Mo.Seg.Imr_s{Mo.channel});
                    [side1, side2]  = Mo.cut_sides(centered_stack, 1);
                    sorted1 = cellfun(@(x) sort(x, 1, 'descend'), side1, 'UniformOutput', false);
                    sorted2 = cellfun(@(x) sort(x, 1, 'descend'), side2, 'UniformOutput', false);
                    side1_int = cellfun(@(x) mean(x(1:3, :), 1), sorted1, 'UniformOutput', false);
                    side2_int = cellfun(@(x) mean(x(1:3, :), 1), sorted2, 'UniformOutput', false);
                    Mo.Side1 = cellfun(@(x) Fit(x, Mo.showGraphs, Mo.pixelSize, 'err'), ...
                                    side1_int, 'UniformOutput', false); 
                    Mo.Side2 = cellfun(@(x) Fit(x, Mo.showGraphs, Mo.pixelSize, 'err'), ...
                                    side2_int, 'UniformOutput', false); 
                                
                elseif strcmp(Mo.segmentationMode, 'FIJI') || ....
                        strcmp(Mo.segmentationMode, 'MAT')
                    Mo.find_files();
                    Mo.cellSize = get_circumference(Mo);
                    Mo.Side1    = Mo.compute_gradients(Mo.side1Name);
                    if ~isempty(Mo.side2Name) 
                        Mo.Side2 = Mo.compute_gradients(Mo.side2Name); 
                    end
                end
            end
        end
        circumference = get_circumference(Mo, top_folder)  
    end
    
    methods (Access = public)
        find_files(Mov)    %Finds both.tif, folder/files side1/side2
        GradientDataArray = compute_gradients(Mo, sideNames)
        read_MetaData(Mo)
        plot_movie(Mo)
        [s, sRs] = fit_all_simul(Mo)
        retrieve_sigmas(Mo, range)
    end
    
    methods (Static)
        [DomainSize] = calc_domain_size(file_name, showGraphs, savePic, mode,...
                            botOffset, topOffset)
        Registered = center_stack(filename);
        [side1, side2] = cut_sides(imageCell, DONOTASSIGNSIDES);
    end
end

