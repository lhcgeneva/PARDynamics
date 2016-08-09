allMovies   = get_Objects_From_Base('Movie');
windowSize = 0.124*141;
for i = 7:length(allMovies)
    MovieArray = eval(allMovies{i});
    for j = 1:length(MovieArray)
        try
            MovieArray(j).folder.load_data(MovieArray(j).folder.filename, ...
                    'external')
        catch
            disp('Could not load data');
        end
        for m = 1:length(MovieArray(j).Side1)
            for k = 1:2
                %Make winSize dependent on pixel size and uneven
                winSize = 2.*round((...
                    windowSize/MovieArray(j).Side1{m}.pixelSize+1)/2)-1;
                if k == 1
                     [sl, ~, ~] = calc_slope(MovieArray(j).Side1{m}.fitData, ...
                        winSize, 5, 0);
                    MovieArray(j).Side1{m}.normSlope = sl / ...
                        MovieArray(j).Side1{m}.pixelSize;
                elseif k == 2
                     [sl, ~, ~] = ...
                         calc_slope(MovieArray(j).Side1{m}.fitData, ...
                        winSize, 5, 0);
                    MovieArray(j).Side2{m}.normSlope = sl / ...
                        MovieArray(j).Side2{m}.pixelSize;
                end
            end
        end
    end
end
%% Assign all Slopes from specified range to their Movie from underlying Side1/2
retrievalArray = [12, 11, 10];
for i = 1:length(allMovies)
    MovieArray = eval(allMovies{i});
    for j = 1:length(MovieArray)
        MovieArray(j).retrieve_sigmas(retrievalArray);
    end
end

%% Plot Slopes
vname=@(x) inputname(1);
P0P2_WT_l = [Mo_Segs_P0_15_12_05_red.retrievedLengthsAv];
P0P2_CRISPR_l = [Mo_Segs_P0_16_07_14_CRISPR.retrievedLengthsAv];
P0P6_WT_l = [Mo_Segs_P0_15_12_05.retrievedLengthsAv];
P0P2_B1_l = [Mo_Segs_P0_BIG1.retrievedLengthsAv];
P0P6_B1_l = [Mo_Segs_P0_BIG1_red.retrievedLengthsAv];
P0P2_I3_l = [Mo_Segs_P0_ima3_red.retrievedLengthsAv];
P0P6_I3_l = [Mo_Segs_P0_ima3.retrievedLengthsAv];
P1P2_WT_l = [Mo_Segs_P1_15_12_05_red.retrievedLengthsAv];
P1P2_WT_diss_l = [Mo_Segs_P1_wt_Diss_red.retrievedLengthsAv];
P1P2_B1_l = [Mo_Segs_P1_BIG1.retrievedLengthsAv];
P1P2_I3_l = [Mo_Segs_P1_ima3_red.retrievedLengthsAv];
P3P2_WT_l = [Mo_Segs_P3_wt_ReallyGood_red.retrievedLengthsAv];

P0P2_WT = [Mo_Segs_P0_15_12_05_red.retrievedSlopesAv];
P0P2_CRISPR = [Mo_Segs_P0_16_07_14_CRISPR.retrievedSlopesAv];
P0P6_WT = [Mo_Segs_P0_15_12_05.retrievedSlopesAv];
P0P2_B1 = [Mo_Segs_P0_BIG1.retrievedSlopesAv];
P0P6_B1 = [Mo_Segs_P0_BIG1_red.retrievedSlopesAv];
P0P2_I3 = [Mo_Segs_P0_ima3_red.retrievedSlopesAv];
P0P6_I3 = [Mo_Segs_P0_ima3.retrievedSlopesAv];
P1P2_WT = [Mo_Segs_P1_15_12_05_red.retrievedSlopesAv];
P1P2_WT_diss = [Mo_Segs_P1_wt_Diss_red.retrievedSlopesAv];
P1P2_B1 = [Mo_Segs_P1_BIG1.retrievedSlopesAv];
P1P2_I3 = [Mo_Segs_P1_ima3_red.retrievedSlopesAv];
P3P2_WT = [Mo_Segs_P3_wt_ReallyGood_red.retrievedSlopesAv];

LsP2 = [P0P2_WT_l, P0P2_B1_l, P0P2_I3_l, P1P2_WT_l, P1P2_WT_diss_l, ...
        P1P2_B1_l, P1P2_I3_l, P3P2_WT_l];
P2 = [P0P2_WT, P0P2_B1, P0P2_I3, P1P2_WT, P1P2_WT_diss, P1P2_B1, ...
        P1P2_I3, P3P2_WT];
LsP6 = [P0P6_WT_l, P0P6_B1_l, P0P6_I3_l];
P6 = [P0P6_WT, P0P6_B1, P0P6_I3];

%Averages 
LsP2av = {P0P2_WT_l, P0P2_CRISPR_l, P0P2_B1_l, P0P2_I3_l, P1P2_WT_l, P1P2_WT_diss_l, ...  
        P1P2_B1_l, P1P2_I3_l, P3P2_WT_l};
