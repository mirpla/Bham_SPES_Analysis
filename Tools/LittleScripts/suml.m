% Simulated pulse with planned analysis transformations with different filters. 
% This is done to estimate the interval of data that should be cut out due to the applied Preprocessing.

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




%% SPKdata

par = set_parameters_Bham(32000);

sr = par.sr;
w_pre = par.w_pre;
w_post = par.w_post;
ref = par.ref;
detect = par.detection;
stdmin = par.stdmin;
stdmax = par.stdmax;
fmin_detect = par.detect_fmin;
fmax_detect = par.detect_fmax;
fmin_sort = par.sort_fmin;
fmax_sort = par.sort_fmax;



[b_detect,a_detect] = ellip(par.detect_order,0.1,40,[fmin_detect fmax_detect]*2/sr);
[b,a] = ellip(par.sort_order,0.1,40,[fmin_sort fmax_sort]*2/sr);

xf_detect = filtfilt(b_detect, a_detect, y);
xf = filtfilt(b, a, y);


noise_std_detect = nanmedian(abs(xf_detect))/0.6745;
noise_std_sorted = nanmedian(abs(xf))/0.6745;
thr = stdmin * noise_std_detect;        %thr for detection is based on detect settings.
thrmax = stdmax * noise_std_sorted;     %thrmax for artifact removal is based on sorted settings.


nspk = 0;
xaux = find(abs(xf_detect(w_pre+2:end-w_post-2)) > thr) +w_pre+1;
xaux0 = 0;
for i=1:length(xaux)
    if xaux(i) >= xaux0 + ref
        [aux_unused, iaux]=max(abs(xf(xaux(i):xaux(i)+floor(ref/2)-1)));    %introduces alignment
        %if iaux == 1
        %    continue
        %end
        nspk = nspk + 1;
        index(nspk) = iaux + xaux(i) -1;
        xaux0 = index(nspk);
    end
end


% SPIKE STORING (with or without interpolation)
ls = w_pre+w_post;
spikes = zeros(nspk,ls+4);

xf = [xf zeros(1,w_post)];

for i=1:nspk                          %Eliminates artifacts
    if max(abs( xf(index(i)-w_pre:index(i)+w_post) )) < thrmax
        spikes(i,:)=xf(index(i)-w_pre-1:index(i)+w_post+2);
    end
end
aux = find(spikes(:,w_pre)==0);       %erases indexes that were artifacts

if ~isempty(aux)
    spikes(aux,:)=[];
    index(aux)=[];
end


spikes(:,end-1:end)=[];       %eliminates borders that were introduced for interpolation
spikes(:,1:2)=[];


timestamp = x(index);
plot(x,xf(1:192000))
xlim([-0.03 0.03])
xlabel(['Raw Pulse'])
ylim([-2500 2500])

for lins = 1:length(timestamp)
    line([timestamp(lins) timestamp(lins)], [-3000 3000],'Color', 'r')
end


