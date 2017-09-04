function read_resolution(this)
%READ_Z_RESOLUTION looks for .log file, finds 3D resolution for SPIM data
%   Right now, this works only for diSPIM images. This function will be
%   different for every type of microscope/image acquisition software

file_split = cellfun(@(x) [x, '/'], strsplit(this.filename{1}, '/'),...
                     'UniformOutput', false);
foldername = strcat(file_split{1:end-1});
curr_dir = pwd;
cd(foldername);
log_file = dir('*.log');
log_file = log_file.name;
% Check whether log file is unique
if ~ischar(log_file)
    cd(curr_dir);
    error('Error in read_resolution(). More than one log file?');
end

fid = fopen(log_file);
data=textscan(fid,'%s %f %f','delimiter',',');
fclose(fid);
this.resolution.x = str2double(data{1}{6}(20:end));
this.resolution.y = str2double(data{1}{6}(20:end));
this.resolution.z = str2double(data{1}{7}(22:end));

end

