function segment_cell(Seg)
%SEGMENT_CELL Finds membrane crossing on ray outwards from cell Seg.midpoint
%   Either uses maximum of intensity or maximum of numerical derivative to
%   find the cell membrane.
dist_mid{Seg.sz_all(3)} = zeros(Seg.seg_prec, 1);
outline{Seg.sz_all(3)} = zeros(Seg.seg_prec, 2);

if contains(Seg.mode, 'Circle')
    register_circle(Seg, 1);
end

for jj = 1 : Seg.sz_all(3)
    innerCircle = Seg.thresh_limits(1) * Seg.minorRadius{jj};
    outerCircle = Seg.thresh_limits(2) * Seg.majorRadius{jj};
    midpoint = Seg.midpoint{jj};
    ROI_width = ceil(2.4*Seg.majorRadius{jj}/2);
    sz = size(Seg.MergeBuff{jj});
    center_im = [sz(1)/2, sz(2)/2];
    theta_list = 2*pi/Seg.seg_prec:2*pi/Seg.seg_prec:2*pi;
    if contains(Seg.mode, 'Sigma')
        if isempty(gcp('nocreate')); parpool(8, 'IdleTimeout', 600); end
        parfor i = 1 : Seg.seg_prec 
            theta = theta_list(i);
            MergeBuff_r = imrotate(Seg.MergeBuff{jj}, theta/pi*180, 'crop');
            a = [1,0,center_im(2); 0,1,center_im(1); 0,0,1];
            b = [cos(theta),sin(theta),0; -sin(theta),cos(theta),0; 0,0,1];
            c = [1,0,-center_im(2); 0,1,-center_im(1); 0,0,1];
            M_cc = a * b * c;
            midpoint_r = M_cc * midpoint; 

            ROI_width_pf = ceil(min([ROI_width, sz(2)-midpoint_r(1)])-1);
            x_top = round(midpoint_r(1));
            y_top = round(midpoint_r(2)-Seg.prec_sigma/2);
            x_bot = ROI_width_pf + x_top;
            y_bot = Seg.prec_sigma + y_top;
            ROI_av = MergeBuff_r(y_top:y_bot, x_top:x_bot);  
            ROI_av(ROI_av==0) = nan;
            fitdata_t = fliplr(nanmean(ROI_av));
            fitdata = fitdata_t(~isnan(fitdata_t));
            length_reduction = length(fitdata_t) - length(fitdata);
            fitdata = fitdata(1: end - ceil(0.5*innerCircle));
            F = Fit(fitdata, 'off', 1);
            m_pf = ROI_width_pf - (ceil(F.curve.c + F.curve.s/2)) - length_reduction;
            outline_point       = [m_pf+midpoint_r(1),midpoint_r(2), 1]';
            outline_point_orig  = M_cc \ outline_point;
            outline(i, :)       = outline_point_orig(1:2);
            dist_mid(i)         = m_pf;
        end
        Seg.dist_mid_sigma{jj}= dist_mid;
        Seg.thresh_sigma{jj} = outline;
    end
    if contains(Seg.mode, 'Max') || contains(Seg.mode, 'Diff')
        for i = 1 : Seg.seg_prec 
            theta = theta_list(i);
            MergeBuff_r = imrotate(Seg.MergeBuff{jj}, theta/pi*180, 'crop');
            a = [1,0,center_im(2); 0,1,center_im(1); 0,0,1];
            b = [cos(theta),sin(theta),0; -sin(theta),cos(theta),0; 0,0,1];
            c = [1,0,-center_im(2); 0,1,-center_im(1); 0,0,1];
            M_cc = a * b * c;
            midpoint_r = M_cc * midpoint;    
            ROI_width_temp = ceil(min([ROI_width, sz(2)-midpoint_r(1)])-1);
            x_top = round(midpoint_r(1));
            x_bot = ROI_width_temp + x_top;    
            if contains(Seg.mode, 'Max')
                dist_mid{Seg.sz_all(3)} = zeros(Seg.seg_prec, 1);
                outline{Seg.sz_all(3)} = zeros(Seg.seg_prec, 2);
                y_top = round(midpoint_r(2)-Seg.prec_max/2);
                y_bot = Seg.prec_max + y_top;
                ROI_av = MergeBuff_r(y_top:y_bot, x_top:x_bot);
                temp = smooth(mean(ROI_av, 1), 10);
                [m_v, m] = max(temp);
                %   Filter out noisy maxima
                left    = sort(temp(1 : m), 'ascend');
                right   = sort(temp(m : end), 'ascend');
                left_min = mean(left(1:round(length(left)/3)));
                right_min = mean(right(1:round(length(right)/3)));
                left_std = std(left(1:round(length(left)/3)));
                right_std = std(right(1:round(length(right)/3)));
                if (m_v - left_min) < 1.5 * left_std ...
                        || (m_v - right_min) < 1.5 * right_std
                    m = NaN;
                end
                if m < innerCircle || m > outerCircle
                    m = NaN;
                end
                outline_point = [m+midpoint_r(1),midpoint_r(2), 1]';
                outline_point_orig = M_cc \ outline_point;
                Seg.dist_mid_max{jj}(i) = m;
                Seg.thresh_max{jj}(i, :) = outline_point_orig(1:2);
            end
            if contains(Seg.mode, 'Diff')
                dist_mid{Seg.sz_all(3)} = zeros(Seg.seg_prec, 1);
                outline{Seg.sz_all(3)} = zeros(Seg.seg_prec, 2);
                y_top = round(midpoint_r(2)-Seg.prec_diff/2);
                y_bot = Seg.prec_diff + y_top;
                ROI_av = MergeBuff_r(y_top:y_bot, x_top:x_bot);
                ROI_av(ROI_av==0) = nan;
                ROI_smooth = nanmean(ROI_av); 
                ROI_smooth = ROI_smooth(~isnan(ROI_smooth));
                d       = smooth(smooth(diff(ROI_smooth),20));
                [~, m]  = min(d(ceil(ROI_width_temp/4):end-10));
                m       = ceil(ROI_width_temp/4) - 1 + m;
                if m < innerCircle || m > outerCircle
                    m = NaN;
                end
                
                % The below if/end is experimental: linear fit between
                % center point and edge and another linear fit at the
                % steepest slope of the edge and taking their intersection.
                %
                % m1*x + n1 = m2*x + n2 -> x = (n2-n1)/(m1-m2)
                % m1 = slope, n1 = smoothed(ROI_av)(m)-slope*m, m2/n2 from polyfit
%                 if ~isnan(m)
%                     xm = round(m);
%                     f = smooth(ROI_smooth, 21, 'sgolay', 5);
%                     pf1 = polyfit(1:xm-30, f(1:xm-30)', 1);
%                     pf2 = polyfit(xm-10:xm+10, f(xm-10:xm+10)', 1);
%                     m = (pf1(2)-pf2(2))/(pf2(1)-pf1(1));
%                 end
                
                outline_point       = [m+midpoint_r(1),midpoint_r(2), 1]';
                outline_point_orig  = M_cc \ outline_point;
                Seg.dist_mid_diff{jj}(i) = m;
                Seg.thresh_diff{jj}(i, :) = outline_point_orig(1:2);
            end                
        end
    end 
end
end

