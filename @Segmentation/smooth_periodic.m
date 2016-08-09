function data_smooth = smooth_periodic( data, window )
%SMOOTH_PERIODIC Periodic smoothing (works for connected start and end) 
%   Always returns column!

m = max(size(data));
try
    repmat(data, m, 1);
    data_smooth = smooth([data, data, data], window);
    data_smooth = data_smooth(m + 1 : 2 * m);
catch
    disp('Error in smoothing, data is probably not a one dimensional array'); 
    data_smooth = [];
end

end

