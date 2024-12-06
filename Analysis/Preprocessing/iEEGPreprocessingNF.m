PatientIDs = {'P07', 'P072', 'P08', 'P082', 'P09', 'P10', 'P102','P11','P112','P12','P06','P062'};

for x = 1:length(PatientIDs)
    subjID = PatientIDs{x};  
    if length(subjID) >= 4
        ses = str2num(subjID(4));
    else
        ses = 1;
    end
    
    if ~isfile([Basepath, 'Mircea/3 - SPES\Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/',PatientIDs{x},'_ProcessedNF.mat'])
        FRprepNF(Basepath, subjID,ses)
    end
end

for subjidx = 1:length(PatientIDs)
    subjID = PatientIDs{1,subjidx};
    
    if length(subjID) >= 4
        ses = 2;
    else
        ses = 1;
    end
    
    load([Basepath, 'Mircea\3 - SPES\Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/',PatientIDs{subjidx},'_ProcessedNF.mat'])
    load([Basepath, 'Mircea\3 - SPES\Datasaves/Macro/stringstimsite/',PatientIDs{subjidx},'/',PatientIDs{subjidx},'_StimInfo.mat'])
    AllMacro.StimSite{1,subjidx}  = StimSiteInfo;
    AllMacro.SubjID{1,subjidx}    = PatientIDs{1,subjidx};
    AllMacro.Session{1,subjidx}   = ICprocessed;
    clear ICprocessed
    clear StimSiteInfo
end

save([Basepath, 'Mircea\3 - SPES/Datasaves/Macro/MacroDataNF'],'AllMacro', '-v7.3');

clear chan
clear i
clear trlstep
clear ICtrials
clear subjidx