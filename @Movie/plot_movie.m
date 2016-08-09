function plot_movie( Mov )
%PLOT_MOVIE Plots all gradients and their fits using tight subplots
    
%Plot Fit1
numSubPlots = length(Mov.Side1);
dimNumR = ceil(sqrt(numSubPlots));
if dimNumR * (dimNumR - 1) >= numSubPlots
    dimNumC = dimNumR -1;
else
    dimNumC = dimNumR;
end

figure;
ts =  tight_subplot(dimNumR, dimNumC, 0.01, 0.01, 0.01);
counter = 1;
max_length = max(cell2mat(cellfun(@(x) length(x.fitData), cellfun(@(x) x, [Mov.Side1, Mov.Side2],...
                    'UniformOutput', false), 'UniformOutput', false)));
max_height = max(cell2mat(cellfun(@(x) max(x.fitData), cellfun(@(x) x, [Mov.Side1, Mov.Side2],...
                    'UniformOutput', false), 'UniformOutput', false))); 
min_height = min(cell2mat(cellfun(@(x) min(x.fitData), cellfun(@(x) x, [Mov.Side1, Mov.Side2],...
                    'UniformOutput', false), 'UniformOutput', false))); 

for i = 1 : dimNumR
    for j = 1 : dimNumC
        axes(ts(counter));
        axis([0 max_length min_height max_height]);
        hold on;
        Fit1 = Mov.Side1{counter};
        if strcmp(Mov.segmentationMode, 'MAT2')
            plot(double(Fit1.fitData));
            plot(Fit1.curve);
            max_x = length(Fit1.fitData);
            max_y = max(Fit1.fitData);
            min_y = min(Fit1.fitData);
            c = Fit1.curve.c;
            s = min(2*Fit1.curve.s, 2*min(c-2, length(Fit1.fitData)-c-2));
            left = c-s/2;
            right = c+s/2;
            a = patch([left, right, right, left], ...
            [min_height, min_height, max_height, max_height], 1);
            alpha(a, 0.2);
            if isnan(Fit1.sigmaInMicrons)
                alpha(a, 0.7); 
            end
            a.EdgeColor = 'none';
            SNR = num2str(Fit1.SNR);
            gradient_length = num2str(Fit1.curve.s*Mov.pixelSize);
        else
            plot(Fit1.intensity);
            plot(Fit1.Grad_Fit.curve);
            max_x = length(Fit1.intensity);
            max_y = max(Fit1.intensity);
            min_y = min(Fit1.intensity);
            SNR = num2str(Mov.Fit1.Grad_Fit.SNR);
        end
        legend('off');
        %Put signal to noise ratio in graph
        y_m = (max_y + 2*min_y)/3; %Weighting minimum more for position
        t = text(double(max_x-0.35*max_x),  double(y_m),{['SNR:', SNR],...
                                ['L = ', gradient_length],...
                                ['RsquTot = ', num2str(Fit1.gof.rsquare)],...
                                ['RsquWind = ' num2str(Fit1.rsqu)],...
                                ['FFTWind = ' num2str(Fit1.maxFFTNorm)],...
                                ['t1/2 = ' num2str(Fit1.autoCorrHalfTime)]});
        t.FontSize = 12;
        t.FontWeight = 'bold';
        counter = counter + 1;
        if counter > numSubPlots; break; end;
    end
end
% Plot Fit2 if available
if ~isempty(Mov.Side2)
    numSubPlots = length(Mov.Side2);
    dimNumR = ceil(sqrt(numSubPlots));
    if dimNumR * (dimNumR - 1) >= numSubPlots
        dimNumC = dimNumR -1;
    else
        dimNumC = dimNumR;
    end

    figure;
    ts =  tight_subplot(dimNumR, dimNumC, 0.01, 0.01, 0.01);
    counter = 1;
    for i = 1 : dimNumR
        for j = 1 : dimNumC
            axes(ts(counter));
            axis([0 max_length min_height max_height]);
            hold on;
            Fit2 = Mov.Side2{counter};
            if strcmp(Mov.segmentationMode, 'MAT2')
                plot(Fit2.fitData);
                plot(Fit2.curve);
                max_x = length(Fit2.fitData);
                max_y = max(Fit2.fitData);
                min_y = min(Fit2.fitData);
                %PATCH OVER GRADIENT AREA
                c = Fit2.curve.c;
                s = min(2*Fit2.curve.s, 2*min(c-2, length(Fit2.fitData)-c-2));
                left = c-s/2;
                right = c+s/2;
                a = patch([left, right, right, left], ...
                [min_height, min_height, max_height, max_height], 1);
                alpha(a, 0.2);
                if isnan(Fit2.sigmaInMicrons)
                    alpha(a, 0.7); 
                end
                a.EdgeColor = 'none';
                SNR = num2str(Fit2.SNR);
                gradient_length = num2str(Fit2.curve.s*Mov.pixelSize);
            else
                plot(Fit2.intensity);
                plot(Fit2.Grad_Fit.curve);
                max_x = length(Fit2.intensity);
                max_y = max(Fit2.intensity);
                min_y = min(Fit2.intensity);
                SNR = num2str(Fit2.Grad_Fit.SNR);
            end
            legend('off');
            %Put signal to noise ratio in graph
            y_m = (max_y + 2*min_y)/3; %Weighting minimum more for position
            t = text(double(max_x-0.35*max_x), double(y_m),{['SNR:', SNR],...
                                ['L = ', gradient_length],...
                                ['RsquTot = ', num2str(Fit2.gof.rsquare)],...
                                ['RsquWind = ' num2str(Fit2.rsqu)],...
                                ['FFTWind = ' num2str(Fit2.maxFFTNorm)],...
                                ['t1/2 = ' num2str(Fit1.autoCorrHalfTime)]});
            t.FontSize = 12;
            t.FontWeight = 'bold';
            counter = counter + 1;
            if counter > numSubPlots; break; end;
        end
    end
end

end

