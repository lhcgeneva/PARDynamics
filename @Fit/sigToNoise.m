function [SNR, heightDiff] = sigToNoise( Fit )
%sigToNoise Calculates signal to noise ratio 
%   Uses moving standard deviation (John D'Errico) to compute ratio between
%   noise level and signal (i.e. gradient height).
    fD = Fit.fitData;
    avSTD = mean(movingstd(fD, 10));
%     heightDiff = Fit.curve.b/2; Use if height difference should be
%     calculated by the fit, not by the data.
    sorted = sort(fD, 'ascend');
    lFD = length(fD);
%     heightDiff = mean(sorted(end-round(0.1*lFD): end)) - ...
%                     mean(sorted(1 : 1+round(0.1*lFD)));
    [~, maxInd] = max(smooth(fD));
    [~, minInd] = min(smooth(fD));
    windowSizeHalf = round(0.05 * lFD);
    left_l = minInd - windowSizeHalf;
    if left_l < 1; left_l = 1; end
    right_l = left_l + 2*windowSizeHalf;
    right_u = maxInd + windowSizeHalf;
    if right_u > length(fD); right_u = length(fD); end
    left_u  = right_u - 2*windowSizeHalf;
    try
        heightDiff = mean(fD(left_u:right_u)) - ...
                    mean(fD(left_l:right_l));
%     heightDiff = mean(fD(end-round(0.2*lFD): end)) - ...
%                     mean(fD(1 : 1+round(0.1*lFD)));
        SNR = heightDiff / avSTD;
    catch
        heightDiff = NaN;
        SNR = NaN;
        disp('SNR not calculated, probably indexing problem in sigToNoise()');
    end
    
% This is a trial for calculating the upper and lower percentage that 
% should be used in the above algorithm. Problems are encountered when
% the gradient takes up so much of fitData (fD) that by taking the upper
% and lower x% values the data is actually taken from the gradient, 
% therefore underestimating the height difference.
%     for i = 1:length(fD)-100
%         m(i) = fit_linear(fD(i:i+99));
%     end
%     plot(m)
%     function m = fit_linear(fitData)
%         F = fit((1:length(fitData))', fitData', 'poly1');
%         m = F.p1;
%     end

end

