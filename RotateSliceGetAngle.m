stack = load_stack('SP_G_ZT-1.TIF');
stack_cropped = imageRot(stack);
xy_res = 0.124;
z_res = 1;
orthogonalslicer(stack_cropped, [xy_res, xy_res, z_res])
pause();
f1 = gca;
f2 = figure;
copyobj(f1, f2);
all_figs = findall(0, 'type', 'figure');
delete(setdiff(all_figs, f2));
[x, z] = ginput(2);
x = x * xy_res;
z = z * z_res;
close(gcf);
angle = atan((z(1)-z(2))/(x(1)-x(2)))/pi*180;
%%
S = Segmentation({'Seg.tif', 'SegR.tif'}, 30, 10, 10, 20, 20);
