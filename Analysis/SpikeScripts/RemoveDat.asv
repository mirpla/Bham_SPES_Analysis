function [Clean] = RemoveDat(Dirty, Basepath, direction, condit, latency)
% Remove units with firing rates below threshold
%   mean?
% remove units without firing in a bunch of trials
%   median > 0

for subjidx = 1:length(Dirty)
    for ses = 1:length(Dirty{1,subjidx})
        for chan = 1:length(Dirty{1,subjidx}{1,ses})%SUA.AllChan{1, subjidx}{1, ses}{1,cc}
            if ~isempty(Dirty{1,subjidx}{1,ses}{1,chan})
                for su = 1:length(Dirty{1,subjidx}{1,ses}{1,chan})
                    DOI  = Dirty{1,subjidx}{1,ses}{1,chan}{1,su}{1,8};
                    [nspk{subjidx,ses}{chan,su}, spkcnt{subjidx,ses}{chan,su},spkrate{subjidx,ses}{chan,su}] = SPK_calc_rates(DOI, condit{subjidx,ses,8},latency);                   
                    avgs{subjidx,ses}(chan,su) = spkcnt{subjidx,ses}{chan,su}.avg;
                    meds{subjidx,ses}(chan,su) = median(nspk{subjidx,ses}{chan,su});
                end 
            end 
        end 
        cselect{subjidx,ses}{1} = find(meds{1,1}(:,1) > 0);
        cselect{subjidx,ses}{1} = find(meds{1,1}(:,2) > 0);
        cselect{subjidx,ses}{1} = find(meds{1,1}(:,3) > 0);
    end 
end 

h = 1'
