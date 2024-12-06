% function [ctxICnoC, ICSUAcERP, SUAlbl] = PhaseDepPreProcLP(Basepath)

CtxTrials{1}   = [11, 12,17,18, 23];

CtxTrials{2}   = [6,7];

CtxTrials{3}   = [6,7,13,14,20,21];

CtxTrials{4}   = [6,7,13,14,20,21];

CtxTrials{5}  = [6,7,13,14, 20,21,26,27];

CtxTrials{6}   = [6,12,18];

CtxTrials{7}   = [6,12,18];

CtxTrials{8}   = [10,11];

CtxTrials{9}   = [6,7,13];

CtxTrials{10}   = [6,7,13];

CtxTrials{11}   = [6,7,13];

CtxTrials{12}   = [6,7,13];
%%

TrialArtf = readmatrix([Basepath,'Mircea/3 - SPES/Datasaves/Artifacts/Artf.csv']);
allsID = {'P07','P072','P08','P082','P09','P10','P102','P11','P112', 'P12','P06'};

load([Basepath,'Mircea/3 - SPES/Datasaves/SpikeTrials.mat'])
x = 0;
for subjidx = 1:length(SPKtrls)
    for ses = 1:length(SPKtrls{1,subjidx})
        for chan = 1:length(SPKtrls{1,subjidx}{1,ses}.label)
            for pn = 1:size(SPKtrls,1)
                DataSUs{pn,subjidx}{1,ses}{1,chan} = SeparateSUnits(SPKtrls{pn,subjidx}{1,ses},chan);
            end
            DataSU{1,subjidx}{1,ses}{1,chan} = [DataSUs{1,subjidx}{1,ses}{1,chan},DataSUs{2,subjidx}{1,ses}{1,chan}];           
        end
        x = x +1;
        DataSUf{x} =  DataSU{1,subjidx}{1,ses};       
    end
end
clear DataSUs DataSU


for x = 1:length(allsID)   
    subjID = allsID{x};
    if length(subjID) >= 4
        ses = str2num(subjID(4));
        if strcmp(allsID{x}, 'P082')
            continue
        end 
    else
        ses = 1;
    end
    DataLocationIC = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    clear ICtrials
    ICstim = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',subjID,'/' subjID,'_StimInfo.mat'];
    ICfile = [DataLocationIC, subjID,'_ICtrials.mat'];
    load(ICstim)
    load(ICfile)
    clear ICstim ICfile
    
    CTrialA = rmmissing(TrialArtf(x,:));
    trialsel = 1:length(ICtrials.trial);

    %% make a trialinfo in the Datafile
    ICtrials.trialinfo = zeros(length(ICtrials.trial),1);
    for catgs =  1:length(StimSiteInfo.Indices)
        for catcond = 1:length(StimSiteInfo.Indices{1,catgs})
            ICtrials.trialinfo(StimSiteInfo.Indices{1,catgs}) = catgs.* ones(length(StimSiteInfo.Indices{1,catgs}),1);
        end
    end
    
    if x == 6 || x == 7
        ICtrials.label{91} = 'U';
    end
    %%
    clear ChanDum
    clear ChanDum2
    ICdataClean =     ICtrials;
    IEEGRereferenceLaplace

    cfg = [];
    cfg.demean			=	'yes';
    %cfg.baselinewindow	=	'all';
    cfg.bpfilter        =   'yes';
    cfg.bpfreq          =   [2,12];
    cfg.bpfilttype      =   'firws';  
    ICnoC	=	ft_preprocessing(cfg, ICReref);
    
    dumCtx = [];
    for i = 1:length(CtxTrials{x})
        dumCtx = [dumCtx; find(ICnoC.trialinfo ==  CtxTrials{x}(i))]; % select trials during cortical stimulation
    end
    trlCtxSel = dumCtx;
    
    cfg = [];
    cfg.trials = trlCtxSel;
    ctxICnoC{x} = ft_selectdata(cfg, ICnoC);
    
    [ICSUAcERP{x}, SUAlbl{x}]   = SUAselectICctx(DataSUf{x},trialsel,CtxTrials{x},allsID{x});
end