function rerun_segmentation(Seg, INPUT)
%RERAUN_SEGMENTATON Reruns manual correction and subsequent straigthening
%   INPUT is 1 if user wants to also rerun selection set_geometry()
    if nargin == 2 && INPUT 
        Seg.set_geometry('PROJECT'); 
        Seg.thresh_max{Seg.sz_all(3)}       = [];
        Seg.thresh_diff{Seg.sz_all(3)}      = [];
        Seg.thresh_sigma{Seg.sz_all(3)}     = [];
        [Seg.thresh_max, Seg.dist_mid_max]  = Seg.get_segmentation(  Seg.max_prec, ...
                                Seg.thresh_limits, 'MAX');
        [Seg.thresh_diff, Seg.dist_mid_diff]= Seg.get_segmentation(  Seg.diff_prec, ...
                                Seg.thresh_limits, 'DIFF');
        Seg.correct_difference();
        Seg.create_final_outline();
        Seg.thresh_corr = Seg.thresh_final;
    end
    h = imageGUI(Seg);
    waitfor(h);
    Seg.Imr_s{1} = Seg.straighten(Seg.channels{1});
    Seg.Imr_s{2} = Seg.straighten(Seg.channels{2});
end

