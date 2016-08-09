% Takes straightened cortex and fits gaussian to each position across
% membrane to obtain an intensity profile for the membrane, based on output
% of Peter's code but easily adaptable for reading in tiffs

y_arr = Profiles{1}.crtxslice.both(:, round(size(Profiles{1}.crtxslice.both,2)/4):...
    round(size(Profiles{1}.crtxslice.both,2)/4*3));
x = 1:size(y_arr,2);

% Intensity = zeros(size(y_arr,1), 1);
Intensity = [];
for i = 1:size(y_arr,1)
    if i > 1
%         Intensity(i-1)
    end
    y = y_arr(i, :);
    sorted = sort(y, 'ascend');
    y = y - mean(sorted(1:round(length(sorted)/10)+1));
    try
        fo = fitoptions('Method','NonlinearLeastSquares',...
                   'Lower',[0,0,0],...
                   'Upper',[Inf, Inf, Inf],...
                   'StartPoint',[max(y), length(x)/2, 4]);
        [f, gof] = fit(x',smooth(y'),'gauss1');
        values = coeffvalues(f);
        Intensity(i) = values(1);
    catch
        Intensity(i) = NaN;
    end
%     values(1)
%     Intensity(i)
end
Intensity(Intensity>1000) = NaN;
%%  Plot
figure(1)
hold on;
plot(Profiles{1}.kymograph.both);
plot(Intensity);
axis([0 600 0 1000]);