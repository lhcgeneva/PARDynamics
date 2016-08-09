%% Aligning whole membranes - Judged by difference to average this seems to align the graphs well
%Exploring tolerance number of steps to left and right.
%Get square differences for each graph by aligning to average, via
%y-difference, find the minimum difference for each graph and the maximum
%difference between graph shifts, pad normalized intensities with nan such 
%that columns now correspond to different membranes at their best overlap,
%cut off values from the side so array doesn't contain nans, plot, x-indices
%shifted!

% Plot one and the same frame from several movies and its average 
int_norm = plot_centered(Mo_Segs_P0_15_12_05, 1, 12);
%Set tolerance for shifting left and right
tolerance = 50; 
shift_squDist = center_by_lsq(int_norm, tolerance); 
[m, shift] = min(shift_squDist, [], 2);
shift = shift-tolerance;
biggestDifference = max(shift)-min(shift);
for i = 1:length(int_norm)
    int_norm_padded{i} = [nan(1, biggestDifference-shift(i)), int_norm{i}, ...
        nan(1, (biggestDifference+shift(i)))];
end
intNormMat = cell2mat(int_norm_padded');

isNaN = isnan(intNormMat);
left = sum(isNaN(:, 1:biggestDifference*2), 2);
right = sum(isNaN(:, end-biggestDifference*2:end), 2);
left = max(left);
right = max(right);
alignedNorm = intNormMat(:, left:end-right);
figure; hold on;
plot(0:length(mean(cell2mat(int_norm'))) -1 , mean(cell2mat(int_norm')));
plot(max(-shift):length(alignedNorm)+max(-shift)-1, mean(alignedNorm));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
