function [channels, merge] = read_stack( filename, merge_factor  )
%READ_STACK(Seg, filename) Reads stack from file filename
%   Returns stack as a matrix, either as a merge 
%   (if two channels(filenames)) or as a single image.
if length(filename) == 2 
    fname = filename{1};
    fname2 = filename{2};
    info1 = imfinfo(fname);
    info2 = imfinfo(fname2);
    width = max([info1.Width]);
    height = max([info1.Height]);
    width2 = max([info2.Width]);
    height2 = max([info2.Height]);
    if length(info2) ~= length(info1) || width2 ~= width || height2 ~= height
        disp('Stacks are not of the same dimensions, aborting.');
        return;
    end
    channels{1}{length(info1)} = zeros(height, width);
    channels{2}{length(info1)} = zeros(height, width);
    merge = zeros(height, width, length(info1));
    for k = 1 : length(info1)
        channels{1}{k}(:,:) = imread(fname, k, 'Info', info1);
        channels{2}{k}(:,:) = imread(fname2, k, 'Info', info2);
        merge(:, :, k) = (channels{1}{k}(:, :) + merge_factor*channels{2}{k}(:, :))/...
                            (merge_factor + 1);
    end
elseif length(filename) == 1
    info1 = imfinfo(filename{1});
    width = max([info1.Width]);
    height = max([info1.Height]);
    channels{1}{length(info1)} = zeros(height, width);
    channels{2} = {};
    merge = zeros(height, width, length(info1));
    for k = 1 : length(info1)
        channels{1}{k}(:,:) = imread(filename{1}, k, 'Info', info1); 
        merge(:, :, k) = channels{1}{k}(:, :);
    end
end
end

