%% select only cortical stimulation trials in macro data where electrodes were located in Anterior Temporal Pole

function [ICPole, ICnPole, AnteriorTemporalPole] = SelectATP(AllMacro)

StimHippLFP{1,1} = [11,12];            % P07 RAH LMH
StimHippLFP{1,3} = [6,7,13,14];        % P08 RAH RMH7 LMH
StimHippLFP{1,5} = [5,6];              % P09 LANT & RAnt

StimHippLFP{2,1} = [21,22,23,16,17,18]; % P07 RMH RPH
StimHippLFP{2,3} = [20, 21];        % P08 RPH LAH LMH LPH
StimHippLFP{2,5} = [12, 13, 19, 20, 25, 26];              % P09 LMH LPH LPHG RMH RPH RPHG


subj = [1,3,5];
for k = subj
    subjidx =  find(subj == k);
    iData{1,k} = AllMacro.Session{1,k};
    
    ATP = [];
    nATP = [];
    for i = 1:length( StimHippLFP{1,k} )
        ATP  = [ATP ; find(iData{1,k}.trialinfo ==  StimHippLFP{1,k}(i))];
    end
    for i = 1:length( StimHippLFP{2,k} )       
        nATP = [nATP; find(iData{1,k}.trialinfo == StimHippLFP{2,k}(i))];
    end
    AnteriorTemporalPole{1,subjidx} = ATP;
    AnteriorTemporalPole{2,subjidx} = nATP;
end

for i = 1:length(AnteriorTemporalPole)
    cfg = [];
    cfg.trials = AnteriorTemporalPole{1,i}';
    ICPole{1,i} = ft_selectdata(cfg, iData{1,subj(i)});
    cfg = [];
    cfg.trials = AnteriorTemporalPole{2,i}';
    ICnPole{1,i} = ft_selectdata(cfg, iData{1,subj(i)});
end

end