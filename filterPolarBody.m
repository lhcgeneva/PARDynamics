t = s_lgl_crt90;
filter_polar_body = 0;
for i = 1:length(t.Imr_s{1})
    straightened = t.Imr_s{1}{i};
    so = sort(straightened);
    so = so(end-2:end, :);
    so_mean = mean(so);
    figure
    plot(so_mean);
    hold on;
    s=smooth(so_mean, round(length(so_mean)/20));
    plot(s) %Using a smoothing window of 5%
    prominence = (max(s)-min(s))/3;
    [pks, pos] = findpeaks(double(s), 'MinPeakProminence', prominence);
    fract_half = round(length(so_mean)/20);
    top(i) = mean([so_mean(1:fract_half), so_mean(end-fract_half+1:end)]);
    % Get cytoplasmic background
    first_row_mean = mean(straightened(1, :));
    last_row_mean = mean(straightened(end, :));
    if first_row_mean > last_row_mean
        cyto_row = straightened(1, :);
    else
        cyto_row = straightened(end, :);
    end
    % Get lower values, if polar body detected, leave 50 pixels on each
    % side space
    if ~isempty(pos) && filter_polar_body
        bottom(i) = mean([so_mean(pos-100:pos-50), so_mean(pos+50:pos+100)]);
        bottom_back = mean([cyto_row(pos-100:pos-50), cyto_row(pos+50:pos+100)]);
    else
        half_length = round(length(so_mean)/2);
        bottom(i) = mean(so_mean(half_length-fract_half:half_length+fract_half));
        bottom_back = mean(cyto_row(half_length-fract_half:half_length+fract_half));
    end
    top_back = mean([cyto_row(1:fract_half), cyto_row(end-fract_half+1:end)]);
    bottom(i) = bottom(i)-bottom_back;
    top(i) = top(i)-top_back;
end

(top-bottom)./(top+bottom)
bottom./top
