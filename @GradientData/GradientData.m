classdef GradientData < handle
    %GradientData Contains gradient data, gradient fit 
    %   Can distinguish between segmentation modes 'MAT', 'FIJI', and
    %   'SIMU' (SIMU standing for simulation, data generated by model)
    
    properties
        filePath;   %Path to file gradient is taken including file name!
        intensity;
        intensityNorm;
        Grad_Fit;
        segmentationMode;
        showGraphs; %Show graphs during fitting
        pixelSize;  %Length of one pixel
        fitType = 'err'; 
    end
    
    methods
        function Grad = GradientData(filePath, segmentationMode, showGraphs, ...
                                    pixelSize, fitType)
            if nargin == 5; Grad.fitType = fitType; end
            if nargin > 0
                Grad.filePath           = filePath;
                Grad.segmentationMode   = segmentationMode;
                Grad.showGraphs         = showGraphs;
                Grad.pixelSize          = pixelSize;
                %Diagnostics
                if strcmp(showGraphs, 'on'); disp(Grad.filePath); end
                %Load segmentation
                if strcmp(Grad.segmentationMode, 'FIJI') || strcmp(Grad.segmentationMode, 'MAT')
                    [Grad.intensity, Grad.intensityNorm] = Grad.create_GradientData();
                elseif strcmp(Grad.segmentationMode, 'SIMU') || ...
                                    strcmp(Grad.segmentationMode, 'MAT2')
                    if mean(filePath(1:round(length(filePath)/3))) > ...
                            mean(filePath(end-round(length(filePath)/3):end))
                        filePath = fliplr(filePath);
                    end
                    Grad.intensity = filePath/max(filePath);
                end
                %Fit
                Grad.Grad_Fit   = Fit(Grad.intensity, Grad.showGraphs, ...
                                        Grad.pixelSize, Grad.fitType);  
                if Grad.Grad_Fit.error_code == 0 
                    try
                        disp(['Error in ', filePath]); 
                    catch
                        disp('Nate''s fit not done');
                    end
                end
            end
        end
        [intensity, intensityNorm] = create_GradientData(Grad);
    end
    
end

