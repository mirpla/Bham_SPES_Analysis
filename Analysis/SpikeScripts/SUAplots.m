%% Responsive vs Non-responsive
PieRat = ([size(find(Chanlist{1,1}),1)/size(Chanlist{1,1},1) size(find(Chanlist{1,1}-1),1)/size(Chanlist{1,1},1)]);
pie(PieRat,[1 0],{['39 Units (' num2str(round(PieRat(1),2)*100) '%)'], ['97 Units (' num2str(round(PieRat(2),2)*100) '%)']})
colormap([0.2 0.2 0.2; 0 0 1])
legend('Responsive Units','Unresponsive Units')

%% Current Distance Effect 
I = 8000; % 8mA = 8000 μA
K = 10:10:1500; % current-distance constant for an average pyramidal cortical neuron in μA/mm2 based on (Stoney et al., 1968)

r   = sqrt(I./K);
rm  = sqrt(I./1292);

figure
hold on
h1 = plot(K,r,'k','LineWidth',2);
h2 = plot(1292,rm,'rx','LineWidth',2,'MarkerSize',10);
h3 = plot(320,r(32),'rx','LineWidth',2,'MarkerSize',10);
text(1292,rm+0.75, num2str(rm))
yline(5,'k--','LineWidth',2)
yticks([0, 2.5, 5, 7.5, 10, 12.5, 15])
ylim([0,15])
xlabel('Current-Distance Constant in μA/mm^2')
ylabel('Distance in mm')
hold off

%% General Plot

trllim = 2900:4000;

ld = 1;
ldc =1;

InvChanlist = abs(Chanlist{1,ldc}-1);

% cfg                  = [];
% cfg.method           = 'montecarlo'; % use the Monte Carlo Method to calculate the significance probability
% cfg.statistic        = 'indepsamplesT'; % use the independent samples T-statistic as a measure to
% % evaluate the effect at the sample level
% cfg.correctm         = 'cluster';
% cfg.clusteralpha     = 0.05;       % alpha level of the sample-specific test statistic that
% % will be used for thresholding
% cfg.clusterstatistic = 'maxsum';   % test statistic that will be evaluated under the
% % permutation distribution.
% cfg.tail             = 0;          % -1, 1 or 0 (default = 0); one-sided or two-sided test
% cfg.clustertail      = 0;
% cfg.alpha            = 0.025;      % alpha level of the permutation test
% cfg.numrandomization = 10000;        % number of draws from the permutation distribution

% n_fc  = size(DUAm{1,dnum}.trial, 2);
% n_fic = size(DUAmI{1,dnum}.trial, 2);
% 
% cfg.design           = [ones(1,n_fic), ones(1,n_fc)*2]; % design matrix
% cfg.ivar             = 1; % number or list with indices indicating the independent variable(s)

% [stat{dnum}] = ft_timelockstatistics(cfg, DUAm{1,dnum}, DUAmI{1,dnum});

[clustersG, p_valuesG, t_sums, permutation_distribution ] = permutest(SUAmERP{1,ld}(logical(Chanlist{1,ldc}),trllim)', SUAmERP{1,ld}(logical(InvChanlist),trllim)',false,0.05,10000,true);
sigclust = p_valuesG<0.05;
% subplot(2,1,1)
% hold on
% h1 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),median(SUAmERP{1,ld}(logical(Chanlist{1,ld}),cfg.lim)),std(SUAmERP{1,ld}(logical(Chanlist{1,ld}),cfg.lim))/sqrt(length(find(Chanlist{1,ld}))));
% h2 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),median(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim)),std(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim))/sqrt(length(find(InvChanlist))),'lineProps','b');
% legend([h1.mainLine h2.mainLine],'Responsive Units','Unresponsive Units','AutoUpdate','off') 
% xline(0,'r')
% yline(0,'r')
% xlim([-0.1 1])
% xlabel('Time in s')
% ylabel('Gaussian Convolved Firing Rate')
% title(['Spike Density Plots of Median and Mean Firing Rate']);
% for clustnum = 1:find(sigclust)
%     plot([SUAnERP{1,ld}{1,1}.time{1,1}(clusters{1,1}(1,1)),SUAnERP{1,ld}{1,1}.time{1,1}(clusters{1,1}(1,end))],[0,0],'m','LineWidth',3)
% end
% hold off

