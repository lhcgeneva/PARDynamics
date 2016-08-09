function [DomainSize] = calc_domain_size(filename, showGraphs, savePic, botOffset, topOffset)
%CALC_DOMAIN_SIZE Computes domain size of each input frame
%   Detects minimum of all frames, registeres so all maxima are in the
%   middle, fits left and right flank of maxima using gradient fitting
%   algorithm, computes domain size from parameter curve.c. Also depends on
%   class Segmentation for function Segmentation.smooth_periodic().
%   Last change Aug 2015 by Lars
    %% Read stack
    close all;
    info = imfinfo(filename);
    width = max([info.Width]);
    height = max([info.Height]);
    imageStack = zeros(height, width, length(info));
    for k = 1:length(info)
        imageStack(:,:,k) = imread(filename, k, 'Info', info);
    end 
    
    %% Stack Maximum intensity projection, smooth, register by min/max
    smooth_window = ceil(width/8);
    Projection = sort(imageStack, 1, 'descend');
    Projection = squeeze(mean(Projection(1:5, :, :), 1));
    if length(info) == 1; Projection = Projection'; end
    Projection = mat2cell(Projection, width, ones(1, length(info)));
    %%%%%%%IMPLEMENT CHECK FOR ZEROS OTHER THAN TRAILING ONES!
    Projection = cellfun(@(x) x(x~=0), Projection, 'UniformOutput', false);
    ProjectionSmooth = cellfun(@(x) ...
                        Segmentation.smooth_periodic(x, smooth_window), ...
                        Projection, 'UniformOutput', false);    
    %Find average minimum and maximum index for each frame
    [~, maxSmoothInd] = cellfun(@max,ProjectionSmooth, 'UniformOutput', false);
    
    for k = 1 : length(info)
        arr = Projection{k};
        mid_old = floor(length(arr)/2);
        mid_new = maxSmoothInd{k};
        draw_from_here = [1:length(arr), 1:length(arr)];
        start_of_array = draw_from_here(mid_new + mid_old);
        ProjectionRegistered{k} = [arr(start_of_array:end); ...
                                    arr(1:start_of_array-1)];
    end
    ProjectionRegisteredSmooth = cellfun(@(x) Segmentation.smooth_periodic(x, smooth_window), ...
                        ProjectionRegistered, 'UniformOutput', false);
    
    %% Smooth registered stack, fit left and right half from maximum
    [~, maxRegSmoothInd] = cellfun(@(x) max(x),ProjectionRegisteredSmooth, ...
                            'UniformOutput', false);
    maxRegSmoothInd = cell2mat(maxRegSmoothInd);
    Fr_c(length(info)) = 0;
    Fl_c(length(info)) = 0; 
    %Calculate points to take into account left and right from maximum
    bot = min(30, maxRegSmoothInd - 1)-botOffset; 
    top = min(30, width - maxRegSmoothInd)-topOffset;
    %Start parallel pool if not started, idle time 10 hours.
    if isempty(gcp('nocreate')); parpool(8, 'IdleTimeout', 600); end 
    parfor k = 1: length(info)
        r = fliplr(ProjectionRegisteredSmooth{k}(maxRegSmoothInd(k) - bot: end)');
        Fr = Fit(r, showGraphs, 1);
        l = ProjectionRegisteredSmooth{k}(1:maxRegSmoothInd(k) + top);
        Fl = Fit(l, showGraphs, 1);
        Fr_c(k) = Fr.curve.c;
        Fl_c(k) = Fl.curve.c;
    end

    %% Calculate domain size, plot
    indivArrayWidth = cell2mat(cellfun(@length, ProjectionRegistered, ...
        'UniformOutput', false));
    DomainSize = (indivArrayWidth - Fl_c - Fr_c)./indivArrayWidth;
    Fl_c = round(Fl_c);
    Fr_c = round(Fr_c);
    right_ind   = zeros(length(Fr_c), 1);
    left_ind    = zeros(length(Fl_c), 1);
    for k = 1 : length(info)
        draw_from_here = [1:indivArrayWidth(k), 1:width];
        try
            left_ind(k) = draw_from_here(Fl_c(k)+maxSmoothInd{k} - maxRegSmoothInd(k)+indivArrayWidth(k));
        
        catch
            left_ind(k) = nan;
        end
        try
            right_ind(k)= draw_from_here(maxSmoothInd{k} - maxRegSmoothInd(k) + indivArrayWidth(k) - Fr_c(k));
        catch
            right_ind(k) = nan;
        end
    end
    imshow(reshape(permute(imageStack, [1,3,2]),[], width), [])
    for k = 1 : length(info)
        if maxSmoothInd{k} < 500
            line([right_ind(k),right_ind(k)], [(k-1) * height + 1, k * height], 'Color','r','LineWidth', 2);
            line([left_ind(k),left_ind(k)], [(k-1) * height + 1, k * height], 'Color','r','LineWidth', 2);
        elseif maxSmoothInd{k} >500
            line([right_ind(k),right_ind(k)], [(k-1) * height + 1, k * height], 'Color','g','LineWidth', 2);
            line([left_ind(k),left_ind(k)], [(k-1) * height + 1, k * height], 'Color','g','LineWidth', 2);
        end
    end
    if strcmp(savePic, 'on'); saveas(gcf, ['Kymo', filename, '.jpg'], 'jpg'); end
    figure(2);
    hold on;
    subplot(2,1,1)
    hold on;
    for i = 1:length(info)
        plot(ProjectionSmooth{i}, 'r');
        plot(ProjectionRegisteredSmooth{i}, 'b');
        legend('Projection', 'Registered projection');
    end
    subplot(2,1,2)
    plot(smooth(DomainSize))
    axis([0 length(info) 0 max(DomainSize)]);
    if strcmp(savePic, 'on'); saveas(gcf, ['DomainSize', filename(1:end-4), '.jpg'], 'jpg'); end
    close all;
    if strcmp(savePic, 'on'); dlmwrite(['DomainSize', filename(1:end-4), '.txt'], DomainSize'); end
end

