function export_circle(Seg)
csvwrite([Seg.filename{1}(1:end-4), '.csv'], [Seg.circle_props.r;...
                                       Seg.circle_props.cen_row;...
                                       Seg.circle_props.cen_col]);
end