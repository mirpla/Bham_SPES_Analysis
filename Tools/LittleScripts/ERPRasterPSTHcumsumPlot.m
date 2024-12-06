% 'Plot for Simon' of ERPs for channel 6 with corresponding MUA of local
% and Cortical stimulation conditions with a Cumulative Sum below with a
% line indicating distance between the two CUMSUMs

PreTime = -0.01; % Only for SpikePlots
PostTime = 0.01; % Only for SpikePlots
BoxColor = [0.9 0.9 0.9];
ID = AllMicro.SubjID{1,1};
Datal = eval(sprintf('CSCHippCond.%s.Conditions{1,1}', ID));
Datad = eval(sprintf('CSCHippCond.%s.Conditions{1,7}', ID));

timetrialsize = 6*32000+1;
resttrialsize = 6*1000+1;
sub = 1;
ID = AllMicro.SubjID{1,sub};
dum = AllMicro.MUAs{1,sub};
kk=1;
chan = 6;    

for trls = length(dum.trial{1,chan}):-1:1    
    if dum.time{1,chan}(1,trls) >= PreTime && dum.time{1,chan}(1,trls) <= PostTime
        idxRem(kk) = trls;
        dum.time{1,chan}(:,idxRem(kk)) = [];
        dum.trial{1,chan}(:,idxRem(kk)) = [];
        dum.unit{1,chan}(:,idxRem(kk)) = [];
        dum.timestamp{1,chan}(:,idxRem(kk)) = [];
        kk = kk+1;
    end    
end

f = figure('Name','Hippocampus AH -Channel 6');
%% ERPs
subplot(3,2,1)

for a = 1:length(Datal.trial)
    ERPlocal(a,:) = [Datal.trial{a}(5,1:2980), NaN(1, 3026 - 2981),  Datal.trial{a}(5,3026:end)];
    ERPbaselin(a,:) = Datal.trial{a}(5,1900:2900);
end



for a = 1:length(Datad.trial)
    ERPdistal(a,:) = [Datad.trial{a}(5,1:2980), NaN(1, 3026 - 2981),  Datad.trial{a}(5,3026:end)];
    ERPbasedin(a,:) = Datad.trial{a}(5,1900:2900);
end

hold on
shadedErrorBar(Datal.time{1,1}, mean(ERPlocal,1)-mean(mean(ERPbaselin)), std(ERPlocal)/sqrt(length(Datal.trial)),'lineProps', 'b')
axis tight
xlim([-0.1 1]);
ylim([-600 200])
y1 = get(gca, 'ylim');
rectangle('Position', [-0.02,y1(1),0.06, abs(y1(1))+ abs(y1(2))], 'FaceColor', BoxColor, 'Edgecolor',BoxColor)
hold off

subplot(3,2,2)
hold on
shadedErrorBar(Datal.time{1,1}, mean(ERPdistal,1)-mean(mean(ERPbasedin)), std(ERPdistal)/sqrt(length(Datad.trial)),'lineProps', 'r')
axis tight
xlim([-0.1 1]);
ylim([-75 100])
y1 = get(gca, 'ylim');
rectangle('Position', [-0.02,y1(1),0.06, abs(y1(1))+ abs(y1(2))], 'FaceColor', BoxColor, 'Edgecolor',BoxColor)
hold off


xlim([-0.1 1]);


%% CumSum
subplot(3,2,5:6)
postLat = [0.04 1];

cfg = [];
cfg.latency = postLat;
cfg.channel = 5;
cfg.avgoverrpt = 'yes';
CSCdatLHippPost = ft_selectdata(cfg, Datal);

cfg = [];
cfg.latency = postLat;
cfg.channel = 5;
cfg.avgoverrpt = 'yes';
CSCdatDHippPost = ft_selectdata(cfg, Datad);
   
AbsERPlocal = abs(CSCdatLHippPost.trial{1,1}(1,:));
ERPcSumLocal = cumsum(AbsERPlocal);
normERPLocal = ERPcSumLocal / ERPcSumLocal(1,end);

AbsERPdistal = abs(CSCdatDHippPost.trial{1,1}(1,:));
ERPcSumdistal = cumsum(AbsERPdistal);
normERPDistal= ERPcSumdistal / ERPcSumdistal(1,end);

hold on

clear h

hi = plot(CSCdatLHippPost.time{1,1}, normERPLocal, 'b');  % std(normERPLocal)/sqrt(length(Datal.trial)
h(1) = hi;
hi = plot(CSCdatDHippPost.time{1,1}, normERPDistal, 'r'); % std(normERPDistal)/sqrt(length(Datad.trial)
h(2) = hi;
legend(h, {'Local Stimulation', 'Cortical Stimulation'}, 'Location', 'southeast')
plot(0.180,0.2,'k*')
plot(0.343,0.2,'k*')
line([0.180, 0.343],[0.2 0.2], 'Color', 'k')

hold off

%% Spike Plots 
subplot(3,2,3)
cfg         = [];
cfg.binsize =  [0.04];
cfg.trials = TrialSelCond{1,1};
cfg.latency = [-0.1 1];
psthl = ft_spike_psth(cfg,dum);


cfg = [];
cfg.topplotfunc = 'line';
cfg.topplotsize = 0.3;
cfg.spikechannel = dum.label(6);
cfg.latency = [-0.1 1];
cfg.plotselection = 'yes';
cfg.errorbars = 'sem';
cfg.interactive = 'no';
cfg.trials = TrialSelCond{1,1};
cfg = ft_spike_plot_raster(cfg, dum, psthl,PreTime, PostTime);

hold on
x1 = PreTime;
y1 = get(gca,'ylim')+1;
x2 = PostTime-PreTime;
y1min = get(cfg.hdl.axRaster,'ylim');
%plot([x1 x1],y1, 'r')
rectangle('Position', [x1,y1(1), x2, y1(2)], 'FaceColor', BoxColor, 'Edgecolor',BoxColor)
hold off


subplot(3,2,4)
cfg         = [];
cfg.binsize =  [0.04];
cfg.latency = [-0.1 1];
cfg.trials = TrialSelCond{1,7};
psthd = ft_spike_psth(cfg,dum);

cfg = [];
cfg.topplotfunc = 'line';
cfg.spikechannel = dum.label(6);
cfg.latency = [-0.1 1];
cfg.topplotsize = 0.3;
cfg.plotselection = 'yes';
cfg.errorbars = 'sem';
cfg.interactive = 'no';
cfg.trials = TrialSelCond{1,7};
cfg = ft_spike_plot_raster(cfg, dum, psthd,PreTime, PostTime);
hold on
x1 = PreTime;
y1 = get(gca,'ylim')+1;
x2 = PostTime-PreTime;
y2 = y1;
%plot([x1 x1],y1, 'r')
rectangle('Position', [x1,y1(1), x2, y1(2)], 'FaceColor', BoxColor, 'Edgecolor',BoxColor)
hold off
