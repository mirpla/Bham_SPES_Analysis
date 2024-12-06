function [SUAERP,SUAnERP] = SUA_ConvIn(Data, param)
Kernelsize      =   param.convol;
trlsize         =   param.trlsize;
resttrialsize   =   round(2*trlsize*1000+1);
bswin           =   param.bswin;

%% Convolve with Gaussian
dum.time{1,1}(1,:)  = linspace(-trlsize,trlsize, resttrialsize);
for trlidx = 1:length(Data.cfg.trials)
    Data.trialpre{1,trlidx} = zeros(length(Data.label), resttrialsize);
    trltimestamp = Data.time{1,1}(Data.trial{1,1} == Data.cfg.trials(trlidx,1));
    if isempty(trltimestamp)
        dum.trial{1,trlidx}(1,:) = zeros(1,resttrialsize);
        dum.trialinfo(trlidx) = Data.trialinfo(trlidx);
    else
        for ttsidx = 1:length(trltimestamp)
            [~, idx] = min(abs( dum.time{1,1}(1,:)-trltimestamp(ttsidx)));
            Data.trialpre{1,trlidx}(1, idx) = 1;
        end
        dum.trial{1,trlidx}(1,:)  = conv(Data.trialpre{1,trlidx}(1,:), gausswin(Kernelsize),'same');
        dum.trialinfo(trlidx) = Data.trialinfo(trlidx);
    end
end

for trlidx = 1:length(Data.cfg.trials)
    avgtrl = mean(cell2mat(dum.trial'));
    dumm.trial{1,trlidx} = (dum.trial{1,trlidx}-mean(avgtrl(bswin)))/std(avgtrl(bswin));
    if isnan(dumm.trial{1,trlidx})
        dumm.trial{1,trlidx} = zeros(1,resttrialsize);
    end 
end

dum.label = Data.label;
dum.fsample = 1000;
SUAERP  = dum;
SUAnERP = dum;
if ~isfield(dum,'trial')
    SUAnERP.trial{1,1} = zeros(1, resttrialsize);
    SUAnERP.trial{1,2} = zeros(1, resttrialsize);
    
    return
end

SUAnERP.trial = [];
SUAnERP.trial = dumm.trial;
%SUAnERP.trial{1,1} = (SUAnERP.trial{1,1}-mean(SUAERP.trial{1,1}(bswin)))/(std(SUAERP.trial{1,1}(bswin)));

end 