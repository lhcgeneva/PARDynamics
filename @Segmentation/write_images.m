function write_images(Seg, subfolder, image_cell, tiff_style, filename )
%WRITE_PADDED_IMAGES writes padded images to disk
%   Images were padded to make square for rotation and easier handling

if strcmp(tiff_style, 'SINGLE')
    mkdir(subfolder);
    try
        for jj = 1 : length(image_cell)
            imwrite(uint16(image_cell{jj}), ...
                [Seg.curr_dir,'/',subfolder,'/',filename, '_', num2str(jj), '.tif'], 'tif');
        end
    catch
        disp(['Writing interrupted at image no. ', num2str(jj)]);
    end
elseif strcmp(tiff_style, 'STACK')
    %Get straightening thickness, abort if not all the same
    s = cellfun(@(x) min(size(x)), image_cell);
    s = s(s~=0);
    if all(s==s(1)) 
        s = s(1); 
    else
        disp('Not all s equal, aborting'); 
        return; 
    end
    %Get maximum length of straightened profiles to then pad the others
    %with zeros
    m = max(cellfun(@(x) max(size(x)), image_cell));
    for i = 1 : length(image_cell)
        %Check whether frame is empty or all zeros
        if mean(mean(image_cell{i})) ~= 0 && ~isnan(mean(mean(image_cell{i})))
            im = [image_cell{i}, zeros(s, m - length(image_cell{i}))];
            imwrite(uint16(im),[filename, '.tif'],'WriteMode','append');
        else
            disp('image empty');
        end
    end
elseif strcmp(tiff_style, 'CSV')
    mkdir(subfolder);
    try
        for jj = 1 : length(image_cell)
            csvwrite([Seg.curr_dir,'/',subfolder,'/',filename, '_', num2str(jj), '.csv'],...
                uint16(image_cell{jj}));
        end
    catch
        disp(['Writing interrupted at image no. ', num2str(jj)]);
    end
end
    
end

