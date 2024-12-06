% Script that removes any spikes occuring at point 0
% The interval of removed data is 15 ms before and 15 ms after the pulse
% was administered

timetrialsize = 6*32000+1;
resttrialsize = 6*1000+1;
sub = 1;
ID = AllMicro.SubjID{1,sub};
dum = AllMicro.MUAs{1,sub};
kk=1;
chan = 6;    
%%
for trls = length(dum.trial{1,chan}):-1:1    
    if dum.time{1,chan}(1,trls) >= -0.015 && dum.time{1,chan}(1,trls) <= 0.015
        idxRem(kk) = trls;
        dum.time{1,chan}(:,idxRem(kk)) = [];
        dum.trial{1,chan}(:,idxRem(kk)) = [];
        dum.unit{1,chan}(:,idxRem(kk)) = [];
        dum.timestamp{1,chan}(:,idxRem(kk)) = [];
        kk = kk+1;
    end    
end

