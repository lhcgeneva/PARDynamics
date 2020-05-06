        function maxFFTNorm = kick_out( Fit, PLOT )
%FOURIER_KICK_OUT Kicks out fit based on fourier transform of residuals
%   Only takes into account residuals of gradient area. Tries to find
%   systematic variations by performing an FFT and looking for the largest
%   value in the spectrum.

% Fourier Transformation kick out
    r = Fit.curve(1:length(Fit.fitData))-Fit.fitData';
    c = Fit.curve.c;
    s = Fit.curve.s;
    try 
        r = r(round(c-s/2):round(c+s/2));
        s = smooth(r, 20);
        s = (s-mean(s))/(max(abs(s))-mean(s));
        fftrans = abs(fft(s));
        %Only use half the first half, to make sure short wavelengths are not
        %taken into account (last peaks in spectrum in below plot)
        maxFFTNorm = max(fftrans(1:round(length(fftrans)/2)));
        Fit.maxFFTNorm = maxFFTNorm;    
        if PLOT
            figure; hold on;
            yyaxis left
            plot(s);
            yyaxis right
            plot(abs(fft(s)));
            pause()
            close;
        end
    catch ME
        if (strcmp(ME.identifier,'MATLAB:badsubscript'))
        disp(['S (', num2str(Fit.curve.s), ') C (', num2str(Fit.curve.c),...
            ') not fully in graph, setting nan']);
        Fit.maxFFTNorm = nan;
        maxFFTNorm = nan;
        end
    end
    
% Autocorrelation kick out
    res = Fit.out.residuals;
    % Only use the upper half of the gradient, lower half is usually better
    % fit anyway
    auto = autocorr(res(round(length(res)/2):end));
    [f, gof] = fit((0:length(auto)-1)', auto, 'exp(-x/b)', 'StartPoint', 0.2, ...
        'Lower', 0.1, 'Upper', 20);
    Fit.autoCorrHalfTime = f.b;
    if PLOT
        figure;  hold on;
        plot((0:length(auto)-1)',auto);
        plot(f);
        t = text(10, 0.9,{['rsqur:', num2str(gof.sse)], ['l_2 = ', num2str(f.b)]});
        t.FontSize = 14;
        legend('off')
    end
    
% Kicking out based on rsqu
    c = Fit.curve.c;
    s = min(2*Fit.curve.s, 2*min(c-2, length(Fit.fitData)-c-2));
    left = c-s/2;
    right = c+s/2;
    diff_Fit_Data = Fit.fitData' - ...
    Fit.curve(1:length(Fit.fitData));
    diff_Fit_Data = diff_Fit_Data(ceil(left):floor(right));
    fitDataWindow = Fit.fitData(ceil(left):floor(right));
    Fit.rsqu = 1 - sumsqr(diff_Fit_Data) / sumsqr(fitDataWindow-mean(fitDataWindow));
    
%Combine all measures 
    if Fit.maxFFTNorm < Fit.fftThresh && Fit.autoCorrHalfTime < Fit.autoCThresh...
            && Fit.rsqu > Fit.rsquThresh
        Fit.sigmaInMicrons = Fit.curve.s * Fit.pixelSize;
    else
        Fit.sigmaInMicrons = nan;
    end

end

