function [ctxICnoC ] = IEEGpreProcessingnoCut(DataLocationIC, ICdataClean, trialsel,s, chsel, CtxTrials,subjID)
% preprocessing with filtering for noise etc (probably remove padding and baseline window)
% No Rereferencing?
IEEGRereferenceLaplace

cfg = [];
cfg.demean			=	'yes';
%cfg.baselinewindow	=	'all';
cfg.bpfilter        =   'yes';
cfg.bpfreq          =   [2,12];
cfg.bpfilttype      =   'firws';  
ICdataFilt	=	ft_preprocessing(cfg, ICReref);


%% Repeated Artifact Rejection
%  cfg = [];
%  cfg.viewmode = 'vertical';
%  ft_databrowser(cfg,ICdataFilt)

cfg            = [];
cfg.trials     = trialsel;
cfg.channel    = chsel;
ICnoC  = ft_selectdata(cfg,ICdataFilt);

dumCtx = [];
for i = 1:length(CtxTrials)
    dumCtx = [dumCtx; find(ICnoC.trialinfo ==  CtxTrials(i))]; % select trials during cortical stimulation
end
trlCtxSel = dumCtx;

cfg = [];
cfg.trials = trlCtxSel;
ctxICnoC = ft_selectdata(cfg, ICnoC);


%% Save Relevant Variables

filnam = [DataLocationIC, sprintf('10HzFiltnC_%s', num2str(s))];
save(filnam, 'ctxICnoC', '-v7.3');

end 