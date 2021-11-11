function register_circle(Seg, sliceNum)
ti = reshape(cell2mat(cellfun(@uint16, Seg.channels{1},...
                 'Uni', false)), Seg.sz_all);
sz = size(ti);
ti_edge = zeros(size(ti));
for i = 1:sz(3)
    ti_edge(:, :, i) = edge(ti(:, :, i), 'sobel');
end
ti_edge = imgaussfilt(double(ti_edge), 2);
row = 0.5:sz(1)-0.5;
col = 0.5:sz(2)-0.5;
t = (1:sz(3))';
F = griddedInterpolant({row,col,t}, double(ti_edge));
F_orig = griddedInterpolant({row,col,t}, double(ti));
step = 0.125;
row_q = (step/2:step:sz(1))';
col_q = (step/2:step:sz(2))';
vq = F({row_q, col_q, t});
vq_orig = F_orig({row_q, col_q, t});
figure; hold on; imshow(vq_orig(:, :, 1), []);
roi = drawcircle;
pause()
roi_cen = roi.Center;
r = roi.Radius;
cen_col = roi_cen(1);
cen_row = roi_cen(2);
Seg.circle_props.cen_row(sliceNum) = cen_row*step;
Seg.circle_props.cen_col(sliceNum) = cen_col*step;
Seg.circle_props.r(sliceNum) = r*step;
cost = zeros(11, 11);
cs = zeros(sz(3), 2);
cs(1, :) = [cen_col, cen_row];
n = vq(cen_row-r:cen_row+r, cen_col-r:cen_col+r, 1);
for im = 1:Seg.sz_all(3)-1
    % maybe assigning n here works for better resolution?
%         n = vq(cen_row-r:cen_row+r, cen_col-r:cen_col+r, im); 
    for i = 1:11
        for j = 1:11
            shift_row = i-6;
            shift_col = j-6;
            n_1 = vq(cen_row-r+shift_row:cen_row+r+shift_row,...
                       cen_col-r+shift_col:cen_col+r+shift_col, im+1);
            cost(i, j) = sum((n-n_1).^2, 'all');
        end
    end
    [~,I] = min(cost,[],'all', 'linear');
    [row, col] = ind2sub(size(cost), I);
    cen_row = cen_row + row - 6;
    cen_col = cen_col + col - 6;
    cs(im+1, :) = [cen_col, cen_row];
    Seg.circle_props.cen_row(im+1) = cen_row*step;
    Seg.circle_props.cen_col(im+1) = cen_col*step;
    Seg.circle_props.r(im+1) = r*step;
end