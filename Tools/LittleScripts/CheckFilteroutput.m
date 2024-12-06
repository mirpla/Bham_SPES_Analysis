Data = CSCdatPreProc;

cfg = [];
cfg.latency = [-1.2 -0.022];
SelectedData = ft_selectdata(cfg, Data);

%% Low Frequency

% cfg = [];
% cfg.output = 'pow';
% %cfg.channel = Datal.label(chanlist);
% cfg.method = 'mtmfft';
% cfg.foi = 1:1:30;
% cfg.tapsmofrq = 1;
% cfg.keeptrials = 'yes';
% ICfreq = ft_freqanalysis(cfg, SelectedData);
% 
% %cfg = []; ft_singleplotER(cfg, ICfreq)
% 
% cfg = [];
% cfg.toi = [-1.2 -0.022];
% [corrected, Slope] = sh_subtr1of(cfg,ICfreq);
% 
% for x = 1:length(squeeze(correctedH.powspctrm(1,:,1)))
%     figure
%     plot(squeeze(corrected.powspctrm(1,x,:)))
% end 

%% High frequency


cfg = [];
cfg.output = 'pow';
cfg.method = 'mtmfft';
cfg.foi = 30:4:150;
cfg.keeptrials = 'yes';
cfg.tapsmofrq = 2;
ICfreqH = ft_freqanalysis(cfg, SelectedData);

%cfg = []; ft_singleplotER(cfg, ICfreq)

cfg = [];
%cfg.toi = [-1.2 -0.022];
[correctedH, Slope] = sh_subtr1of(cfg,ICfreqH);

for x = 1:length(squeeze(correctedH.powspctrm(1,:,1)))
    figure
    plot(correctedH.freq , squeeze(correctedH.powspctrm(1,x,:)))
end 

