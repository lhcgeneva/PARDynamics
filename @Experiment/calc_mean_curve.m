function [ mean_intensity, mean_x, aligned_intensities ] = calc_mean_curve( ...
    ~, intensity_cell, align_points, x_cell )
%CALC_MEAN_CURVE Calculates average of curves in intensity cells 
%   Aligns curves in intensity cell along points specified in align_points

%   Yet to be implemented, also giving specific x vaules to each element in
%   intensity_cell
if nargin == 4
    disp('input of x_cell not supported yet');
%   Assumes equally spaced values in x axis (assumes spacing of 1)
elseif nargin == 3
    for i = 1 : length(intensity_cell)
        x_cell{i} = -align_points(i):1:length(intensity_cell{i})-1-align_points(i);
    end
    max_limit = min(cellfun(@max, x_cell));
    min_limit = max(cellfun(@min, x_cell));
    mean_x = min_limit:max_limit-1;
    
    aligned_intensities = zeros(length(intensity_cell), abs(max_limit) + abs(min_limit));
    for i = 1 : length(intensity_cell)
        disp(i);
        aligned_intensities(i, :) = intensity_cell{i}(align_points(i) - abs(min_limit)+1:...
            align_points(i) + abs(max_limit));
    end
    mean_intensity = mean(aligned_intensities, 1);
else disp('Wrong number of input arguments for calc_mean_curve()');
end

end

