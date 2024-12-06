allsID = {'P07','P072','P08','P082','P09','P10','P102','P11','P112', 'P12','P06', 'P062'};

for x = 1:length(allsID)   
    subjID = allsID{x};
    if length(subjID) >= 4
        ses = str2num(subjID(4));
        if strcmp(allsID{x}, 'P082')
            continue
        end 
    else
        ses = 1;
    end
    DataLocationIC = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    clear ICtrials
    ICstim = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',subjID,'/' subjID,'_StimInfo.mat'];
    ICfile = [DataLocationIC, subjID,'_ICtrials.mat'];
    load(ICstim)
    load(ICfile)
    clear ICstim ICfile
    
    %CTrialA = rmmissing(TrialArtf(x,:));
    trialsel = 1:length(ICtrials.trial);

    %% make a trialinfo in the Datafile
    ICtrials.trialinfo = zeros(length(ICtrials.trial),1);
    for catgs =  1:length(StimSiteInfo.Indices)
        for catcond = 1:length(StimSiteInfo.Indices{1,catgs})
            ICtrials.trialinfo(StimSiteInfo.Indices{1,catgs}) = catgs.* ones(length(StimSiteInfo.Indices{1,catgs}),1);
        end
    end
    
    if x == 6 || x == 7
        ICtrials.label{91} = 'U';
    end
    %%
    clear ChanDum
    clear ChanDum2
    ICdataClean =     ICtrials;
    IEEGRereferenceLaplace
    
    cfg = [];
    cfg.demean			=	'yes';
    cfg.baselinewindow	=	'all';
    cfg.lpfilter        =   'yes';
    cfg.lpfreq          =   [40];
    %cfg.bpfilttype      =   'firws';
    ICPreproc	=	ft_preprocessing(cfg, ICReref);

    
    if x == 10
        cfg = [];
        cfg.trials = 1:size(ICnoC.trial,2);
        ICPreproc = ft_selectdata(cfg, ICPreproc);
    end 
    [~,mcart] = setdiff(AllMicro.Session{1,x}.cfg.previous.trlold(:,1),AllMicro.Session{1,x}.cfg.previous.trl(:,1));
    artftrls = setdiff(1:size(ICPreproc.trial,2),mcart);
    
    cfg = [];
    cfg.trials = artftrls;
    ICnoC = ft_selectdata(cfg, ICPreproc);
    dumCtx = [];
    for i = 1:length(CtxTrials{x})
        dumCtx = [dumCtx; find(ICnoC.trialinfo ==  CtxTrials{x}(i))]; % select trials during cortical stimulation
    end
    trlCtxSel = dumCtx;
    
    cfg = [];
    cfg.trials = artftrls;
    ICnoC = ft_selectdata(cfg, ICPreproc);
    dumCtx = [];
    for i = 1:length(HippTrials{x})
        dumCtx = [dumCtx; find(ICnoC.trialinfo ==  HippTrials{x}(i))]; % select trials during cortical stimulation
    end
    trlHippSel = dumCtx;
    
   
    cfg = [];
    cfg.trials = trlCtxSel;
    ctxICnoClean{x} = ft_selectdata(cfg, ICnoC);
    
    cfg = [];
    cfg.trials = trlHippSel;
    ctxICnoHlean{x} = ft_selectdata(cfg, ICnoC);
    
end

%%

AllSigERPbase = cell(size(CorrMat,1),size(CorrMat,2));

