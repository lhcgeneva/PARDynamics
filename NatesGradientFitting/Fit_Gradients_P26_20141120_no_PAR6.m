function [Profile2, Distance, Sigma2 ] =  Fit_Gradients_P26_20141120_no_PAR6
clear all, close all
pathname = uigetdir; % Select Dir
cd (pathname);
files = dir('*.tif');

% umpx = 0.133; % Old Andor FRAPPA

umpx = 0.129; % Andor 20101013
% umpx = 0.158; %Prairie
umpx = 0.202; % Nate Tony
% umpx = 0.156;
%%
Profile2 = NaN(1500,length(files));
% Profile6 = NaN(1500,length(files));
Distance = NaN(1500,length(files));
Distance2 = NaN(1500,length(files));
% Distance6 = NaN(1500,length(files));


%% Load File
for fileno = 1:length(files);
    filename = getfield(files,{fileno,1},'name');
    stack = loadmultitif(pathname, filename);
    disp(filename)
    stack = squeeze(stack);
    P2 = sort(stack(:,:,1),'descend');
%     P6 = sort(stack(:,:,2),'descend');
    P2 = mean(P2(1:5,:),1);
%     P6 = mean(P6(1:5,:),1);
    x=1:length(P2);

    Length = (1:length(P2))*umpx;

    k = Length>=0;
    Profile2(1:length(P2),(fileno)) = P2/mean(P2);
%     Profile6(1:length(P6),(fileno)) = P6/mean(P6);
    Distance(1:length(Length),(fileno)) = Length;
    MeanTotDist(fileno)=max(Length);
end

for i = 1:size(Profile2,2)
    
    notnan = ~isnan(Profile2(:,i));
    P2 = Profile2(notnan,i);
%     P6 = Profile6(notnan,i);
    x = Distance(notnan,i);
    
    P2s = smooth(P2, 100);
    maxlimit = sort(P2s, 'descend');
    minlimit = sort(P2s, 'ascend');
    half = (mean(maxlimit(1:50))-mean(minlimit(1:50)))/3+mean(minlimit(1:50));
    [C, halfpos] = min(abs(P2s-half));
%     clf, hold on, plot(x, P2s),plot([x(halfpos) x(halfpos)], [min(P2s) max(P2s)]), pause

    maxlimita = mean(maxlimit(1:round(length(x)/20)))-mean(minlimit(1:round(length(x)/20)));
    maxc = max(x);
    k = (halfpos - floor(length(x)/5)):(halfpos + floor(length(x)/5));    
    
    EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
    EFitOpts =   fitoptions(EFit);
    set(EFitOpts,'StartPoint',[1 1 halfpos 0.5]);
    set(EFitOpts,'Upper',[maxlimita 2 max(x(k)) 1]);
    set(EFitOpts,'Lower',[0 0 min(x(k)) -1]);        
     [EFitRes, gof] = fit(x(k),P2s(k),EFit,EFitOpts);
    
%      
%     clf
%     hold all;    
%     plot(x,P2,'b-');     
%     y = EFitRes(x);
%     plot(x,y,'k-');
%     pause();
%     
    k = find((x > (EFitRes.c-(2/(abs(EFitRes.m)))) & ( x <(EFitRes.c+(2/abs(EFitRes.m))))));
    
    EFitOpts =   fitoptions(EFit);
    set(EFitOpts,'StartPoint',[EFitRes.a EFitRes.b EFitRes.c EFitRes.m]);
    set(EFitOpts,'Upper',[maxlimita 2 maxc 1]);
    set(EFitOpts,'Lower',[0 0 0 -1]);
    [EFitRes, gof] = fit(x(k),P2(k),EFit,EFitOpts);
% %     
%     disp(EFitRes);
%     disp(gof);
%     clf
%     hold all;
%     y = EFitRes(x);
%     plot(x,y,'k-');
%     plot(x,P2,'b-');
%     pause();

    Sigma2(i,1)=sqrt(2)/EFitRes.m;
    center2 = EFitRes.c;
    center2 = x(halfpos);
    Profile2(:,i)=(Profile2(:,i)-(EFitRes.b-EFitRes.a/2))./((EFitRes.b+EFitRes.a/2)-(EFitRes.b-EFitRes.a/2));
   
