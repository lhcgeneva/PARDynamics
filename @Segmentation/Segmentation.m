classdef Segmentation < handle
%SEGMENTATION(fname, seg_prec, lineThick, lut) 
%   returns cell outlines and straightened profiles using MIJ
%   Loads data (3-D stack), creates segmentation using different modes,
%   either all together or the ones specified (maximum intensity,
%   maximum difference, sigmoidal fit), loads ROIs into FIJI via MIJ
%   which does the straightening.

properties
    
    %Inputs
    filename;
    lineThick; %Line thickness used in FIJI
    lut = [];  %Look up table used for segmentation correction
    seg_prec;
    
    %Other properties
    channels;       %Imaging channels
    circle_props;   %Properties of circle, if mode contains 'Circle'
    curr_dir;       %Current directory (base for all file operations)
    dist_mid_max;   %Distance from midpoint to outline for each point 
    dist_mid_diff;  %Same for difference method
    dist_mid_sigma; %Same for sigma method
    Imr_s;          %Straightened profiles
    majorRadius;
    Merge;          %Overlay of the channels
    MergeBuff;      %Merge buffered with zeros to make square
    merge_factor = 2; %multiplier for channel2 (Im = (ch1 + MF*ch2)/(MF+1))
    midpoint;
    minorRadius;
    mode = 'MaxDiffCircle';
    posteriorPos;
    prec_diff = 10;
    prec_max = 5;
    prec_sigma = 20;
    priority_order = [1, 2]; %Order in which segmentations are used for final
    project_mode = 'PROJECT' %either 'external', 'internal_no_project', 'PROJECT'
    ROTATE = 1;     %Whether posterior should be rotated to start of outline
    saveImagingData = 'on'; %Save or drop imaging data (stack)
    straight = 0; %Whether straightening should be performed in constructor
    sz_all;         %Size 
    thresh_corr;    %User corrected final outline
    thresh_diff;    %Threshold as computed by maximum difference method
    thresh_diff_c;  %Threshold as corrected using the maximum method
    thresh_final;   %Final outline produced by algorithm
    thresh_limits = [0.8, 1.1];
    thresh_max;     %Threshold as computed by maximum methods
    thresh_rot;     %Rotated corrected final outline, posterior at beginning
    thresh_sigma;   %Threshold as computed by sigma fitting method
end

methods
    function Seg = Segmentation(file, seg_prec, lineThick, lut)
        if nargin > 0
            % Assign constructor inputs to properties
            if nargin == 4; Seg.lut = lut; end
            Seg.curr_dir = pwd;
            Seg.seg_prec = seg_prec;
            Seg.lineThick = lineThick;
            Seg.load_data(file, Seg.project_mode);
            
            % Preallocate outline lists, run segmentation
            Seg.segment_cell();
            Seg.correct_difference();
            Seg.create_final_outline();
            
            % Plot final segmentations, write padded imaging files to disk.
            Seg.thresh_corr = Seg.thresh_final;
%             h = imageGUI(Seg);
            h = imageGUI_App(Seg);
            waitfor(h);
            
            % Check, whether straightening should be performed within
            % constructor
            if Seg.straight
                Seg.Imr_s{1} = Seg.straighten(Seg.channels{1});
                if ~isempty(Seg.channels{2})
                    Seg.Imr_s{2} = Seg.straighten(Seg.channels{2});
                end
            end
            % Delete imaging data if not kept
            if strcmp(Seg.saveImagingData, 'off'); Seg.delete_Data(); end 
        end
    end
    
    correct_difference(Seg);
    correct_segmentation(Seg, index, IsPropagated);
    create_final_outline(Seg); 
    delete_Data(Seg);
    export_circle(Seg);
    export_thresh_corr(Seg);
    load_data(Seg, file, project_mode);
    plot_segmentations(Seg, frame, mode);
    register_circle(Seg, sliceNum);
    rerun_segmentation(Seg, INPUT);
    segment_cell(Seg, prec, g, mode);
    set_geometry(Seg, mode)
    S = straighten(Seg, input);
    write_images(Seg, subfolder, image_cell, tiff_style, filename);
end

methods(Static)
    [midpoint, minorRadius, majorRadius, g_handle, MergeBuff] = ...
                          define_geometry(MergeBuff, seedingMode, lut);
    dist                = dist_point_array(point, array);
    [out1,out2,out3]    = myginput(arg1, strpointertype);
                          plot_kymo(Imr_s, s, ax);
    [channels, merge]   = read_stack(Seg, filename );
    data_smooth         = smooth_periodic(data, window);
end
end