function export_thresh_corr(Seg)
%EXPORT_THRESH(Seg) Exports ROIs from thresh_corr to .txt files
%   Each frame gets one file, output is M x 2 matrix where M is the number
%   of sampling points in the Segmentation

if nargin == 2; cd(dir); end
for i = 1 : length(Seg.thresh_corr)
    dlmwrite(['ROI_plane_', num2str(i)], Seg.thresh_corr{i});
end

end

