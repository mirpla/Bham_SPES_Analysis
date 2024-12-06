function [stat]= SUAplotsE(SUAmERP,SUAnERP, Chanlist)%% Responsive vs Non-responsive
% PieRat = ([size(find(Chanlist{1,1}),1)/size(Chanlist{1,1},1) size(find(Chanlist{1,1}-1),1)/size(Chanlist{1,1},1)]);
% pie(PieRat,[1 0],{['39 Units (' num2str(round(PieRat(1),2)*100) '%)'], ['97 Units (' num2str(round(PieRat(2),2)*100) '%)']})
% colormap([0.2 0.2 0.2; 0 0 1])
% legend('Responsive Units','Unresponsive Units')

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

[stat.clustersG, stat.p_valuesG, stat.t_sums, stat.permutation_distribution ] = permutest(SUAmERP{1,ld}(logical(Chanlist{1,ldc}),trllim)', SUAmERP{1,ld}(logical(InvChanlist),trllim)',false,0.05,10000,true);
stat.sigclust = stat.p_valuesG<0.05;
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
figure
% subplot(2,1,2)
hold on
cfg = [];
cfg.lim = 1:6001; 
InvChanlist = abs(Chanlist{1,ldc}-1);
h3 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),mean(SUAmERP{1,ld}(logical(Chanlist{1,ldc}),cfg.lim)),std(SUAmERP{1,ld}(logical(Chanlist{1,ldc}),cfg.lim))/sqrt(length(find(Chanlist{1,ldc}))),'lineProps','b');
h4 = shadedErrorBar(SUAnERP{1,ld}{1,1}.time{1,1}(1,cfg.lim),mean(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim)),std(SUAmERP{1,ld}(logical(InvChanlist),cfg.lim))/sqrt(length(find(InvChanlist))),'lineProps','k');
legend([h3.mainLine h4.mainLine],'Responsive Units','Unresponsive Units','AutoUpdate','off') 
xline(0,'r')
yline(0,'r')
xlim([-0.1 1])
%ylim([-10 50])
ylabel('Gaussian Convolved Firing Rate')
xlabel('Time in s')
% if ~isempty(find(sigclust, 1))
%     for clustid = 1:length(find(sigclust))
%         plot([SUAnERP{1,ld}{1,1}.time{1,1}(clustersG{1,clustid}(1,1)+trllim(1)),SUAnERP{1,ld}{1,1}.time{1,1}(clustersG{1,clustid}(1,end)+trllim(1))],[0,0],'m','LineWidth',3)
%     end
% end
hold off