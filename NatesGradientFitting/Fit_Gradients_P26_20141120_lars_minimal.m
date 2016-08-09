function [Profile2, Distance, Sigma2 ] =  Fit_Gradients_P26_20141120_lars_minimal
% clear all, close all
pathname = uigetdir; % Select Dir
cd (pathname);
files = dir('*.tif');

% umpx = 0.133; % Old Andor FRAPPA

umpx = 0.129; % Andor 20101013
umpx = 0.202; %Tony
% umpx = 0.158; %Prairie
umpx = 0.202;
%%
Profile2 = NaN(1500,length(files));
Distance = NaN(1500,length(files));
Distance2 = NaN(1500,length(files));

%% Load File
for fileno = 1:length(files);
    filename = getfield(files,{fileno,1},'name');
    stack = loadmultitif(pathname, filename);
    stack = squeeze(stack);
    P2 = sort(stack(:,:,1),'descend');
    P2 = mean(P2(1:5,:),1);
    if mean(P2(1:round(length(P2)/2))) > mean(P2(end-round(length(P2)/2):end))
        disp('Gradient inverted');
        P2 = fliplr(P2);
    end
    Length = (1:length(P2))*umpx;

    Profile2(1:length(P2),(fileno)) = P2/mean(P2);
    Distance(1:length(Length),(fileno)) = Length;
end

for i  = 1:size(Profile2,2)
    notnan = ~isnan(Profile2(:,i));
    P2 = Profile2(notnan,i);
    x = Distance(notnan,i);
    
    P2s = smooth(P2, 100);
    maxlimit = sort(P2s, 'descend');
    minlimit = sort(P2s, 'ascend');
    half = (mean(maxlimit(1:50))-mean(minlimit(1:50)))/3+mean(minlimit(1:50));
    [~, halfpos] = min(abs(P2s-half));

    maxlimita = mean(maxlimit(1:round(length(x)/20)))-mean(minlimit(1:round(length(x)/20)));
    maxc = max(x);
    k = (halfpos - floor(length(x)/5)):(halfpos + floor(length(x)/5));    
    
    EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
    EFitOpts =   fitoptions(EFit);
    set(EFitOpts,'StartPoint',[1 1 halfpos 0.5]);
    set(EFitOpts,'Upper',[maxlimita 2 max(x(k)) 1]);
    set(EFitOpts,'Lower',[0 0 min(x(k)) -1]);        
     [EFitRes, ~] = fit(x(k),P2s(k),EFit,EFitOpts);
    
    k = find((x > (EFitRes.c-(2/(abs(EFitRes.m)))) & ( x <(EFitRes.c+(2/abs(EFitRes.m))))));
    
    EFitOpts =   fitoptions(EFit);
    set(EFitOpts,'StartPoint',[EFitRes.a EFitRes.b EFitRes.c EFitRes.m]);
    set(EFitOpts,'Upper',[maxlimita 2 maxc 1]);
    set(EFitOpts,'Lower',[0 0 0 -1]);
    [EFitRes, ~] = fit(x(k),P2(k),EFit,EFitOpts)

    Sigma2(i,1)=sqrt(2)/EFitRes.m;
    center2 = x(halfpos);
    Profile2(:,i)=(Profile2(:,i)-(EFitRes.b-EFitRes.a/2))./((EFitRes.b+EFitRes.a/2)-(EFitRes.b-EFitRes.a/2));
   
    
    Distance2(:,i) = Distance(:,i)-center2;
    Distance(:,i) = Distance2(:,i);     
end

