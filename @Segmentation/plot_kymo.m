function plot_kymo( Imr_s, straighten_line_thickness, ax )
%PLOT_KYMO Plots kymograph of Imr_s
%   Uses straightened profiles saved in object to plot kymograph and
%   membrane intensity over time
%   ax ... cell of axes used to display kymographs in

%% Plot kymograph of straightened lines
maximum_length = max(cellfun(@(x) max(size(x)), Imr_s));
im = zeros(length(Imr_s) * straighten_line_thickness, maximum_length);
for j = 1 : length(Imr_s)  
    for i = 1:length(Imr_s{1})
        im((i-1)*straighten_line_thickness+1:i*straighten_line_thickness,...
            1:length(Imr_s{j}{i})) = Imr_s{j}{i};
    end
    if nargin == 2
        figure;
        imshow(im, []);
    elseif nargin == 3
        axes(ax{j});
        subimage(im, [0, max(im(:))]);
    end
end
%% Plot mean membrane intensity over time
if 1 == 0
    for j = 1:length(Imr_s)
        for i = 1 : length(Imr_s{1})
            int = Imr_s{j}{i};
            int = sort(int,'descend');
            try
            int = int(1:5, :);
            catch
                int = 0;
            end
            int_f{j}{i} = smooth(nanmean(int));
        end
        p{j} = cellfun(@(x) mean(x'), int_f{j});
        figure;
        plot(smooth(p{j}(p{j}~=0)));
    end
    shg
end
end

