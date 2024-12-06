function [ICSUAcERP, SUAlbl] = SUAselectICctx(DataSUf,trialsel, CtxTrials, subjID)

param = [];
param.convol    = 50;
param.bswin     = 1000:2000;
param.stimwin   = 2000:4000;
param.maxpercentile     = 97.5;
param.minpercentile     = 2.5;
param.fs                = 1000;
param.trlsize           = 3;
param.clsize            = 50;

x = 1;
for c = 1:length(DataSUf)
    for su = 1:length(DataSUf{c})
        cfg = [];
        cfg.trials = trialsel;
        dum = ft_spike_select(cfg,DataSUf{c}{su});
        %dum.trialtime = dum.trialtime(trialsel,:);
        dum.trialinfo = dum.trialinfo(trialsel,:);
        
        dumCtx = [];
        for i = 1:length(CtxTrials)
            dumCtx = [dumCtx; find(dum.trialinfo ==  CtxTrials(i))]; % select trials during cortical stimulation
        end
        trlCtxSel = dumCtx;
        
        cfg = [];
        cfg.trials = trlCtxSel;
        ctxICnoC{c}{su} = ft_spike_select(cfg,dum);  
        
        param.trlsize   = round(ctxICnoC{c}{su}.trialtime(1,2));
        [~,ICSUAcERP{x}] = SUA_ConvIn(ctxICnoC{c}{su},param);
        
        ICSUAcERP{x}.label{1,1}(1:4) = [];
        ICSUAcERP{x}.label{1,1} = [num2str(subjID),'c',num2str(c),'u',num2str(su), ICSUAcERP{x}.label{1,1}];                   
        mtrL = mean(cell2mat(ICSUAcERP{x}.trial'),'omitnan');
        if any(isinf(mtrL))
            continue
        end
        
        SUAlbl{x} = ICSUAcERP{x}.label{1};

%         figure
%         plot(ICSUAcERP{x}.time{1,1}(2000:end-2000),mtrL(2000:end-2000),'k');
%         axis('tight')
        x = x + 1;
        
            end
end