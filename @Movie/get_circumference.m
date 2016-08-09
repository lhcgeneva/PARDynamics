function circumference = get_circumference( Mov )
%get_cell_size Get cell circumference 
%   Determines circumference of cell by measuring length of the both.tif
%   file containing the full straightened intensity profile 
    try
        TIFF = imread([Mov.folder, '/both.tif']);
        circumference = Mov.pixelSize * max(size(TIFF));
    catch
        try 
            temp = dir('*.mat');
            load([Mov.folder, '/Analysis/side1/', temp(1).name]);
            circumference = 2 * L;
        catch
            circumference = NaN;
            disp(['No both.tif file available in ', Mov.folder, ', setting circumference to NaN.']);
        end
    end
end

