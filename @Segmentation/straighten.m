function  S = straighten( Seg, input)
%STRAIGHTEN Uses MIJ to straighten outlines in FIJI
%   straighten( Seg, input), input is a cell array containing 
%   image data. Interfaces with ImageJ/FIJI using MIJ (see project page online for
%   documentation). 

%% Start FIJI via MIJ, open padded images and send/display ROIs
if isempty(input)
    disp('Empty input provided to straighten, returning.');
    S = [];
end

curr = pwd;
start_frame = 1;
stop_frame = length(input);

% Save tifs and ROIs in directories that can be picked up by Miji
cd('~/');
% Change current directory to home folder so write_images() writes to
% correct folder which can be used by FIJI/Miji
temp = Seg.curr_dir;
Seg.curr_dir = '~/';
mkdir('temp_out');
mkdir('temp');
Seg.write_images('temp', input, 'SINGLE', 'in');
cd('~/temp');

% Rotate, so posterior is where straightened line starts
if Seg.ROTATE == 1
    for i = start_frame : stop_frame
        if isequal(size(Seg.posteriorPos), [1 1])
            temp_diff = Seg.thresh_corr{i}-repmat(Seg.posteriorPos{1}, [Seg.seg_prec,1]);
        else 
            temp_diff = Seg.thresh_corr{i}-repmat(Seg.posteriorPos{i}, [Seg.seg_prec,1]);
        end
        [~, ind] = min(temp_diff(:, 1).^2+temp_diff(:, 2).^2);
        Seg.thresh_rot{i} = [Seg.thresh_corr{i}(ind:end, :); Seg.thresh_corr{i}(1:ind-1, :)];
    end
end
% Interpolate points that are nan, either use rotated or unrotated outline,
% Add first point of circumference to end of circumference, to straighten
% everything, otherwise FIJI doesn't close the line to get the whole.
for i = start_frame : stop_frame
    if Seg.ROTATE == 0
        interpolated_circum = naninterp(Seg.thresh_corr{i});
    elseif Seg.ROTATE == 1
        interpolated_circum = naninterp(Seg.thresh_rot{i});
    end
    interpolated_circum = [interpolated_circum; interpolated_circum(1, :)];
    dlmwrite([num2str(i), '.txt'], interpolated_circum);
end
Seg.curr_dir = temp;
dlmwrite('lineThick.txt', Seg.lineThick);
% In order to get Miji and straighten_ROI to run copy the
% straighten_ROI.txt into Fiji's plugin folder (not macro folder!) and add
% Fiji's script folder to the path like so addpath(genpath('/Applications/Fiji.app/scripts'));
% Also make sure to have mij.jar in Applications/Fiji.app/jars/
evalc('Miji(false);'); %Miji is wrapped in evalc to suppress unnecessary output
MIJ.run('straighten ROI');
cd('~/temp_out');
for i = start_frame : stop_frame
    S{i} = imread([num2str(i),'.tif'], 'tif');
end
rmdir('~/temp', 's');
rmdir('~/temp_out', 's');
try
    cd(curr);
catch
    cd('~/Desktop');
end
end
