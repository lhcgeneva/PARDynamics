function find_polarity(this, tPoint, channel, PLOTTING)
%FIND_POLARITY Finds plane of highest polarity that goes through COM
%   Detailed explanation goes here
trans = this.TriangulationCell{tPoint}.tri_c;
tri_m = this.TriangulationCell{tPoint}.tri_m{channel};
stepsize = 5; % Step size for rotation angle in deg
ang = 0:stepsize:180-stepsize; % half rotations are enough for each plane, symmetries
tri_area = this.TriangulationCell{tPoint}.tri_area;

le = length(ang);
sums = zeros(le, le, le);

% Rotate embryo in 3D, calculate polarity for each plane. Polarity is
% defined by the overlap of the intensity histograms of both sides of the
% yz-plane.
if isempty(gcp('nocreate')); parpool(4, 'IdleTimeout', 600); end 
tic
parfor k = 1 : le
    for l = 1 : le
        for m = 1 : le
            % Rotate points
            trans_rot=(rotz(ang(m))*roty(ang(l))*rotx(ang(k))*trans')';
            
%             % Get histogram of positive x points, normalize to triangle
%             % area
%             logic = trans_rot(:, 1) > 0;
%             tri_area_greater_zero = tri_area(logic);
%             [N, edges, bins] = histcounts(tri_m(logic));
%             x1 = edges(1:end-1) + (edges(2)-edges(1))/2;
%             f1 = zeros(1, length(x1));
%             for i = 1:length(x1)
%                 f1(i) = N(i)*mean(tri_area_greater_zero(bins==i));
%             end
%             
%             % Get histogram of negative x points, normalize to triangle
%             % area
%             tri_area_smaller_zero = tri_area(~logic);
%             [N, edges, bins] = histcounts(tri_m(~logic));
%             x2 = edges(1:end-1) + (edges(2)-edges(1))/2;
%             f2 = zeros(1, length(x2));
%             for i = 1:length(x2)
%                 f2(i) = N(i)*mean(tri_area_smaller_zero(bins==i));
%             end
%             
%             % Interpolate points to the same x domain, to be able to
%             % find overlap
%             interp_domain = linspace(min([x1(:); x2(:)]),...
%                                      max([x1(:); x2(: )]), 50);
%             f1_interp = interp1(x1(~isnan(f1)), f1(~isnan(f1)),...
%                                 interp_domain, 'spline', 0);
%             f2_interp = interp1(x2(~isnan(f2)), f2(~isnan(f2)),...
%                                 interp_domain, 'spline', 0);
%             % Normalize histograms
%             f1_interp = f1_interp/sum(f1_interp);
%             f2_interp = f2_interp/sum(f2_interp);
%             sums(k, l, m) = abs(2-sum(max([f1_interp;f2_interp])));
            
            % Alternatively: just sum up both sides of the histogram and
            % normalize each triangles intensity by its area as well as the
            % overall sum by the overall area of each side
            logic = trans_rot(:, 1) > 0;
            f1 = tri_area(logic)*tri_m(logic)'/sum(tri_area(logic));
            f2 = tri_area(~logic)*tri_m(~logic)'/sum(tri_area(~logic));
            sums(k, l, m) = abs(f1 - f2);
        end
    end
end
toc
% Find indices of angles for which polarity is maximal (minimum overlap)
% [~, ind] = min(sums(:)); % This is for overlap via interpolation
[~, ind] = max(sums(:)); % This is for difference via mean
[xm,ym,zm] = ind2sub(size(sums), ind); 

% Rotate p and tri_c by the angles (xm, ym, zm), save in TriangulationCell
this.TriangulationCell{tPoint}.p_rot = (rotz(ang(zm))*roty(ang(ym))*rotx(ang(xm))*...
                                this.TriangulationCell{tPoint}.p_c')';
this.TriangulationCell{tPoint}.tri_c_rot = (rotz(ang(zm))*roty(ang(ym))*rotx(ang(xm))*...
                                this.TriangulationCell{tPoint}.tri_c')';

% Save angles                          
this.Ang.x = ang(xm);
this.Ang.y = ang(ym);
this.Ang.z = ang(zm);
this.Ang.xind = xm;
this.Ang.yind = ym;
this.Ang.zing = zm;
    
% Get normalized histograms:

logic = this.TriangulationCell{tPoint}.tri_c_rot(:, 1) > 0;
% Get histogram of positive x points, normalize to triangle
% area
tri_area_greater_zero = tri_area(logic);
[N, edges, bins] = histcounts(tri_m(logic));
x1 = edges(1:end-1) + (edges(2)-edges(1))/2;
f1 = zeros(1, length(x1));
for i = 1:length(x1)
    f1(i) = N(i)*mean(tri_area_greater_zero(bins==i));
end
% Get histogram of negative x points, normalize to triangle
% area
tri_area_smaller_zero = tri_area(~logic);
[N, edges, bins] = histcounts(tri_m(~logic));
x2 = edges(1:end-1) + (edges(2)-edges(1))/2;
f2 = zeros(1, length(x2));
for i = 1:length(x2)
    f2(i) = N(i)*mean(tri_area_smaller_zero(bins==i));
end

% Interpolate points to the same x domain
interp_domain = linspace(min([x1(:); x2(:)]),...
                         max([x1(:); x2(: )]), 50);
f1_interp = interp1(x1(~isnan(f1)), f1(~isnan(f1)),...
                    interp_domain, 'spline', 0);
f2_interp = interp1(x2(~isnan(f2)), f2(~isnan(f2)),...
                    interp_domain, 'spline', 0);  
f1_interp = f1_interp/sum(f1_interp);
f2_interp = f2_interp/sum(f2_interp); 
% this.overlap{tPoint}{channel} = abs(2-sum(max([f1_interp;f2_interp])));
this.overlap{tPoint}{channel} = sum(min([f1_interp;f2_interp]));


if PLOTTING
    this.plot_triangulation(tPoint);
    
    % Plot unnormalized histograms of intensity +x and -x
    figure; hold on;
    histogram(tri_m(this.TriangulationCell{tPoint}.tri_c_rot(:, 1) > 0))
    histogram(tri_m(this.TriangulationCell{tPoint}.tri_c_rot(:, 1) < 0));  
    
    % Plot normalized histograms interpolated to the same domain
    figure; hold on;
    plot(interp_domain, f1_interp, 'b');
    plot(interp_domain, f2_interp, 'r');
end

end
