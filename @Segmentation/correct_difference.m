function  correct_difference( Seg )
%CORRECT_DIFFERENCE Corrects offset of difference method
%   Difference method is systematically off, depending on steepness of
%   intensity gradient between extraembryonic space and membrane. Therefore
%   correction is needed, using the available points found by the maximum
%   method.

for i = 1 : Seg.sz_all(3)
    d_unsorted = hypot(Seg.thresh_diff{i}(:, 1) - Seg.thresh_max{i}(:,1), ...
        Seg.thresh_diff{i}(:, 2) - Seg.thresh_max{i}(:,2));
    d = sort(d_unsorted);
    d = d(~isnan(d));
    mean_d = mean(d(1:round(0.8*length(d))));
    Seg.thresh_max{i}(d_unsorted > 2 * mean_d, :) = nan;
    Seg.dist_mid_max{i}(d_unsorted > 2 * mean_d) = nan;
end

d = cellfun(@(x,y) nanmean(x - y), Seg.dist_mid_diff, Seg.dist_mid_max);
theta_list = 2*pi/Seg.seg_prec:2*pi/Seg.seg_prec:2*pi;
sz = size(Seg.MergeBuff{1});
center_im = [sz(1)/2, sz(2)/2];
Seg.thresh_diff_c = Seg.thresh_diff;
for i = 1 : Seg.sz_all(3)
    if sum(~isnan(Seg.dist_mid_max{i})) < 0.1*length(Seg.dist_mid_diff{i})
        warning(['Difference method not corrected, because maximum method ', ...
          'almost empty. Setting Seg.thresh_diff_c to Seg.thresh_diff ', ...
          'in frame %i .'], i);
        Seg.thresh_diff_c{i} = Seg.thresh_diff{i};
    else
        for j = 1 : Seg.seg_prec
            theta = theta_list(j);
            a = [1,0,center_im(2); 0,1,center_im(1); 0,0,1];
            b = [cos(theta),sin(theta),0; -sin(theta),cos(theta),0; 0,0,1];
            c = [1,0,-center_im(2); 0,1,-center_im(1); 0,0,1];
            M_cc = a * b * c;
            midpoint_r = M_cc * Seg.midpoint{i}; 
            m = Seg.dist_mid_diff{i}(j) - d(i);
            outline_point = [m+midpoint_r(1),midpoint_r(2), 1]';
            outline_point_orig = M_cc \ outline_point; 
            Seg.thresh_diff_c{i}(j, :) = outline_point_orig(1:2);
        end
    end
end     
end

