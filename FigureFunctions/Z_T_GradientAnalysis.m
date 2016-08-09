%%  Get Movies from Segmentations
pixel_size_0255 = 0.255;
pixel_size_0124 = 0.124;
pixel_size_0155 = 0.155;
%%
for i = 1:20
%     try Mo_Segs_P0_15_12_05(i)     = Movie(Segs_P0_15_12_05{i}, 'MAT2', 'off', pixel_size_0124); end
%     try Mo_Segs_P0_BIG1_DONOTASSIGNSIDES(i)         = Movie(Segs_P0_BIG1{i}, 'MAT2', 'off', pixel_size_0255, 1); end
%     try Mo_Segs_P0_ima3(i)         = Movie(Segs_P0_ima3{i}, 'MAT2', 'off', pixel_size_0124); end
%     try Mo_Segs_P1_15_12_05(i)     = Movie(Segs_P1_15_12_05{i}, 'MAT2', 'off', pixel_size_0124); end
%     try Mo_Segs_P1_BIG1(i)         = Movie(Segs_P1_BIG1{i}, 'MA   T2', 'off', pixel_size_0255); end
%     try Mo_Segs_P1_ima3(i)         = Movie(Segs_P1_ima3{i}, 'MAT2', 'off', pixel_size_0124); end
%     try Mo_Segs_P2_wt_Good(i)      = Movie(Segs_P2_wt_Good{i}, 'MAT2', 'off', pixel_size_0124); end
%     try Mo_Segs_P3_wt_ReallyGood(i) = Movie(Segs_P3_wt_ReallyGood{i}, 'MAT2', 'off', pixel_size_0124); end
%     try Mo_Segs_P1_wt_Diss(i) = Movie(Segs_laser_diss_P1{i}, 'MAT2', 'off', pixel_size_0155); end
    try Mo_Segs_P0_16_07_14_CRISPR(i)         = Movie(Segs_P0_16_07_14_CRISPR{i}, 'MAT2', 'off', pixel_size_0124, 1); end
end
%%
for i = 1:20
    try Mo_Segs_P0_15_12_05_red(i)     = Movie(Segs_P0_15_12_05{i}, 'MAT2', 'off', pixel_size_0124); end
    try Mo_Segs_P0_BIG1_red(i)         = Movie(Segs_P0_BIG1{i}, 'MAT2', 'off', pixel_size_0255); end
    try Mo_Segs_P0_ima3_red(i)         = Movie(Segs_P0_ima3{i}, 'MAT2', 'off', pixel_size_0124); end
    try Mo_Segs_P1_15_12_05_red(i)     = Movie(Segs_P1_15_12_05{i}, 'MAT2', 'off', pixel_size_0124); end
    try Mo_Segs_P1_BIG1_red(i)         = Movie(Segs_P1_BIG1{i}, 'MAT2', 'off', pixel_size_0255); end
    try Mo_Segs_P1_ima3_red(i)         = Movie(Segs_P1_ima3{i}, 'MAT2', 'off', pixel_size_0124); end
    try Mo_Segs_P2_wt_Good_red(i)      = Movie(Segs_P2_wt_Good{i}, 'MAT2', 'off', pixel_size_0124); end
    try Mo_Segs_P3_wt_ReallyGood_red(i) = Movie(Segs_P3_wt_ReallyGood{i}, 'MAT2', 'off', pixel_size_0124); end
    try Mo_Segs_P1_wt_Diss_red(i)       = Movie(Segs_laser_diss_P1{i}, 'MAT2', 'off', pixel_size_0155); end
end
%% Set Movie from workspace
Movie_cell_PAR_2 = {'Mo_Segs_P0_15_12_05_red', 'Mo_Segs_P0_BIG1', 'Mo_Segs_P0_ima3_red', ...
                'Mo_Segs_P1_15_12_05_red', 'Mo_Segs_P1_BIG1', 'Mo_Segs_P1_ima3_red', ...
                'Mo_Segs_P2_wt_Good_red', 'Mo_Segs_P3_wt_ReallyGood_red', 'Mo_Segs_P1_wt_Diss_red'};
