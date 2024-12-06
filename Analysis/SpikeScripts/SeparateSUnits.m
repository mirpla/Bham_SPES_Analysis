function Datasel = SeparateSUnits(Data,chanidx)

Datasel = [];
for su = 1:max(Data.unit{1,chanidx})
    dum = [];
    unitstamps = [];
    cfg = [];
    cfg.spikechannel = chanidx;
    cfg.latency = 'maxperiod';
    cfg.trials = 'all';
    dum = ft_spike_select(cfg, Data);
    Datasel{1,su} = dum;
    unitstamps = [find(Data.unit{1,chanidx} == su)];
    Datasel{1,su}.waveform{1,1}     = dum.waveform{1,1}(1,:,unitstamps);
    Datasel{1,su}.timestamp{1,1}    = dum.timestamp{1,1}(1,unitstamps);
    Datasel{1,su}.unit{1,1}         = dum.unit{1,1}(1,unitstamps);
    Datasel{1,su}.time{1,1}         = dum.time{1,1}(1,unitstamps);
    Datasel{1,su}.trial{1,1}        = dum.trial{1,1}(1,unitstamps);
    
end

        