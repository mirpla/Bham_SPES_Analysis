% simulate pulse

x = linspace(-3, 3, 32000*6);
y = zeros(1, length(x))+4;
y(96001:96033) = 2000+4;
y(96034:96066) = -2000+4;

subplot(3,2,1)
plot(x,y)
xlim([-0.03 0.03])
xlabel(['Raw Pulse'])
ylim([-2500 2500])

dum.hdr.nChans = 1;
dum.hdr.label{1,1} = 'dummy';
dum.hdr.Fs = 32000;
dum.hdr.nSamples = 19200;
dum.hdr.nSamplesPre = 0;
dum.hdr.nTrials = 1;
dum.trial{1,1} = y ;
dum.time{1,1}  = x;
dum.label{1,1} = 'dummy';
dum.fsample = 32000;
dum.sampleinfo = [1 19200];

cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 300;
%cfg.lpfilttype = 'butter';
cfg.demean = 'yes';
lpdum = ft_preprocessing(cfg, dum);

subplot(3,2,3)
plot(lpdum.time{1,1}, lpdum.trial{1,1})
xlim([-0.03 0.03])
xlabel(['LP filtered 300 Hz'])
ylim([-2500 2500])

cfg = [];
cfg.resamplefs = 1e3;
%cfg.detrend = 'yes';
cfg.demean = 'yes';
[resdum] = ft_resampledata( cfg,lpdum);



subplot(3,2,5)
plot(resdum.time{1,1}, resdum.trial{1,1})
xlim([-0.03 0.03])
xlabel(['Resampled at 1000 Hz from 32000'])
ylim([-2500 2500])


%%

x = linspace(-3, 3, 32000*6);
y = zeros(1, length(x))+4;
y(96001:96033) = 8000+4;
y(96034:96066) = -8000+4;

subplot(3,2,2)
plot(x,y)
xlim([-0.03 0.03])
xlabel(['Raw Pulse'])
ylim([-2500 2500])

dum.hdr.nChans = 1;
dum.hdr.label{1,1} = 'dummy';
dum.hdr.Fs = 32000;
dum.hdr.nSamples = 19200;
dum.hdr.nSamplesPre = 0;
dum.hdr.nTrials = 1;
dum.trial{1,1} = y ;
dum.time{1,1}  = x;
dum.label{1,1} = 'dummy';
dum.fsample = 32000;
dum.sampleinfo = [1 19200];

cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 300;
%cfg.lpfilttype = 'butter';
cfg.demean = 'yes';
lpdum = ft_preprocessing(cfg, dum);

subplot(3,2,4)
plot(lpdum.time{1,1}, lpdum.trial{1,1})
xlim([-0.03 0.03])
xlabel(['LP filtered 300 Hz'])
ylim([-2500 2500])

cfg = [];
cfg.resamplefs = 1e3;
%cfg.detrend = 'yes';
cfg.demean = 'yes';
[resdum] = ft_resampledata( cfg,lpdum);



subplot(3,2,6)
plot(resdum.time{1,1}, resdum.trial{1,1})
xlim([-0.03 0.03])
xlabel(['Resampled at 1000 Hz from 32000'])
ylim([-2500 2500])


