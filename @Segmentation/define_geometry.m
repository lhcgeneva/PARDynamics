function [ midpoint, minorRadius, majorRadius, MergeBuff, posteriorPos ] = ...
                                    define_geometry( MergeBuff, seedingMode, lut )
%DEFINE_GEOMETRY determines midpoint and geometrical constraints of cell
%   Depending on input parameters either tries to fit an ellipse to the
%   cell or uses manual input by clicking on midpoint and minor and major
%   radii.

%   Determine parameters
if seedingMode == 0
    h = fspecial('gaussian', [10 10], 30);
    blurred = imfilter(MergeBuff,h,'replicate');
    imshow(blurred, lut);
    title('Click on midpoint and on short and long axis membrane intersections, as well as on the posterior pole.');
    axis equal;
    % Using a version of ginput from about 2005/6, cause most recent one
    % seems to be buggy (crosshair vanishes after as soon as ginput() is
    % called). Also, myginput allows cooler pointer ('crosshair').
    [X, Y] = Segmentation.myginput(4, 'crosshair');
    midpoint=[X(1); Y(1); 1];
    minorRadius=sqrt(sum([X(1) - X(2), Y(1) - Y(2)].^2));
    majorRadius=sqrt(sum([X(1) - X(3), Y(1) - Y(3)].^2));
    posteriorPos=[X(4), Y(4)];
    % Swapping values in case majorRadius and minorRadius are clicked in 
    % the wrong order.
    if majorRadius < minorRadius 
        t = majorRadius; 
        majorRadius = minorRadius; 
        minorRadius = t; 
    end
% The following cannot define the posterior pole!
elseif seedingMode == 1;
    [~, threshold] = edge(MergeBuff, 'roberts');
    fudgeFactor = 0.65;
    BWs = edge(MergeBuff,'sobel', threshold * fudgeFactor);
    [x, y] = find(BWs);
    e = fit_ellipse(y, x, gcf);
    close all;
    angleDeg = e.phi/3.141592 * 180;
    BWs = imrotate(BWs, angleDeg);
    MergeBuff = imrotate(MergeBuff, angleDeg);
    I2 = uint16(255 * MergeBuff); 
    imwrite(I2, 's.tif');
    [x1, y1] = find(BWs);
    figure(2), imshow(BWs), title('binary gradient mask'); hold on;
    e = fit_ellipse(y1, x1, gcf);
    %set up ROI_av 
    ellipse_oversize = 0.1;
    width = e.short_axis*(1+ellipse_oversize);
    height = e.long_axis*(1+ellipse_oversize);
    X_0 = e.X0_in-e.short_axis/2-width*ellipse_oversize/2;
    Y_0 = e.Y0_in-e.long_axis/2-height*ellipse_oversize/2;
    h = imellipse(gca, [X_0 Y_0  width height]);
    BW = createMask(h);
    BWs(BW==0)=0;
    %Fit ellipse to data that's left
    [x, y] = find(BWs);
    figure
    imshow(MergeBuff, []); hold on;
    e = fit_ellipse(y, x, gcf);
    midpoint = [e.X0_in; e.Y0_in; 1];
    minorRadius = e.short_axis/2;
    majorRadius = e.long_axis/2;
else disp('Not a known seeding mode')
end

end

