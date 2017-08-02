function create_final_outline( Seg )
%CREATE_FINAL_OUTLINE Creates the final outline from diff max and sigma
%   Depending on the priorities defined this function takes the segmented
%   outlines from the different methods and combines them, starting with
%   the first (most important) one and continuing with the second for every
%   value that was nan and so on.

for i = 1 : Seg.sz_all(3)
    d_unsorted = hypot(Seg.thresh_diff{i}(:, 1) - Seg.thresh_max{i}(:,1), ...
        Seg.thresh_diff{i}(:, 2) - Seg.thresh_max{i}(:,2));
    d = sort(d_unsorted);
    d = d(~isnan(d));
    mean_d = mean(d(1:round(0.8*length(d))));
    Seg.thresh_max{i}(d_unsorted > 2 * mean_d, :) = nan;
    Seg.dist_mid_max{i}(d_unsorted > 2 * mean_d) = nan;
end
            
            
t = {Seg.thresh_max, Seg.thresh_diff_c};%, S.thresh_sigma}; 
t = t(Seg.priority_order);%Priority for different segmentations in final
% Make outline smooth using sgolay, interpolate nans
Seg.thresh_final = t{1};
for jj = 1 : Seg.sz_all(3)
    Seg.thresh_final{jj}(isnan(Seg.thresh_final{jj})) = ...
            t{2}{jj}(isnan(Seg.thresh_final{jj}));
%     Seg.thresh_final{jj}(isnan(Seg.thresh_final{jj})) = ...
%             Seg.thresh_sigma{jj}(isnan(Seg.thresh_final{jj}));
    
    % This can be used to close the outline, if desired, normally this is
    % done in straighten.m, only use for error checking.
%     Seg.thresh_final{jj} = [Seg.thresh_final{jj}; Seg.thresh_final{jj}(1, :)];

    % Put points that are too far away from an sgolay-filtered outline
    % on that filtered outline
    filt1 = smooth(Seg.thresh_final{jj}(:, 1), 15, 'sgolay', 5);
    filt2 = smooth(Seg.thresh_final{jj}(:, 2), 15, 'sgolay', 5);
    dist1 = filt1 - Seg.thresh_final{jj}(:, 1);
    dist2 = filt2 - Seg.thresh_final{jj}(:, 2);
    mask1 = abs(dist1) >= 2.5;
    mask2 = abs(dist2) >= 2.5;
    Seg.thresh_final{jj}(mask1, 1) = filt1(mask1);
    Seg.thresh_final{jj}(mask2, 2) = filt2(mask2);

    % Interpolate nans in final outline:
    % to get a periodic interpolation concatenate Seg.thresh_final{jj}
    % twice, then do interpolation on the concatenated stack, then take out
    % the middle bit which has been interpolated periodically.
    %
    % Indices of temp_i: 1, ... , len, len+1, ... , 2*len(=end)
    %
    % Example, len=51: 1:51, 52:102, [end-51+1:end-floor(51/2)(=25)(=77),
    % 51-floor(51/2(=25))(=26)+1(=27):51
    len = length(Seg.thresh_final{jj}(:, 1));
    t1 = [Seg.thresh_final{jj}(:, 1); Seg.thresh_final{jj}(:, 1)];
    tInd1 = 1:length(t1);
    t_i1 = interp1(tInd1(~isnan(t1)), t1(~isnan(t1)), tInd1, 'spline');
    Seg.thresh_final{jj}(:, 1) = [t_i1(end-len+1:end-floor(len/2)),...
                                  t_i1(len-floor(len/2)+1:len)];
    t2 = [Seg.thresh_final{jj}(:, 2); Seg.thresh_final{jj}(:, 2)];
    tInd2 = 1:length(t2);
    t_i2 = interp1(tInd2(~isnan(t2)), t2(~isnan(t2)), tInd2, 'spline');
    Seg.thresh_final{jj}(:, 2) = [t_i2(end-len+1:end-floor(len/2)),...
                                  t_i2(len-floor(len/2)+1:len)];
    
end



end

