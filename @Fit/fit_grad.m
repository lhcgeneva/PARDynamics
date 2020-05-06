function [gof, curve, out, error_code, mean_min, data_max, data_min,...
          curve_Nate, gof_Nate, data_Nate] = ...
          fit_grad( fitData, fitType, showGraphs, pixelSize, secondRound )
%FIT_GRAD Fits gradient using specified method ('sigma' or 'err')
%   To implement: comparison between Nate/my method

    %   Find right starting values for fit
    error_code = 1; %Returned to invoking function if no error in fit
    if strcmp(fitType, 'ErrSavGol') || strcmp(fitType, 'err_domain_size_SavGol')
        fitData = sgolayfilt(double(fitData), 5, 2*round(5/(pixelSize*2))+1);
    end
    Profile = fitData;
    sortedProfile = sort(Profile);
    data_max = mean(sortedProfile(end-round(length(sortedProfile)/20):end));
    
    data_min = mean(sortedProfile(1:round(length(sortedProfile)/20)));
    
    diff_temp = data_max - data_min;
    
    min_inds = Profile<data_min;
    min_vals = Profile(min_inds);
    if isempty(min_vals); min_vals = data_min; end
    mean_min = mean(min_vals);
    if isnan(mean_min) && data_min == 0; mean_min = 0; end
    fitdata = Profile(:);
    [~, middle_index] = min(abs(fitData-diff_temp/2-mean_min));
%%  Lars' fit
%   First round of fitting
    if strcmp(fitType, 'sigma')
        if strcmp(showGraphs, 'on'); disp('Fitting sigma function'); end
        %   Fitoptions
        fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[-Inf -Inf, -Inf, -Inf],...
               'Upper',[Inf Inf, Inf, Inf],...
               'StartPoint',[-diff_temp 1 round(length(fitdata)/2) mean_min]);
        ft = fittype('a*sigmf(x, [b,c]) + d','options',fo);
    elseif strcmp(fitType, 'err') || strcmp(fitType, 'ErrSavGol')
        if strcmp(showGraphs, 'on'); disp('Fitting error function'); end
        %   Fitoptions
        fo = fitoptions('Method','NonlinearLeastSquares',... %+1 in upper limit if mean_min == 0, cause then upper and lower boundary would be the same
               'Lower',[0, -2000, -length(fitdata), -Inf],...
               'Upper',[1.1 * (mean_min + 1), 2* diff_temp, length(fitdata), Inf],...           
                'StartPoint',[mean_min diff_temp/2 middle_index 5]);%round(length(fitdata)/2)
        ft = fittype('(a+b/2) + b/2*(erf((x-c)*sqrt(2)/s))', 'options', fo);
        plot_func = @(x) (mean_min + diff_temp/2) + diff_temp/2*(erf((x-middle_index)*sqrt(2)/5));
    elseif strcmp(fitType, 'err_domain_size') || strcmp(fitType, 'err_domain_size_SavGol')
    if strcmp(showGraphs, 'on'); disp('Fitting error function'); end
    %   Fitoptions
    middle_index = round(length(fitdata)*0.6);
    fo = fitoptions('Method','NonlinearLeastSquares',... %+1 in upper limit if mean_min == 0, cause then upper and lower boundary would be the same
           'Lower',[0, -2000, -length(fitdata), -Inf],...
           'Upper',[1.1 * (mean_min + 1), 2* diff_temp, length(fitdata), Inf],...           
            'StartPoint',[mean_min diff_temp/2 middle_index 5]);%round(length(fitdata)/2)
    ft = fittype('(a+b/2) + b/2*(erf((x-c)*sqrt(2)/s))', 'options', fo);
    plot_func = @(x) (mean_min + diff_temp/2) + diff_temp/2*(erf((x-middle_index)*sqrt(2)/5));
    else
        disp('Fittype not supported')
    end
%     fo = fitoptions() Use only, if no fitoptions should be specified in
%     the final round of fitting
    [curve, gof, out] = fit((1:length(fitdata))', double(fitdata), ft);
    %   [curve, gof] = fit((1:length(fitdata))', fitData, ft);
%   Plot fit and data 
    if strcmp(showGraphs, 'on')
        j = figure;
        title('Fit Lars')
        set(j, 'visible', showGraphs);
        hold on;
        plot(plot_func(1:length(fitdata))); 
        pause(0.1);
        plot(fitData);
        plot(curve, 'g');
        hold off; 
        pause();
    end

%   Second round of fitting fixing upper and lower points
if nargin == 5 && secondRound == 0
    disp('Second round not fit.');
else
    try
        if strcmp(fitType, 'sigma')
            if strcmp(showGraphs, 'on'); disp('Fitting sigma function'); end
            %   Fitoptions
            fo = fitoptions('Method','NonlinearLeastSquares',...
                   'Lower',[-Inf -Inf, -Inf, -Inf],...
                   'Upper',[Inf Inf, Inf, Inf],...
                   'StartPoint',[-diff_temp 1 round(length(fitdata)/2) mean_min]);
            ft = fittype('a*sigmf(x, [b,c]) + d','options',fo);
        elseif strcmp(fitType, 'err')|| strcmp(fitType, 'ErrSavGol')
            if strcmp(showGraphs, 'on'); disp('Fitting error function'); end
            %   Fitoptions
            fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0.9 * mean_min, 0, -length(fitdata), -Inf],...
               'Upper',[1.1 * mean_min, 1 * diff_temp, length(fitdata), Inf],...
                   'StartPoint',[curve.a curve.b curve.c curve.s]);

               ft = fittype('(a+b/2) + b/2*(erf((x-c)*sqrt(2)/s))', 'options', fo);
        end

        warning('off', 'curvefit:cfit:subsasgn:coeffsClearingConfBounds');
        if strcmp(fitType, 'err'); curve.s = abs(curve.s); end; %Absolute value of sigma!!!
        x = 1:length(fitdata);
        try
            k = find(x < curve.c + 2*round(10/pixelSize)+1 &...
                     x > curve.c - 2*round(10/pixelSize)+1);
           % Only fit lower half of the curve
