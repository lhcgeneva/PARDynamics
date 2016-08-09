function find_files( Mov )
%FIND_FILES Finds location of 'both.tif' and side1/2.tif
%   ...and the two folders side1Names and side2Names in Analysis folder
    current_directory = pwd;
    Mov.bothName = [Mov.folder, '/both.tif'];
    side1Base = [Mov.folder, '/Analysis/side1/'];
    side2Base = [Mov.folder, '/Analysis/side2/'];
    try 
        if strcmp(Mov.segmentationMode, 'FIJI') || strcmp(Mov.segmentationMode, 'MAT2')
            cd(side1Base);
            side1Files = dir('*.tif');
            side1Files = struct2cell(side1Files);
            side1Name = side1Files(1, :);
            side1Name = cellfun(@(x) [side1Base, x], side1Name, 'UniformOutput', false);
            Mov.side1Name = side1Name;
            try
                cd(side2Base);
                side2Files = dir('*.tif');
                side2Files = struct2cell(side2Files);
                side2Name = side2Files(1, :);
                side2Name = cellfun(@(x) [side2Base, x], side2Name, 'UniformOutput', false);
                Mov.side2Name = side2Name;
                cd(side2Base);
                cd(current_directory);
            catch
                disp('No side2 folder available');
            end
        elseif strcmp(Mov.segmentationMode, 'SIMU')
            cd(side1Base);
            side1Files = dir('*.mat');
            side1Files = struct2cell(side1Files);
            side1Name = side1Files(1, :);
            side1Name = cellfun(@(x) [side1Base, x], side1Name, 'UniformOutput', false);
            Mov.side1Name = side1Name;
        end
    catch
        if strcmp(Mov.segmentationMode, 'FIJI')
            Mov.side1Name = {[Mov.folder, '/Analysis/side1.tif']};
            Mov.side2Name = {[Mov.folder, '/Analysis/side2.tif']};
        elseif strcmp(Mov.segmentationMode, 'SIMU')
            Mov.side1Name = {[Mov.folder, '/Analysis/side1.mat']};
        else
            disp('Unsupported segmentation type in Movie.find_files.');
        end
        try
            imread(Mov.side2Name{1});
        catch
            Mov.side2Name = [];
        end
    end
end

