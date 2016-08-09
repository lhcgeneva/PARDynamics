% Use fft on all Fits in all Movies in workspace
load 17_05_16_green_red
%%
allMovies   = get_Objects_From_Base('Movie');
fftThresh = 20;
rsquThresh = 0.08;
autoCThresh = 1;
for i = 1:length(allMovies)
    MovieArray = eval(allMovies{i});
    for j = 1:length(MovieArray)
        for m = 1:length(MovieArray(j).Side1)
            for k = 1:2
                if k == 1
                    MovieArray(j).Side1{m}.fftThresh = fftThresh;
                    MovieArray(j).Side1{m}.rsquThresh = rsquThresh;
                    MovieArray(j).Side1{m}.autoCThresh = autoCThresh / ...
                                MovieArray(j).Side1{m}.pixelSize;
                    MovieArray(j).Side1{m}.kick_out(0);
                elseif k == 2
                    MovieArray(j).Side2{m}.fftThresh = fftThresh;
                    MovieArray(j).Side2{m}.rsquThresh = rsquThresh;
                    MovieArray(j).Side2{m}.autoCThresh = autoCThresh / ...
                                MovieArray(j).Side1{m}.pixelSize;
                    MovieArray(j).Side2{m}.kick_out(0);
                end
            end
        end
    end
end
%% Assign all sigmas from specified range to their Movie from underlying Side1/2
retrievalArray = [12, 11, 10];
for i = 1:length(allMovies)
    MovieArray = eval(allMovies{i});
    for j = 1:length(MovieArray)
        MovieArray(j).retrieve_sigmas(retrievalArray);
    end
end

%% Plot Sigmas
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

P0P2_WT = [Mo_Segs_P0_15_12_05_red.retrievedSigmasAv];
P0P2_CRISPR = [Mo_Segs_P0_16_07_14_CRISPR.retrievedSigmasAv];
P0P6_WT = [Mo_Segs_P0_15_12_05.retrievedSigmasAv];
P0P2_B1 = [Mo_Segs_P0_BIG1.retrievedSigmasAv];
P0P6_B1 = [Mo_Segs_P0_BIG1_red.retrievedSigmasAv];
P0P2_I3 = [Mo_Segs_P0_ima3_red.retrievedSigmasAv];
P0P6_I3 = [Mo_Segs_P0_ima3.retrievedSigmasAv];
P1P2_WT = [Mo_Segs_P1_15_12_05_red.retrievedSigmasAv];
P1P2_WT_diss = [Mo_Segs_P1_wt_Diss_red.retrievedSigmasAv];
P1P2_B1 = [Mo_Segs_P1_BIG1.retrievedSigmasAv];
P1P2_I3 = [Mo_Segs_P1_ima3_red.retrievedSigmasAv];
P3P2_WT = [Mo_Segs_P3_wt_ReallyGood_red.retrievedSigmasAv];

LsP2 = [P0P2_WT_l, P0P2_CRISPR_l, P0P2_B1_l, P0P2_I3_l, P1P2_WT_l, P1P2_WT_diss_l, ...
        P1P2_B1_l, P1P2_I3_l, P3P2_WT_l];
P2 = [P0P2_WT, P0P2_CRISPR, P0P2_B1, P0P2_I3, P1P2_WT, P1P2_WT_diss, P1P2_B1, ...
        P1P2_I3, P3P2_WT];
LsP6 = [P0P6_WT_l, P0P6_B1_l, P0P6_I3_l];
P6 = [P0P6_WT, P0P6_B1, P0P6_I3];

%Averages 
LsP2av = {P0P2_WT_l, P0P2_CRISPR_l P0P2_B1_l, P0P2_I3_l, P1P2_WT_l, P1P2_WT_diss_l, ...  
        P1P2_B1_l, P1P2_I3_l, P3P2_WT_l};
LsP2av = cellfun(@nanmean, LsP2av);
P2a = {P0P2_WT, P0P2_CRISPR, P0P2_B1, P0P2_I3, P1P2_WT, P1P2_WT_diss, P1P2_B1, ...
        P1P2_I3, P3P2_WT};
P2av = cellfun(@nanmean, P2a);
LsP6a = {P0P6_WT_l, P0P6_B1_l, P0P6_I3_l};
LsP6av = cellfun(@nanmean, LsP6a);
P6av = {P0P6_WT, P0P6_B1, P0P6_I3};
P6av = cellfun(@nanmean, P6av);
figure; hold on;
plot(LsP2av, P2av, 'b.', 'MarkerSize', 30);
plot(LsP6av, P6av, 'r.', 'MarkerSize', 30);
legend('PAR-2', 'PAR-6');
legend boxoff
plot(LsP6, P6, 'r.', 'MarkerSize', 10);
plot(LsP2, P2, 'b.', 'MarkerSize', 10);
axis([0, 200, 0, 22]);
dx = [1.5, 1.5, 1.5, 1.5, -17, 1.5, 1.5, 1.5, 1.5];
dy = [0.2, 0.2, 0.2, 0.2, 0.2, 0.2, -0.2, 0.2, 0.2];
set(gca, 'FontSize', 14);
labels = {'P0P2WT', 'P0P2CRISPR', 'P0P2B1', 'P0P2I3', 'P1P2WT', 'P1P2WTdiss',...
    'P1P2B1', 'P1P2I3', 'P3P2WT'};
text(LsP2av+dx, P2av+dy, labels, 'FontSize', 14, 'FontWeight', 'bold');
dx = 1.5;
dy = [0.2, -0.1, 0.2];
labels = {'P0P6WT', 'P0P6B1', 'P0P6I3'};
text(LsP6av+dx, P6av+dy, labels, 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Embryo circumference [$\mu m$]', 'Interpreter', 'Latex', 'FontSize', 24);
ylabel('$\sigma$ [$\mu m$]', 'Interpreter', 'Latex', 'FontSize', 24);
