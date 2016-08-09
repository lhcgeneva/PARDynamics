function read_Meta_Data( Mo )
%READ_META_DATA Uses base folder to calculate time intervals, mags etc
%   Reads file creation date of .nd file, reads out start time, calculates
%   time interval between two acquisitions based on these two, also gets
%   magnification
%   NOT PROPERLY IMPLEMENTED YET, REVISIT!

%Creation date
names = dir('*.ND');
[~, str] = unix(['mdls ', [Mo.folder,names.name], ' -name kMDItemFSCreationDate']);
str = textscan(str,'%s');
t_create = datenum([str{1}{3},' ', str{1}{4}]);

%Acquisition start date
current_directory = pwd;
cd(Mo.folder)
names = dir('*.ND');
fid = fopen(names.name, 'r');
str = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
time_str    = str{1}{3};
t_acqu      = datenum((time_str(15:end)));

cd(current_directory);

end

