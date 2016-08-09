function [side1, side2] = cut_sides(imageCell, DONOTASSIGNSIDE)
%If DONOTASSIGNSIDE is true, the sides are randomly mixed, otherwise side 1
%will be the one more likely to be quantified 

intensity = cellfun(@(x) mean(sort(x(1:8,:),1, 'ascend'),1), imageCell, ...
                    'UniformOutput', false);
right   = mean(cell2mat(cellfun(@(x) mean(x(round(length(x)/2) : end)), ...
                intensity, 'UniformOutput', false)));
left    = mean(cell2mat(cellfun(@(x) mean(x(1 : round(length(x)/2))), ...
                intensity, 'UniformOutput', false)));
if DONOTASSIGNSIDE
    side2 = cellfun(@(x) x(:, 1:round(length(x)/2+length(x)/8)), imageCell, ...
                'UniformOutput', false);    
    side1 = cellfun(@(x) x(:, round(length(x)/2-length(x)/8):end), imageCell, ...
                'UniformOutput', false);
else
    if right > left                
        side1 = cellfun(@(x) x(:, 1:round(length(x)/2+length(x)/8)), imageCell, ...
                    'UniformOutput', false);    
        side2 = cellfun(@(x) x(:, round(length(x)/2-length(x)/8):end), imageCell, ...
                    'UniformOutput', false);
    elseif left > right    
        side2 = cellfun(@(x) x(:, 1:round(length(x)/2+length(x)/8)), imageCell, ...
                    'UniformOutput', false);    
        side1 = cellfun(@(x) x(:, round(length(x)/2-length(x)/8):end), imageCell, ...
                    'UniformOutput', false);
    else
        disp('This is pretty unlikely :P..., check in function cut_sides()');
        side1 = NaN;
        side2 = Nan;
    end
    
end
    
end