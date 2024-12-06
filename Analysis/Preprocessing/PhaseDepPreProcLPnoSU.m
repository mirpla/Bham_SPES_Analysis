% function [ctxICnoCl] = PhaseDepPreProcLP(Basepath)

CtxTrials{1}   = [11, 12,17,18, 23];
CtxTrials{2}   = [6,7];
CtxTrials{3}   = [6,7,13,14,20,21];
CtxTrials{4}   = [6,7,13,14,20,21];
CtxTrials{5}   = [6,7,13,14, 20,21,26,27];
CtxTrials{6}   = [6,12,18];
CtxTrials{7}   = [6,12,18];
CtxTrials{8}   = [10,11];
CtxTrials{9}   = [6,7,13];
CtxTrials{10}  = [6];
CtxTrials{11}  = [9];
CtxTrials{12}  = [18,19,30,31,41,43];

HippTrials{1}  = [7,8,13,14,19,20];
HippTrials{2}  = [1,2];
HippTrials{3}  = [1,2,8,9,15,16];
HippTrials{4}  = [1,2,8,9,15,16];
HippTrials{5}  = [1,2,8,9, 15,16, 22,23];
HippTrials{6}  = [1,7,13];
HippTrials{7}  = [1,7,13];
HippTrials{8}  = [5,6];
HippTrials{9}  = [1,2,8,9];
HippTrials{10} = [1,2];
HippTrials{11} = [4];
HippTrials{12} = [14,15,25,26,36,37];
%%

%TrialArtf = readmatrix([Basepath,'Mircea/3 - SPES/Datasaves/Artifacts/Artf.csv']);
allsID = {'P07','P072','P08','P082','P09','P10','P102','P11','P112', 'P12','P06', 'P062'};

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
    
    %CTrialA = rmmissing(TrialArtf(x,:));
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

%     cfg = [];
%     cfg.demean			=	'yes';
%     %cfg.baselinewindow	=	'all';
%     cfg.lpfilter        =   'yes';
%     cfg.lpfreq          =   [1,40];
% %     cfg.bpfilttype      =   'firws';


    cfg = [];
    cfg.demean			=	'yes';
    %cfg.baselinewindow	=	'all';
    cfg.bpfilter        =   'yes';
    cfg.bpfreq          =   [2,12];
    cfg.bpfilttype      =   'firws'; 
    ICPreproc	=	ft_preprocessing(cfg, ICReref);

    if x == 10
        cfg = [];
        cfg.trials = 1:size(ICnoC.trial,2);
        ICPreproc = ft_selectdata(cfg, ICPreproc);
    end 
    [~,mcart] = setdiff(AllMicro.Session{1,x}.cfg.previous.trlold(:,1),AllMicro.Session{1,x}.cfg.previous.trl(:,1));
    artftrls = setdiff(1:size(ICPreproc.trial,2),mcart);
    
    cfg = [];
    cfg.trials = artftrls;
    ICnoC = ft_selectdata(cfg, ICPreproc);
    dumCtx = [];
    for i = 1:length(CtxTrials{x})
        dumCtx = [dumCtx; find(ICnoC.trialinfo ==  CtxTrials{x}(i))]; % select trials during cortical stimulation
    end
    trlCtxSel = dumCtx;
    
    cfg = [];
    cfg.trials = artftrls;
    ICnoC = ft_selectdata(cfg, ICPreproc);
    dumCtx = [];
    for i = 1:length(HippTrials{x})
        dumCtx = [dumCtx; find(ICnoC.trialinfo ==  HippTrials{x}(i))]; % select trials during cortical stimulation
    end
    trlHippSel = dumCtx;
    
   
    cfg = [];
    cfg.trials = trlCtxSel;
    ctxICnoC{x} = ft_selectdata(cfg, ICnoC);
    microSelIC{x} = ft_selectdata(cfg, AllMicro.Session{1,x});
    
    cfg = [];
    cfg.trials = trlHippSel;
    ctxICnoH{x} = ft_selectdata(cfg, ICnoC);
    microSelIH{x} = ft_selectdata(cfg, AllMicro.Session{1,x});
    
end