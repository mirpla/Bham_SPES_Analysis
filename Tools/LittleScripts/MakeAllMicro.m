function MakeAllMicro(Basepath, PatientIDs)

for subjidx = 1:length(PatientIDs)
   subjID = PatientIDs{1,subjidx};
   
   if length(subjID) >= 4
       ses = 2;
   else
       ses = 1;
   end
   
       load([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID(1:3),'/Ses', num2str(ses),'/LFP_artT_',PatientIDs{subjidx},'.mat'])
       load([Basepath 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',PatientIDs{subjidx},'/',PatientIDs{subjidx},'_StimInfo.mat'])
   
       AllMicro.Session{1,subjidx}   = CSCdatIED;
       AllMicro.StimSite{1,subjidx}  = StimSiteInfo;
       AllMicro.SubjID{1,subjidx }   = subjID;

end

AllMicro.SessionNorm = AllMicro.Session;

for i = 1:length(AllMicro.SessionNorm)
    try
        for chan = 1:length(AllMicro.SessionNorm{1,i}.label)
            
            for trlstep = 1:length(AllMicro.SessionNorm{1,i}.trial{1,i})
                if      AllMicro.SessionNorm{1,i}.trial{1,i}(chan, trlstep) > 0
                    
                    AllMicro.SessionNorm{1,i}.trial{1,i}(chan, trlstep) = AllMicro.SessionNorm{1,i}.trial{1,i}(chan,trlstep) / max(AllMicro.SessionNorm{1,i}.trial{1,i}(chan,:));
                    
                elseif  AllMicro.SessionNorm{1,i}.trial{1,i}(chan, trlstep) < 0
                    
                    AllMicro.SessionNorm{1,i}.trial{1,i}(chan, trlstep) = AllMicro.SessionNorm{1,i}.trial{1,i}(chan,trlstep) / min(AllMicro.SessionNorm{1,i}.trial{1,i}(chan,:));
                end
            end
            
        end
    catch
    end
end
%% MUAs
%MUATrialsBulk Save Spike data in separate variable

%% 
save([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/MicroData'],'AllMicro','-v7.3');
end 