function c = checkunit(waveforms,varargin)
% c = checkunit(waveforms,varargin)
% this function performs a quality check on a set of sorted waveforms
%
% MANDATORY INPUT
% waveforms     a matrix whose rows are events and whose columns are ticks (or vice versa -
%               checkunit.m assumes that the longer dimension represents separate waveforms)
%
% OPTIONAL INPUTS
% markvec       vector of markers of the units in the channel; should be of the same size as waveforms
% target        which marker should be analyzed
% timevec       vector of timestamps of the unit in the channel; should be of the same size as waveform
%               NOTE THAT TIMESTAMPS SHOULD BE GIVEN IN SECONDS!
% binsz         bin size (�s) of analog sampling; reciprocal of sampling rate (e.g. 50 �s for 20 kHz)
%               if provided, checkunit will compute spike width (FWHM, full width at half maximum)
% tevents       vector with event times; if provided, an additional plot will be generated that depicts
%               spike times relative to event times +- 200 ms; in addition, spike waveforms in a window
%               +- 20 ms will be plotted to verify that these waveforms are indeed spikes and not some
%               event- or stimulus-related artifact
%               NOTE THAT TIMESTAMPS SHOULD BE GIVEN IN SECONDS!
%               also, if tevents is provided, timevec is also needed
% plotno        number of waveforms to plot; default is 5,000
% elimWin       window for elimination of spikes in pecking vicinity (in ms; default [20 20])
%
% OUTPUT
% c             structure with a range of quality indices (mean and sd of waveforms, SNR etc)
%
% EXAMPLES
% checkunit(chan1.adc);                       % performs check on all waveforms in channel 1; stationarity cannot be evaluated
%                                             % because no time vector is given
%
% checkunit(chan1.adc,'timevec',chan1.timings);   % same, but with depiction of stationarity
%
% checkunit(chan1.adc,'timevec',chan1.timings,'markvec',chan1.markers(:,1),'target',1);       % same, but only for markers of code '1' (the target)
%
% checkunit(chan9.adc,'timevec',chan9.timings,'markvec',chan9.markers(:,1),'target',1,...
%           'tevents',chan32.timings(chan32.markers(:,1)==110));       % same, with extra PSTH
% 
% HISTORY
% july 3, 2012        renamed variable 'time', included estimate of overall firing rate
% june 28, 2012       some polishing work for publication
% june 8, 2012        renamed variable tpecks to tevents
% june 4, 2012        changed output figure size; changed critical values
% may 7, 2012         new outputs: estimated percent false negatives, percent refractory period violations
%                     distill recommendations for classification (take e.g. skew and std)
% april 27, 2012      stepsize for histograms calculated automatically
%                     debugged histogram output for subplot 447
% aug 16, 2011        changed sd plot to % of sd
% june 16, 2011       new additional outputs:
%                     - no. of waveforms within pecking range
%                     - zoom in on ISI distribution's first 50 ms
%                     - spike amplitude over session time plus regression line
%                     - firing rate over session time
%                     - Gaussian fit and false negative estimation
%                     added optional input: elimWin
% june 16, 2011       cosmetic fixes to subplot 3
% may 24, 2011        added density plot and waveform samples; incorporated cpecks.m code into this function
% may 04, 2011        constrained number of plotted waveforms to 5,000 (default); optional:
% feb 28, 2011        added cpecks and binsz (optional arguments)
% feb 16, 2011        added examples
% 
% by Maik C. St�ttgen, Feb 2011
%% specify and assign defaults
% if size(waveforms,1)<size(waveforms,2) %fm: auskommentiert am 24.10.13, da fehlerhaft falls #Spikes<64
%   waveforms=waveforms';
% end
target  = 1;
tevents = [];
binsz   = [];
plotno  = 5000;
elimWin = [20 20];
nospx   = 3; % ms - time window in which spikes are not to be expected too often
markvec = ones(size(waveforms,1),1);
timevec = zeros(size(waveforms,1),1);
if nargin
  for i=1:2:size(varargin,2)
    switch varargin{i}
      case 'markvec'
        markvec = varargin{i+1};
      case 'target'
        target = varargin{i+1};
      case 'timevec'
        timevec = varargin{i+1};
      case 'binsz'
        binsz = varargin{i+1};
      case 'plotno'
        plotno = varargin{i+1};
      case 'tevents'
        tevents  = varargin{i+1};
      case 'elimWin'
        elimWin = varargin{i+1};
      case 'thr'
        thr = varargin{i+1};
      otherwise
        errordlg('unknown argument')
    end
  end
