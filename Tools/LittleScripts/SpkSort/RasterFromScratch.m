% Plot rasterplots of every single channel for every participants

SPKtrialsAll = 1;
for sub = [1 3 4] % Array of subjects to be analysed
    
    kk=1;
    dum = [];
    Data = [];
    Datasel = [];
    ID = AllMicro.SubjID{1,sub};
    dum = [SPKTrial];
    
    for chan = 1:length(dum.label) % removal of timestamps around zero (0.2 before and after)
        for trls = length(dum.trial{1,chan}):-1:1
            if dum.time{1,chan}(1,trls) >= -0.02 && dum.time{1,chan}(1,trls) <= 0.02
                idxRem(kk) = trls;
                dum.time{1,chan}(:,idxRem(kk)) = [];
                dum.trial{1,chan}(:,idxRem(kk)) = [];
                dum.unit{1,chan}(:,idxRem(kk)) = [];
                dum.timestamp{1,chan}(:,idxRem(kk)) = [];
                kk = kk+1;
            end
        end
    end
    Data = dum;
    
    for condidx = [8 7]
        for chanidx = 1:length(Data.label)
            % Select particular channel and trials of the condition
            % (fieldtrip implementation, but his can also be done with
            % find(ismember(Data.trial{1,chanidx},TrialSelCond{sub,condidx}))
            
            cfg = [];
            cfg.spikechannel = chanidx;
            cfg.latency = 'maxperiod';
            cfg.trials = [TrialSelCond{sub,condidx}'];
            Datasel = ft_spike_select(cfg, Data);
            
            figure('units','normalized','outerposition',[0 0 1 1])
            % Get indixes from selected Data.Trials and apply to Data.time
            for trls = 1:length(TrialSelCond{sub,condidx})
                
                %% plotting of raster by using relative timestamps per trial
                ts_dat = find(Datasel.trial{1,1}==TrialSelCond{sub,condidx}(trls));
                if isempty(ts_dat)
                    
                else
%                     subplot(6,1,1:4);
                    hold on;
                    % dt = -3e3:250:6e3; % time axis, in steps depending on binsize for instantaneous
                    % n = [];
                    for it = 1:length(ts_dat)
                        x = Datasel.time{1,1}(ts_dat(it));
                        x = [x;x];                  % plot lines in horizontal
                        y = trls*ones(1,length(x));   % plot on y axis dependant on what trial is at
                        y = [y-.5;y+.5];            % determine line height
                        line(x,y,'Color','k');
                        
                        
                        %[n(it,:),~] = hist(ts_dat{it},dt); % only relevant for binning the variables regarding instantaneous firing rate
                        
                    end;
                    
                    
                    %% Instantaneous firing rate plot
%                             subplot(6,1,6);
%                             hold on;
%                             fr = sum(n,1)./size(n,1)./2.5e-1;
%                             plot(dt,fr,'ks-','LineWidth',3);
%                             plot([0 0],[min(fr) max(fr)],'r','LineWidth',3);
%                             axis tight;
%                             xlim([-500 5e3]);
%                             xlabel('Time [ms]');
%                             ylabel('Spikes/s^{-1}');
%                     
                end
                
            end
            x1 = -0.000;
            y1 = get(gca,'ylim');
            x2 = 0.000;
            y2 = y1;
            plot([x1 x1],y1, 'r')
            plot([x2 x2],y2, 'r')
            ylim([1 trls])
            xlim([-1 1]);
            xlabel('Time [ms]');
            ylabel('Trial #');
            title([ID,' --', CSCHippCond.P09.Labels{1,condidx}, '-- Chan ' num2str(chanidx)]);
            
            %saveas(gcf,[ID,'_RasterMUA_', CSCHippCond.P09.Labels{1,condidx}, '_Chan_' num2str(chanidx) '.jpg']);
        end
        %close all
    end
end