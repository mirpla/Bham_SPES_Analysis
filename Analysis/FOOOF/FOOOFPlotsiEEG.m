function [FQstat] = FOOOFPlotsiEEG(perpamlong, aperiodicparameters,DlFoofready)
preLocal   = perpamlong{1,1}(:,2);
preDistal    = perpamlong{1,2}(:,2);
postLocal   = perpamlong{1,3}(:,2);
postDistal    = perpamlong{1,4}(:,2);

idx = isnan( preLocal );
preLocal(idx) = [];
preDistal(idx) = [];
idx = isnan( preDistal );
preLocal(idx) = [];
preDistal(idx) = [];

idx = isnan( postLocal );
postLocal(idx) = [];
postDistal(idx) = [];
idx = isnan( postDistal );
postLocal(idx) = [];
postDistal(idx) = [];


%%
Prediff = preLocal -  preDistal;
Postdiff = postLocal -  postDistal;

pre1_SE = std( preDistal) / sqrt( length( preDistal ));
pre2_SE = std( preLocal ) / sqrt( length( preLocal ));
post1_SE = std( postDistal ) / sqrt( length( postDistal  ));
post2_SE = std( postLocal  ) / sqrt( length( postLocal  ));
DiffD_SE = std( Prediff  ) / sqrt( length( Prediff  ));
DiffV_SE = std( Postdiff ) / sqrt( length( Postdiff  ));
RMdata{1,1} = preDistal;
RMdata{2,1} = preLocal;
RMdata{1,2} = postDistal;
RMdata{2,2} = postLocal;
RMSE{1,1}   = pre1_SE;
RMSE{2,1}   = pre2_SE;
RMSE{1,2}   = post1_SE;
RMSE{2,2}   = post2_SE;

cl = 1/255*[76 0 153;255 128 0];

% bdw = 0.08;
% figure
% hc = rm_raincloud2x2Connected(RMdata,RMSE,cl,0,'ks',bdw,20,100,1);
% set(gca,'yticklabel',{'Post','Pre'})

% Difference Plot
% figure
% 
% h1 = raincloud_plot(Prediff, 'box_on', 1, 'color',1/255*[76 0 153], 'alpha', 0.5,...
%     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .66,...
%     'box_col_match', 0,'SE', DiffD_SE, 'band_width', bdw);
% h2 = raincloud_plot(Postdiff, 'box_on', 1, 'color',1/255*[255 128 0], 'alpha', 0.5,...
%     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .66,...
%     'box_col_match', 0,'SE', DiffV_SE, 'band_width', bdw );
% legend([h1{1} h2{1}],'Pre Difference (Local-Distal)', 'Post Difference (Local-Distal)' ) 
% title(['Periodic Component'])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
% %xlim([0 100])
% camroll(90)
% set(gca, 'XLimSpec', 'Tight');

%% Aperiodic Plots
for x = 1:2
    preLocal   = aperiodicparameters(1,:,x)';
    preDistal  = aperiodicparameters(2,:,x)';
    postLocal  = aperiodicparameters(3,:,x)';
    postDistal = aperiodicparameters(4,:,x)';
    
    Prediff = preLocal -  preDistal;
    Postdiff = postLocal -  postDistal;
    
    pre1_SE = std( preDistal) / sqrt( length( preDistal ));
    pre2_SE = std( preLocal ) / sqrt( length( preLocal ));
    post1_SE = std( postDistal ) / sqrt( length( postDistal  ));
    post2_SE = std( postLocal  ) / sqrt( length( postLocal  ));
    DiffD_SE = std( Prediff  ) / sqrt( length( Prediff  ));
    DiffV_SE = std( Postdiff ) / sqrt( length( Postdiff  ));
    RMdata{1,1} = preLocal;
    RMdata{2,1} = preDistal;
    RMdata{1,2} = postLocal;
    RMdata{2,2} = postDistal;
    RMSE{1,1}   = pre1_SE;
    RMSE{2,1}   = pre2_SE;
    RMSE{1,2}   = post1_SE;
    RMSE{2,2}   = post2_SE;
    
    cl = 1/255*[76 0 153;255 128 0];
    
%     bdw = 0.2;
%     figure
%     hc = rm_raincloud2x2Connected(RMdata,RMSE,cl,0,'ks',bdw,20,100,1);
%     set(gca,'yticklabel',{'Local','Distal'})
%     
    % Difference Plot
%     figure
%    
%     h1 = raincloud_plot(Prediff, 'box_on', 1, 'color',1/255*[76 0 153], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .66,...
%         'box_col_match', 0,'SE', DiffD_SE, 'band_width', bdw);
%     h2 = raincloud_plot(Postdiff, 'box_on', 1, 'color',1/255*[255 128 0], 'alpha', 0.5,...
%         'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .66,...
%         'box_col_match', 0,'SE', DiffV_SE, 'band_width', bdw );
%     legend([h1{1} h2{1}],'Pre Difference', 'Post Difference' )
%     set(gca,'ytick',[])
%     set(gca,'yticklabel',[])
%     %xlim([0 100])
%     camroll(90)
%      title(['Aperiodic Components'])
%     set(gca, 'XLimSpec', 'Tight');
end
%% Plot Aperiodic Components
for x = 1:size(aperiodicparameters,2)
    for y = 1:size(aperiodicparameters,1)
        off = aperiodicparameters(y,x,1);
        exp = aperiodicparameters(y,x,2);
        
        FQCorrected{y,x} = DlFoofready{y,x};
        FQCorrected{y,x}.powspctrm = log10(FQCorrected{y,x}.powspctrm)-(off - log10(DlFoofready{1,x}.freq.^exp));
        FQCorrected{y,x}.label = 'A';
    end
