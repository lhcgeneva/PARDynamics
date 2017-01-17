classdef Segmentation < handle
%SEGMENTATION(fname, seg_prec, max_prec, diff_prec, sigma_prec, straighten_line_thickness) 
%   returns cell outlines and straightened profiles using MIJ
%   Loads data (3-D stack), creates segmentation using different modes,
%   either all together or the ones specified (maximum intensity,
%   maximum difference, sigmoidal fit), loads ROIs into FIJI via MIJ
%   which does the straightening.

properties
    %Inputs
    filename;
    seg_prec;
    max_prec;
    diff_prec;
    sigma_prec;
    straighten_line_thickness; %Line thickness used in FIJI
    look_up_table = [];
    %Other properties
    midpoint;
    majorRadius;
    minorRadius;
    posteriorPos;
    ROTATE = 1;         %Whether posterior should be rotated to start of outline
    thresh_limits;
    sz_all;         %Size 
    channels;       %Imaging channels
    Merge;          %Overlay of the channels
    MergeBuff;      %Merge buffered with zeros to make square
    channelsStr;    %Straightened channels
    Imr_s;          %Straightened profiles
    merge_factor;   %Factor by which ch2 is multiplied (Im = (ch1 + MF*ch2)/(MF+1))
    dist_mid_max;   %Distance from midpoint to outline for each point 
    dist_mid_diff;  %Same for difference method
    dist_mid_sigma; %Same for sigma method
    thresh_max;     %Threshold as computed by maximum methods
    thresh_diff;    %Threshold as computed by maximum difference method
    thresh_sigma;   %Threshold as computed by sigma fitting method
    thresh_diff_c;  %Threshold as corrected using the maximum method
    thresh_final;   %Final outline produced by algorithm
    thresh_corr;    %User corrected final outline
    thresh_rot;     %Rotated corrected final outline, posterior at beginning
    priority_order; %Order in which segmentations are used for final
    curr_dir;       %Current directory (base for all file operations
    saveImagingData;%Save or drop imaging data (stack) 
end

methods
    function Seg = Segmentation(file, seg_prec, max_prec, diff_prec, ...
                        sigma_prec, straighten_line_thickness, look_up_table)
        if nargin > 0
            %% Assign constructor inputs to properties
            Seg.curr_dir        = pwd;
            Seg.seg_prec        = seg_prec;
            Seg.max_prec        = max_prec;
            Seg.diff_prec       = diff_prec;
            Seg.sigma_prec      = sigma_prec;
            if nargin == 7; Seg.look_up_table = look_up_table; end
            Seg.thresh_limits   = [0.8, 1.1];
            Seg.priority_order  = [1, 2];
            Seg.straighten_line_thickness = straighten_line_thickness;
            Seg.merge_factor    = 3;
            Seg.saveImagingData = 'on';
            Seg.load_data(file, 'internal_no_project'); %internal_project for projection of all cells
            %% Preallocate outline lists, run segmentation
            Seg.thresh_max{Seg.sz_all(3)}       = [];
            Seg.thresh_diff{Seg.sz_all(3)}      = [];
            Seg.thresh_sigma{Seg.sz_all(3)}     = [];
            [Seg.thresh_max, Seg.dist_mid_max]  = Seg.get_segmentation(  Seg.max_prec, ...
                                    Seg.thresh_limits, 'MAX');
            [Seg.thresh_diff, Seg.dist_mid_diff]= Seg.get_segmentation(  Seg.diff_prec, ...
                                    Seg.thresh_limits, 'DIFF');        
%             [Seg.thresh_sigma, Seg.dist_mid_sigma] = get_segmentation( Seg, Seg.sigma_prec, ...
%                                     Seg.thresh_limits, 'SIGMA');
            Seg.correct_difference();
            Seg.create_final_outline();
            %% Plot final segmentations, write padded imaging files to disk.
            Seg.thresh_corr = Seg.thresh_final;
            h = imageGUI(Seg);
            waitfor(h);
            Seg.Imr_s{1} = Seg.straighten(Seg.channels{1});
            if ~isempty(Seg.channels{2})
                Seg.Imr_s{2} = Seg.straighten(Seg.channels{2});
            end
            %% Delete imaging data if not kept
            if strcmp(Seg.saveImagingData, 'off'); Seg.delete_Data(); end
        end
    end
                                correct_difference( Seg );
                                correct_segmentation( Seg, index, IsPropagated );
                                create_final_outline( Seg ); 
                                delete_Data(Seg);
                                export_thresh_corr(Seg);
    [outline, dist_mid] =       find_membrane( Seg, seg_prec, RoiHeight, MergeBuff, ...
                                        RoiWidth, midpoint, innerCircle, outerCircle, mode );
     [thresh, dist_mid] =       get_segmentation( Seg, prec, g, mode);
                                load_data(Seg, file, mode);
                                plot_segmentations( Seg, frame, mode );
                                rerun_segmentation(Seg, INPUT);
                                set_geometry( Seg, mode )
                                set_points( Seg );
                      S =       straighten( Seg, input);
                                write_images(Seg, subfolder, image_cell, tiff_style, filename );
end

methods(Static)
    [midpoint, minorRadius, majorRadius, g_handle, MergeBuff ] = ...
                          define_geometry( MergeBuff, seedingMode, look_up_table );
    dist                = dist_point_array(point, array);
    [out1,out2,out3]    = myginput(arg1, strpointertype); 
                          plot_kymo( Imr_s, s, ax );
    [channels, merge]   = read_stack(Seg, filename  );
    data_smooth         = smooth_periodic( data, window );
end
end

