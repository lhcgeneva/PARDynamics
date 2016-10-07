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

%Save tifs and ROIs in directories that can be picked up by Miji
cd('/Users/hubatsl/');
%Change current directory to home folder so write_images() writes to
%correct folder which can be used by FIJI/Miji
temp = Seg.curr_dir;
Seg.curr_dir = '/Users/hubatsl/';
mkdir('temp_out');
mkdir('temp');
Seg.write_images('temp', input, 'SINGLE', 'in');
cd('/Users/hubatsl/temp');
for i = start_frame : stop_frame
    dlmwrite([num2str(i), '.txt'], naninterp(Seg.thresh_corr{i}));
end
Seg.curr_dir = temp;
dlmwrite('straighten_line_thickness.txt', Seg.straighten_line_thickness);
% In order to get Miji and straighten_ROI to run copy the
% straighten_ROI.txt into Fiji's plugin folder (not macro folder!) and add
% Fiji's script folder to the path like so addpath(genpath('/Applications/Fiji.app/scripts'));
evalc('Miji(false);'); %Miji is wrapped in evalc to suppress unnecessary output
MIJ.run('straighten ROI');
cd('/Users/hubatsl/temp_out');
for i = start_frame : stop_frame
    S{i} = imread([num2str(i),'.tif'], 'tif');
end
rmdir('/Users/hubatsl/temp', 's');
rmdir('/Users/hubatsl/temp_out', 's');
cd(curr);
end
