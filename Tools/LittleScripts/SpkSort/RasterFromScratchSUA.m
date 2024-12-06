function nspk = RasterFromScratchSUA(Datasel, condit, varargin)
% Plot rasterplots of every single channel for every participant
% Select particular channel and trials of the condition
% where Datasel is the spike data structure, condit is a vector containing
% all the trail numbers for a given condition and tw indicates plotted
% triwl width
% (fieldtrip implementation, but his can also be done with
% find(ismember(Data.trial{1,chanidx},TrialSelCond{sub,condidx}))

%figure('units','normalized','outerposition',[0 0 1 1])
% Get indixes from selected Data.Trials and apply to Data.time
%subplot(6,1,1:5);

if nargin > 2
    tw = varargin{1};
else
    tw = 1;
end 
if nargin > 3
    infc = varargin{2};
end 

cnt = 1;
c = 1;
x2 = [-3 3];
y2{c}= [0,0];

for trls = 1:length(condit)%unique(Datasel.trial{1,1})
    %% plotting of raster by using relative timestamps per trial
    ts_dat = find(Datasel.trial{1,1}== condit(trls));% TrialSelCond{sub,condidx}(trls));
    hold on;
    %dt = -3e3:250:3e3; % time axis, in steps depending on binsize for instantaneous
    %n = []; 
    if ~isempty(ts_dat)
        for it = 1:length(ts_dat)
            x = Datasel.time{1,1}(ts_dat(it));
            x = [x;x];                  % plot lines in horizontal
            y = cnt*ones(1,length(x)); % plot on y axis dependant on what trial is at
            y = [y-.5;y+.5];            % determine line height
            line(x,y,'Color','k');
            %[n(it,:)] = histcounts(Datasel.time{1,1}(ts_dat),dt/1000); % only relevant for binning the variables regarding instantaneous firing rate       
        end
        
        nspk(trls,1) = length(ts_dat);
        
    else
        nspk(trls,1) = 0;
    end
    cnt = cnt +1;
    
    if exist('infc','var') %&& exist('y','var')
        f(trls) = Datasel.trialinfo(condit(trls));
        if trls > 1
            if f(trls)-f(trls-1)~=0
                c = c + 1;
                y2{c}= [y(2,1),y(2,1)];
                line(x2,y2{c},'Color','k')
                my= mean([y2{c}(1),y2{c-1}(1)]);
                text(tw+0.05,my,infc.Labels{1,f(trls-1)})                
            end
        end
    end
    
    
end
c = c + 1;
y2{c}= [y(2,1),y(2,1)];
my= mean([y2{c}(1),y2{c-1}(1)]);
text(tw+0.05,my,infc.Labels{1,f(trls-1)})
%% Instantaneous firing rate plot
%         subplot(6,1,6);
%         hold on;
%         fr = sum(n,1)./size(n,1)./2.5e-1;
%         plot(fr,'ks-','LineWidth',3);
%         plot([13 13],[min(fr) max(fr)],'r','LineWidth',3);
%         axis tight;
%         %xlim([-500 5e3]);
%         xlabel('Time [ms]');
%         ylabel('Spikes/s^{-1}');

x1 = -0.000;
y1 = get(gca,'ylim');
x2 = 0.000;
y2 = y1;
plot([x1 x1],y1, 'r')
plot([x2 x2],y2, 'r')
if cnt > 1
    ylim([1 cnt])
end 
xlim([-tw tw]);
xlabel('Time [ms]');
ylabel('Trial #');

