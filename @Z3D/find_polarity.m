function find_polarity(this, tPoint, channel, PLOTTING)
%FIND_POLARITY Finds plane of highest polarity that goes through COM
%   Detailed explanation goes here
trans = this.TriangulationCell{tPoint}.tri_c;
tri_m = this.TriangulationCell{tPoint}.tri_m{channel};
ang = 0:5:175; % half rotations are enough for each plane, symmetries
tri_area = this.TriangulationCell{tPoint}.tri_area;

le = length(ang);
sums = zeros(le, le, le);

% Rotate embryo in 3D, calculate polarity for each plane. Polarity is
% defined by the overlap of the intensity histograms of both sides of the
% yz-plane.
if isempty(gcp('nocreate')); parpool(4, 'IdleTimeout', 600); end 
tic
for k = 1 : le
    for l = 1 : le
        for m = 1 : le
            % Rotate points
            trans_rot=(rotz(ang(m))*roty(ang(l))*rotx(ang(k))*trans')';
            
            % Get histogram of positive x points, normalize to triangle
            % area
            logic = trans_rot(:, 1) > 0;
            tri_area_greater_zero = tri_area(logic);
            [N, edges, bins] = histcounts(tri_m(logic));
            x1 = edges(1:end-1) + (edges(2)-edges(1))/2;
            f1 = zeros(1, length(x1));
            for i = 1:length(x1)
                f1(i) = N(i)*mean(tri_area_greater_zero(bins==i));
            end
            
            % Get histogram of negative x points, normalize to triangle
            % area
            logic = trans_rot(:, 1) < 0;
            tri_area_smaller_zero = tri_area(logic);
            [N, edges, bins] = histcounts(tri_m(logic));
            x2 = edges(1:end-1) + (edges(2)-edges(1))/2;
            f2 = zeros(1, length(x2));
            for i = 1:length(x2)
                f2(i) = N(i)*mean(tri_area_smaller_zero(bins==i));
            end
            
            % Interpolate points to the same x domain, to be able to
            % find overlap
            interp_domain = linspace(min([x1(:); x2(:)]),...
                                     max([x1(:); x2(: )]), 50);
            f1_interp = interp1(x1(~isnan(f1)), f1(~isnan(f1)),...
                                interp_domain, 'spline', 0);
            f2_interp = interp1(x2(~isnan(f2)), f2(~isnan(f2)),...
                                interp_domain, 'spline', 0);
            % Normalize histograms
            f1_interp = f1_interp/sum(f1_interp);
            f2_interp = f2_interp/sum(f2_interp);
            sums(k, l, m) = abs(2-sum(max([f1_interp;f2_interp])));
        end
    end
end
toc
% Find indices of angles for which polarity is maximal (minimum overlap)
[~, ind] = min(sums(:));
[xm,ym,zm] = ind2sub(size(sums), ind);

% Rotate p and tri_c by the angles found above (xm, ym, zm)
this.TriangulationCell{tPoint}.p_rot = (rotz(ang(zm))*roty(ang(ym))*rotx(ang(xm))*...
                                this.TriangulationCell{tPoint}.p_c')';
this.TriangulationCell{tPoint}.tri_c_rot = (rotz(ang(zm))*roty(ang(ym))*rotx(ang(xm))*...
                                this.TriangulationCell{tPoint}.tri_c')';

if PLOTTING
    this.plot_triangulation(tPoint);
    figure; hold on;
    histogram(tri_m(this.TriangulationCell{tPoint}.tri_c_rot(:, 1) > 0))
    histogram(tri_m(this.TriangulationCell{tPoint}.tri_c_rot(:, 1) < 0));
    
    trans_rot=(rotz(zm)*roty(ym)*rotx(xm)*trans')';

    % Get histogram of positive x points, normalize to triangle
    % area
    logic = trans_rot(:, 1) > 0;
    tri_area_greater_zero = tri_area(logic);
    [N, edges, bins] = histcounts(tri_m(logic));
    x1 = edges(1:end-1) + (edges(2)-edges(1))/2;
    f1 = zeros(1, length(x1));
    for i = 1:length(x1)
        f1(i) = N(i)*mean(tri_area_greater_zero(bins==i));
    end

    % Get histogram of negative x points, normalize to triangle
    % area
    logic = trans_rot(:, 1) < 0;
    tri_area_smaller_zero = tri_area(logic);
    [N, edges, bins] = histcounts(tri_m(logic));
    x2 = edges(1:end-1) + (edges(2)-edges(1))/2;
    f2 = zeros(1, length(x2));
    for i = 1:length(x2)
        f2(i) = N(i)*mean(tri_area_smaller_zero(bins==i));
    end

    % Interpolate points to the same x domain, to be able to
    % find overlap
    interp_domain = linspace(min([x1(:); x2(:)]),...
                             max([x1(:); x2(: )]), 50);
    f1_interp = interp1(x1(~isnan(f1)), f1(~isnan(f1)),...
                        interp_domain, 'spline', 0);
    f2_interp = interp1(x2(~isnan(f2)), f2(~isnan(f2)),...
                        interp_domain, 'spline', 0);  
    f1_interp = f1_interp/sum(f1_interp);
    f2_interp = f2_interp/sum(f2_interp);          
    figure; hold on;
    plot(interp_domain, f1_interp, 'b');
    plot(interp_domain, f2_interp, 'r');
end

end