% PAR 6 analysis


% % % %     P6s = smooth(P6, 100);
% % % %     maxlimit = sort(P6s, 'descend');
% % % %     minlimit = sort(P6s, 'ascend');
% % % %     half = (mean(maxlimit(1:50))-mean(minlimit(1:50)))/3+mean(minlimit(1:50));
% % % %     [C, halfpos] = min(abs(P6s-half));
% % % % %     clf, hold on, plot(x, P6s),plot([x(halfpos) x(halfpos)], [min(P6s) max(P6s)]), pause
% % % % 
% % % %     maxlimita = mean(maxlimit(1:round(length(x)/20)))-mean(minlimit(1:round(length(x)/20)));
% % % %     maxc = max(x);
% % % %     k = (halfpos - floor(length(x)/5)):(halfpos + floor(length(x)/5));    
% % % %     
% % % %     EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
% % % %     EFitOpts =   fitoptions(EFit);
% % % %     set(EFitOpts,'StartPoint',[1 1 halfpos 0.5]);
% % % %     set(EFitOpts,'Upper',[maxlimita 2 max(x(k)) 1]);
% % % %     set(EFitOpts,'Lower',[0 0 min(x(k)) -1]);        
% % % %     [EFitRes, gof] = fit(x(k),P6s(k),EFit,EFitOpts);
% % % %     
% % % % %     clf
% % % % %     hold all;    
% % % % %     plot(x,P6,'b-');
% % % % %     y = EFitRes(x);
% % % % %     plot(x,y,'k-');
% % % % %     pause();
% % % % %     
% % % %     k = find((x > (EFitRes.c-(2/(abs(EFitRes.m)))) & ( x <(EFitRes.c+(2/abs(EFitRes.m))))));
% % % %     
% % % %     EFitOpts =   fitoptions(EFit);
% % % %     set(EFitOpts,'StartPoint',[EFitRes.a EFitRes.b EFitRes.c EFitRes.m]);
% % % %     set(EFitOpts,'Upper',[maxlimita 2 maxc 1]);
% % % %     set(EFitOpts,'Lower',[0 0 0 -1]);
% % % %     [EFitRes, gof] = fit(x(k),P6(k),EFit,EFitOpts);
% % % % %     
% % % % %     disp(EFitRes);
% % % % %     disp(gof);
% % % % %     clf
% % % % %     hold all;
% % % % %     y = EFitRes(x);
% % % % %     plot(x,y,'k-');
% % % % %     plot(x,P6,'b-');
% % % % %     pause();
% % % % 
% % % %     
% % % %     Profile6(:,i)=(Profile6(:,i)-(EFitRes.b-EFitRes.a/2))./((EFitRes.b+EFitRes.a/2)-(EFitRes.b-EFitRes.a/2));
% % % %     Sigma6(i,1)=sqrt(2)/EFitRes.m;
% % % %     center6 = EFitRes.c;
% % % %     center6 = x(halfpos);
    
    
    Distance2(:,i) = Distance(:,i)-center2;
%     Distance6(:,i) = Distance(:,i)-center6;
%     Distance(:,i) = Distance(:,i)-(0.5*(center2+center6));
    Distance(:,i) = Distance2(:,i);

    %     

%     clf
%     hold all
%     title([num2str(Sigma6(i)),' ',num2str(Sigma2(i))])
%     plot(Distance(:,i),smooth(Profile6(:,i)),'r-')
%     plot(Distance(:,i),smooth(Profile2(:,i)),'g-')
%     pause()


    
    
end

    
%% Extract Mean Curves

MinDist = floor(min(min(Distance)));
MaxDist = ceil(max(max(Distance)));

xi = MinDist:0.1:MaxDist;
for i = 1:size(Profile2,2)
    notnan = ~isnan(Profile2(:,i));
    interpolP2(:,i) = interp1(Distance(notnan,i),Profile2(notnan,i),xi);
%     interpolP6(:,i) = interp1(Distance(notnan,i),Profile6(notnan,i),xi);
    
end