Movie_cell_PAR_6 = {'Mo_Segs_P0_15_12_05', 'Mo_Segs_P0_BIG1_red', 'Mo_Segs_P0_ima3', ...
                'Mo_Segs_P1_15_12_05', 'Mo_Segs_P1_BIG1_red', 'Mo_Segs_P1_ima3', ...
                'Mo_Segs_P2_wt_Good', 'Mo_Segs_P3_wt_ReallyGood', 'Mo_Segs_P1_wt_Diss'};
pixel_size_cell = {0.124, 0.255, 0.124, 0.124, 0.255, 0.124, 0.124, 0.124, 0.155};
for jj = 1:length(Movie_cell_PAR_2);% : length(Movie_cell_PAR_2)
    Movies_PAR_2 = eval(Movie_cell_PAR_2{jj});
    Movies_PAR_6 = eval(Movie_cell_PAR_6{jj});
    no_timeframes = min(cell2mat(cellfun(@length, {Movies_PAR_6.Side1}, 'UniformOutput', false)));
    no_embryos = length(Movies_PAR_6);
    % Get lengths of straightened lines (membrane length) and gradient lengths
    length_cell = cell(1, no_embryos);
    sigma_cell_side1_PAR2 = cell(1, no_embryos);
    sigma_cell_side2_PAR2 = cell(1, no_embryos);
    sigma_cell_side1_PAR6 = cell(1, no_embryos);
    sigma_cell_side2_PAR6 = cell(1, no_embryos);
    for ii = 1:no_embryos
        length_cell{ii} = cellfun(@length, Movies_PAR_6(ii).Seg.Imr_s{1}, 'UniformOutput', false);
        sigma_cell_side1_PAR2{ii} = cellfun(@(x) x.curve.s, Movies_PAR_2(ii).Side1, 'UniformOutput', false);
        sigma_cell_side2_PAR2{ii} = cellfun(@(x) x.curve.s, Movies_PAR_2(ii).Side2, 'UniformOutput', false);
        sigma_cell_side1_PAR6{ii} = cellfun(@(x) x.curve.s, Movies_PAR_6(ii).Side1, 'UniformOutput', false);
        sigma_cell_side2_PAR6{ii} = cellfun(@(x) x.curve.s, Movies_PAR_6(ii).Side2, 'UniformOutput', false);
    end
    ls_temp = cellfun(@(x) cell2mat(x(end-no_timeframes+1:end)), length_cell, 'UniformOutput', false);
    ls{jj} = cell2mat(ls_temp')*pixel_size_cell{jj};
    sigmas_temp_side1 = (cellfun(@(x) cell2mat(x(end-no_timeframes+1:end)), sigma_cell_side1_PAR2, 'UniformOutput', false))';
    sigmas_PAR2_side1{jj} = cell2mat(sigmas_temp_side1)*pixel_size_cell{jj};
    sigmas_temp_side2 = (cellfun(@(x) cell2mat(x(end-no_timeframes+1:end)), sigma_cell_side2_PAR2, 'UniformOutput', false))';
    sigmas_PAR2_side2{jj} = cell2mat(sigmas_temp_side2)*pixel_size_cell{jj};
    ls{jj} = cell2mat(ls_temp')*pixel_size_cell{jj};
    sigmas_temp_side1 = (cellfun(@(x) cell2mat(x(end-no_timeframes+1:end)), sigma_cell_side1_PAR6, 'UniformOutput', false))';
    sigmas_PAR6_side1{jj} = cell2mat(sigmas_temp_side1)*pixel_size_cell{jj};
    sigmas_temp_side2 = (cellfun(@(x) cell2mat(x(end-no_timeframes+1:end)), sigma_cell_side2_PAR6, 'UniformOutput', false))';
    sigmas_PAR6_side2{jj} = cell2mat(sigmas_temp_side2)*pixel_size_cell{jj};
end
%%
close all
Movie_cell = Movie_cell_PAR_2;
%All, divided by par6 par2
figure(1); hold on;
for i = 1 : length(Movie_cell)
    plot(mean(ls{i}(:, end-8+1:end-8+3), 2), mean(sigmas_PAR2_side1{i}(:, end-8+1:end-8+3), 2), 'b.', 'MarkerSize', 10);
    plot(mean(ls{i}(:, end-8+1:end-8+3), 2), mean(sigmas_PAR6_side1{i}(:, end-8+1:end-8+3), 2), 'r.', 'MarkerSize', 10);
end
%Par2 divided by phenotype
figure(2); hold on;
plot(mean(ls{1}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side1{1}(:, end-14+1:end-14+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{1}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side2{1}(:, end-14+1:end-14+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{4}(:, end-13+1:end-13+3), 2), mean(sigmas_PAR2_side1{4}(:, end-13+1:end-13+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{7}(:, end-11+1:end-11+3), 2), mean(sigmas_PAR2_side1{7}(:, end-11+1:end-11+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{8}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side1{8}(:, end-14+1:end-14+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{3}(:, end-13+1:end-13+3), 2), mean(sigmas_PAR2_side1{3}(:, end-13+1:end-13+3), 2), 'r.', 'MarkerSize', 10);
plot(mean(ls{3}(:, end-13+1:end-13+3), 2), mean(sigmas_PAR2_side1{3}(:, end-13+1:end-13+3), 2), 'r.', 'MarkerSize', 10);
plot(mean(ls{6}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side2{6}(:, end-14+1:end-14+3), 2), 'r.', 'MarkerSize', 10);
plot(mean(ls{2}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side1{2}(:, end-14+1:end-14+3), 2), 'g.', 'MarkerSize', 10);
plot(mean(ls{2}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side2{2}(:, end-14+1:end-14+3), 2), 'g.', 'MarkerSize', 10);
plot(mean(ls{5}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR2_side1{5}(:, end-14+1:end-14+3), 2), 'g.', 'MarkerSize', 10);
plot(mean(mean(ls{1}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side1{1}(:, end-14+1:end-14+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{1}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side2{1}(:, end-14+1:end-14+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{4}(:, end-13+1:end-13+3), 2)), mean(mean(sigmas_PAR2_side1{4}(:, end-13+1:end-13+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{7}(:, end-11+1:end-11+3), 2)), mean(mean(sigmas_PAR2_side1{7}(:, end-11+1:end-11+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{8}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side1{8}(:, end-14+1:end-14+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{3}(:, end-13+1:end-13+3), 2)), mean(mean(sigmas_PAR2_side1{3}(:, end-13+1:end-13+3), 2)), 'r.', 'MarkerSize', 30);
plot(mean(mean(ls{3}(:, end-13+1:end-13+3), 2)), mean(mean(sigmas_PAR2_side1{3}(:, end-13+1:end-13+3), 2)), 'r.', 'MarkerSize', 30);
plot(mean(mean(ls{6}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side2{6}(:, end-14+1:end-14+3), 2)), 'r.', 'MarkerSize', 30);
plot(mean(mean(ls{2}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side1{2}(:, end-14+1:end-14+3), 2)), 'g.', 'MarkerSize', 30);
plot(mean(mean(ls{2}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side2{2}(:, end-14+1:end-14+3), 2)), 'g.', 'MarkerSize', 30);
plot(mean(mean(ls{5}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR2_side1{5}(:, end-14+1:end-14+3), 2)), 'g.', 'MarkerSize', 30);
axis([0 180 0 70]);
figure(3); hold on;
plot(mean(ls{1}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side1{1}(:, end-14+1:end-14+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{1}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side2{1}(:, end-14+1:end-14+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{4}(:, end-13+1:end-13+3), 2), mean(sigmas_PAR6_side1{4}(:, end-13+1:end-13+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{7}(:, end-11+1:end-11+3), 2), mean(sigmas_PAR6_side1{7}(:, end-11+1:end-11+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{8}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side1{8}(:, end-14+1:end-14+3), 2), 'b.', 'MarkerSize', 10);
plot(mean(ls{3}(:, end-13+1:end-13+3), 2), mean(sigmas_PAR6_side1{3}(:, end-13+1:end-13+3), 2), 'r.', 'MarkerSize', 10);
plot(mean(ls{3}(:, end-13+1:end-13+3), 2), mean(sigmas_PAR6_side1{3}(:, end-13+1:end-13+3), 2), 'r.', 'MarkerSize', 10);
plot(mean(ls{6}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side2{6}(:, end-14+1:end-14+3), 2), 'r.', 'MarkerSize', 10);
plot(mean(ls{2}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side1{2}(:, end-14+1:end-14+3), 2), 'g.', 'MarkerSize', 10);
plot(mean(ls{2}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side2{2}(:, end-14+1:end-14+3), 2), 'g.', 'MarkerSize', 10);
plot(mean(ls{5}(:, end-14+1:end-14+3), 2), mean(sigmas_PAR6_side1{5}(:, end-14+1:end-14+3), 2), 'g.', 'MarkerSize', 10);
plot(mean(mean(ls{1}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side1{1}(:, end-14+1:end-14+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{1}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side2{1}(:, end-14+1:end-14+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{4}(:, end-13+1:end-13+3), 2)), mean(mean(sigmas_PAR6_side1{4}(:, end-13+1:end-13+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{7}(:, end-11+1:end-11+3), 2)), mean(mean(sigmas_PAR6_side1{7}(:, end-11+1:end-11+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{8}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side1{8}(:, end-14+1:end-14+3), 2)), 'b.', 'MarkerSize', 30);
plot(mean(mean(ls{3}(:, end-13+1:end-13+3), 2)), mean(mean(sigmas_PAR6_side1{3}(:, end-13+1:end-13+3), 2)), 'r.', 'MarkerSize', 30);
plot(mean(mean(ls{3}(:, end-13+1:end-13+3), 2)), mean(mean(sigmas_PAR6_side1{3}(:, end-13+1:end-13+3), 2)), 'r.', 'MarkerSize', 30);
plot(mean(mean(ls{6}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side2{6}(:, end-14+1:end-14+3), 2)), 'r.', 'MarkerSize', 30);
plot(mean(mean(ls{2}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side1{2}(:, end-14+1:end-14+3), 2)), 'g.', 'MarkerSize', 30);
plot(mean(mean(ls{2}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side2{2}(:, end-14+1:end-14+3), 2)), 'g.', 'MarkerSize', 30);
plot(mean(mean(ls{5}(:, end-14+1:end-14+3), 2)), mean(mean(sigmas_PAR6_side1{5}(:, end-14+1:end-14+3), 2)), 'g.', 'MarkerSize', 30);
axis([0 180 0 70]);
%% Analyse movies I: Plot timelapse of average graphs
clear sig_indiv;
clear gof_indiv;
pixel_size = 0.155;
Movies = Mo_Segs_P1_wt_Diss_red;
no_timeframes = min(cell2mat(cellfun(@length, {Movies.Side1}, 'UniformOutput', false)));
no_embryos = length(Movies);
av_mat_norm = cell(no_timeframes);
av_mat_norm_mean = cell(no_timeframes);
Fits = {Movies.Side2}';
sig_indiv = zeros(no_timeframes, no_embryos);
gof_indiv = zeros(no_timeframes, no_embryos);
for j = 1:no_timeframes
    frame = j;
    %Either extract fitdata or all Fits, all fits better if parameters are used
    %later for alignment
    % Alignment by fit
%     Fits1 = F{i}';
    data = cellfun(@(y) cellfun(@(x) x, y, 'UniformOutput', false), Fits, 'UniformOutput', false);
    min_length = min(cellfun(@length, data));
    data = cellfun(@(x) x(end-min_length+1:end), data, 'UniformOutput', false);
    r = reshape([data{:}], [min_length, length(Fits)]);
    r_t = num2cell(r', [1,min_length]);
    min_l = floor(min(cell2mat(cellfun(@(x) x.curve.c, r_t{frame}, 'UniformOutput', false))));
    min_r = floor(min(cell2mat(cellfun(@(x) length(x.fitData), r_t{frame}, 'UniformOutput', false))...
                -cell2mat(cellfun(@(x) x.curve.c, r_t{frame}, 'UniformOutput', false))));
    av_mat = cell2mat(cellfun(@(x) x.fitData(round(x.curve.c)-min_l + 1:round(x.curve.c)+min_r), r_t{frame}, 'UniformOutput', false));
    av_mat_norm{j} = (av_mat-repmat((min(av_mat'))', 1, length(av_mat)))...
                        ./repmat((max(av_mat')-min(av_mat'))', 1, length(av_mat));
    av_mat_norm_mean{j} = mean(av_mat_norm{j});
    %Calculate average sigma for frame j from individual fits
    sig_indiv(j, :) = cell2mat(cellfun(@(x) x.curve.s, r_t{end-no_timeframes + j}, 'UniformOutput', false)');
    gof_indiv(j, :) = cell2mat(cellfun(@(x) x.gof.rsquare, r_t{end-no_timeframes + j}, 'UniformOutput', false)');
end
%Kicking out bad fits (lower 10% of rsqu)
sig_indiv(gof_indiv<prctile(gof_indiv(:), 25)) = nan;
sig = nanmean(sig_indiv, 2)*pixel_size;
% Plotting of averaged timelapse with std and individual graphs
numSubPlots = no_timeframes;
dimNumR = ceil(sqrt(numSubPlots));
if dimNumR * (dimNumR - 1) >= numSubPlots
    dimNumC = dimNumR -1;
else
    dimNumC = dimNumR;
end
figure;
ts =  tight_subplot(dimNumR, dimNumC, 0.01, 0.01, 0.01);
counter = 1;
for j = 1:no_timeframes
    axes(ts(counter));
    hold on;
    shadedErrorBar((1:length(av_mat_norm{j})), mean(av_mat_norm{j}), std(av_mat_norm{j}));
    plot(av_mat_norm{j}')%, 'Color', 'r');
    plot(mean(av_mat_norm{j}), 'Color', 'b', 'LineWidth', 3);
    f(j) = Fit(mean(av_mat_norm{j}), 'off', pixel_size, 'err');
    plot(f(j).curve, 'g');
    cProtein1 = f(j).curve.c;
    s = f(j).curve.s;
    l(j) = length(f(j).fitData);
    left = cProtein1-s/2;
    right = cProtein1+s/2;
%         ylims = ylim();
    ylims = [0, 1];
    a = patch([left, right, right, left], ...
    [ylims(1), ylims(1), ylims(2), ylims(2)], 1);
    alpha(a, 0.3);
    a.EdgeColor = 'none';            
    y_m = (ylims(2) + 2*ylims(1))/3; %Weighting minimum more for position
    t = text(right,  double(y_m),{['L_{av} = ', num2str(f(j).curve.s*pixel_size)], ...
                            ['L_{ind} = ', num2str(sig(j))]});
    t.FontSize = 18;
    counter = counter + 1;
    legend('off');
end
allAxesInFigure = findall(gcf,'type','axes');
for j = 1:no_timeframes
    allAxesInFigure(j).XLim = [0 l(j)];
    allAxesInFigure(j).YLim = [0 1];
end
%% Analyse movies II: Plot all kymos
for i = 1:5
    cProtein1 = Movies(i).center_stack(Movies(i).Seg.Imr_s{1});
    cProtein2 = Movies(i).center_stack(Movies(i).Seg.Imr_s{2});
    [side1, side2] = Movie.cut_sides(cProtein1);     
%     figure
%     for j = 1:6; subpl(j) = subplot(3, 2, j); end
%     Movies(i).Seg.plot_kymo({Movies(i).Seg.Imr_s{1}, Movies(i).Seg.Imr_s{2}}, 20, {subpl(1), subpl(2)});
%     Movies(i).Seg.plot_kymo({cProtein1, cProtein2}, 20, {subpl(3), subpl(4)});
%     Movies(i).Seg.plot_kymo({side1, side2}, 20, {subpl(5), subpl(6)});
%     axes(subpl(1)); title('Protein 1');
%     axes(subpl(2)); title('Protein 2');

%     axes(subpl(3)); title('Centered Protein 1');
%     axes(subpl(4)); title('Centered Protein 2');
%     axes(subpl(5)); title('Side 1');
%     axes(subpl(6)); title('Side 2');
    figure;
    subpl(1) = subplot(1, 2, 1);
    subpl(2) = subplot(1, 2, 2);
    Movies(i).Seg.plot_kymo({Movies(i).Seg.Imr_s{1}, Movies(i).Seg.Imr_s{2}}, 20, {subpl(1), subpl(2)});
    figure;
    subpl(1) = subplot(1, 2, 1);
    subpl(2) = subplot(1, 2, 2);
    Movies(i).Seg.plot_kymo({cProtein1, cProtein2}, 20,  {subpl(1), subpl(2)});
    figure;
    subpl(1) = subplot(1, 2, 1);
    subpl(2) = subplot(1, 2, 2);
    Movies(i).Seg.plot_kymo({side1, side2}, 20,  {subpl(1), subpl(2)});
    pause();
    close all;
end
%% Analyse movies III: Plot average data and average fit timelapse overlay for all three phases
numSubPlots = no_timeframes;
dimNumR = ceil(sqrt(numSubPlots));
if dimNumR * (dimNumR - 1) >= numSubPlots
    dimNumC = dimNumR -1;
else
    dimNumC = dimNumR;
end
figure;
ts =  tight_subplot(dimNumR, dimNumC, 0.01, 0.01, 0.01);
counter = 1;    
for j = 1:no_timeframes
    axes(ts(counter));
    hold on;
    l0 = length(f0(j).fitData);
    l1 = length(f1(j).fitData);
    l3 = length(f3(j).fitData);
    normf0 = (f0(j).curve(1:l0) - f0(j).curve(1))/(f0(j).curve(10000)-f0(j).curve(1));
    normf1 = (f1(j).curve(1:l1) - f1(j).curve(1))/(f1(j).curve(10000)-f1(j).curve(1));
    normf3 = (f3(j).curve(1:l3) - f3(j).curve(1))/(f3(j).curve(10000)-f3(j).curve(1));
    normData0 = (f0(j).fitData - f0(j).curve(1))/(f0(j).curve(10000)-f0(j).curve(1));
    normData1 = (f1(j).fitData - f1(j).curve(1))/(f1(j).curve(10000)-f1(j).curve(1));
    normData3 = (f3(j).fitData - f3(j).curve(1))/(f3(j).curve(10000)-f3(j).curve(1));
    c0 = f0(j).curve.c;
    s0 = f0(j).curve.s;
    c1 = f1(j).curve.c;
    s1 = f1(j).curve.s;
    c3 = f3(j).curve.c;
    s3 = f3(j).curve.s;
    plot(normf0, 'r--', 'LineWidth', 3);
    h0 = plot(normData0, 'r');
    plot((1:length(normf1))+c0-c1, normf1, 'b--', 'LineWidth', 3);
    h1 = plot((1:length(normf1))+c0-c1, normData1, 'b');
    plot((1:length(normf3))+c0-c3, normf3, 'g--', 'LineWidth', 3);
    h3 = plot((1:length(normf3))+c0-c3, normData3, 'g');           
    y_m = (ylims(2) + 2*ylims(1))/3; %Weighting minimum more for position
    counter = counter + 1;
    legend([h0, h1, h3], {'P0', 'P1', 'P3'});
end
%%
%Either extract fitdata or all Fits, all fits better if parameters are used
%later for alignment
% data = cellfun(@(y) cellfun(@(x) x.fitData, y, 'UniformOutput', false), Fits1, 'UniformOutput', false);
    r_t = Movies(1).Side1(end-17:end-8);
    min_l = floor(min(cell2mat(cellfun(@(x) x.curve.c, r_t, 'UniformOutput', false))));
    min_r = floor(min(cell2mat(cellfun(@(x) length(x.fitData), r_t, 'UniformOutput', false))...
                -cell2mat(cellfun(@(x) x.curve.c, r_t, 'UniformOutput', false))));
    av_mat = cell2mat(cellfun(@(x) x.fitData(round(x.curve.c)-min_l + 1:round(x.curve.c)+min_r), r_t, 'UniformOutput', false)');
    av_mat_norm = (av_mat-repmat((min(av_mat'))', 1, length(av_mat)))...
                        ./repmat((max(av_mat')-min(av_mat'))', 1, length(av_mat));
    figure;                  
    shadedErrorBar((1:length(av_mat_norm)), mean(av_mat_norm), std(av_mat_norm))

%% Get statistics
SP0 = sig_indivP0PAR2(2:2:11, :);
SP1 = sig_indivP1PAR2(1:5, :);
% SP1(SP1 > 200) = nan;
%Get five frame average for every movie, then do t-test based on individual
%(five) fits and based on the five frame average
SP1_mean = nanmean(SP1, 1);
SP0_mean = nanmean(SP0, 1);
for i = 1:5
    [h, p] = ttest2(SP0(i, :), SP1(i, :))
end
[h, p] = ttest2(SP1_mean, SP0_mean)