%             k = find(x < curve.c &...
%                      x > curve.c - 1.5*round(10/pixelSize)+1);
        catch
            k = find(x < curve.c + sqrt(2)*curve.s & x > curve.c - sqrt(2) * curve.s);
            disp('caught');
        end
        [curve, gof, out] = fit(x(k)', double(fitdata(k)), ft);
        warning('on', 'curvefit:cfit:subsasgn:coeffsClearingConfBounds');
        if strcmp(showGraphs, 'on'); disp(curve); end
        
        %Plot fit and fitted data in same graph as before (figure j)
        if strcmp(showGraphs, 'on')
            disp(curve.s);
            hold on;
            plot(x(k)', double(fitdata(k)));
            plot(curve, 'k');
            hold off;
            pause(); 
            close all;
        end
    catch err
        disp(['Second round of fitting unsuccessfull.', err.identifier]);  
        error_code = 0;
        gof.rsquare = nan;
    end
end
%% Nate's fitting procedure CORRECTS FOR PIXEL SIZE ALREADY HERE, uses raw data
%     The fit results between the procedure here and Nate's original code
%     differ slightly (<0.5% normally), because in Nate's loadmultitif
%     images are read in and converted to integers for historic matlab
%     reasons
if 0
    P2 = Profile/mean(Profile);
    Length = (1:length(P2))*pixelSize;
    Distance(1:length(Length)) = Length;
    notnan = ~isnan(P2);
    P2 = P2(notnan);
    x = Distance(notnan);

    P2s = smooth(P2, 100);
    maxlimit = sort(P2s, 'descend');
    minlimit = sort(P2s, 'ascend');
    try
        half = (mean(maxlimit(1:50))-mean(minlimit(1:50)))/3+mean(minlimit(1:50));
    catch
        half = (mean(maxlimit(1:10))-mean(minlimit(1:10)))/3+mean(minlimit(1:10));
        disp(['Exception in Nates fitting method, length(maxlimit) < 50.', ...
        'This occurs in simulations if length(fitdata) is too small.']);
    end
    [~, halfpos] = min(abs(P2s-half));

    maxlimita = mean(maxlimit(1:round(length(x)/20)))-mean(minlimit(1:round(length(x)/20)));
    maxc = max(x);

    k = (halfpos - floor(length(x)/5)):(halfpos + floor(length(x)/5));    

    try
        EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
        EFitOpts =   fitoptions(EFit);
        set(EFitOpts,'StartPoint',[1 1 halfpos 0.5]);
        set(EFitOpts,'Upper',[maxlimita 2 max(x(k)) 1]);
        set(EFitOpts,'Lower',[0 0 min(x(k)) -1]);        
        [EFitRes, ~] = fit(x(k)',P2s(k),EFit,EFitOpts);

    %   Plot fit and data  
        if strcmp(showGraphs, 'on'); 
            jj = figure;
            title('Fit Nate')
            set(jj, 'visible', showGraphs);
            hold on;
            pause(0.1);     
            plot(x(k)', P2s(k));
            plot(x(k)', P2(k));
            plot(EFitRes, 'g');
            hold off; 
        end

        k = find((x > (EFitRes.c-(2/(abs(EFitRes.m)))) & ( x <(EFitRes.c+(2/abs(EFitRes.m))))));

        EFitOpts =   fitoptions(EFit);
        set(EFitOpts,'StartPoint',[EFitRes.a EFitRes.b EFitRes.c EFitRes.m]);
        set(EFitOpts,'Upper',[maxlimita 2 maxc 1]);
        set(EFitOpts,'Lower',[0 0 0 -1]);
        [curve_Nate, gof_Nate] = fit(x(k)',double(P2(k)'),EFit,EFitOpts);  
        data_Nate = P2(k);

    %   Plot fit and fitted data in same graph as before (figure jj)
        if strcmp(showGraphs, 'on'); 
            hold on;
            plot(Distance, P2);
            plot(x(k)', double(P2(k)'));
            plot(curve_Nate, 'k');
            pause(0.1); 
            close gcf;
        end
    catch err
        disp(err.identifier); 
        curve_Nate.a = NaN;
        curve_Nate.b = NaN;
        curve_Nate.c = NaN;
        curve_Nate.m = NaN;
        gof_Nate = NaN;
        data_Nate = NaN;
        error_code = 0;
    end
else
        curve_Nate.a = NaN;
        curve_Nate.b = NaN;
        curve_Nate.c = NaN;
        curve_Nate.m = NaN;
        gof_Nate = NaN;
        data_Nate = NaN;
end
end

