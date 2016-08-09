function [s, sumRsqu] = fit_all_simul(Mo)
%fit_all_simul Takes all the movie's data and tries to fit one and the same
%sigma to all curves, to see how much the residuals vary.
    centered_stack = Mo.center_stack(Mo.Seg.Imr_s{2});
    [side1, side2]  = Mo.cut_sides(centered_stack);
    sorted1 = cellfun(@(x) sort(x, 1, 'descend'), side1, 'UniformOutput', false);
    sorted2 = cellfun(@(x) sort(x, 1, 'descend'), side2, 'UniformOutput', false);
    side1_int = cellfun(@(x) mean(x(1:3, :), 1), sorted1, 'UniformOutput', false);
    side2_int = cellfun(@(x) mean(x(1:3, :), 1), sorted2, 'UniformOutput', false);
    s = fminsearch(@(x) obj_func(x, side1_int), 10);
    sumRsqu = obj_func(s, side1_int);
end

function sumRsqur = obj_func(s, int_cell)
    for i = 1:length(int_cell)
        if mean(int_cell{i}(1:end-round(length(int_cell{i})/2)))...
                >mean(int_cell{i}(end-round(length(int_cell{i})/2):end))
            int_cell{i} = fliplr(int_cell{i});
        end
        sortedProfile = sort(int_cell{i});
        data_max = mean(sortedProfile(end-round(length(sortedProfile)/20):end));
        data_min = mean(sortedProfile(1:round(length(sortedProfile)/20)));
        diff_temp = data_max - data_min;
        min_inds = int_cell{i}<data_min;
        min_vals = int_cell{i}(min_inds);
        if isempty(min_vals); min_vals = data_min; end
        mean_min = mean(min_vals);
        if isnan(mean_min) && data_min == 0; mean_min = 0; end
        [~, middle_index] = min(abs(int_cell{i}-diff_temp/2-mean_min));
        fo = fitoptions('Method','NonlinearLeastSquares',... %+1 in upper limit if mean_min == 0, cause then upper and lower boundary would be the same
       'Lower',[0, -2000, -length(int_cell{i})],...
       'Upper',[1.1 * (mean_min + 1), 2* diff_temp, length(int_cell{i})],...           
        'StartPoint',[mean_min diff_temp/2 middle_index]);
        ft = fittype('(a+b/2) + b/2*(erf((x-c)*sqrt(2)/s))', 'problem', 's', 'options', fo);
        [curve, gof] = fit((1:length(int_cell{i}))', double(int_cell{i}'), ft, 'problem', s);
        Curve{i} = curve;
        GOF{i} = gof;
    end
    sumRsqur = -sum(cell2mat(cellfun(@(x) GOF{i}.rsquare, GOF, 'UniformOutput', false)));
end
      