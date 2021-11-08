function plot_segmentations( Seg, frame, mode )
%PLOT_SEGMENTATIONS Plots object elements, depending on availability
%   'IMAGE'     Displays segmented image
%   'MIDPOINT'  Plots midpoint 
%   'LIMITS'    Plots threshold limits
%   'MAX'       Plots segmentation obtained by maximum method
%   'DIFF'      Plots segmentation obtained by finite difference method
%   'GRAD'      Plots segmentation obtained by sigma fit method
%   'FINAL'     Plots segmentation obtained after combingin the above
%   'CORRECTED' Plots manually corrected 

figure(gcf);
cla;

if sum(ismember(mode, 'IMAGE')) == 1
    imshow(Seg.MergeBuff{frame}, Seg.lut); 
end
hold on;
if sum(ismember(mode, 'MIDPOINT')) == 1
    plot(Seg.midpoint{frame}(1), Seg.midpoint{frame}(2), 'k.', ...
            'MarkerSize', 30);
end
if ~isempty(Seg.thresh_limits) && sum(ismember(mode, 'LIMITS')) == 1   
    ang = 0 : 0.01 : 2*pi;
    rad = 180/pi;
    x_coo = Seg.midpoint{frame}(1) + ...
            Seg.thresh_limits(1)*Seg.minorRadius{frame}*cos(ang * rad);
    y_coo = Seg.midpoint{frame}(2) + ...
            Seg.thresh_limits(1)*Seg.minorRadius{frame}*sin(ang * rad);
    plot(x_coo, y_coo, 'r', 'LineWidth', 1);
    x_coo = Seg.midpoint{frame}(1) + ...
        Seg.thresh_limits(2)*Seg.majorRadius{frame}*cos(ang * rad);
    y_coo = Seg.midpoint{frame}(2) + ...
            Seg.thresh_limits(2)*Seg.majorRadius{frame}*sin(ang * rad);
    plot(x_coo, y_coo, 'r', 'LineWidth', 1);
end
if ~isempty(Seg.thresh_max{frame}) && sum(ismember(mode, 'MAX')) == 1
    plot(Seg.thresh_max{frame}(:, 1), Seg.thresh_max{frame}(:, 2), 'r.', ...
            'MarkerSize', 30);
end
if ~isempty(Seg.thresh_diff{frame}) && sum(ismember(mode, 'DIFF')) == 1
    plot(Seg.thresh_diff{frame}(:, 1), Seg.thresh_diff{frame}(:, 2), 'b.', ...
            'MarkerSize', 30);
end

if ~isempty(Seg.thresh_final{frame}) && sum(ismember(mode, 'FINAL')) == 1
    plot(Seg.thresh_final{frame}(:, 1), Seg.thresh_final{frame}(:, 2), 'y.', ...
        'MarkerSize', 30);
end

if ~isempty(Seg.thresh_diff_c{frame}) && sum(ismember(mode, 'DIFFC')) == 1
    plot(Seg.thresh_diff_c{frame}(:, 1), Seg.thresh_diff_c{frame}(:, 2), 'g.', ...
        'MarkerSize', 30);
end

if ~isempty(Seg.thresh_corr{frame}) && sum(ismember(mode, 'CORR')) == 1
    plot(Seg.thresh_corr{frame}(:, 1), Seg.thresh_corr{frame}(:, 2), 'm.', ...
        'MarkerSize', 30);
end

if ~isempty(Seg.circle_props.r(frame)) && sum(ismember(mode, 'CIRCLE')) == 1
    drawcircle('Center', [Seg.circle_props.cen_col(frame),...
               Seg.circle_props.cen_row(frame)], 'Radius',...
               Seg.circle_props.r(frame));
    shg;
end
hold off;
end