meanP2 = mean(interpolP2,2);
% meanP6 = mean(interpolP6,2);
interpolP2 = (interpolP2-min(meanP2))./(max(meanP2)-min(meanP2));
% interpolP6 = (interpolP6-min(meanP6))./(max(meanP6)-min(meanP6));
meanP2 = mean(interpolP2,2);
% meanP6 = mean(interpolP6,2);
stdP2 = std(interpolP2,0,2);
% stdP6 = std(interpolP6,0,2);
maxP2 = max(interpolP2,[],2);
minP2 = min(interpolP2,[],2);
% maxP6 = max(interpolP6,[],2);
% minP6 = min(interpolP6,[],2);
Profile2=interpolP2;
% Profile6=interpolP6;


notnan = ~isnan(meanP2);
xi = xi(notnan);
xi = xi-min(xi);
xi1 =-(xi-max(xi));
xi2 =xi-max(xi);


meanP2 = meanP2(notnan);
% meanP6 = meanP6(notnan);
stdP2 = stdP2(notnan);
% stdP6 = stdP6(notnan);
maxP2 = maxP2(notnan);
minP2 = minP2(notnan);
% maxP6 = maxP6(notnan);
% minP6 = minP6(notnan);


%% Calculate Slope
xi = xi2;
k=xi<0;

maxlimit = sort(meanP2(k), 'descend');
minlimit = sort(meanP2(k), 'ascend');
maxlimita = mean(maxlimit(1:50))-mean(minlimit(1:50));
maxlimitb = mean(maxlimit(1:50))-0.5*maxlimita;
minc = min(xi);
maxc = max(xi);
midc = (minc+maxc)/2;

EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
EFitOpts =   fitoptions(EFit);
EFitOpts.Weights=1./stdP2(k).^2;
set(EFitOpts,'StartPoint',[0.5 0.5 midc 0]);
set(EFitOpts,'Upper',[maxlimita maxlimitb maxc 1]);
set(EFitOpts,'Lower',[0 0 minc -1]);        
[EFitRes2, gof] = fit(xi(k)',meanP2(k),EFit,EFitOpts);

while abs(EFitRes2(max(xi)) - EFitRes2(max(xi)-1)) > 0.001
    EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
    EFitOpts =   fitoptions(EFit);
    EFitOpts.Weights=1./stdP2(k).^2;
    set(EFitOpts,'StartPoint',[0.5 0.5 midc EFitRes2.m]);
    set(EFitOpts,'Upper',[maxlimita maxlimitb maxc 1]);
    set(EFitOpts,'Lower',[0 0 minc 1.1*EFitRes2.m]);        
    [EFitRes2, gof] = fit(xi(k)',meanP2(k),EFit,EFitOpts);
end

meanSigmaP2 = sqrt(2)/EFitRes2.m
figure, plot(xi(k),meanP2(k)), hold on, plot(xi, EFitRes2(xi))
    disp(EFitRes2);
    disp(gof);

% maxlimit = sort(meanP6(k), 'descend');
% minlimit = sort(meanP6(k), 'ascend');
% maxlimita = mean(maxlimit(1:50))-mean(minlimit(1:50));
% maxlimitb = mean(maxlimit(1:50))-0.5*maxlimita;
% 
% EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
% EFitOpts =   fitoptions(EFit);
% EFitOpts.Weights=1./stdP6(k).^2;
% set(EFitOpts,'StartPoint',[0.5 0.5 midc 0]);
% set(EFitOpts,'Upper',[maxlimita maxlimitb maxc 1]);
% set(EFitOpts,'Lower',[0 0 minc -1]);        
% [EFitRes6, gof] = fit(xi(k)',meanP6(k),EFit,EFitOpts);
% 
% while abs(EFitRes6(min(xi)) - EFitRes6(min(xi)+1)) > 0.001
%     EFit     =   fittype('a*0.5*( erf(m*(x - c))) + b'); 
%     EFitOpts =   fitoptions(EFit);
%     EFitOpts.Weights=1./stdP6(k).^2;
%     set(EFitOpts,'StartPoint',[0.5 0.5 midc EFitRes6.m]);
%     set(EFitOpts,'Upper',[maxlimita maxlimitb maxc 1.1*EFitRes6.m]);
%     set(EFitOpts,'Lower',[0 0 minc -1]);        
%     [EFitRes6, gof] = fit(xi(k)',meanP6(k),EFit,EFitOpts);
% end
%     
% 
% 
%     disp(EFitRes6);
%     disp(gof);
% meanSigmaP6 = sqrt(2)/EFitRes6.m
% figure, plot(xi(k),meanP6(k)), hold on, plot(xi, EFitRes6(xi))

%% Plot
xi = xi2;

xi = xi-(mean(MeanTotDist) + min(xi))/2;

XLIM = [min(xi),max(xi)];
% 
% subplot(2,3,1),hold on, plot(xi,meanP2+stdP2,'g-'),plot(xi,meanP2-stdP2,'g-'),plot(xi,meanP2,'g-','LineWidth',4),xlim(XLIM)
% subplot(2,3,4),hold on, plot(xi,meanP6+stdP6,'r-'),plot(xi,meanP6-stdP6,'r-'),plot(xi,meanP6,'r-','LineWidth',4),xlim(XLIM)
% 
% subplot(2,3,[2,3,5,6]), hold on, plot(xi,meanP2,'g-','LineWidth',2),plot(xi,meanP2+stdP2,'g.'),plot(xi,meanP2-stdP2,'g.'),plot(xi,meanP6,'r-','LineWidth',2),plot(xi,meanP6+stdP6,'r.'),plot(xi,meanP6-stdP6,'r.'),xlim(XLIM)
% 
figure('Position',[0 0 350 250]), hold on 
set(gca,'FontSize',14)
% plot(xi,meanP6+stdP6,'r:','MarkerSize',4,'MarkerEdgeColor',[1 0.8 0.8],'Color',[1 0.5 0.5])
% plot(xi,meanP6-stdP6,'r:','MarkerSize',4,'MarkerEdgeColor',[1 0.8 0.8],'Color',[1 0.5 0.5])
plot(xi,meanP2+stdP2,'g:','MarkerSize',4,'MarkerEdgeColor',[0.8 1 0.8],'Color',[0.5 1 0.5])
plot(xi,meanP2-stdP2,'g:','MarkerSize',4,'MarkerEdgeColor',[0.8 1 0.8],'Color',[0.5 1 0.5])
plot(xi,meanP2,'g-','MarkerSize',12,'LineWidth',3)
%plot(xi,EFitRes2(xi),'k-')
% plot(xi,meanP6,'r-','MarkerSize',12,'LineWidth',3)
%plot(xi,EFitRes6(xi),'k-')
xlim(XLIM)
ylim([-0.25 1.4])
text(200,80,['\omega = ',num2str(meanSigmaP2,2),'\mum'],'Units','pixels','Color','g','FontSize',14)
% text(20,80,['\omega = ',num2str(meanSigmaP6,2),'\mum'],'Units','pixels','Color','r','FontSize',14)
ylabel('Intensity (a.u.)')
xlabel('Distance from Posterior \mum')
set(gca,'XTickLabel',-get(gca,'XTick'));

figure('Position',[0 0 350 250]), hold on 
set(gca,'FontSize',14)
% plot(xi,maxP6,'r:','MarkerSize',4,'MarkerEdgeColor',[1 0.8 0.8],'Color',[1 0.5 0.5])
% plot(xi,minP6,'r:','MarkerSize',4,'MarkerEdgeColor',[1 0.8 0.8],'Color',[1 0.5 0.5])
plot(xi,maxP2,'g:','MarkerSize',4,'MarkerEdgeColor',[0.8 1 0.8],'Color',[0.5 1 0.5])
plot(xi,minP2,'g:','MarkerSize',4,'MarkerEdgeColor',[0.8 1 0.8],'Color',[0.5 1 0.5])
plot(xi,meanP2,'g.','MarkerSize',12,'LineWidth',3)
% plot(xi,meanP6,'r.','MarkerSize',12,'LineWidth',3)

xlim(XLIM)
ylim([-0.25 1.4])
text(200,80,['\omega = ',num2str(meanSigmaP2,2),'\mum'],'Units','pixels','Color','g','FontSize',14)
% text(20,80,['\omega = ',num2str(meanSigmaP6,2),'\mum'],'Units','pixels','Color','r','FontSize',14)
ylabel('Intensity (a.u.)')
xlabel('Distance from Posterior \mum')
set(gca,'XTickLabel',-get(gca,'XTick'));



%%
% [p,table,stats] = anova1([Sigma2,Sigma6])   

% centerx=(center2+center6)./2

