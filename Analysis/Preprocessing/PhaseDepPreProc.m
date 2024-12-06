function [ctxICnoC, ICSUAcERP, SUAlbl] = PhaseDepPreProc(Basepath)

chsel{1} = [23,31,39];
CtxTrials{1}   = [11, 12,17,18, 23];

chsel{2} = 100;
CtxTrials{2}   = [6,7];

chsel{3} = [1,9,17]; %maybe remove 9..
CtxTrials{3}   = [6,7,13,14,20,21];

chsel{4} = [25,33,41];
CtxTrials{4}   = [6,7,13,14,20,21];

chsel{5} = [53,61,69]; %maybe remove 69
CtxTrials{5}  = [6,7,13,14, 20,21,26,27];

chsel{6} = [1,9,17];
CtxTrials{6}   = [6,12,18];

chsel{7} = [33,41,49];
CtxTrials{7}   = [6,12,18];

chsel{8} = [17,25,33];
CtxTrials{8}   = [10,11];

chsel{9} = [1,9];
CtxTrials{9}   = [6,7,13];
%%

TrialArtf = readmatrix([Basepath,'Mircea/3 - SPES/Datasaves/Artifacts/Artf.csv']);
allsID = {'P07','P072','P08','P082','P09','P10','P102','P11','P112'};

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
    
    ICstim = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',subjID,'/' subjID,'_StimInfo.mat'];
    ICfile = [DataLocationIC, subjID,'_ICtrials.mat'];
    load(ICstim)
    load(ICfile)
    clear ICstim ICfile
    
    CTrialA = rmmissing(TrialArtf(x,:));
    trialsel = setdiff(1:length(ICtrials.trial),CTrialA);

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
    
    ctxICnoC{x} = IEEGpreProcessingnoCut(DataLocationIC,ICtrials,trialsel,x, chsel{x}, CtxTrials{x},allsID{x}); 
    [ICSUAcERP{x}, SUAlbl{x}]   = SUAselectICctx(DataSUf{x},trialsel,CtxTrials{x},allsID{x});
end