PatientIDs = {'P07', 'P072', 'P08', 'P082', 'P09', 'P10', 'P102','P11','P112'};

for x = 1:length(PatientIDs)
    subjID = PatientIDs{x}
    FTPPS(Basepath, subjID)
end 

for subjidx = 1:length(PatientIDs)
    subjID = PatientIDs{1,subjidx};
    
    if length(subjID) >= 4
        ses = 2;
    else
        ses = 1;
    end
    
    load([Basepath, 'Mircea/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/',PatientIDs{subjidx},'_ProcessedNF.mat'])
    load([Basepath, 'Mircea/Datasaves/Macro/stringstimsite/',PatientIDs{subjidx},'/',PatientIDs{subjidx},'_StimInfo.mat'])
    AllMacro.StimSite{1,subjidx}  = StimSiteInfo;
    AllMacro.SubjID{1,subjidx}    = PatientIDs{1,subjidx};
    AllMacro.Session{1,subjidx}   = ICprocessed;
    clear ICprocessed
    clear StimSiteInfo
end

save([Basepath, 'Mircea/Datasaves/Macro/MacroDataNF'],'AllMacro', '-v7.3');

clear chan
clear i
clear trlstep
clear ICtrials
clear subjidx

%%
if ~exist('AllMicro', 'var')
    load([Basepath, 'Mircea/Datasaves/Micro/MicroDataF.mat'])
end

[CSCHippCondLFP, ~, TrialSelCondLFP, TrialSelCondiEEG, ICConditions] = SelectedConditions_IEEG_I_LFP(AllMicro, AllMacro);
[MacroStat{1,1},MacroStat{1,2},FreqDat{1,2},FreqDat{1,3}] = MacroData(Basepath, AllMacro, ICConditions, TrialSelCondiEEG);
