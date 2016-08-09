function [outline, dist_mid] = get_segmentation( Seg, prec, thresh_limits, mode)
%FIND_MEMBRANE Finds membrane crossing on ray outwards from cell Seg.midpoint
%   Either uses maximum of intensity or maximum of numerical derivative to
%   find the cell membrane.
dist_mid{Seg.sz_all(3)} = zeros(Seg.seg_prec, 1);
outline{Seg.sz_all(3)} = zeros(Seg.seg_prec, 2);
for jj = 1 : Seg.sz_all(3)
    innerCircle = thresh_limits(1) * Seg.minorRadius{jj};
    outerCircle = thresh_limits(2) * Seg.majorRadius{jj};
    midpoint = Seg.midpoint{jj};
    ROI_width = ceil(2.4*Seg.majorRadius{jj}/2);
    sz = size(Seg.MergeBuff{jj});
    center_im = [sz(1)/2, sz(2)/2];
    theta_list = 2*pi/Seg.seg_prec:2*pi/Seg.seg_prec:2*pi;
    if strcmp(mode, 'SIGMA')
        MergeBuff = Seg.MergeBuff{jj};
        if isempty(gcp('nocreate')); parpool(8, 'IdleTimeout', 600); end
        parfor i = 1 : Seg.seg_prec 
            theta = theta_list(i);
            MergeBuff_r = imrotate(MergeBuff, theta/pi*180, 'crop');
            a = [1,0,center_im(2); 0,1,center_im(1); 0,0,1];
            b = [cos(theta),sin(theta),0; -sin(theta),cos(theta),0; 0,0,1];
            c = [1,0,-center_im(2); 0,1,-center_im(1); 0,0,1];
            M_cc = a * b * c;
            midpoint_r = M_cc * midpoint; 

            ROI_width_pf = ceil(min([ROI_width, sz(2)-midpoint_r(1)])-1);
            x_top = round(midpoint_r(1));
            y_top = round(midpoint_r(2)-prec/2);
            x_bot = ROI_width_pf + x_top;
            y_bot = prec + y_top;
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
            outline{jj} = outline;
            dist_mid{jj}= dist_mid;
    elseif strcmp(mode, 'MAX') || strcmp(mode, 'DIFF')
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
            y_top = round(midpoint_r(2)-prec/2);
            x_bot = ROI_width_temp + x_top;
            y_bot = prec + y_top;
            ROI_av = MergeBuff_r(y_top:y_bot, x_top:x_bot);    
            if strcmp(mode, 'MAX')
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
            elseif strcmp(mode, 'DIFF') 
                ROI_av(ROI_av==0) = nan;
                d_t = nanmean(ROI_av);
                d = d_t(~isnan(d_t));
                d       = smooth(smooth(diff(d),20));
                [~, m]  = min(d(ceil(ROI_width_temp/4):end-10));
                m       = ceil(ROI_width_temp/4) - 1 + m;
            else disp('Membrane detection mode not known.')
            end
            if m < innerCircle || m > outerCircle
                m = NaN;
            end
            outline_point       = [m+midpoint_r(1),midpoint_r(2), 1]';
            outline_point_orig  = M_cc \ outline_point;
            dist_mid{jj}(i)     = m;
            outline{jj}(i, :)   = outline_point_orig(1:2);
        R{i} = MergeBuff_r;
        M{i} = midpoint_r;
        x_t{i} = x_top;
        y_t{i} = y_top;
        x_b{i} = x_bot;
        y_b{i} = y_bot; 
        end
    else disp([mode, ' is not a known segmentation mode.']);
    end
end

end

