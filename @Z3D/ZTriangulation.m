function Triangulation = zTriangulation( this, tPoint )
%ZTriangulation(this, tPoint) Gets triangulation for z stack
%   Detailed explanation goes here

Seg = this.SegmentationCell{tPoint};
p = [];
S{1} = [];
S{2} = [];

% Get intensity values at each point segmented in Z-stack.
for i = 1 : length(Seg.thresh_corr)
    try 
        temp = Seg.thresh_corr{i};
        samp = 1:max(size(temp));
        quer = 1:0.25:max(size(temp));
        temp1 = round(interp1(samp, naninterp(temp(:, 1)), quer));
        temp2 = round(interp1(samp, naninterp(temp(:, 2)), quer));
        im = im2double(Seg.channels{1}{i});
        im = medfilt2(im,[8 8]);
        P = impixel(im,temp1,temp2);
        P = P(:, 1);
        S{1} = [S{1}; P];
        temp = [this.resolution.x * temp1', this.resolution.y * temp2', ...
                    this.resolution.z * ones(max(size(temp1)),1) * i];
        p = [p; temp]; 
        if length(Seg.channels) == 2
            im = im2double(Seg.channels{2}{i});
            im = medfilt2(im,[8 8]);
            P = impixel(im,temp1,temp2);
            P = P(:, 1);
            S{2} = [S{2}; P];
        end
    catch
        disp(['No segmentation in plane nr. ', num2str(i)]);
    end
end

[t, tnorm] = MyRobustCrust(p);

% Calculate triangle area for each triangle in the triangulation
tri_area = zeros(1, length(t));
for i = 1:length(t)
    tri_area(i) = triangle_area(p(t(i, :)', :));
end

% Caculate mean intensity for each triangle from vertex intensities based
% on S.
tri_m = cell(1, 2);
for i = 1:length(t)
    tri_m{1}(i) = mean(S{1}(t(i, :)))';
    if ~isempty(S{2})
        tri_m{2}(i) = mean(S{2}(t(i, :)))';
    end
end

% Calculate centroid: get centroids of every triangle in the triangulation,
% get average of all centroids, where each is weighted by its triangle's
% area.
tri_centr = zeros(size(t));
for i = 1:length(t)
    tri_centr(i, :) = mean(p(t(i, :)', :));
end
c = sum(tri_centr.*repmat(tri_area', 1, 3))/sum(tri_area);
tri_c = tri_centr - c;
p_c = p - c;

% Create output structure
Triangulation.c = c; %Centroid of Volume
Triangulation.p = p; %Point cloud, units: microns
Triangulation.p_c = p_c; %Points translated so center of mass is at 0
Triangulation.S = S; %Intensities at each point in p
Triangulation.t = t; %Triangulation using MyRobustCrust
Triangulation.tnorm = tnorm; %normal vectors from MyRobustCrust
Triangulation.tri_area = tri_area; %Area of each of the triangles in t
Triangulation.tri_c = tri_c; %Center of mass of each indiv. triangle in t, center:0
Triangulation.tri_m = tri_m; %Mean intensity of each triangle (mean of three points)
                             %For each channel

end

