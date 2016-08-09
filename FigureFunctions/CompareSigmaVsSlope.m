load 17_05_16_green_red.mat
%%
close all;
Fit = Mo_Segs_P0_BIG1(6).Side1{8};
xScale = Fit.pixelSize * (1:length(Fit.fitData));
yDataSort = sort(Fit.fitData);
yData = Fit.fitData-mean(yDataSort(1:round(length(Fit.fitData)/5)));
F = Fit.curve;
F.a = 0;
figure; 

g = subplot(1, 2, 1); hold on; 
yFit = F(1:length(Fit.fitData));
plot(xScale, yData, 'LineWidth', 2);
plot(xScale, yFit, 'LineWidth', 3);
max_y = max(yData);
min_y = min(yData);
c = Fit.curve.c * Fit.pixelSize;
s = min(2*Fit.curve.s, 2*min(c-2, length(Fit.fitData)-c-2)) * Fit.pixelSize;
left = c-s/2;
right = c+s/2;
a = patch([left, right, right, left], ...
[0, 0, max_y, max_y], 1);
alpha(a, 0.2);
if isnan(Fit.sigmaInMicrons)
    alpha(a, 0.7); 
end
a.EdgeColor = 'none';
g.set('FontSize', 12);
axis([0 max(xScale) min_y max_y]);
xlabel('Embryo circumference [$\mu m$]', 'Interpreter', 'Latex', 'FontSize', 18);
ylabel('Intensity [a.u.]', 'Interpreter', 'Latex', 'FontSize', 18);

h = subplot(1, 2, 2); hold on;
calc_slope(yData, 71, 5, 1, h);
h.set('FontSize', 12);
h = xlabel('Embryo circumference [$\mu m$]', 'Interpreter', 'Latex', 'FontSize', 18);
set(h,'FontWeight','bold')
ylabel('m [$\frac{a.u.}{\mu m}$]', 'Interpreter', 'Latex', 'FontSize', 18, 'FontWeight', 'bold');
% axis([0 max(xScale) min_y max_y]);
