fi = 1;
z_pos = 0;
for ang = 10:10:90
    precision = 100;
    alpha = ang*pi/180;
    d = z_pos;
    a = 2;
    syms x;
    S = @(x) 1/2*(erf((x)*sqrt(2)/0.8));
    X = x;
    Y = sqrt(1 - x^2/a - (d - x/tan(alpha))^2);
    Y2 = sqrt(1 - x^2/a);
    Z = (d - x/tan(alpha));
    sol = solve(Y==0);
    X_dot = 1;
    Y_dot = matlabFunction(diff(Y));
    Z_dot = matlabFunction(diff(Z));
    Y2_dot = matlabFunction(diff(Y2));
    L = @(t) sqrt(Y_dot(t).^2 + Z_dot().^2 + 1);
    L2 = @(t) sqrt(Y2_dot(t).^2 + 1);
    len_c = zeros(precision, 1);
    len_x = zeros(precision, 1);
    len_x2= zeros(precision, 1);
    for ii = 1 : precision
        len_c(ii) = integral(L,0,1/precision*ii*double(sol(2)));
        len_x(ii) = 1/precision*ii*double(sol(2));
        len_x2(ii) = integral(L2,0,1/precision*ii*double(sol(2)));
    end
    len_xa(:, fi) = len_x;
    s_data(:, fi) = S(len_c);
    inter{fi} = interp1(len_xa(:, fi), s_data(:, fi), 0:0.01:max(len_xa(:, fi)));
    inter_x{fi} = 0:0.01:max(len_xa(:, fi));
    figure(1);
    plot(len_c, s_data/max(s_data));
    hold on;
    figure(2);
    plot(inter_x{fi}, inter{fi}/max(inter{fi}));
    hold on;
    fi = fi + 1;
end
%%
for ii = 1:9
int = [fliplr(-inter{ii}(~isnan(inter{ii}))), inter{ii}(~isnan(inter{ii}))];
Fi = Fit(int+0.5, 'on', 1, 'err');
s_i(ii) = Fi.curve.s;
end