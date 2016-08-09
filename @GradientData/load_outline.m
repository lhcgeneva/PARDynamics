function load_outline()
% LOAD_OUTLINE loads outline of KoreTechs segmentation
%   Only used in Matlab segmentation mode
    outline = dir('*.mat');

    if isempty(sum(size(outline) > 1)) 
        warning('More than one Matlab file in Analysis folder, check for correct outline!');
    end
    load(outline(1).name);

end
    
    