end
%% assign criteria for traffic lights (green, yellow)
crit_SNRd = [6 5];  
crit_SNR99 = [2 1.5];
crit_SNR95 = [2.5 2];
crit_skew = [0.5 0.75];
crit_ISI  = [0.02 0.05];
crit_FN   = [0.1 0.25];
%% rearrange input
if size(markvec,1)<size(markvec,2)
  markvec=markvec';
end
markvec = markvec(:,1);
wavs = single(waveforms(markvec==target,:));
spxtimes = single(timevec(markvec==target));
if numel(markvec)~=size(waveforms,1)
  errordlg('vectors do not match')
  return
end
%% calculate indices...
c.spx       = size(wavs,1);
c.fr        = 1/mean(diff(spxtimes));
c.meanwave  = mean(wavs,1);
c.stdev     = std(wavs,0,1);
c.skew      = skewness(wavs,0,1);
if binsz
  maxvolt  = max(c.meanwave);
  minvolt  = min(c.meanwave);
  nullvolt = mean(c.meanwave(1:10));
  firstpassup  = find(c.meanwave>nullvolt+(maxvolt-nullvolt)*0.5,1);
  secondpassup = find(c.meanwave(firstpassup+1:end)<nullvolt+(maxvolt-nullvolt)*0.5,1)+firstpassup;
  firstpassdown  = find(c.meanwave<nullvolt+(minvolt-nullvolt)*0.5,1);
  secondpassdown = find(c.meanwave(firstpassdown+1:end)>nullvolt+(minvolt-nullvolt)*0.5,1)+firstpassdown;
  c.FWHMax = round((secondpassup-firstpassup)*binsz)/1000;
  c.FWHMin = round((secondpassdown-firstpassdown)*binsz)/1000;
end
%% plot 'em
%disp('quality check...')
f = figure('units','normalized','position',[0 0 .9 .9],'name',['unit quality check for marker ',num2str(target),...
      ' with ',num2str(c.spx),' waveforms, overall firing rate is ' num2str(c.fr,2) ' Hz'], 'Visible', 'off');
