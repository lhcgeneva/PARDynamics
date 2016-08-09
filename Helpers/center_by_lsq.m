function shift_ind = center_by_lsq(int_norm, tolerance)
%CENTER_BY_LSQ Align curves in stack by getting rough average first and
%aligning each curve individually to the average afterwards by lsq. Maximum
%allowed displacement of each graph is tolerance.

n_mean = mean(cell2mat(int_norm'));
squ1 = zeros(length(int_norm), tolerance+1);
squ2 = zeros(length(int_norm), tolerance+1);

for i = 1:length(int_norm)
%     figure; hold on; %DEBUG PLOT
%     plot(n_mean, 'LineWidth', 5);
    for j = 0:tolerance
        difference1 = int_norm{i}(1:end-j)-n_mean(j+1:end);
%         plot(j+1:length(n_mean), int_norm{i}(1:end-j)); %DEBUG PLOT
%         pause();
        difference2 = n_mean(1:end-j)-int_norm{i}(j+1:end);
%         plot(1:length(n_mean)-j, int_norm{i}(j+1:end)); %DEBUG PLOT
%         pause();
        %Normalize, so different lengths don't matter
        squ1(i, j+1) = sum(difference1.^2)/length(difference1); 
        squ2(i, j+1) = sum(difference2.^2)/length(difference2);
        
    end
end

shift_ind = [fliplr(squ2), squ1(:, 2:end)];

    