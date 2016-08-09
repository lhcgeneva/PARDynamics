% i = ;

% for i = 10:10
% figure
% R{i}(R{i}==0) = nan;
% plot(smooth(nanmean( R{i}(y_t{i}:y_b{i}, x_t{i}:x_b{i})), 10));
[ma, ind] = max(smooth(nanmean( R{i}(y_t{i}:y_b{i}, x_t{i}:x_b{i})), 10));
figure(3)
imshow(R{i}, []);
hold on;
plot(M{i}(1), M{i}(2), 'r.','MarkerSize', 20);
plot([x_t{i}, x_b{i}], [y_b{i}, y_b{i}]);
plot([x_t{i}, x_b{i}], [y_t{i}, y_t{i}]);
plot(M{i}(1)+m, M{i}(2), 'r.','MarkerSize', 20);
% end
%%
figure(1);
clf;
imshow(Seg.MergeBuff{jj}, []);
hold on;
plot(outline_point_orig(1), outline_point_orig(2), 'r.', 'MarkerSize', 20);
plot(midpoint(1), midpoint(2), 'r.', 'MarkerSize', 20);
figure(2);
clf;
imshow(Imr_r, []);
hold on;
plot(outline_point(1), outline_point(2), 'r.', 'MarkerSize', 20);
plot(midpoint_r(1), midpoint_r(2), 'r.', 'MarkerSize', 20);
% figure(3);

% plot(F.curve);
% hold on;
% plot(fitdata);
%%
figure(1)
Imr_r(Imr_r==0) = nan;
hold on;
plot(smooth(nanmean( Imr_r(y_top:y_bot, x_top:x_bot)), 5));
[ma, ind] = max(smooth(nanmean( Imr_r(y_top:y_bot, x_top:x_bot)), 5));
figure(2)
imshow(Imr_r, []);
hold on;
plot(midpoint_r(1), midpoint_r(2), 'r.','MarkerSize', 20);
plot([x_top, x_bot], [y_bot, y_bot]);
plot([x_top, x_bot], [y_top, y_top]);
plot(midpoint_r(1)+ind-1, midpoint_r(2), 'r.','MarkerSize', 20);