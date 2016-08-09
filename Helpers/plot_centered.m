function int_norm = plot_centered(MovArr, channel, tp)
%PLOT_CENTERED Plots the overall membrane profile for channel *channel* for
%all the Movies in MovArr at time point tp, where t = end-tp, so tp=0 gives
%the last frame.

temp = [MovArr.Seg];
ImrArr = {temp.Imr_s};
ImrArr = cellfun(@(x) x{end-tp}, ...
            cellfun(@(x) x{channel}, ImrArr, 'UniformOutput', false), ...
            'UniformOutput', false); 
stack = Movie.center_stack(ImrArr);
sorted = cellfun(@(x) sort(x, 1, 'descend'), stack, 'UniformOutput', false);
int = cellfun(@(x) mean(x(1:3, :), 1), sorted, 'UniformOutput', false);
int_norm = cellfun(@(x) (x-min(x))/(mean(x-min(x))), int, 'UniformOutput', false);

minCirc = min(cell2mat(cellfun(@length, stack, 'UniformOutput', false)));
minCirc = floor(minCirc/2)-1;
int_norm = cellfun(@(x) x(round(length(x)/2)-minCirc:round(length(x)/2)+minCirc), ...
                int_norm, 'UniformOutput', false);
n = cell2mat(int_norm');
figure; hold on; 
for i= 1:length(int_norm)
hold on; plot(int_norm{i});
end
plot(mean(n), 'LineWidth', 5);
