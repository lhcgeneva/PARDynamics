close all;
% clear all;
%% Define ellipsoid, sigma function
x_rad = 2;
y_rad = 1;
z_rad = y_rad;
precision = 200;
ang = 45;
[x, y, z] = ellipsoid(0, 0, 0, x_rad, y_rad, z_rad, precision);
S = sigmf(x, [-x_rad/2, 0]);
% S1 = sigmf(x+0*y + 0*z, [-x_rad, 0]);
%% Create rotation matrix, get 3*N vector of points of ellipsoid, rotate 
R = roty(ang);
sz = size(x);
sz = sz(1);
x_reshaped = reshape(x, 1, sz*sz);
y_reshaped = reshape(y, 1, sz*sz);
z_reshaped = reshape(z, 1, sz*sz);
points = [x_reshaped; y_reshaped; z_reshaped];
points_rotated = R * points;
x_rotated = reshape(points_rotated(1, :), sz, sz);
y_rotated = reshape(points_rotated(2, :), sz, sz);
z_rotated = reshape(points_rotated(3, :), sz, sz);
%% Create slicing plane
[X, Y] = meshgrid(0:x_rad/precision:x_rad, 0:x_rad/precision:y_rad);
l_x = length(0:x_rad/precision:x_rad);
l_y = length(0:x_rad/precision:y_rad);
m = zeros(l_x, l_y);
m_ind = zeros(l_x, l_y);
lin_ind_pos = zeros(l_y, 1);
lin_ind_neg = zeros(l_y, 1);
%% Do min least squares
tic
for j = 1 : l_y
    for i = 1 : l_x
        rep = repmat([X(j, i); Y(j, i); 0], size(points_rotated(1, :)));
        dif = rep-points_rotated;
        sz = size(dif);
        dist = sum(dif.*dif, 1);
        [m(i, j), m_ind(i, j)] = min(dist);
    end
    [~, ind] = min(m(:, j));
    lin_ind_pos(j) = m_ind(ind);
end
% Obviously symmetric, just to check computation/dimensions/directions
for j = 1 : l_y
    for i = 1 : l_x
        rep = repmat([-X(j, i); Y(j, i); 0], size(points_rotated(1, :)));
        dif = rep-points_rotated;
        sz = size(dif);
        dist = sum(dif.*dif, 1);
        [m(i, j), m_ind(i, j)] = min(dist);
    end
    [~, ind] = min(m(:, j));
    lin_ind_neg(j) = m_ind(ind);
end
% Compute data
S_data = [S(lin_ind_pos(1:end-1)); flipud(S(lin_ind_neg))];
toc
%% Plot initial ellipsoid, rotated ellipsoid, interpolated data
figure(1)
% Plot untilted ellipsoid
subplot(2, 2, 1);
surf(x, y, z, S, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
colormap('jet')
axis equal
axis tight
set(gca, 'FontName', 'Palatino');
set(gca,'TickDir','out');
set(gca, 'FontSize', 10, 'LineWidth', 1)
% Plot tilted ellipsoid with imaging plane
subplot(2, 2, 2);
% figure(2);
hold on;
surf(x_rotated, y_rotated, z_rotated, S, 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
shading interp
surf(X(1:2, :), Y(1:2, :), zeros(size(X(1:2, :))), 'EdgeColor','none','LineStyle','none','FaceLighting','phong');
shading interp
surf(X, Y, zeros(size(X)),'EdgeColor','none','LineStyle','none','FaceLighting','phong');
surf(-X, Y, zeros(size(X)),'EdgeColor','none','LineStyle','none','FaceLighting','phong');
surf(X, -Y, zeros(size(X)),'EdgeColor','none','LineStyle','none','FaceLighting','phong');
surf(-X, -Y, zeros(size(X)),'EdgeColor','none','LineStyle','none','FaceLighting','phong');
% whitebg('black')
axis equal
axis tight
% box off
grid on
set(gca, 'FontName', 'Palatino');
set(gca,'TickDir','out');
set(gca, 'FontSize', 10, 'LineWidth', 1)
a = gca;
% a.XColor = [0.98, 0.844, 0.16];
% a.YColor = [0.98, 0.844, 0.16];
% a.ZColor = [0.98, 0.844, 0.16];
view(3);
subplot(2, 2, 4); hold on;
plot(S_data(1:end-1), 'LineWidth', 2);
set(gca, 'FontName', 'Palatino');
set(gca,'TickDir','out');
set(gca, 'FontSize', 10, 'LineWidth', 1)
% set(gcf,'color','black')
xlabel('Position along embryo (a.u.)');
ylabel('Concentration (a.u.)');

subplot(2, 2, 3); hold on;
plot(s_temp(1:end-1), 'LineWidth', 2); %Run first for 0 degrees, then do s_temp=S_data in terminal, then rerun with 45 deg
set(gca, 'FontName', 'Palatino');
set(gca,'TickDir','out');
set(gca, 'FontSize', 10, 'LineWidth', 1)
% set(gcf,'color','black')
xlabel('Position along embryo (a.u.)');
ylabel('Concentration (a.u.)');

box off
a = gca;
% a.XColor = [0.98, 0.844, 0.16];
% a.YColor = [0.98, 0.844, 0.16];
% Set colormap
f = gcf;
f.Colormap(:, 1) = linspace(0, 1, 64);
f.Colormap(:, 3) = linspace(1, 0, 64);
f.Colormap(:, 2) = zeros(64, 1);
f.Colormap(:, 2) = 0.35*ones(64, 1);
print('/Users/hubatsl/Desktop/interplay-cell-size/Gradient/ZOrientation', '-dpng', '-r600');
%% Compute distance between points to correct for curvature
P = [ points_rotated(:,lin_ind_pos(1:end-1)), fliplr(points_rotated(:,lin_ind_neg(1:end))), ];