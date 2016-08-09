%%
filenames = dir('*.txt');
filenames = {filenames.name};
p = [];
Z = [];
S = [];
for i = 1 : length(filenames)
    temp = dlmread(['ROI copy ', num2str(11-i), '.txt']);
    samp = 1:max(size(temp));
    quer = 1:0.25:max(size(temp));
    temp1 = round(interp1(samp, temp(:, 1), quer));
    temp2 = round(interp1(samp, temp(:, 2), quer));
    im = im2double(imread([num2str(14-i), '.tif']));
    im = medfilt2(im,[5 5]);
    inds = sub2ind(size(im), temp1, temp2);
    Z = [Z; (im(inds)-min(im(inds)))/(max(im(inds))-min(im(inds)))];
    S = [S; im(inds)];
    temp = [0.255*temp1', 0.255*temp2', ones(max(size(temp1)),1)*i];
    p = [p; temp];  
end
%%
[t,tnorm]=MyRobustCrust(p);

%% plot the points cloud
figure(1);
set(gcf,'position',[0,0,1280,800]);
subplot(1,2,1)
hold on
axis equal
title('Points Cloud','fontsize',14)
plot3(p(:,1),p(:,2),p(:,3),'r.')
view(3);
axis vis3d


%% plot of the output triangulation
figure(1)
subplot(1,2,2)
hold on
title('Output Triangulation','fontsize',14)
axis equal
h = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), Z');
view(3);
set(h,'edgecolor','none');
subplot(1,2,1)
hold on
title('Output Triangulation','fontsize',14)
axis equal
h = trisurf(t(:, :),p(:,1),p(:,2),p(:,3), S');
cmap = colormap(gray);
cmap(cmap>0.9) = 1;
colormap(cmap);
view(3);
set(h,'edgecolor','none');