for x = 1:size(CorrMat,1)
    for y = 1:size(CorrMat,2)
        for  y2 = 1:size(zvalsig{x,y},2)                   
            if ~isempty(mchan{x,y}) && ~isempty(PhaseInf{x,y}{y2})
                % select the correct data
                if x==1
                    dstrl   = find(contains(AllMicro.StimSite{1,x}.Labels,lbl{1,y}));
                    subtrl = dstrl(kk);
                else
                    subtrl = find(contains(AllMicro.StimSite{1,x}.Labels,lbl{1,y}));
                end
                
                cfg = [];
                cfg.trials      =   any(microSelIH{1,x}.trialinfo == subtrl,2);
                macroDat        =   ft_selectdata(cfg,ctxICnoHlean{1,x});
                
                cfg = [];
                cfg.latency = [-0.1 1];
                cfg.channel  = chans{1,x}(y2);
                AllSigERP{x,y}{y2}  = ft_timelockanalysis(cfg,macroDat);
                origlabel{x,y}{y2} = AllSigERP{x,y}{y2}.label;
                AllSigERP{x,y}{y2}.label = {'ElecLabel'};
                
                cfg = [];
                cfg.baseline = [-0.1 0];               
                AllSigERPbase{x,y}{y2} = ft_timelockbaseline(cfg,AllSigERP{x,y}{y2} );
                
                lax1 = figure;
                hold on
                shadedErrorBar(AllSigERPbase{x,y}{y2}.time,AllSigERPbase{x,y}{y2}.avg, sqrt(AllSigERP{x,y}{y2}.var)./AllSigERPbase{x,y}{y2}.dof(1),'lineProps', 'b')
                axis('tight');
                lim = axis;
                rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
                axis(lim);
                xlim([-0.1 1.2]);
                xlabel(['time in s']);
                ylabel(['Amplitude in ',char(181),'V'])
                title(['Session ',num2str(x),' | ',num2str(y),' | ',num2str(y2)])
                hold off
                               
                if zvalsig{x,y}{y2} % only plot the significant channels                
                    
                  
                    %%
                    maxt = size(macroDat.trial,2);  % determine amount of trials
                    
                    cnum = 360;
                    cirCmap = phasemap(cnum);                        % select a circular colormap
                    ccatnum = [1 91 181 271];
                    
                    
                    figx = PhaseInf{x,y}{y2};
                    h= figure('units','normalized','outerposition',[0 0 1 1]);
                    h.Renderer = 'painters';
                    hold on
                    
                    % sort trials  by phase
                    phaseCat{1,1} = find(figx>deg2rad(-45) & figx<deg2rad(45));
                    phaseCat{1,2} = find(figx>deg2rad(45) & figx<deg2rad(135));
                    phaseCat{1,3} = find(figx>deg2rad(135) | figx<deg2rad(-135));
                    phaseCat{1,4} = find(figx>deg2rad(-135) & figx<deg2rad(-45));
                    
                    hold on
                    for c = 1:4
                        if ~isempty(phaseCat{1,c})
                            cfg = [];
                            cfg.trials = phaseCat{1,c};
                            cfg.channel  = chans{1,x}(y2);
                            cfg.latency = [-0.1 1];
                            timeVar = ft_timelockanalysis(cfg,macroDat);
                            timeVar.label = {'ElecLabel'};
                
                            cfg = [];
                            cfg.baseline = [-0.1 0];
                            timeVarB = ft_timelockbaseline(cfg,timeVar);
                            %ampvalERP{x,y}{y2}(t) = max(abs(timeVarB.avg(chans{1,x}(y2),3000:3400)))
                            
                            dofs(c) = timeVar.dof(1);
                            %cval = round(((PhaseInf{x,y}{y2}(sortI(c))+pi)/(2*pi))*cnum); % pick color based on the phase value. In this case phase value os translated from -pi -> pi to 0->256
                            catfigH(c) = shadedErrorBar(timeVarB.time,timeVarB.avg,sqrt(timeVar.var)/sqrt(timeVar.dof(1)),'lineProps', {'color',cirCmap(ccatnum(c),:)})
                        else
                            catfigH(c).mainLine = plot(zeros(1,160),'linewidth', 1.5,'color', [1, 1, 1])
                        end
                    end
                    hold off
                    xlim([timeVarB.time(1) timeVarB.time(end)])
                    legend([catfigH(1).mainLine,catfigH(2).mainLine,catfigH(3).mainLine,catfigH(4).mainLine],'0','90','180','270');
                    %%
                    mAmp = zeros(1,4);
                    sAmp = zeros(1,4);
                    figure
                    hold on
                    for c = 1:4
                        mAmp(c) = mean(ampval{x,y}{y2}(phaseCat{1,c}));
                        sAmp(c) = std(ampval{x,y}{y2}(phaseCat{1,c}))/sqrt(timeVar.dof(c));
                        
                        bplot = bar(c,mAmp(c));
                        bplot.FaceColor    = cirCmap(ccatnum(c),:);
                    end
                    er = errorbar(1:4, mAmp,sAmp,sAmp);
                    er.Color = [0 0 0];
                    er.LineStyle = 'none';
                    hold off
                    xlabel('Phase Bin');
                    ylabel('Mean Amplitude');
                    %title('');
                    
                    xticks([1 2 3 4])
                    xticklabels([0 90 180 -90])
                    %%
                    figure
                    mAmp = zeros(1,4);
                    sAmp = zeros(1,4);
                    nAmp = zeros(1,4);
                    
                    hold on
                    for c = 1:4
                        mAmp(c) = median((ampval{x,y}{y2}(phaseCat{1,c})-min(ampval{x,y}{y2}))/(max(ampval{x,y}{y2}-min(ampval{x,y}{y2}))));
                        
                        sAmp(c) = std((ampval{x,y}{y2}(phaseCat{1,c})-min(ampval{x,y}{y2}))/(max(ampval{x,y}{y2})-min(ampval{x,y}{y2})))/sqrt(timeVar.dof(c));
                        
                        bplot = bar(c,mAmp(c));
                        bplot.FaceColor    = cirCmap(ccatnum(c),:);
                    end
                    er = errorbar(1:4, mAmp,sAmp,sAmp);
                    er.Color = [0 0 0];
                    er.LineStyle = 'none';
                    hold off
                    xlabel('Phase Bin');
                    ylabel('Mean Amplitude');
                    %title('');
                    
                    xticks([1 2 3 4])
                    xticklabels([0 90 180 -90])
                    %saveas(gcf, [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDep\S',num2str(x),'E',num2str(y),'C',num2str(y2),'.png']);
                end
            end
        end
        if ~isempty(AllSigERPbase{x,y})
            AllSigERPA{x,y} = ft_timelockgrandaverage([],  AllSigERPbase{x,y}{~cellfun('isempty',  AllSigERPbase{x,y})});
        end 
    end
    if ~isempty(AllSigERPbase{x,y})
        AllSigERPAidy = ~cellfun('isempty',  AllSigERPA);
        AllSigERPAvg{x}= ft_timelockgrandaverage([], AllSigERPA{x,AllSigERPAidy(x,:)});
    end
end

%% GA
FinalSigERPidx = ~cellfun('isempty',  AllSigERPAvg);
FinalSigERP = ft_timelockgrandaverage([], AllSigERPAvg{FinalSigERPidx});

lax1 = figure;
hold on
shadedErrorBar(FinalSigERP.time,FinalSigERP.avg, sqrt(FinalSigERP.var)./FinalSigERP.dof(1),'lineProps', 'b')
axis('tight');
lim = axis;
%rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
title(['Grand Average'])
hold off
