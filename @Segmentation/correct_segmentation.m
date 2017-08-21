function correct_segmentation( Seg, sliceNum, IsPropagated)
%CORRECT_SEGMENTATION Displays segmentations, lets user make corrections
%   Creates draggable points from outline lets user correct positions 
imshow(Seg.MergeBuff{sliceNum},  Seg.lut); hold on;
sc = scatter(Seg.thresh_corr{sliceNum}(:, 1), Seg.thresh_corr{sliceNum}(:, 2),...
             'red', 'filled');
plot(Seg.midpoint{sliceNum}(1), Seg.midpoint{sliceNum}(2), 'k.', 'MarkerSize', 20);
freeHandSelectionHandle = imfreehand('Closed', false);
bds = freeHandSelectionHandle.getPosition;
temp_thresh = Seg.thresh_corr{sliceNum};
x_mid = Seg.midpoint{sliceNum}(1);
y_mid = Seg.midpoint{sliceNum}(2);
xi = nan(1, length(Seg.thresh_corr{sliceNum}));
yi = nan(1, length(Seg.thresh_corr{sliceNum}));
for i = 1:length(Seg.thresh_corr{sliceNum})
    try
        %%%Calculate point on the line midpoint-radial point which
        %%%is for sure outside the cell membrane.
        x_corr = Seg.thresh_corr{sliceNum}(i, 1);
        y_corr = Seg.thresh_corr{sliceNum}(i, 2);
        m = (y_mid-y_corr)/(x_mid-x_corr);
        n = y_corr-m*x_corr;
        if x_corr>x_mid
            x_extrapolate = 1000000;
            y_extrapolate = m*x_extrapolate + n;
        elseif x_corr<x_mid
            x_extrapolate = -1000000;
            y_extrapolate = m*x_extrapolate + n;
        elseif x_corr == x_mid
            x_extrapolate = x_mid;
            if y_corr<y_mid
                y_extrapolate = -1000000;
            elseif y_corr>y_mid
                y_extrapolate = 1000000;
            else
                disp('Segmentation goes through midpoint, repeat.');
            end
        end
        [xtemp, ytemp] = polyxpoly([x_mid, x_extrapolate], ...
                    [y_mid, y_extrapolate],...
                    bds(:, 1),bds(:, 2));
        if ~isempty(xtemp)
            xi(i) = xtemp(1);
            yi(i) = ytemp(1);
        end
    catch
        disp('Check correct_segmentation(), error in manually setting point.');
    end
end

Seg.thresh_corr{sliceNum}(~isnan(xi),1) = xi(~isnan(xi));
Seg.thresh_corr{sliceNum}(~isnan(yi),2) = yi(~isnan(yi));
delete(sc);
scatter(Seg.thresh_corr{sliceNum}(:, 1), Seg.thresh_corr{sliceNum}(:, 2),...
        'red', 'filled');
% Get points that have changed. Need to check whether x OR y have changed,
% because for angles 90, 180, 270 and 360 deg x or y remains the same.
unequal_inds = ((temp_thresh(:, 1) ~= Seg.thresh_corr{sliceNum}(:, 1)))|...
                ((temp_thresh(:, 2) ~= Seg.thresh_corr{sliceNum}(:, 2)));

% Propagate through all images
if IsPropagated
    for i = sliceNum+1:length(Seg.thresh_corr)
        Seg.thresh_corr{i}(unequal_inds, :) = Seg.thresh_corr{sliceNum}(unequal_inds, :);
    end
end 
end