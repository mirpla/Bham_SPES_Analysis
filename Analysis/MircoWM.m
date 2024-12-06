function MircoWM(Basepath, AllMicro, CSCHippCondLFP, TrialSelCondLFP)

subs = [1,2,3,4,5,6,8,9];

BundleDef

%% White Matter

count = 1;
for subjidx = [subs]
    %%
    
    ID = AllMicro.SubjID{1,subjidx};
    Data{1,subjidx} = AllMicro.Session{1,subjidx};
    if strcmp(AllMicro.SubjID{1,subjidx},'P072');
        chanlist = eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID));
    elseif strcmp(AllMicro.SubjID{1,subjidx},'P11');
        chanlist = eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID));
    elseif strcmp(AllMicro.SubjID{1,subjidx},'P112');
        chanlist = [eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,2}',ID))];
    else
        chanlist =  [eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,2}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,3}',ID))];
    end
    cfg = [];
    cfg.channel = chanlist;
    Datae{1,subjidx} = ft_selectdata(cfg, Data{1,subjidx});
    
    for b = 1:size(bundlelist{1,subjidx},2)
        trl = [];
        trl = [find(ismember(Datae{1,subjidx}.trialinfo,bundlelist{1,subjidx}{3,b}))'];
        if isempty(trl)
            warning('no trials for sub ',num2str(subjidx),'Bundle ', num2str(b))
            wdum = [subjidx,b];
            continue
        end 
        cfg = [];
        cfg.channel = bundlelist{1,subjidx}{1,b};
        cfg.avgoverchan = 'yes';
        cfg.trials = trl;
        DatabWMc{1,count} = ft_selectdata(cfg, Data{1,subjidx});
        DatabWMc{1,count}.label = {'A'};
        
        cfg = [];
        cfg.viewmode = 'vertical';
        Artct{1,count} = ft_databrowser(cfg,  DatabWMc{1,count} );
        Artct{1,count}.artfctdef.reject = 'complete';
        DatabWM{1,count}   = ft_rejectartifact(Artct{1,count}, DatabWMc{1,count});
       
        cfg = [];
        cfg.channel = bundlelist{1,subjidx}{1,b};
        cfg.avgoverchan = 'no';
        cfg.trials = trl;
        DatafWM{1,count} = ft_selectdata(cfg, Data{1,subjidx});
        count = count+1;
    end
end
for bundle = 1:size(DatabWM,2)
    cfg = [];
    cfg.avgoverchan = 'yes';
    ERPwmnoGA{1,bundle} = ft_timelockanalysis(cfg, DatabWM{1,bundle});
    
    cfg = [];
    cfg.baseline = [-2 -1];
    ERPwmGA{1,bundle} = ft_timelockbaseline(cfg, ERPwmnoGA{1,bundle});
end


%% Reject Noisy Bundles
% for sigWM = [1:length(DatabWM)]
%     DatfWMtrl = cell2mat(DatabWM{1,sigWM}.trial');
%     figure
%     hold on
%    % plot(DatafWM{1,sigWM}.time{1,1},mean(DatfWMtrl(chans:4:size(DatfWMtrl,1),:)))
%     plot(DatafWM{1,sigWM}.time{1,1},mean(DatfWMtrl))
%     axis('tight');
%    % xlim([-0.1 1.2]);
%     xlabel(['time in s']);
%     ylabel(['Amplitude in ',char(181),'V'])
%     hold off
% end

%%
cfg = [];
ERPwmGGA = ft_timelockgrandaverage(cfg, ERPwmnoGA{1,[1,2,3,6,7,8,9,10,11,12,13,14]});


figure
hold on
shadedErrorBar(ERPwmGGA.time,ERPwmGGA.avg, sqrt(ERPwmGGA.var)/ERPwmGGA.dof(1),'lineProps', 'b')
axis('tight');
lim = axis;
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
%ylim([-200 400])
hold off

%%
fLat = [0.026 1.026];
fLat(2,:) = [-1.022 -0.022];
for b = 1:size(DatafWM,2)
    cfg = [];
    cfg.latency = fLat(2,:);
    Datapp{1,b} = ft_selectdata(cfg, DatafWM{1,b}); % Pre
    
    cfg = [];
    cfg.latency = fLat(1,:);
    Datapp{2,b} = ft_selectdata(cfg, DatafWM{1,b}); %post
    
    for x = 1:size(Datapp,1)
        Datapp{x,b}.hdr.nTrials    =length(Datapp{x,b}.trial);
        
        cfg = [];
        cfg.output = 'pow';
        cfg.method = 'mtmfft';
        cfg.foi = 1:1:30;
        cfg.tapsmofrq = 1;
        cfg.keeptrials = 'yes';
        FFTl{x,b} = ft_freqanalysis(cfg, Datapp{x,b});
        
        cfg = [];
        cfg.variance      = 'yes';
        FFTlv{x,b} = ft_freqdescriptives(cfg,FFTl{x,b});
       
       
        if length(FFTlv{x,b}.label) == 1            
            cfg                 = [];
            cfg.trials          = 'all';
            DlFoofready{x,b}    = ft_selectdata(cfg, FFTlv{x,b});
        else
            cfg                 = [];
            cfg.trials          = 'all';
            cfg.avgoverchan     = 'yes';
            DlFoofready{x,b}    = ft_selectdata(cfg, FFTlv{x,b});
        end
    end
end


for x = 1:size(DlFoofready,1)
    for y = 1:size(DlFoofready,2)
        FFTGA{x,1}(y,:) = DlFoofready{x,y}.powspctrm;
    end     
end
figure 
hold on
h1 = shadedErrorBar(DlFoofready{1,2}.freq,mean(FFTGA{2,1}),std(FFTGA{2,1})/sqrt(size(FFTGA{2,1},1)),'lineProps', '-b');
h2 = shadedErrorBar(DlFoofready{1,1}.freq,mean(FFTGA{1,1}),std(FFTGA{1,1})/sqrt(size(FFTGA{1,1},1)),'lineProps', '-r');
set(gca, 'YScale', 'log')
legend([h1.mainLine h2.mainLine],'Post WM Stimulation', 'Pre WM Stimulation')
hold off

end