function [intensity, intensityNorm] = create_GradientData( Grad )
%CREATE_PROFILE Summary of this function goes here
%   Detailed explanation goes here

    %Get current directory, create outline...
    current_dir = pwd;
    is_correct = 0;
    while is_correct == 0
        %Previous standard segmentation (Peter's code), not
        %maintained anymore
        if strcmp(Grad.segmentationMode, 'MAT') 
            Grad.create_Fiji_Outline();
            Grad.load_outline();
            define_poles_and_time_interval;
            create_kymo_from_outline;
            cd 'Results_Kymo_test/';
            load Kymo_results.mat
            intensity = Kymo.kymograph.side1;
            intensity = intensity(isfinite(intensity));
            disp('Cutting off NaN values from gradient');
            
        %FIJI segmentation analyzing stills (no fileName specified)
        elseif strcmp(Grad.segmentationMode, 'FIJI') 
            %Spiel about preallocation in order to get double precision
            %output of imread.
            info = imfinfo(Grad.filePath);
            slices = length(info);
            pixelwidth = info.Width;
            pixelheight = info.Height;
            im_array = zeros(pixelheight, pixelwidth, 1);
            %Check whether given .tif file is actually a stack. In this
            %case no error is thrown but a message given. The first slice
            %of the stack is then taken as the image, not considering the
            %rest of the stack.
            if slices ~= 1; disp('Stacks not supported!'); end  
            im_array(:, :, 1) = imread(Grad.filePath); %1, to read 1. image (P2) in stack
            sorted   = sort(im_array, 'descend');
            intensity    = mean(sorted(1:5,:));
            
        %FIJI segmentation and specific frame of movie (fileName.tif)
        else
            disp('No segmentation mode set');
        end
        
        %Turn anterior to the right, normalize profile to maximum after
        %subtracting minimum
        side1_left = mean(intensity(1:round(length(intensity)/2)));
        side1_right = mean(intensity(round(length(intensity)/2):end));  
        if side1_left > side1_right; intensity = fliplr(intensity); end
        intensityNorm = (intensity - min(intensity))/(max(intensity)-min(intensity));        

        %Ask whether graphs are reasonable if Matlab segmentation is in use
        if strcmp(Grad.segmentationMode, 'MAT')
            figure;
            hold on;
            plot(intensity);    
            choice = questdlg('Correct Bezier?', 'Bezier - correction', ...
                        'Yes','No', 'Yes');
            switch choice
                case 'Yes'
                    close all;
                    is_correct = 1;
                case 'No'
                    close all;
                    is_correct = 0;
            end
        else break;
        end 
        
    end
    cd(current_dir);
end

