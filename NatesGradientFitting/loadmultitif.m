function [stack] = loadmultitif (directory_name, file_name)

% loadmultitif inputs directory and filename of a desired multi-image tiff
% stack and returns a uint16 stack.

%% Read in multi-image tif
cd (directory_name);
info = imfinfo(file_name);
slices = length(info);
pixelwidth = info.Width;
pixelheight = info.Height;
stack = uint16(zeros(pixelheight,pixelwidth,1,slices)); %Preallocate stack
stack = (zeros(pixelheight,pixelwidth,1,slices)); %Use this line when
% comparing with new code (no conversion to integer necessary, more precise
% data!
for slice = 1:slices
   stack(:,:,:,slice) = imread(file_name,slice); 
end