end

%%
for x = 1:size(FQCorrected,1)
    structarrayl = [FQCorrected{x,:}];
    FQTest{1,x} = vertcat(structarrayl(:).powspctrm);
end
for x = 1:size(FQCorrected,1)
    structarrayl = [FQCorrected{x,:}];
    SEM{1,x} = sqrt(mean(vertcat(structarrayl(:).powspctrmsem)));
end

cfg=[];
cfg.keepindividual = 'no';
GA{1,1} = ft_freqgrandaverage(cfg, FQCorrected{1,:}); % Pre Local
GA{1,2} = ft_freqgrandaverage(cfg, FQCorrected{2,:}); % Pre Distal
GA{2,1} = ft_freqgrandaverage(cfg, FQCorrected{3,:}); % Post Local
GA{2,2} = ft_freqgrandaverage(cfg, FQCorrected{4,:}); % Post Distal

[FQstat.clusters, FQstat.p_values, FQstat.t_sums, FQstat.permutation_distribution ] = permutest( FQTest{1,3}', FQTest{1,4}',false);

%%

% figure
% hold on
% shadedErrorBar(GA{2,1}.freq(2:end),GA{2,1}.powspctrm(2:end),std(FQTest{1,3}(:,2:end))/sqrt(size(FQTest{1,3},1)),'lineProps', '-b')
% hi = plot(GA{2,1}.freq(2:end),GA{2,1}.powspctrm(2:end), 'b');
% h(1) = hi(1);
% shadedErrorBar(GA{2,2}.freq(2:end),GA{2,2}.powspctrm(2:end), std(FQTest{1,4}(:,2:end))/sqrt(size(FQTest{1,4},1)),'lineProps', '-r')
% hi = plot(GA{2,2}.freq(2:end),GA{2,2}.powspctrm(2:end), 'r');
% h(2) = hi(1);
% legend(h,'Local', 'Distal');
% xlabel(['Frequency in Hz']);
% ylabel(['Power'])
% title(['PostLocal - PostDistal'])
% xlim([0 30])
% hold off

%%

%% Aperiodic Plots
for x = 1:size(aperiodicparameters,2)
    for y = 1:size(aperiodicparameters,1)
        off = aperiodicparameters(y,x,1);
        exp = aperiodicparameters(y,x,2);
        
        FOOOFSlope{y,x} = (off - log10(GA{2,1}.freq(2:end).^exp));
    end
end
%% Calculate mean slope and SE
for x = 1:4 % 1 = DLPFC post, 2 = DLPFC pre, 3 = Vertex post,4 = Vertex Pre 
    MeanSlope{1,x} = mean(cell2mat(FOOOFSlope(x,:)'),1);  
    SESlope{1,x} = std(cell2mat(FOOOFSlope(x,:)'),0,1)/sqrt(size(FOOOFSlope,2));    
%     cell2mat(structarraypre = [data{group,:,1}]);
%     psds = vertcat(structarraypre(:).powspctrm);)
end
%% Calculate mean difference Post-Pre 
MeanDiffSlope{1,1} = mean(cell2mat(FOOOFSlope(1,:)')-cell2mat(FOOOFSlope(2,:)'),1);
MeanDiffSlope{1,2} = mean(cell2mat(FOOOFSlope(3,:)')-cell2mat(FOOOFSlope(4,:)'),1);

%% Slope Figure
Colrs{1,1} = 1/255*[76,0,153];
Colrs{1,2} = 1/255*[20,0,220];
Colrs{2,1} = 1/255*[255,128,0];
Colrs{2,2} = 1/255*[255,30,0];
figure
%tiledlayout(1,2)
%ax1 = nexttile;

hold on 
plot(GA{2,1}.freq(2:end),MeanSlope{1,1},'Color',Colrs{1,1})
plot(GA{2,1}.freq(2:end),MeanSlope{1,2},'Color',Colrs{1,2})
%plot(GA{2,1}.freq(2:end),MeanDiffSlope{1,1},'--k')
% legend('Local Pre', 'Distal Pre','Local-Dista')
% set(gca, 'XScale', 'log')
% xticks(ax1,[0 5 10 20 30 45 70])
% axis('tight')
% hold on
plot(GA{2,1}.freq(2:end),MeanSlope{1,3},'Color',Colrs{2,1})
plot(GA{2,1}.freq(2:end),MeanSlope{1,4},'Color',Colrs{2,2})
%plot(GA{2,1}.freq(2:end),MeanDiffSlope{1,2},'--k')
legend('Local Pre', 'Distal Pre','Local Post','Distal Post')
set(gca, 'XScale', 'log')
axis('tight')
xticks([0 5 10 20 30 45 70])
% linkaxes([ax1 ax2],'y')
