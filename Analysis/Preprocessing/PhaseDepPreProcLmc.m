function [HippLFP, ICSUAcERP, SUAlbl] = PhaseDepPreProcLmc(Basepath, AllMicro)

HippTrials{1}   = [7,8,13,14,19];
HippTrials{2}   = [1,2,3];
HippTrials{3}   = [1,2,8,9,15,16];
HippTrials{4}   = [1,2,8,9,15,16];
HippTrials{5}   = [1,2,8,22];
HippTrials{6}   = [1,2,7,13];
HippTrials{7}   = [1,2,7,13];
HippTrials{8}   = [5,6];
HippTrials{9}   = [1,2,8,9];


allsID = {'P07','P072','P08','P082','P09','P10','P102','P11','P112'};

for subjidx = 1:length(allsID)
     trllength(subjidx) =  length(AllMicro.Session{1,subjidx}.cfg.previous.trlold);
    if subjidx == 8      
        TrialArtf{subjidx} = setdiff(1:length(AllMicro.Session{1,8}.cfg.previous.trlold), AllMicro.Session{1,8}.cfg.trials);       
    else
        TrialArtf{subjidx} = [];
        for artfl = 1:length(AllMicro.Session{1,subjidx}.cfg.previous.artfctdef.visual.artifact)
            dum = find(AllMicro.Session{1,subjidx}.cfg.previous.trlold(:,2) > AllMicro.Session{1,subjidx}.cfg.previous.artfctdef.visual.artifact(artfl,1) ...
                & AllMicro.Session{1,subjidx}.cfg.previous.artfctdef.visual.artifact(artfl,1) > AllMicro.Session{1,subjidx}.cfg.previous.trlold(:,1));
            if any(size(dum) >1)
                warning(['Trial ',num2str(artfl), ' ', num2str(subjidx),' has multiple options, both trials removed'])
            end
            TrialArtf{subjidx} = [TrialArtf{subjidx}, dum'];
            clear dum
        end
    end
end

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


for x = [1,3,4,5,6,7,8,9]   
    subjID = allsID{x};
    if length(subjID) >= 4
        ses = str2num(subjID(4));
        if strcmp(allsID{x}, 'P082')
            continue
        end 
    else
        ses = 1;
    end
    DataLocationIC = [Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    
    ICstim = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',subjID,'/' subjID,'_StimInfo.mat'];
    ICfile = [DataLocationIC, '/LFP_artT_',subjID,'.mat'];
    load(ICstim)
    load(ICfile)
    clear ICstim ICfile
    
    CTrialA = rmmissing(TrialArtf{x});
    trialsel = setdiff(1:trllength(x),CTrialA);

%     %% make a trialinfo in the Datafile
%     CSCdatIED.trialinfo = zeros(length(CSCdatIED.trial),1);
%     for catgs =  1:length(StimSiteInfo.Indices)
%         for catcond = 1:length(StimSiteInfo.Indices{1,catgs})
%             CSCdatIED.trialinfo(StimSiteInfo.Indices{1,catgs}) = catgs.* ones(length(StimSiteInfo.Indices{1,catgs}),1);
%         end
%     end
    %%
     dumCtx = [];
     for i = 1:length(HippTrials{x})
         dumCtx = [dumCtx; find(CSCdatIED.trialinfo ==  HippTrials{x}(i))]; % select trials during cortical stimulation
     end
     trlCtxSel = dumCtx;
     
     cfg = [];
     cfg.trials =  trlCtxSel;
     HippLFP{x} = ft_selectdata(cfg,CSCdatIED); 
    
    [ICSUAcERP{x}, SUAlbl{x}]   = SUAselectICctx(DataSUf{x},trialsel,HippTrials{x},allsID{x});
end