%% subplot 1 - raw waveforms
subplot(441)
title(['up to ' num2str(plotno) ' waveforms']),hold all
if plotno>size(wavs,1),plotno=size(wavs,1);end
plot(wavs(randsample(1:size(wavs,1),plotno),:)','b')
plot(c.meanwave,'k','LineWidth',2);
plot(c.meanwave+c.stdev,'k');
plot(c.meanwave+2*c.stdev,'k');
plot(c.meanwave-c.stdev,'k');
plot(c.meanwave-2*c.stdev,'k');
lower = single(min(c.meanwave)-max(c.stdev)*3);
upper = single(max(c.meanwave)+max(c.stdev)*3);
axis([0 size(wavs,2)+1 lower upper])
xlabel('time (bins)'),ylabel('ADC units')
%% subplot 2 - distributions of peak and baseline voltages
subplot(442)
% adjust stepsize for histograms according to voltage units
step = abs(min(diff(max(wavs))))/10;
title('baseline & peak voltages'),hold on
% baseline voltages
[n,b] = hist(wavs(:,1),min(wavs(:,1)):step:max(wavs(:,1)));
bar(b,n,'b','EdgeColor','b'),hold on
% peak voltages
[a1,b1] = max(wavs,[],2);
[a3,b3] = min(wavs,[],2);
[n2,b2] = hist(a1,min(a1):step:max(a1));
[n4,b4] = hist(a3,min(a3):step:max(a3));
bar(b2,n2,'r','EdgeColor','r'),bar(b4,n4,'g','EdgeColor','g')
xlabel('ADC units'),ylabel('frequency')
%% subplot 3 - waveform variability
subplot(443)
title('waveform variability'),hold all
[ax,h1,h2] = plotyy([5 size(wavs,2)-5],[100 100],[5 size(wavs,2)-5],[mean(c.skew) mean(c.skew)]);
plot(ax(1),1:size(wavs,2),100*c.stdev/mean(c.stdev(1:5)),'b')
plot(ax(1),[5 size(wavs,2)-5],[50 50],'b:')
plot(ax(1),[5 size(wavs,2)-5],[150 150],'b:')
set(gcf,'CurrentAxes',ax(2))
line(1:size(wavs,2),c.skew,'Color','r') % plot seems to destroy parent figure
line([5 size(wavs,2)-5],[-.5 -.5],'Color','r','LineStyle',':')
line([5 size(wavs,2)-5],[.5 .5],'Color','r','LineStyle',':')
xlabel('time (bins)');
set(get(ax(1),'Ylabel'),'String','% of noise SD')
set(ax(1),'Xlim',[0 size(wavs,2)+1],'Ylim',[0 200],'YTick',[0 100 200],'YColor','b')
set(h1,'Color','b')
set(get(ax(2),'Ylabel'),'String','skewness')
yskew = [-1 1];
set(ax(2),'Xlim',[0 size(wavs,2)+1],'Ylim',[-1 1],'YTick',[yskew(1) 0 yskew(2)],'YColor','r')
set(h2,'Color','r')
%% subplot 4 - text box with indices
subplot(444),axis off,axis([0 1.3 0 1.1]),axis tight,hold on
c.SNR_dmax = (mean(a1) - mean(wavs(1,:))) / sqrt(0.5 * var(wavs(:,1)) + var(a1));
c.SNR_dmin = (mean(a3) - mean(wavs(1,:))) / sqrt(0.5 * var(wavs(:,1)) + var(a3));
c.SNR99    = (max(c.meanwave)-min(c.meanwave)) / diff(prctile(wavs(:,1),[.5 99.5]));
c.SNR95    = (max(c.meanwave)-min(c.meanwave)) / ...
    diff(prctile(wavs(:,1),[2.5 97.5]));
% the stuff below is invisible in matlab 2018, so I (T.R.) moved it down
% to where the trafficlight colors are drawn and annotate it there
% line #460 ff
% $$$ text(0,1.0,'SNR(dmax) ','FontName','Courier'),text(0.7,1.0,num2str(c.SNR_dmax,2),'FontName' ,'Courier')
% $$$ text(0,0.9,'SNR(dmin)','FontName','Courier'),text(0.7,0.9,num2str(c.SNR_dmin,2),'FontName' ,'Courier')
% $$$ text(0,0.75,'SNR99%','FontName','Courier'),text(0.7,0.75,num2str(c.SNR99,2),'FontName','Courier')
% $$$ text(0,0.65,'SNR95%','FontName','Courier'),text(0.7,0.65,num2str(c.SNR95,2),'FontName','Courier')
% $$$ text(0,0.5,'SKEW(max) ','FontName','Courier'),text(0.7,0.5,num2str(max(c.skew(5:end-5)),2),'FontName','Courier')
% $$$ text(0,0.4,'SKEW(min) ','FontName','Courier'),text(0.7,0.4,num2str(min(c.skew(5:end-5)),2),'FontName','Courier')
%% subplot 5 - stationarity: cumulative spikes over time
subplot(445)
try
  title('stability over time'),hold on
  [n,b] = hist(spxtimes,0:1:max(spxtimes));
  plot(b/60,cumsum(n)),xlabel('time (minutes)'),ylabel('cumulative spike count (1s bins)')
  xlim([0 ceil(max(b/60))])
catch
  text(0,0.5,'no timestamps','FontName','Courier')
  axis off
end
%% subplot 6 - stationarity: firing rate histogram over time, amplitudes over time
% w = get(subplot(446),'Position'); % somehow yields different positions
subplot('Position',[0.34264 0.54832 0.12 0.15554]) % left bottom width height

try
  title('stability over time'),hold on
  [n,b] = hist(spxtimes,0:60:max(spxtimes));
  amps = max(wavs')-min(wavs');
  [ax,h1,h2] = plotyy(b/60,n,spxtimes/60,amps,'bar','plot');
  
  pars = polyfit(spxtimes/60,amps',1);
  set(gcf,'CurrentAxes',ax(2))
  line(spxtimes/60,pars(1)*spxtimes/60+pars(2),'Color','r') % plot seems to destroy parent figure
  
  set(h1,'LineStyle','-')
  set(h2,'LineStyle','none','Marker','.','MarkerSize',3)

  set(get(ax(1),'Ylabel'),'String','spike count (60s bins)')
  set(get(ax(2),'Ylabel'),'String','p2p amplitude (ADC units)')
  set(ax(1),'Xlim',[0 ceil(max(b/60))],'Ylim',[0 max(n)*2],'YColor','b')
  set(ax(2),'Xlim',[0 ceil(max(b/60))],'Ylim',[min(amps)*0.2 max(amps)*1.1],'YColor','r')
  set(h2,'Color','r')
  xlabel('time (minutes)')

catch
  text(0,0.5,'no timestamps','FontName','Courier')
  axis off
end
%% subplot 7 - interspike intervals
subplot(447)
try
  title('ISI (10ms bins)'),hold on
  resol = 0.5;
  [n,b]=hist(diff(spxtimes),0.005:0.01:(max(diff(spxtimes))));
  bar(b(1:min([resol*1000 numel(b)])),n(1:min([resol*1000 numel(b)])),'b','EdgeColor','b')
  axis([0 resol 0 ceil(max(n)*1.1)])
  xlabel('interval (s)'),ylabel('frequency')
catch
  text(0,0.5,'no timestamps','FontName','Courier')
  axis off
end
%% subplot 8 - interspike intervals, zoomed in
subplot(448)
try
  title('ISI (1ms bins)'),hold on
  resol = 0.05;
  [n,b]=hist(diff(spxtimes),0.0005:0.001:(max(diff(spxtimes))));
  bar(b(1:resol*1000),n(1:resol*1000),'b','EdgeColor','b')
  axis([0 resol 0 ceil(max(n)*1.1)])
  xlabel('interval (s)'),ylabel('frequency')
  c.violations = sum(n(1:nospx))/c.spx;
  subplot(444)
  text(0,0.25,['ISI <' (num2str(nospx+1)) ' ms'],'FontName','Courier'),text(0.7,0.25,num2str(c.violations,2),'FontName','Courier')
catch
  text(0,0.5,'no timestamps','FontName','Courier')
  axis off
end
%% subplots 9&10 - density plots
subplot(449)
title('density plot'),hold on
clear n b
numTicks = size(wavs,2);
for i = 1:numTicks
  [n(i,:),b(i,:)] = hist(wavs(:,i),linspace(lower,upper,min([numel(unique(wavs))/4 500])));
end
colormap(hot)
% remove extreme outliers
cutoff = 5*std(reshape(n,numel(n),1));
n(n>cutoff) = cutoff;
pcolor(n'),shading interp
axis([1 numTicks 1 size(n,2)])
xlabel('time (bins)')
ylabel('ADC units (bins)')

% density plot in log-coordinates
subplot(4,4,10)
title('density plot in log space'),hold on
colormap(hot)
pcolor(log10(n)'),shading interp
axis([1 numTicks 1 size(n,2)])
xlabel('time (bins)')
ylabel('ADC units (bins)')
%% subplot 11 - sample waveforms
subplot(426)
[numWavs numTicks] = size(wavs);
toPlot = floor(min([numWavs/3 200]));
if numWavs>200
  plot(1:numTicks,wavs(1:toPlot,:)','b'),hold on
  plot(numTicks+1:numTicks*2,wavs(round(numWavs/2-toPlot/2):round(numWavs/2+toPlot/2),:),'c')
  plot(numTicks*2+1:numTicks*3,wavs(end-ceil(toPlot/2):end,:)','r')
  axis([0 numTicks*3+1 lower upper])
  axis tight
  mult = 16:-4:-16;
  x = mult.*ones(1,numel(mult))*c.stdev(1)+c.meanwave(1);
  for i = 1:numel(x)
    plot([1,numTicks*3+1],[c.meanwave(1)+x(i) c.meanwave(1)+x(i)],'k:')
  end
end
axis off
ypos = double(round(max(c.meanwave)+max(c.stdev)*2));
text(1,ypos,['first ' num2str(toPlot) ' spikes'])
text(1+numTicks,ypos,['middle ' num2str(toPlot) ' spikes'])
text(1+numTicks*2,ypos,['last ' num2str(toPlot) ' spikes'])
%% subplots 12&13 - PETH and eliminated waveforms (if any)
if tevents

  % low-pass filter key pecks
  minInt = 0.005;                        % minimum time interval (in s) between two peck events
  todelete = zeros(numel(tevents),1);     % becomes array to index peck events for deletion
  
  % while loop marks peck events for deletion
  i=2;
  while i<=numel(tevents)
    if tevents(i)-tevents(i-1)<minInt,todelete(i)=1;end,i=i+1;
  end
  tevents2 = tevents(todelete==0);
  
  % eliminate spikes in close proximity to key pecks
  % for each key peck, find spikes close to it and note their index
  elimWin = elimWin/1000;
  isclose = 0;
  for p = 1:numel(tevents2);
    isclose = [isclose;find(spxtimes>=tevents2(p)-elimWin(1) & spxtimes<=tevents2(p)+elimWin(2))];
  end
  isclose(1)=[];
  tspikes2 = spxtimes;
  tspikes2(isclose) = [];
  
  plotrange = -0.2:0.001:+0.2;
  peckpsth  = zeros(numel(plotrange),1);
  peckpsth2 = zeros(numel(plotrange),1);
    
  % construct psth for original spike array
  for i = 1:numel(tevents2)
    clear stimes trialtimes
    stimes = spxtimes - tevents2(i);
    trialtimes = round(1000*(stimes(stimes>=plotrange(1) & stimes<=plotrange(end))));
    peckpsth(plotrange(1)*-1000+trialtimes+1) = peckpsth(plotrange(1)*-1000+trialtimes+1)+1;
  end
  
  % construct psth for clean spike array
  for i = 1:numel(tevents2)
    clear stimes trialtimes
    stimes = tspikes2 - tevents2(i);
    trialtimes = round(1000*(stimes(stimes>=plotrange(1) & stimes<=plotrange(end))));
    peckpsth2(plotrange(1)*-1000+trialtimes+1) = peckpsth2(plotrange(1)*-1000+trialtimes+1)+1;
  end
  
  subplot(4,4,13)
  title(['PSTH, elimWin=[' num2str(elimWin(1)) ' ' num2str(elimWin(2)) ']']),hold on
  plot(plotrange,peckpsth,'m')
  plot(plotrange,peckpsth2,'b')
  xlabel('time relative to key peck (s)')
  ylabel('number of spikes')
  
  % waveforms eliminated due to closeness to peck event
  subplot(4,4,14)
  title([num2str(numel(isclose)) ' waveforms in event vicinity']), hold on
  plot(wavs(isclose,:)')
  axis([0 numTicks+1 lower upper])
  xlabel('time (bins)'),ylabel('ADC units')
  
else
  subplot(4,4,13)
  text(0,0.5,'no timestamps','FontName','Courier')
  axis off
  subplot(4,4,14)
  text(0,0.5,'no timestamps','FontName','Courier')
  axis off
  
end
%% subplots 14&15 - estimating false negatives for minimum and maximum peak distributions
% guess mode - from mode_guesser.m
% find the range of the most tightly distributed data
% use median of the tightest range as the guess of the mode
% have to do for minimum and maximum!

p = 0.5;
x = a3;
num_samples = length(x);
shift = round(num_samples*p);
x = sort(x);
[val,m_spot] = min(x(shift+1:end) - x(1:end-shift));
m = x(round(m_spot + (shift/2)));
% now duplicate sorted data set around the mode
if skewness(x)>0 % skewed towards positive values
  y = vertcat(m+m-x(x>m),x(x>m));
else
  y = vertcat(m+m-x(x<m),x(x<m));
end
Gaussmean = mean(y);
Gaussstd  = std(y);
xval         = linspace(min(y),max(y),1000);
distribution = normpdf(xval,Gaussmean,Gaussstd);
distribution = distribution/(max(distribution));
c.FNmin = 1-normcdf(max(b4),Gaussmean,Gaussstd);

subplot(4,4,15)
title('minimum distribution'),hold all
bar(b4,n4,'g','EdgeColor','g')
plot(xval,distribution*max(n4),'k')
xlabel('ADC units'),ylabel('frequency')
xlim([b4(find(n4>0,1,'first'))-2*(b4(2)-b4(1)) 0])

x = a1;
num_samples = length(x);
shift = round(num_samples*p);
x = sort(x);
[val,m_spot] = min(x(shift+1:end) - x(1:end-shift));
m = x(round(m_spot + (shift/2)));
% now duplicate sorted data set around the mode
if skewness(x)>0 % skewed towards positive values
  y = vertcat(m+m-x(x>m),x(x>m));
else
  y = vertcat(m+m-x(x<m),x(x<m));
end
Gaussmean = mean(y);
Gaussstd  = std(y);
xval         = linspace(min(y),max(y),1000);
distribution = normpdf(xval,Gaussmean,Gaussstd);
distribution = distribution/(max(distribution));
c.FNmax = 1-normcdf(-min(b2),-Gaussmean,Gaussstd);

subplot(4,4,16)
title('maximum distribution'),hold all
bar(b2,n2,'r','EdgeColor','r')
hold all
plot(xval,distribution*max(n2),'k')
xlabel('ADC units'),ylabel('frequency')
xlim([0 b2(find(n2>0,1,'last'))+2*(b2(2)-b2(1))])

% JN 2013-02-25: added threshold plotting
ylimnow = get(gca, 'ylim');
if exist('thr', 'var')
    x = [thr; thr];
    y = [zeros(1, size(thr, 2)); ylimnow(2) * ones(1, size(thr, 2))];
    line(x, y, 'color', 'k');
end

subplot(444)
text(0,0.15,'FNneg','FontName','Courier')
text(0.7,0.15,num2str(c.FNmin,2),'FontName','Courier')
text(0,0.05,'FNpos','FontName','Courier')
text(0.7,0.05,num2str(c.FNmax,2),'FontName','Courier')
%% recommendations
subplot(444, 'color','none')

if c.SNR_dmax>crit_SNRd(1)
  rectangle('Position',[1.2 0.95 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none');
  tc = 'g';
elseif c.SNR_dmax>crit_SNRd(2)
  rectangle('Position',[1.2 0.95 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none')

  tc = 'y';
else
  rectangle('Position',[1.2 0.95 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none')
  tc = 'r';
end

text(1.2, 0.95, sprintf('SNR(dmax): %.3g', c.SNR_dmax), 'VerticalAlignment', ...
     'bottom');


if c.SNR_dmin<-crit_SNRd(1)
  rectangle('Position',[1.2 0.85 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif c.SNR_dmin<-crit_SNRd(2)
    
  rectangle('Position',[1.2 0.85 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none')
  tc = 'y';
else
  rectangle('Position',[1.2 0.85 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none')
  tc = 'r';
end
text(1.2, 0.85, sprintf('SNR(dmin): %.3g', c.SNR_dmin), 'VerticalAlignment', ...
     'bottom');


if c.SNR99>crit_SNR99(1)
  rectangle('Position',[1.2 0.7 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif c.SNR99>crit_SNR99(2)
  rectangle('Position',[1.2 0.7 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none');
  tc = 'y';
else
  rectangle('Position',[1.2 0.7 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none')
  tc = 'r';
end
text(1.2, 0.7, sprintf('SNR99: %.3g', c.SNR99), 'VerticalAlignment', ...
     'bottom');



if c.SNR95>crit_SNR95(1)
  rectangle('Position',[1.2 0.6 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif c.SNR95>crit_SNR95(2)
  rectangle('Position',[1.2 0.6 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none')
  tc = 'y';
else
  rectangle('Position',[1.2 0.6 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none')
  tc = 'r';
end
text(1.2, 0.6, sprintf('SNR95: %.3g', c.SNR95), 'VerticalAlignment', ...
     'bottom');


if max(c.skew(5:end-5))<crit_skew(1)
  rectangle('Position',[1.2 0.45 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif max(c.skew(5:end-5))<crit_skew(2)
  rectangle('Position',[1.2 0.45 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none')
  tc = 'y';
else
  rectangle('Position',[1.2 0.45 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none');
  tc = 'r';
end
text(1.2, 0.45, sprintf('SKEW(max): %.3g', max(c.skew(5:end-5))), 'VerticalAlignment', ...
     'bottom');


if min(c.skew(5:end-5))>-crit_skew(1)
  rectangle('Position',[1.2 0.35 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif min(c.skew(5:end-5))>-crit_skew(2)
  rectangle('Position',[1.2 0.35 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none')
  tc = 'y';
else
  rectangle('Position',[1.2 0.35 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none');
  tc = 'g';
end
text(1.2, 0.35, sprintf('SKEW(min): %.3g', min(c.skew(5:end-5))), 'VerticalAlignment', ...
     'bottom');


if isfield(c,'violations')
  if c.violations<crit_ISI(1)
    rectangle('Position',[1.2 0.2 0.1 0.1],'EdgeColor','g', ...
              'FaceColor', 'none')
    tc = 'g';
  elseif c.violations<crit_ISI(2)
    rectangle('Position',[1.2 0.2 0.1 0.1],'EdgeColor','y', ...
              'FaceColor', 'none')
    tc = 'y';
  else
    rectangle('Position',[1.2 0.2 0.1 0.1],'EdgeColor','r', ...
              'FaceColor', 'none')
    tc = 'r';
  end
else
  rectangle('Position',[1.2 0.2 0.1 0.1],'EdgeColor','k', 'FaceColor', ...
            'none')
  
  tc = 'k';
end
text(1.2, 0.2, sprintf('ISI violations: %.3g', c.violations), ...
     'VerticalAlignment', 'bottom');


if c.FNmax<crit_FN(1)
  rectangle('Position',[1.2 0.0 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif c.FNmax<crit_FN(2)
  rectangle('Position',[1.2 0.0 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none')
  tc = 'y';
else
  rectangle('Position',[1.2 0.0 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none')
  tc = 'g';
end
text(1.2, 0.0, sprintf('FN max: %.3g', c.FNmax), ...
     'VerticalAlignment', 'bottom');


if c.FNmin<crit_FN(1)
  rectangle('Position',[1.2 0.1 0.1 0.1],'EdgeColor','g', 'FaceColor', ...
            'none')
  tc = 'g';
elseif c.FNmin<crit_FN(2)
  rectangle('Position',[1.2 0.1 0.1 0.1],'EdgeColor','y', 'FaceColor', ...
            'none');
  tc = 'y';
else
  rectangle('Position',[1.2 0.1 0.1 0.1],'EdgeColor','r', 'FaceColor', ...
            'none');
  tc = 'g';
end
text(1.2, 0.1, sprintf('FN min: %.3g', c.FNmin), ...
     'VerticalAlignment', 'bottom');
c.f = f;
