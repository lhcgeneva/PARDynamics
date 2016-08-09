 function registeredImageCell = center_stack(imageCell)
%CENTER_STACK Centers input stack around maximum
%   Use same algorithm as calc_domain_size(), but does not work for
%   images buffered with zeros.

width = cellfun(@length, imageCell);
%% Stack Maximum intensity projection, smooth, register by min/max
smooth_window = ceil(min(width)/3);
Projection = cellfun(@(x) sort(x, 1, 'descend'), imageCell, 'UniformOutput', false);
Projection = cellfun(@(x) mean(x(1:5, :), 1), Projection, 'UniformOutput', false);
ProjectionSmooth = cellfun(@(x) ...
                    Segmentation.smooth_periodic(x, smooth_window), ...
                    Projection, 'UniformOutput', false);    
%Find average minimum and maximum index for each frame
[~, maxSmoothInd] = cellfun(@max,ProjectionSmooth, 'UniformOutput', false);
[~, minSmoothInd] = cellfun(@min,ProjectionSmooth, 'UniformOutput', false);
for i = 1:length(minSmoothInd)
    shifted{i} = [ProjectionSmooth{i}(minSmoothInd{i}:end); ...
                  ProjectionSmooth{i}(1:minSmoothInd{i})];
%     f(i) = figure; hold on;
%     plot(shifted{i}, 'r');
%     plot(ProjectionSmooth{i}, 'b');
end
% for i = 1:length(f); close(f(i)); end
fit_cell = cellfun(@(x) fit((1:length(x))', double(x-min(x)), 'gauss1'), shifted, ...
                    'UniformOutput', false);  
fittedShiftInd = cellfun(@(x) round(x.b1), fit_cell, 'UniformOutput', false); 
for i = 1 : length(minSmoothInd)
    maxSmoothInd{i} = fittedShiftInd{i}+minSmoothInd{i};
    if maxSmoothInd{i} > length(Projection{i}) 
        maxSmoothInd{i} = maxSmoothInd{i} - length(Projection{i});
    end
end
for k = 1 : length(imageCell)
    arr = Projection{k};
    mid_old = floor(length(arr)/2);
    mid_new = maxSmoothInd{k};
    draw_from_here = [1:length(arr), 1:length(arr)];
    start_of_array = draw_from_here(mid_new + mid_old);
    registeredImageCell{k} = [imageCell{k}(:, start_of_array:end), ...
                                imageCell{k}(:, 1:start_of_array-1)];
end