% subplot(2,1,2)
hold on
cfg = [];
cfg.lim = 1:6001; 
InvChanlist = abs(Chanlist{1,ldc}-1);
h3 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),mean(SUAmERP{1,ld}(logical(Chanlist{1,ldc}),cfg.lim)),std(SUAmERP{1,ld}(logical(Chanlist{1,ldc}),cfg.lim))/sqrt(length(find(Chanlist{1,ldc}))));
h4 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),mean(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim)),std(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim))/sqrt(length(find(InvChanlist))),'lineProps','b');
legend([h3.mainLine h4.mainLine],'Responsive Units','Unresponsive Units','AutoUpdate','off') 
xline(0,'r')
yline(0,'r')
xlim([-0.1 1])
ylabel('Gaussian Convolved Firing Rate')
xlabel('Time in s')
if ~isempty(find(sigclust, 1))
    for clustid = 1:length(find(sigclust))
        plot([SUAnERP{1,ld}{1,1}.time{1,1}(clustersG{1,clustid}(1,1)+trllim(1)),SUAnERP{1,ld}{1,1}.time{1,1}(clustersG{1,clustid}(1,end)+trllim(1))],[0,0],'m','LineWidth',3)
    end
end
hold off
%% White matter Plot

cfg = [];
trllim = 2500:5001;
cfg.lim = trllim; 

ld = 1;
ldc = 1;

wInvChanlist = abs(wChanlist{1,ldc}-1);
[clusters, p_values, t_sums, permutation_distribution ] = permutest(SUAwERP{1,ld}(logical(wChanlist{1,ldc}),cfg.lim)', SUAwERP{1,ld}(logical(wInvChanlist),cfg.lim)',false,0.05,10000,true);
sigclust = p_values<0.05;

hold on
cfg = [];
cfg.lim = 1:6001; 
wInvChanlist = abs(wChanlist{1,ldc}-1);
h3 = shadedErrorBar(wSUAnERP{1,1}.time{1,1}(1,cfg.lim),mean(SUAwERP{1,ld}(logical(Chanlist{1,ldc}),cfg.lim)),std(SUAwERP{1,ld}(logical(wChanlist{1,ldc}),cfg.lim))/sqrt(length(find(wChanlist{1,ldc}))));
h4 = shadedErrorBar(wSUAnERP{1,1}.time{1,1}(1,cfg.lim),mean(SUAwERP{1,ld}(logical(wInvChanlist),cfg.lim)),std(SUAwERP{1,ld}(logical(wInvChanlist),cfg.lim))/sqrt(length(find(wInvChanlist))),'lineProps','b');
legend([h3.mainLine h4.mainLine],'Responsive Units','Unresponsive Units','AutoUpdate','off') 
xline(0,'r')
yline(0,'r')
xlim([-0.1 1.2])
ylabel('Gaussian Convolved Firing Rate')
xlabel('Time in s')
if ~isempty(find(sigclust, 1))
    for clustid = 1:length(find(sigclust))
        plot([wSUAnERP{1,1}.time{1,1}(clusters{1,clustid}(1,1)+trllim(1)),wSUAnERP{1,1}.time{1,1}(clusters{1,clustid}(1,end)+trllim(1))],[0,0],'m','LineWidth',3)
    end
end
hold off
%% White Matter Pie
PieRat = ([size(find(wChanlist{1,1}),1)/size(wChanlist{1,1},1) size(find(wChanlist{1,1}-1),1)/size(wChanlist{1,1},1)]);
pie(PieRat,[1 0],{['28 Units (' num2str(round(PieRat(1),2)*100) '%)'], ['97 Units (' num2str(round(PieRat(2),2)*100) '%)']})
colormap([0.2 0.2 0.2; 0 0 1])
legend('Responsive Units','Unresponsive Units')


%% Distances

