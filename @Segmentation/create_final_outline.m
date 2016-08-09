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
end
            
            
t = {Seg.thresh_max, Seg.thresh_diff_c};%, S.thresh_sigma}; 
t = t(Seg.priority_order);%Priority for different segmentations in final
%% Filter out final outline
Seg.thresh_final = t{1};
for jj = 1 : Seg.sz_all(3)
    Seg.thresh_final{jj}(isnan(Seg.thresh_final{jj})) = ...
            t{2}{jj}(isnan(Seg.thresh_final{jj}));
%                 Seg.thresh_final{jj}(isnan(Seg.thresh_final{jj})) = ...
%                         Seg.thresh_sigma{jj}(isnan(Seg.thresh_final{jj}));
%     Seg.thresh_final{jj} = [Seg.thresh_final{jj}; Seg.thresh_final{jj}(1, :)];
end
end

