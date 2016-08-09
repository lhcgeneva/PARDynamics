function correct_segmentation( Seg, sliceNum, IsPropagated, stand_alone )
%CORRECT_SEGMENTATION Displays segmentations, lets user make corrections
%   Creates draggable points from outline lets user correct positions 
EXIT = 0; 
if nargin == 4
    for jj = 1 : Seg.sz_all(3)
        segment(IsPropagated);
        if EXIT; break; end
    end
    close all;
elseif nargin == 3 
    jj = sliceNum;
    segment(IsPropagated);
else disp('Wrong number of input parameters.');
end

function segment(IsPropagated)
    x = Seg.thresh_corr{jj}(:, 1);
    y = Seg.thresh_corr{jj}(:, 2);
    imshow(Seg.MergeBuff{jj}, []);
    hold on;
    i = 1;
    h = {};
    if IsPropagated == 2
        sc = scatter(Seg.thresh_corr{jj}(:, 1), Seg.thresh_corr{jj}(:, 2), 'red', 'filled');
        plot(Seg.midpoint{jj}(1), Seg.midpoint{jj}(2), 'g.', 'MarkerSize', 20);
        freeHandSelectionHandle = imfreehand('Closed', false);
        bds = freeHandSelectionHandle.getPosition;
        %%%
%         theta_list = 0:2*pi/Seg.seg_prec:2*pi;
%         thetas_freehand = zeros(length(bds), 1);
%         abs_X = abs(Seg.midpoint{jj}(1) - bds(:, 1));
%         abs_Y = abs(Seg.midpoint{jj}(2) - bds(:, 2));
%         angles = atan(abs_Y./abs_X);
%         for i = 1:length(bds(:, 1))
%             if bds(i, 1) >= Seg.midpoint{jj}(1) && bds(i, 2) <= Seg.midpoint{jj}(2)
%                 thetas_freehand(i) = angles(i);
%             elseif bds(i, 1) < Seg.midpoint{jj}(1) && bds(i, 2) <= Seg.midpoint{jj}(2)
%                 thetas_freehand(i) = pi - angles(i);
%             elseif bds(i, 1) < Seg.midpoint{jj}(1) && bds(i, 2) > Seg.midpoint{jj}(2)
%                 thetas_freehand(i) = pi + angles(i);
%             elseif bds(i, 1) >= Seg.midpoint{jj}(1) && bds(i, 2) > Seg.midpoint{jj}(2)
%                 thetas_freehand(i) = 2*pi - angles(i);
%             else
%                 disp('Something wrong in correct_segmentation.');
%             end
%         end
        
        %inds contains indices of bins in which each element of 
        %theta_freehand can be found
%         inds = discretize(thetas_freehand, theta_list); 
%         u = unique(inds);
        %For very fine segmentations sometimes there can be jumps of more
        %than one interval, so none of the angles segmented actually fits
        %for a specific interval. This point will then appear unchanged.
%         x_free = bds(:, 1);
%         y_free = bds(:, 2);
        temp_thresh = Seg.thresh_corr{jj};
        x_mid = Seg.midpoint{jj}(1);
        y_mid = Seg.midpoint{jj}(2);
        for i = 1:length(Seg.thresh_corr{jj});
            try
                %%%Calculate point on the line midpoint-radial point which
                %%%is for sure outside the cell membrane.
                x_corr = Seg.thresh_corr{jj}(i, 1);
                y_corr = Seg.thresh_corr{jj}(i, 2);
                m = (y_mid-y_corr)/(x_mid-x_corr);
                n = y_corr-m*x_corr;
                if x_corr>x_mid
                    x_extrapolate = 1000000;
                    y_extrapolate = m*x_extrapolate + n;
                elseif x_corr<x_mid
                    x_extrapolate = -1000000;
                    y_extrapolate = m*x_extrapolate + n;
                end
                [xtemp, ytemp] = polyxpoly([x_mid, x_extrapolate], ...
                            [y_mid, y_extrapolate],...
                            bds(:, 1),bds(:, 2));
                if ~isempty(xtemp)
                    xi(i) = xtemp(1);
                    yi(i) = ytemp(1);
                else
                    xi(i) = NaN;
                    yi(i) = NaN;
                end
            catch
                xi(i) = NaN;
                yi(i) = NaN;
            end
        end
        Seg.thresh_corr{jj}(~isnan(xi),1) = xi(~isnan(xi));
        Seg.thresh_corr{jj}(~isnan(yi),2) = yi(~isnan(yi));
        