trllim  = 2500:5001;
testlim = 2500:5001;
for dnum = 1:length(DUAm)
    
%     cfg                  = [];
%     cfg.latency          = [DUAm{dnum}.time{1,1}(testlim(1)) DUAm{dnum}.time{1,1}(testlim(end))];
%     
%     cfg.method           = 'montecarlo'; % use the Monte Carlo Method to calculate the significance probability
%     cfg.statistic        = 'indepsamplesT'; % use the independent samples T-statistic as a measure to
%     % evaluate the effect at the sample level
%     cfg.correctm         = 'cluster';
%     cfg.clusteralpha     = 0.05;       % alpha level of the sample-specific test statistic that
%     % will be used for thresholding
%     cfg.clusterstatistic = 'maxsum';   % test statistic that will be evaluated under the
%     % permutation distribution.
%     cfg.tail             = 0;          % -1, 1 or 0 (default = 0); one-sided or two-sided test
%     cfg.clustertail      = 0;
%     cfg.alpha            = 0.025;      % alpha level of the permutation test
%     cfg.numrandomization = 10000;        % number of draws from the permutation distribution
%     
%     n_fc  = size(DUAm{1,dnum}.trial, 2);
%     n_fic = size(DUAmI{1,dnum}.trial, 2);
%     
%     cfg.design           = [ones(1,n_fic), ones(1,n_fc)*2]; % design matrix
%     cfg.ivar             = 1; % number or list with indices indicating the independent variable(s)
%     
%     [statdist{dnum}] = ft_timelockstatistics(cfg, DUAm{1,dnum}, DUAmI{1,dnum});
%    
    disttrl{1,dnum} = cell2mat(DUAm{1,dnum}.trial');
    disttrl{2,dnum} = cell2mat(DUAmI{1,dnum}.trial');
%     [clusters, p_values, t_sums, permutation_distribution] = permutest(disttrl{1,dnum}(:,testlim)', disttrl{2,dnum}(:,testlim)',false,0.1,10000,true); 
%     AllClust{dnum} = clusters;
%     AllP{dnum} = p_values;
%     sigclust{dnum} = AllP{dnum}<(0.05/length(AllClust{dnum}));
   % AllPc{dnum} = cellfun('length',AllClust{dnum}(sigclust{dnum}))>=50;
    
    figure
    hold on
    InvChanlist = abs(Chanlist{1,ld}-1);
    
    h1 = shadedErrorBar(DUAm{1,dnum}.time{1,1},mean(disttrl{1,dnum}),std(disttrl{1,dnum}));
    h2 = shadedErrorBar(DUAmI{1,dnum}.time{1,1},mean(disttrl{2,dnum}),std(disttrl{2,dnum}),'lineProps','b');
    %h2 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),mean(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim)),std(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim)),'lineProps','b');
    
%     begsample = find(diff([0 statdist{dnum}.mask 0])== 1);
%     endsample = find(diff([0 statdist{dnum}.mask 0])==-1)-1;
%     for i=1:length(begsample)
%         begx = DUAm{1,dnum}.time{1,1}(begsample(i)+testlim(1));
%         endx = DUAm{1,dnum}.time{1,1}(endsample(i)+testlim(1));
%         plot([begx,endx],[0 0],'Color','r','linewidth',3)
%     end
%     
%     
%     if ~isempty(find( sigclust{dnum}, 1))
%         for clustid = 1:length(find(sigclust{dnum}))
%             plot([DUAm{1,1}.time{1,1}(AllClust{dnum}{1,clustid}(1,1)+testlim(1)),DUAm{1,1}.time{1,1}(AllClust{dnum}{1,clustid}(1,end)+testlim(1))],[0,0],'m','LineWidth',3)          
%         end
%     end
%     
    %legend([h3.mainLine h4.mainLine],'Responsive Units','Unresponsive Units','AutoUpdate','off')
    %     xline(0,'r')
    %     yline(0,'r')
    xlim([-0.1 1.2])
    ylabel('Gaussian Convolved Firing Rate')
    xlabel('Time in s')
    hold off
end
