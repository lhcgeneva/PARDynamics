classdef Fit < handle
    %FIT Contains all relevant data for a fit (gof, fitdata, fitobject
    %etc.)
    %   Can also be used independently from rest of framework to do a and
    %   plot a single fit and get averaged data_max and data_min
    
    properties
        curve;              %Resulting fit curve
        gof;                %Goodness of fit parameters
        fitData;            %Data to be fitted
        mean_min;           %Mean of data below data_min
        data_max;           %Average of ~5% biggest raw data points
        data_min;           %Average of ~5% smallest raw data points
        fitType = 'err';    %Error function is used as default, 'err', 
                            %'err_domain_size', 'sigma'
        showGraphs;         %Display graphs during fitting
        error_code;         %Encodes errors encountered during fit
        curve_Nate;         %Nate's final fitting object
        gof_Nate;           %Nate's goodness of fit
        data_Nate;          %Data normalized to mean as used by Nate's procedure
        pixelSize;          %Length of one pixel (ususally in microns)
        SNR;                %Signal to noise ratio
        heightDiff;
        out;                %Fit output (third return value of fit())
        fftThresh;          %Threshold for fourier trafo method
        maxFFTNorm;         %normalized maximum of power spectrum of fourier 
                            %analysis of gradient area residuals
        autoCThresh;        %Threshold for autocorrelation halftime
        autoCorrHalfTime;   %half time fit to autocorrelation in kick_out 
        rsquThresh;         %Threshold for r-squared method
        rsqu;
        sigmaInMicrons;     %(1, 2) array of sigmas in microns by pixelsize
        normSlope;          %Normalized slope as calculated by calc_slope
    end
    
    methods
        function Fi = Fit(fitData, showGraphs, pixelSize, fitType)
            
            Fi.pixelSize    = pixelSize;
            Fi.fitType      = fitType;
            if nargin ~= 0;
                middle = round(length(fitData)/2);
                if mean(fitData(1:middle)) > mean(fitData(middle:end))
                    fitData = fliplr(fitData);
                end
                %Flip max to the right
                Fi.fitData = fitData;
                Fi.showGraphs = showGraphs;
                [Fi.gof, Fi.curve, Fi.out, Fi.error_code, Fi.mean_min, Fi.data_max, Fi.data_min,... 
                    Fi.curve_Nate, Fi.gof_Nate, Fi.data_Nate] = Fi.fit_grad(Fi.fitData, Fi.fitType,...
                                                 showGraphs, Fi.pixelSize);
                [Fi.SNR, Fi.heightDiff]       = Fi.sigToNoise();
                
            end
        end  
        [SNR, heightDiff] = sigToNoise(Fit);
        plot_Fit(Fit);
        maxFFTNorm = kick_out(Fit, PLOT);
    end
    
    methods (Static)
        [gof, curve, out, error_code, mean_min, data_max, data_min, ...
         curve_Nate, gof_Nate, data_Nate] = fit_grad(fitData, fitType, showGraphs, pixelSize) 
    end
    
end

