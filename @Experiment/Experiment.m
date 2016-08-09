classdef Experiment < handle
    %EXPERIMENT Groups movies/stills and statistics for one experiment
    %   Folder names are created by concatenating segmentation mode, image
    %   type, treatmnt, protein imaged and the germcell. From this base
    %   folder all subfolders are found that are called Analysis. Further
    %   options are parallel computing (treating each folder as an
    %   independent element for a for loop), and an option to display
    %   graphs, when in non-parallel mode.
    
    properties
        %Input
        germcell;           %P0, P1, P2 or P3
        segmentationMode;   %If given determines Matlab (MAT) or Fiji (FIJI) as 
                            %straightening tool or SIMU for simultations
                            %in case model generated data is used
        imageType;          %'Movies' or 'Stills'
        treatment;          %Phenotype (for now: 'WT', 'IMA3', 'WT_Dissection')
        protein;            %Which Protein is being analyzed (for now: PAR-2)
        line;               %Wormline used for experiments. 'MIX' can be any
        temperature;        %Imaging temperature, room temperature means no cooling used,
                            %temp probably between 18-22 °C
        microscopeMode;     %Pin hole (PH) or Spiral (SP)
        suffix;             %Suffix of experiment name, in case the above are not sufficient
                            %to uniquely define a name
        
        %Meta 
        MovieArray;         %Array that stores one Profile for each embryo 
        subfolders;         %List of subfolders containing data to analyse
        showGraphs;         %Set 'true' to Display fits 
        parallel;           %Use parfor in compute_profiles
        pixelSize;          %PixelSize for Experiment
        poolSize = 8;       %Size of the parallel pool, maximum: 8
        create_diary = 'off'%Create log file of errors 
        
        %Compiled sigmas + errors
        sigmaList;          %Cell Array of Sigmas of all the gradients
        sigmaAll;
        sigmaAv;            %Average of above Sigmas
        sigmaStd;           %Standard deviation of sigmaAvFiltered
        sigmaStdErr;        %Standard error of the mean of sigmaListFiltered
        lambda;             %Expected value from unfiltered Poisson fit = average of sigmaAv
        lambda_conf_int;    %Confidence interval for lambda assuming poisson distribution
        lambdaStd;          %Standard deviation of SigmaAv
        lambdaStdErr;   %Standard error of the mean of SigmaAv
        
        %Compiled sigmas + errors for Nate's method
        sigmaListNate;
        sigmaAllNate;
        sigmaAvNate;
        lambdaNate;
        lambda_conf_int_Nate;
        lambdaStdNate; 
        %Filtered Statistics
        sigmaListFiltered;  %Cell Array of Sigmas of all the gradients
        sigmaAvFiltered;    %Average of above Sigmas
        sigmaStdFiltered;   %Standard deviation of sigmaAvFiltered
        sigmaStdErrFiltered;%Standard error of the mean of sigmaListFiltered
        cellSizeAv;         %Average of 'both.tif' file lengths
        cellSizeList;
        
        %Simulations
        SimulationArray;    %In case of simulations contains array of simulated data
    end
    
    methods
        function Exp = Experiment(ExpSpecs, showGraphs, parallel, pixelSize)
%                             temperature
            if nargin ~= 0
                
                %Toggles diary on
                if strcmp(Exp.create_diary, 'on'); diary; end
                
                %Assign class properties
                Exp.showGraphs          = showGraphs;
                Exp.parallel            = parallel;
                Exp.pixelSize           = pixelSize;
                if strcmp(ExpSpecs{1}, 'AnaMat')
                    Exp.segmentationMode    = ExpSpecs{1};
                    Exp.imageType           = ExpSpecs{2};
                    Exp.treatment           = ExpSpecs{3};
                    Exp.protein             = ExpSpecs{4};
                    Exp.germcell            = ExpSpecs{5};
                    Exp.line                = ExpSpecs{6};
                    Exp.temperature         = ExpSpecs{7};
                    Exp.microscopeMode      = ExpSpecs{8};
                    Exp.suffix              = ExpSpecs{9};
                        
                elseif strcmp(ExpSpecs{1}, 'FIJI') || strcmp(ExpSpecs{1}, 'MAT')
                    Exp.segmentationMode    = ExpSpecs{1};
                    Exp.imageType           = ExpSpecs{2};
                    Exp.treatment           = ExpSpecs{3};
                    Exp.protein             = ExpSpecs{4};
                    Exp.germcell            = ExpSpecs{5};
                    Exp.line                = ExpSpecs{6};
                    Exp.temperature         = ExpSpecs{7};
                    Exp.microscopeMode      = ExpSpecs{8};
                    Exp.suffix              = ExpSpecs{9};
                    Exp.list_subfolders();
                    Exp.compute_movies();
                    Exp.list_Sigmas();   
                elseif strcmp(ExpSpecs{1}, 'SIMU')
                    Exp.segmentationMode    = ExpSpecs{1};
                    Exp.imageType           = ExpSpecs{2};
                    Exp.treatment           = ExpSpecs{3};
                    Exp.protein             = ExpSpecs{4};
                    Exp.suffix              = ExpSpecs{5};
                    Exp.SimulationArray     = ExpSpecs{6};
                    Exp.cellSizeAv          = ExpSpecs{7};
                    Exp.subfolders          = '0';
                    Exp.compute_movies();
                    Exp.list_Sigmas();   
                    Exp.cellSizeList        = zeros(1, length(Exp.sigmaAv));
                    Exp.cellSizeList(:)     = Exp.cellSizeAv;
                else
                    disp('Segmentation mode not supported.')
                end
                                
                %Run class methods

                %Toggles diary of and outputs diary file
                if strcmp(Exp.create_diary, 'on'); diary('diary.txt'); end
            end
        end 
    end
    
    methods(Access = public)
        plot_experiment(Exp);
        [ mean_intensity, mean_x, aligned_intensities ] = ...
            calc_mean_curve(intensity_cell, align_points, x_cell);
    end
    
    methods(Access = protected)
        list_subfolders(Exp); 
        list_Sigmas(Exp);
        compute_Cell_Sizes(Exp);
        compute_movies(Exp); 
    end  
    
end