LsP2av = cellfun(@nanmean, LsP2av);
P2a = {P0P2_WT, P0P2_CRISPR, P0P2_B1, P0P2_I3, P1P2_WT, P1P2_WT_diss, P1P2_B1, ...
        P1P2_I3, P3P2_WT};
P2av = cellfun(@nanmean, P2a);
LsP6a = {P0P6_WT_l, P0P6_B1_l, P0P6_I3_l};
LsP6av = cellfun(@nanmean, LsP6a);
clear P6av;
P6av1 = {P0P6_WT, P0P6_B1, P0P6_I3};
for i = 1:length(P6av1)
    P6av{i} = mean(P6av1{i}(~isnan(LsP6a{i})));
end
P6av = cell2mat(P6av);
% P6av = cellfun(@nanmean, P6av);
figure; hold on;
plot(LsP2av, P2av, 'b.', 'MarkerSize', 30);
plot(LsP6av, P6av, 'r.', 'MarkerSize', 30);
legend('PAR-2', 'PAR-6');
legend boxoff
plot(LsP6, P6, 'r.', 'MarkerSize', 10);
plot(LsP2, P2, 'b.', 'MarkerSize', 10);
axis([0, 180, 0, 0.35]);
dx = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5];
dy = [0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01];
set(gca, 'FontSize', 14);
labels = {'P0P2WT', 'P0P2CRISPR', 'P0P2B1', 'P0P2I3', 'P1P2WT', 'P1P2WTdiss',...
    'P1P2B1', 'P1P2I3', 'P3P2WT'};
text(LsP2av+dx, P2av+dy, labels, 'FontSize', 14, 'FontWeight', 'bold');
dx = 1.5;
dy = [0.01, 0.01, 0.01];
labels = {'P0P6WT', 'P0P6B1', 'P0P6I3'};
text(LsP6av+dx, P6av+dy, labels, 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Embryo circumference [$\mu m$]', 'Interpreter', 'Latex', 'FontSize', 24);
ylabel('m [$\frac{a.u.}{\mu m}$]', 'Interpreter', 'Latex', 'FontSize', 24);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%SIMULATIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulate different sizes
Ls = 23:1:26;
bins = 46:2:52;
tic
StoV = arrayfun(@(x) S_to_V('Circumference', {x, 1/1.5}), Ls);
S = Simulations({{{'L', 'psi', 'bins'}}, ...
    {{Ls, arrayfun(@(x) S_to_V('Circumference', {x, 1/1.8}), Ls), bins}}}, 3);
S.SimulationCell = S.run_simulations();
S.average_datasets;
toc
save(['simus_', num2str(Ls(1)), '_', num2str(Ls(end))]);
%% Read in new simulations P0 different sizes, plot simulated slopes
% load simus_10_180_0_5micronbinsize.mat. 
Simus = S;
% Simus.average_datasets
Simus.assign_slopes;
windowSize = 31;
pixelSize = 0.5;
a = cellfun(@(x) calc_slope(flipud(x{1}(:, end)), windowSize, 5, 0), Simus.AvSimus,...
            'UniformOutput', false);
b = cellfun(@(x) calc_slope(x{2}(:, end), windowSize, 5, 0), Simus.AvSimus,...
            'UniformOutput', false);
sz = size(Simus.SimulationCell);
means = zeros(sz(1), 1);
stds = means;
for i = 1:sz(1)
    means_a(i) = mean(cellfun(@(x) x.slopeA, Simus.SimulationCell(i, :)));
    stds_a(i) = std(cellfun(@(x) x.slopeA, Simus.SimulationCell(i, :)));
    means_b(i) = mean(cellfun(@(x) x.slopeB, Simus.SimulationCell(i, :)));
    stds_b(i) = std(cellfun(@(x) x.slopeB, Simus.SimulationCell(i, :)));
end
x = Ls;
b_plot = cell2mat(b)'./pixelSize;
a_plot = cell2mat(a)'./pixelSize;
means_a = means_a/pixelSize;
means_b = means_b/pixelSize;
stds_a = stds_a/pixelSize;
stds_b = stds_b/pixelSize;
%%%%%%%%Remove small simulations which do produce slope but did not in fact
%%%%%%%%polarize%%%%%%%%%%%%%%%%%%%%
b_plot = b_plot(2:end);
a_plot = a_plot(2:end);
means_a = means_a(2:end);
means_b = means_b(2:end);
stds_a = stds_a(2:end);
stds_b = stds_b(2:end);
x = Ls(2:end);
figure; hold on;
errorbar(x, means_b, stds_b, 'LineWidth', 2);
errorbar(x+1, means_a, stds_a, 'LineWidth', 2);
% plot(x, b_plot, 'LineWidth', 5);
% plot(x, a_plot, 'LineWidth', 5);
axis([0 185 0 0.6]);
set(gca,'FontSize',16)
h = legend('PAR-2', 'PAR-6');
h.set('FontSize', 20);
xlabel('Embryo circumference [$\mu m$]', 'Interpreter', 'Latex', 'FontSize', 24);
ylabel('m [$\frac{a.u.}{\mu m}$]', 'Interpreter', 'Latex', 'FontSize', 24);