function rerun_segmentation(Seg, userInput)
%RERAUN_SEGMENTATON Reruns manual correction and subsequent straigthening
%   userInput is 1 if user wants to also rerun selection set_geometry()
if nargin == 2 && userInput 
    Seg.set_geometry('PROJECT'); 
    Seg.thresh_max{Seg.sz_all(3)}       = [];
    Seg.thresh_diff{Seg.sz_all(3)}      = [];
    Seg.thresh_sigma{Seg.sz_all(3)}     = [];
    Seg.segment_cell();
    Seg.correct_difference();
    Seg.create_final_outline();
    Seg.thresh_corr = Seg.thresh_final;
end
h = imageGUI(Seg);
waitfor(h);
Seg.Imr_s{1} = Seg.straighten(Seg.channels{1});
Seg.Imr_s{2} = Seg.straighten(Seg.channels{2});
if Seg.straight
    Seg.Imr_s{1} = Seg.straighten(Seg.channels{1});
    Seg.Imr_s{2} = Seg.straighten(Seg.channels{2});
end

end