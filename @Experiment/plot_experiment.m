function plot_experiment( Exp )
%PLOT_EXPERIMENT Plots sigmas over time for each movie
%   Only makes sense for movies, otherwise only one point per graph will be
%   plotted and graphs look empty.

%Plotting timelapses in subplots
numSubPlots = length(Exp.sigmaList);
dimNumR = ceil(sqrt(numSubPlots));
if dimNumR * (dimNumR - 1) >= numSubPlots
    dimNumC = dimNumR -1;
else
    dimNumC = dimNumR;
end
figure;
ts =  tight_subplot(dimNumR, dimNumC, 0.04, 0.04, 0.04);
counter = 1;
for i = 1 : dimNumR
    for j = 1 : dimNumC
        axes(ts(counter));
        hold on;
        plot(Exp.sigmaList{counter}, '.');
        axis([0 length(Exp.sigmaList{counter}) 0 40]);
        legend('off');
        ax = gca;
        ax.YTick = [0, 10, 17, 22, 30];
        ax.YTickLabel = {'0', '10', '(\mum)', 'L  ', '30'};
        ax.XTick = [0, length(Exp.sigmaList{counter})/4, ...
            length(Exp.sigmaList{counter})/2, ...
            length(Exp.sigmaList{counter})*3/4, ...
            length(Exp.sigmaList{counter})];
        ax.XTickLabel = {'0', num2str(round(length(Exp.sigmaList{counter})/4)),... 
            'FRAMES' num2str(round(length(Exp.sigmaList{counter})*3/4)),...
            num2str(length(Exp.sigmaList{counter}))};
        counter = counter + 1;
        if counter > numSubPlots; break; end;
    end
end

%Plotting averaged timelapse, works only if all movies are shot at
%approximately the same rate! Cells are synchronized at the end of their
%time course (so t1_1...t1_n and t2_1...t2_m will be synchronized at t1_n
%and t2_m, which usually corresponds to cytokinesis).
minimumTimeLapseLength = min(cellfun(@(x)length(x), Exp.sigmaList));
temp = zeros(length(Exp.sigmaList), minimumTimeLapseLength);
for i = 1:length(Exp.sigmaList)
    temp(i, 1:minimumTimeLapseLength) = Exp.sigmaList{i}(end-minimumTimeLapseLength+1:end);
end
figure;
plot((mean(temp, 1)), 'LineWidth', 2);
hold on;
%Try plotting std, if only one movie: no std possible, catch with simple
%plot
try
    shadedErrorBar(1:length(mean(temp,1)), mean(temp, 1), std(temp,1), 'b');
    shadedErrorBar(1:length(mean(temp,1)), mean(temp, 1), ...
        std(temp,1)/sqrt(length(Exp.sigmaAv)));
    textbp( ...%0.6*minimumTimeLapseLength, 25,
        {['\lambda =', num2str(Exp.lambda), ...
         ' +/- ', num2str(Exp.lambdaStd), '\mum'], ...
         ['SE:', num2str(Exp.lambdaStdErr), '\mum'], ...
         'Shaded area: STD', ...
         ['n_{gradients} = ', num2str(length(Exp.sigmaList))]}, ...
         'FontSize', 14);
catch
    plot(1:length(mean(temp,1)), mean(temp, 1), 'b');
    textbp(...%0.6*minimumTimeLapseLength, 25, 
        {['\lambda =', num2str(Exp.lambda)], ...
         ['n_{gradients} = ', num2str(length(Exp.sigmaList))]}, ...
         'FontSize', 14);
end
axis([0 minimumTimeLapseLength 0 30]);
xlabel('time (frames)', 'FontSize', 14);
ylabel('Gradient length (\mum)', 'FontSize', 14);
title(Exp.germcell, 'Interpreter', 'none');
hold off;
%Plotting sigma averages vs size as scatter plot, including stats
figure;
hold on;
plot(Exp.cellSizeList, Exp.sigmaAv, '.', 'MarkerSize', 15);
c = corr(Exp.cellSizeList', Exp.sigmaAv');
%Plotting average of sigmaAv for same sizes (which only happens in P0, when
%there are two sides per cell
%Get matrix of integers, with each integer representing one cell size
[~, ~, ic] = unique(Exp.cellSizeList);  
xmean = accumarray(ic,Exp.cellSizeList, [], @mean);
ymean = accumarray(ic,Exp.sigmaAv, [], @mean);
cmean = corr(xmean, ymean);
plot(xmean, ymean, '.', 'MarkerSize', 30);
h_l = legend('Single data points', 'Average of each cell size (P0 cells have two gradients)');
set(h_l, 'FontSize', 12);
h_tbp = textbp({['Correlation individual values: ', num2str(c)], ['Correlation mean values:       ', num2str(cmean)]});
set(h_tbp, 'FontSize', 14);
xlabel('cell circumference (\mum)', 'FontSize', 14);
ylabel('Gradient length (\mum)', 'FontSize', 14);
title([Exp.germcell, ' corr. circumference : gradient length'], 'Interpreter', 'none');
hold off;
end

