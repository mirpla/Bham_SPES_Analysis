function MakeAllMacro(Basepath, PatientIDs)

for subjidx = 1:length(PatientIDs)
    subjID = PatientIDs{1,subjidx};
    
    if length(subjID) >= 4
        ses = 2;
    else
        ses = 1;
    end
    
        load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/',PatientIDs{subjidx},'_Processed.mat'])
        load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',PatientIDs{subjidx},'/',PatientIDs{subjidx},'_StimInfo.mat'])
        AllMacro.StimSite{1,subjidx}  = StimSiteInfo;
        AllMacro.SubjID{1,subjidx}    = PatientIDs{1,subjidx};
        AllMacro.Session{1,subjidx}   = ICprocessed;
        clear ICprocessed
        clear StimSiteInfo
    
end

save([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroData'],'AllMacroNF', '-v7.3');

clear chan
clear i
clear trlstep
clear ICtrials
clear subjidx


%% #nofilter
% 
% for subjidx = 1:length(PatientIDs)
%     subjID = PatientIDs{1,subjidx};
%     if length(subjID) >= 4
%         ses = 2;
%     else
%         ses = 1;
%     end
%     
%     %try
%     load([Basepath, 'Mircea/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/',PatientIDs{subjidx},'_ICtrials.mat'])
%     load([Basepath, 'Mircea/Datasaves/Macro/stringstimsite/',PatientIDs{subjidx},'/',PatientIDs{subjidx},'_StimInfo.mat'])
%     
%     ICtrials.trialinfo = zeros(length(ICtrials.trial),1);
%     for catgs =  1:length(StimSiteInfo.Indices)
%         for catcond = 1:length(StimSiteInfo.Indices{1,catgs})
%             ICtrials.trialinfo(StimSiteInfo.Indices{1,catgs}) = catgs.* ones(length(StimSiteInfo.Indices{1,catgs}),1);
%         end
%     end
%     
%     AllMacroNF.StimSite{1,subjidx}  = StimSiteInfo;
%     AllMacroNF.SubjID{1,subjidx}    = PatientIDs{1,subjidx};
%     AllMacroNF.Session{1,subjidx}   = ICtrials;
%     
%     
%     clear ICtrials
%     clear StimSiteInfo
%     % catch
%     % end
%     
% end
% 
% save([Basepath, 'Mircea/Datasaves/Macro/MacroDataNF'],'AllMacroNF', '-v7.3');
end

