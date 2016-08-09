function [norm_slope, ind_mid, residuals] = calc_slope(intensity, winSize, polynomialOrder, DOPLOT, ax)
try
    intensity   = intensity-min(intensity);
    sortedInt   = sort(intensity, 'ascend');
    lowerAvg    = mean(sortedInt(1:round(winSize/2)));
    upperAvg    = mean(sortedInt(end-round(winSize/2):end));
    middle      = (lowerAvg+upperAvg)/2;
    filtered    = sgolayfilt(double(intensity), polynomialOrder, winSize);
    filtered    = sgolayfilt(double(filtered), polynomialOrder, winSize);
    diff_filt   = diff(filtered);
    diff_filt_nan = diff_filt;
    diff_filt_nan(1:round(winSize/4)) = nan;
    diff_filt_nan(end-round(winSize/4):end) = nan;
    logic = filtered(1:end-1)<1.2*middle;
    diff_filt_nan(logic<1) = nan;
    [~,ind_mid] = max(diff_filt_nan);
    norm_slope  = diff_filt(ind_mid)/(filtered(ind_mid)+filtered(ind_mid+1))*2;
%     residuals = filtered(max([ind_mid-winSize, 1]):min([ind_mid+winSize, length(filtered)]))-...
%                 intensity(max([ind_mid-winSize, 1]):min([ind_mid+winSize, length(filtered)]));
    try     
        residuals = filtered(ind_mid-round(winSize/4):ind_mid+round(winSize/4))-...
                intensity(ind_mid-round(winSize/4):ind_mid+round(winSize/4));
    catch
        residuals = nan(1, 2*round(winSize/4)+1);
        disp('Residuals set to nan');
    end
    if DOPLOT
        if nargin == 5
            axes(ax);
        else
            f = figure; hold on;
        end
        plot(intensity/max(intensity), 'LineWidth', 2); 
        plot(filtered/max(intensity), 'LineWidth', 2);
        plot(diff_filt_nan/max(diff_filt_nan), 'LineWidth', 2);
        plot([ind_mid, ind_mid], [0, 2], 'LineWidth', 2);
        xdata = (1:length(intensity));
        diff1 = diff(filtered/max(intensity));
        [x1, y1] = polyxpoly([ind_mid, ind_mid], [0, 2], 1:length(filtered),...
            filtered/max(intensity));
        ydata = diff1(ind_mid)*xdata+y1-x1*diff1(ind_mid);
        plot(xdata(ind_mid-30:ind_mid+30), ydata(ind_mid-30:ind_mid+30), 'LineWidth', 3);
        plot([0, length(intensity)], [middle, middle]);
        axis([0, length(intensity), -0, 1]);    
%         pause()
        close(f);
    end
catch
    disp('No slope calculated, setting all outputs to nan.');
    norm_slope  = nan;
    ind_mid     = nan;
    residuals   = nan;
end
end