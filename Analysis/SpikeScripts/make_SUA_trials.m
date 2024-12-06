function [SPKTrial] = make_SUA_trials(spike, rest, AM)
% Use the Initial Micro definition transferred from the macrodata to the
% spike data where spike is the spike data to be made into trials, Rest 
%being a variable containing the timestamp for the first spike of the recording
% and  containing the TimeStampPerSample and AM being the Micro data trial definition of a
% given subject as a result of the pipeline (just necessary for extracting
% the trial-definition)

if AM(1,3) == -3000
    fsAM = 1000;
elseif AM(1,3) == -96000
    fsAM = 32000;   
else
    error('FS of trialdefinition not recognised (not 1000 or 32000)')
end 
TSPSAM = 1/fsAM*1e6;
[TimeStampPerSample] = rest.tsps;
SPKTime = rest.spktim;
fts = AM;

spkdef = fts(:,1:3) * TSPSAM;
spkdef(:,4) = fts(:,4);

spkdef(:,1) = spkdef(:,1) + 0.0020*1.0e+03;
spkdef(:,2) = spkdef(:,2) - 0.0020*1.0e+03;
spkdef(:,3) = spkdef(:,3) + 0.0020*1.0e+03;

for jk = 1:length(spike.timestamp)
    spike.timestamp{1,jk} = (spike.timestamp{1,jk}*1000  -  double(SPKTime(1,1)));
end

cfg = [];
cfg.trl = spkdef;
cfg.trlunit = 'timestamps';
cfg.timestampspersecond = 1000000; % Clock speed of the Neuralynx system 
[SPKTrial] = ft_spike_maketrials(cfg,spike);

% spktrlunits = any(spike.timestamp{1,chan} >= spkdef(:,1) & spike.timestamp{1,chan} <= spkdef(:,2),1);
% spike.unit{1,chan} = spike.unit{1,chan}(1,spktrlunits) 

