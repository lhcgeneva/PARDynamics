function stack = load_stack( filename )
%LOAD_STACK(filename) Loads stack from filename
%   Written by lhcgeneva, potentially improve with metadata
info = imfinfo(filename);
des = info.ImageDescription;
des = strsplit(des);
try
    for i = 1:length(des)
        k = strfind(des{i}, 'slices');
        if k == 1; numZSlices = str2double(des{i}(8:end)); break; end
    end
catch
    numZSlices = 1;
end
numTPoints = 1; %Default, now check whether there is more than one frame
for i = 1:length(des)
    k = strfind(des{i}, 'frames');
    if k == 1; numTPoints = str2double(des{i}(8:end)); break; end
end
width = max([info.Width]);
height = max([info.Height]);
try
    stack = zeros(height, width, numZSlices, numTPoints);
    for j = 1:numTPoints
        for i = 1:numZSlices
            stack(:, :, i, j) = imread(filename, (j-1)*numZSlices+i, 'Info', info);
        end
    end
catch
    stack = zeros(height, width, length(info));
    for k = 1 : length(info)
        stack(:, :, k) = imread(filename, k, 'Info', info);
    end
    disp('Could not determine dimensions in Z and T, loading one dimensional stack.');
end
end

