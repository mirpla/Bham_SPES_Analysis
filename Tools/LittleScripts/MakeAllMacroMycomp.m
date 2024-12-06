PatientIDs = {'P07', 'P072', 'P08', 'P082', 'P09'};
 
for subjidx = 1:5
   subjID = PatientIDs{1,subjidx};
    
     if length(subjID) >= 4
        ses = 2;
    else
        ses = 1;
    end
    
    try
    load(['Z:\Mircea\Datasaves\Macro/',subjID(1:3),'/Ses', num2str(ses),'/',PatientIDs{subjidx},'_Processed.mat'])
    load(['Z:\Mircea\Datasaves\Macro/stringstimsite/',PatientIDs{subjidx},'/',PatientIDs{subjidx},'_StimInfo.mat'])

    AllMacro.StimSite{1,subjidx}  = StimSiteInfo;
    AllMacro.SubjID{1,subjidx}    = PatientIDs{1,subjidx};
    AllMacro.Session{1,subjidx}   = ICprocessed;
    clear ICprocessed
    clear StimSiteInfo
    catch
    end 
end 

save('Z:\Mircea\Datasaves\Macro/MacroData','AllMacro', '-v7.3');

clear chan
clear i
clear trlstep
clear ICtrials
clear subjidx

