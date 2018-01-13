function plot_triangulation(this, tPoint)
%PLOT_TRIANGULATION(this) plots triangulation of tPoint
%   Plots available channels for time point tPoint and merge if two
%   channels are available. Change lut cutoff in case of large dynamic
%   range.

t = this.TriangulationCell{tPoint}.t;
p = this.TriangulationCell{tPoint}.p_rot;
ta = this.TriangulationCell{tPoint}.tri_area;

%Normalize to min and max
P{1} = this.TriangulationCell{tPoint}.S{1};
P{2} = this.TriangulationCell{tPoint}.S{2};
P{1} = (P{1}-min(P{1}))/(max(P{1}-min(P{1})));
P{2} = (P{2}-min(P{2}))/(max(P{2}-min(P{2})));

% %   Plot merge
% if ~isempty(P{1}) && ~isempty(P{2})
%     figure(1);
%     hold on;
%     cdata = 1:length(P{1});
%     title(['Merge timepoint ', num2str(tPoint)], 'fontsize', 14);
%     axis equal;
%     h1 = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), cdata);    
%     view(3);
%     set(h1,'edgecolor','none');
%     set(gca,'color','black');
%     set(gcf,'color','black');
%     axis off;
%     %     cmap = colormap(gray);
%     %     cmap(cmap>0.9) = 1; %Threshold highest values
%     %This colormap plots the first protein in green, the second protein in
%     %red, just swap for different colors.
%     cmap = [P{2}, P{1}, zeros(size(P{1}))];
%     colormap(cmap);
%     %     set(h1,'CData', cdata );
%     az = -1;
%     el = 7;
%     view(az, el);
% end

% Plot first channel if available
if ~isempty(P{1})
    cmap = [zeros(size(P{1})), P{1}, zeros(size(P{1}))];
    plot_channel(P{1}, cmap, '1', t, p, tPoint, ta);    
end

% Plot second channel if available
% if ~isempty(P{2})
%     cmap = [P{2}, zeros(size(P{2})), zeros(size(P{2}))];
%     plot_channel(P{2}, cmap, '2', t, p, tPoint, ta);
% end
end

function plot_channel(Pi, cmap, channel_string, t, p, tPoint, ta)
    figure;
    hold on;
    cdata = 1:length(Pi);
    title(['Channel ', num2str(channel_string), ' timepoint ',...
            num2str(tPoint)], 'fontsize', 14);
    axis equal;
    h1 = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), cdata);   
    view(3);
    set(h1,'edgecolor','none');
    
%     % Face colors as average data from the three vertices of each triangle,
%     % this is to check sanity, should give the same result (maybe different
%     % scaling) than the one below, using colormap
%     ms = zeros(1, length(t));
%     for i = 1:length(t)
%         ms(i) = mean(Pi(t(i, :)))';
%     end
%     ms = (ms-min(ms))/(max(ms)-min(ms));
%     ms(ms>0.7) = 0.7;
%     h1.FaceVertexCData = [zeros(size(ms')), ms', zeros(size(ms'))];
%         
%     % Set colormap to triangle area, to check for sanity of triangle
%     % calculation
%     comap = [zeros(size(ta')), ta', zeros(size(ta'))];
%     h1.CData = ta;
%     [~, ind] = max(ta);
%     % Painting the biggest triangle in red for sanity check.
%     fill3(p(t(ind, :), 1), p(t(ind, :), 2), p(t(ind, :), 3), 'y');
%     colormap(comap);
    
    comap = bsxfun(@rdivide, cmap, max(cmap));
    % Normal mode, using cmap argument as colormap, normalizing,
    % thresholding, green colormap
%     comap(comap>0.7) = 0.7; %Threshold highest values
%     comap = bsxfun(@rdivide, comap, max(comap));
%     colormap(comap);
    % Fire colormap (fire function from stackexchange)
    [~, inds] = sort(comap(:, 2));
    [~, inds2] = sort(inds);
    F = fire(length(comap));
    comap1 = F(inds2, :);
    colormap(comap1)

    % Plot yz plane
    [mgy, mgz] = meshgrid(-10:10, -10:10);
    surf(zeros(size(mgy)), mgy, mgz, 'FaceColor', 'b', 'EdgeColor', 'none',...
         'FaceAlpha',0.5)

    az = 47;
    el = 8;
    view(az, el); 
end


