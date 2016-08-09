function Triangulation = zTriangulation( this, tPoint )
%ZTriangulation(this, tPoint) Gets triangulation for z stack
%   Detailed explanation goes here

Seg = this.SegmentationCell{tPoint};
p = [];
S{1} = [];
S{2} = [];
Z{1} = [];
Z{2} = [];

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
        Z{1} = [Z{1}; (P-min(P))/(max(P)-min(P))];
        temp = [this.resolution.x * temp1', this.resolution.y * temp2', ...
                    this.resolution.z * ones(max(size(temp1)),1) * i];
        p = [p; temp]; 
        if length(Seg.channels) == 2
            im = im2double(Seg.channels{2}{i});
            im = medfilt2(im,[8 8]);
            P = impixel(im,temp1,temp2);
            P = P(:, 1);
            S{2} = [S{2}; P];
            Z{2} = [Z{2}; (P-min(P))/(max(P)-min(P))];
        end
    catch
        disp(['No segmentation in plane nr. ', num2str(i)]);
    end
end

[t, tnorm] = MyRobustCrust(p);

%Create output structure
Triangulation.p = p;
Triangulation.S = S;
Triangulation.Z = Z;
Triangulation.t = t;
Triangulation.tnorm = tnorm;

end