%         for i = 1:length(u)
%             index = length(Seg.thresh_corr{jj}(:, 1))+1 - u(i);
%             Seg.thresh_corr{jj}(index, 1) = mean(x_free(inds == u(i)));
%             Seg.thresh_corr{jj}(index, 2) = mean(y_free(inds == u(i)));
%             %In case point i did not change (due to above fine segmentation
%             %issue) interpolate between neighboring points!
%         end
%         for i = 1:length(u)
%             index = length(Seg.thresh_corr{jj}(:, 1))+1 - u(i);
% %             if all(Seg.thresh_corr{jj}(index, :) == temp_thresh(index, :))% && i ~= 1 && i ~= length(u)
% %                 Seg.thresh_corr{jj}(index, 1) = (x_temp(i+1) + x_temp(i-1))/2;
% %                 Seg.thresh_corr{jj}(index, 2) = (y_temp(i+1) + y_temp(i-1))/2;
% %                 disp(['1', num2str(i)]);
% %             end
% %             if Seg.thresh_corr{jj}(index, 1) - temp_thresh(index, 1) ==0
% %                 disp(['2', num2str(i)]);
% %             end
%             try
%                 if Seg.thresh_corr{jj}(index, 1) == temp_thresh(index, 1) || Seg.thresh_corr{jj}(index, 2) == temp_thresh(index, 2)% && i ~= 1 && i ~= length(u)
%                     Seg.thresh_corr{jj}(index, 1) = NaN%(x_temp(i+1) + x_temp(i-1))/2;
%                     Seg.thresh_corr{jj}(index, 2) = NaN%(y_temp(i+1) + y_temp(i-1))/2;
%                     disp(['1', num2str(i)]);
%                 end
%             catch
%                 'Try again!'
%             end
%         end
        delete(sc);
        scatter(Seg.thresh_corr{jj}(:, 1), Seg.thresh_corr{jj}(:, 2), 'red', 'filled');
        unequal_inds = temp_thresh(:, 1) ~= Seg.thresh_corr{jj}(:, 1);
        for i = jj+1:length(Seg.thresh_corr{jj}(:, 1))
            Seg.thresh_corr{i}(unequal_inds, :) = Seg.thresh_corr{jj}(unequal_inds, :);
        end
        %%%
%         bds = bwboundaries(freeHandSelectionHandle.createMask);
%         res = ceil(length(bds(:, 1))/Seg.seg_prec);
%         Seg.thresh_corr{jj} = fliplr(bds(1:res:end, :));
    elseif IsPropagated == 1 || IsPropagated == 0
        scatter(Seg.thresh_final{jj}(:, 1), Seg.thresh_final{jj}(:, 2), 'yellow', 'filled');
        scatter(x, y, 20, 'red', 'filled');
        plot(Seg.midpoint{jj}(1), Seg.midpoint{jj}(2), 'g.', 'MarkerSize', 20);
        try      
            while 1
                [u,v] = ginput(1);
                if u < 0; break; end;
                if v < 0; EXIT = 1; break; end;
                if v > Seg.sz_all(2)
                    Seg.thresh_corr(jj:end) = Seg.thresh_final(jj:end);
                    x = Seg.thresh_corr{jj}(:, 1);
                    y = Seg.thresh_corr{jj}(:, 2);
    %                 clf;
                    imshow(Seg.MergeBuff{jj}, []);
                    hold on;
                    scatter(x, y, 20, 'red', 'filled');
                    plot(Seg.midpoint{jj}(1), Seg.midpoint{jj}(2), 'g.', 'MarkerSize', 20);
                    i = 1;
                    h = {};
                    [u,v] = ginput(1);
                end
                [~, ind] = min(hypot(x-u,y-v));
                h(i).handle = impoint(gca, x(ind), y(ind));
                h(i).index  = ind;
                i = i + 1;
            end
            if EXIT; return; end
            pause;
        catch
            disp('Manual correction interrupted.');
        end
    end
    if ~isempty(h)
        for i = 1:length(h)
            Seg.thresh_corr{jj}(h(i).index, :) = h(i).handle.getPosition();
            if IsPropagated
                try
                    for j = 1:length(Seg.thresh_corr)-jj
                        d = hypot(Seg.thresh_corr{jj}(h(i).index, 1) - Seg.thresh_corr{jj+j}(h(i).index, 1),...
                                Seg.thresh_corr{jj}(h(i).index, 2) - Seg.thresh_corr{jj+j}(h(i).index, 2));
                        if d > 2.5 || isnan(d)
                            Seg.thresh_corr{jj+j}(h(i).index, :) = Seg.thresh_corr{jj}(h(i).index, :);
                        end
                    end
                catch
                    disp('End of stack reached');
                end
            end
        end
    end 
end

end

