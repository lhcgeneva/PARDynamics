close all
p1 = p(:, 1);
p2 = p(:, 2);
p3 = p(:, 3);
p1s = p1(p1>52);
p2s = p2(p1>52);
p3s = p3(p1>52);
scatter(p2s, p3s,[],P{2}(p1>52), 'filled')
func = @(f, a, b, c, n, x, y) n*(1-f.*y)./(1+exp(-c*(x-b)+y.*tan(a)))+0.35+n*y*f;
x = p2s;
y = p3s;
z = P{2}(p1>52);
alphaFit = fit([x, y], z, func);
plot3(x, y, z, 'o')
hold on;
% plot(alphaFit);
dummy = func(-0.1, 0.5, 30, 1.51, -0.25, x, -y+15);
plot3(x, y, dummy, 'o')