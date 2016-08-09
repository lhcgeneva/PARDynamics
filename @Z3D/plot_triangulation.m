function plot_triangulation(this, tPoint, mode, showAll)
%PLOT_TRIANGULATION(this) plots triangulation of tPoint
%   Detailed explanation goes here
    t = this.TriangulationCell{tPoint}.t;
    p = this.TriangulationCell{tPoint}.p;
    %Normally normalized mode should not be used, often gives a false sense
    %of polarity because no matter how small the differences are they will be amplified!
    if strcmp(mode, 'normalized')
        P{1} = this.TriangulationCell{tPoint}.Z{1};
        P{2} = this.TriangulationCell{tPoint}.Z{2};
    elseif strcmp(mode, 'raw')
        P{1} = this.TriangulationCell{tPoint}.S{1};
        P{2} = this.TriangulationCell{tPoint}.S{2};
        P{1} = (P{1}-min(P{1}))/(max(P{1}-min(P{1})));
        P{2} = (P{2}-min(P{2}))/(max(P{2}-min(P{2})));
    else 
        disp('plot_triangulation: Mode not supported.');
    end

    figure(1);
    hold on;
    cdata = 1:length(P{1});
    title(['Merge timepoint ', num2str(tPoint)], 'fontsize', 14);
    axis equal;
    h1 = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), cdata);    
    view(3);
    set(h1,'edgecolor','none');
    set(gca,'color','black');
    set(gcf,'color','black');
    axis off;
%     cmap = colormap(gray);
%     cmap(cmap>0.9) = 1; %Threshold highest values
    %This colormap plots the first protein in green, the second protein in
    %red, just swap for different colors.
    cmap = [P{2}, P{1}, zeros(size(P{1}))];
    colormap(cmap);
%     set(h1,'CData', cdata );
    az = -1;
    el = 7;
    view(az, el);
    if showAll == 1
        figure(2)
        hold on;
        cdata = 1:length(P{1});
        title(['Channel 1 timepoint ', num2str(tPoint)], 'fontsize', 14);
        axis equal;
        h1 = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), cdata);    
        view(3);
        set(h1,'edgecolor','none');
    %     cmap = colormap(gray);
    %     cmap(cmap>0.9) = 1; %Threshold highest values
        cmap = [zeros(size(P{1})), P{1}, zeros(size(P{1}))];
        colormap(cmap);
    %     set(h1,'CData', cdata );
        az = 47;
        el = 8;
        view(az, el);  
        figure(3)
        hold on;
        cdata = 1:length(P{2});
        title(['Channel 2 timepoint ', num2str(tPoint)], 'fontsize', 14);
        axis equal;
        h1 = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), cdata);    
        view(3);
        set(h1,'edgecolor','none');
    %     cmap = colormap(gray);
    %     cmap(cmap>0.9) = 1; %Threshold highest values
        cmap = [P{2}, zeros(size(P{2})), zeros(size(P{2}))];
        colormap(cmap);
    %     set(h1,'CData', cdata );
        az = 47;
        el = 8;
        view(az, el);
        hold off;
    end
end

