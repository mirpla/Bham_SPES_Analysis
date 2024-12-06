%Cortex Stimulation phase dep in Hipp
% function [ctxICnoCl] = PhaseDepPreProcLP(Basepath)

CtxTrials{1}   = [11, 12,17,18, 23];
CtxTrials{2}   = [6,7];
CtxTrials{3}   = [6,7,13,14,20,21];
CtxTrials{4}   = [6,7,13,14,20,21];
CtxTrials{5}   = [6,7,13,14, 20,21,26,27];
CtxTrials{6}   = [6,12,18];
CtxTrials{7}   = [6,12,18];
CtxTrials{8}   = [10,11];
CtxTrials{9}   = [6,7,13];
CtxTrials{10}  = [6];
CtxTrials{11}  = [9];
CtxTrials{12}  = [18,19,30,31,41,43];

HippTrials{1}  = [7,8,13,14,19,20];
HippTrials{2}  = [1,2];
HippTrials{3}  = [1,2,8,9,15,16];
HippTrials{4}  = [1,2,8,9,15,16];
HippTrials{5}  = [1,2,8,9, 15,16, 22,23];
HippTrials{6}  = [1,7,13];
HippTrials{7}  = [1,7,13];
HippTrials{8}  = [5,6];
HippTrials{9}  = [1,2,8,9];
HippTrials{10} = [1,2];
HippTrials{11} = [4];
HippTrials{12} = [14,15,25,26,36,37];

%TrialArtf = readmatrix([Basepath,'Mircea/3 - SPES/Datasaves/Artifacts/Artf.csv']);
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

%     cfg = [];
%     cfg.demean			=	'yes';
%     %cfg.baselinewindow	=	'all';
%     cfg.lpfilter        =   'yes';
%     cfg.lpfreq          =   [1,40];
% %     cfg.bpfilttype      =   'firws';


    cfg = [];
    cfg.demean			=	'yes';
    cfg.lpfilter        =   'yes';
    cfg.lpfreq          =   [10];
    cfg.hpfilter        =   'yes';
    cfg.hpfreq          =   [3];
    cfg.latency         = [-2.05,-0.05];
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
    ctxICnoC{x} = ft_selectdata(cfg, ICnoC);
    microSelIC{x} = ft_selectdata(cfg, AllMicro.Session{1,x});
    
    cfg = [];
    cfg.trials = trlHippSel;
    ctxICnoH{x} = ft_selectdata(cfg, ICnoC);
    microSelIH{x} = ft_selectdata(cfg, AllMicro.Session{1,x});
    
end
%% MNI Coordinates + Atlas

MNI = readmatrix([Basepath,'Mircea\3 - SPES\Datasaves\CortexMNI.csv']);
for s = 1:size(AllMacro.StimSite,2)
    c2 = 0;
    for c = [0 3 6]
        c2 = c2 + 1
        Atlas{s,c2} = mni2atlas(MNI(1,1+c:3+c));
    end
end
%%

thetarange = 4:8;
subs = [1,2,3,5,6,7,8,9,10,11,12];
chans{1,1}  = [30,38,46];
chans{1,2}  = [0  107 0];
chans{1,3}  = [8,16,24];
chans{1,4}  = [32,40,48];
chans{1,5}  = [60,68,76];
chans{1,6}  = [8,16,24];
chans{1,7}  = [40,48,56];
chans{1,8}  = [8,16, 24];
chans{1,9}  = [32,0,40];
chans{1,10} = [8, 15, 23];
chans{1,11} = [0, 32, 0];
chans{1,12} = [8,16,24];

chans{2,1} = [23,31,39];
chans{2,2} = [0  100 0];
chans{2,3} = [1,9,17];
chans{2,4} = [25,33,41];
chans{2,5} = [53,61,69];
chans{2,6} = [1,9,17];
chans{2,7} = [33,41,49];
chans{2,8} = [1,9, 17];
chans{2,9} = [25,0,33];
chans{2,10} = [1, 9, 16];
chans{2,11} = [0,25,0];
chans{2,12} = [1,9,17];


mchan{1,1} = [1:7];         %AH
mchan{1,2} = [16:22];     %MH
mchan{1,3} = [23:30];     %PH

% P072 Left
mchan{2,1} = [];
mchan{2,2} = [9:16];     %MH
mchan{2,3} = [];

% P08 Right
mchan{3,1} = [];                %AH
mchan{3,2} = [25:32];     %MH
mchan{3,3} = [41:47];     %PH (from Distal)

% P082 Left
mchan{4,1} = [];             %AH
mchan{4,2} = [17:24];     %
mchan{4,3} = [33:40];     %PH (from Distal)

% P09 Left
mchan{5,1} = [1:8];         %AH
mchan{5,2} = [17:24];     %MH
mchan{5,3} = [49:56];     %PH
%mchan{5,4} = [36 37 38 39];     %PHG

% P10 Right Huge line noise in right channels following trial 74
mchan{6,1} = [9:16]; %12 16     %AH
mchan{6,2} = [25:32];     %MH
mchan{6,3} = [56:63];     %PH
%mchan{6,4} = [];     %PHG

% P102 Left
mchan{7,1} = [1:8];     %AH
mchan{7,2} = [16:23];     %MH
mchan{7,3} = [48:54];     %PH
%mchan{7,4} = [];     %PHG

%P11 Left
mchan{8,1} = []; %12 16     %AH
mchan{8,2} = [];     %MH
mchan{8,3} = [21:28];     %PH

% P112 Right
mchan{9,1} = [7:13];     %AH
mchan{9,2} = [];                     %MH
mchan{9,3} = [30:36];                %PH

% P12 Left
mchan{10,1} = [1:8];                 %AH
mchan{10,2} = [];                  %MH
mchan{10,3} = [];                %PH


% P12 Right
%mchan{10,2} = [25:30];                %MH

% P06 Left
mchan{11,1} = [];
mchan{11,2} = [1:8];                % MH
mchan{11,3} = [];

% P06 Right
mchan{12,1} = [8,17,23:28];           %AH
mchan{12,2} = [29,10:13];             %MH
mchan{12,3} = [14:16,18:22];          %PH

lbl{1,1}    = 'AH';
lbl{1,2}    = 'MH';
lbl{1,3}    = 'PH';

SigRespMat
lpc = 1;
thetarange = 4:8;

clear selchan
clear selchanp
stimloc = 1;
for x = 1:size(chans,2) % cycle through subjets
    for y = 1:size(chans{1,x},2) % cycle through ctx macro electrodes
        if chans{1,x}(1,y) ~= 0 && ~isempty(microSelIC{x})
            if ~isempty(microSelIC{x}.trialinfo)
                subtrl = find(contains(AllMacro.StimSite{1,x}.Labels,lbl{1,y}));
                
                cfg = [];
                cfg.trials      = any( microSelIC{x}.trialinfo == subtrl,2);
                %cfg.latency     = [0.04,1.2];
                selmicDat       = ft_selectdata(cfg, microSelIC{1,x}); % select data without NANs (Freq analysis doesn work otherwise)
                if ~isempty(selmicDat.trialinfo)
                    
                    cfg = [];
                    cfg.channel     = [chans{1,x}(1,y)];%,chans{1,x}(1,y)-1,chans{1,x}(1,y)-2];
                    %cfg.latency     = [-3,-0.021];
                    cfg.trials      = any(microSelIC{1,x}.trialinfo == subtrl,2);
                    macroDat        = ft_selectdata(cfg,ctxICnoC{1,x});
                    
                    if ~isempty(mchan{x,y})
                        for y2 = 1:size(mchan{x,y},2)
                            for t = 1:size(macroDat.trial,2)
                                dumphase = angle(hilbert(macroDat.trial{1,t}));
                                PhaseInfCtx{x,y}{y2}(t,:) = dumphase(2049);
                                
                                ampvalCtx{x,y}{y2}(t)    = max(abs(selmicDat.trial{1,t}(mchan{x,y}(y2),3025:3425)));  % find cortical amplitude during hippocampal stimulation
                                postrespCtx{x,y}{y2}(t)  = max(abs(selmicDat.trial{1,t}(mchan{x,y}(y2),3025:3425)));
                                prerespCtx{x,y}{y2}(t)   = max(abs(selmicDat.trial{1,t}(mchan{x,y}(y2),2580:2980)));
                                
                                %                         hold on
                                %                         plot(1:1401,macroDat.trial{1,t}(chans{1,x}(y2),2000:3400))
                                %                         hold off
                            end
                            
                            [selchanCtx{x,y}(y2),selchanpCtx{x,y}(y2)] = ttest( postrespCtx{x,y}{y2},prerespCtx{x,y}{y2});
                            %                     if ismember([x,y,y2], manselchan,'rows')
                            %                         selchan{x,y}(y2) = 1;
                            %                     else
                            %                         selchan{x,y}(y2) = 0;
                            %                     end
                            %selchan{x,y}(y2) =
                            [CorrMatCtx{x,y}{y2}] = circ_corrcl(  PhaseInfCtx{x,y}{y2},ampvalCtx{x,y}{y2}');
                        end
                    end
                end
            end
        end
    end
end

%%


% Statistical testing
% Permute Phase Info and Amplitude within Subject per trial and perform
% Z-test
clear zval
clear zvalsig
chanC = 1;
cselect = [0 3 6];
nperm = 10000;
tic
zcrit=norminv(0.95,0,1);
sigN = 0;
nsigN = 0;
totN = 0;
zvalCtx = cell(size(CorrMatCtx,1),size(CorrMatCtx,2));
for x = 1:size(CorrMatCtx,1)
    for y = 1:size(CorrMatCtx,2)
        for y2 = 1:size(CorrMatCtx{x,y},2)
            if ~isempty(CorrMatCtx{x,y})
                if  ~isempty(CorrMatCtx{x,y}{y2})
                    if selchanCtx{x,y}(y2) == 1
                        for p = 1:nperm
                            phasepermCtx     = PhaseInfCtx{x,y}{y2}(randperm(length(PhaseInfCtx{x,y}{y2})))';
                            amppermCtx       = ampvalCtx{x,y}{y2}(randperm(length(ampvalCtx{x,y}{y2})));
                            [CorrDist{x,y}(p,y2)]    = circ_corrcl(phasepermCtx, amppermCtx);
                        end
                        zvalCtx{x,y}{y2} = (CorrMatCtx{x,y}{y2}-mean(CorrDist{x,y}(:,y2)))/std(CorrDist{x,y}(:,y2));
                        %[~,pCorr{x,y}(y2)] = ztest(CorrMat{x,y}{y2},mean(CorrDist{x,y}(:,y2)),std(CorrDist{x,y}(:,y2)));
                        %sigchannels(chanC) = pCorr{x,y}(y2)<0.05;
                        chanC = chanC+1;
                        zvalsigCtx{x,y}{y2} = zvalCtx{x,y}{y2}>zcrit;
                        totN = totN+1;
                        if zvalsigCtx{x,y}{y2} ==1
                            sigN = sigN+1;
                            Bregions.sig{sigN} = Atlas{x,y}(2).label;
                            sigMNI(sigN,:) = MNI(x,cselect(y)+1:cselect(y)+3);
                        else
                            nsigN = nsigN + 1;
                            Bregions.nsig{nsigN} = Atlas{x,y}(2).label;
                            nsigMNI(nsigN,:) = MNI(x,cselect(y)+1:cselect(y)+3);
                        end
                    end
                end
            end
        end
    end
end
toc
for x = 1:size(zvalsigCtx,1)
    for y = 1:size(zvalsigCtx,2)
        if ~isempty(zvalsigCtx{x,y})
            bundsigidx(x,y) = double(any(cellfun(@(v)isequal(v,1),zvalsigCtx{x,y})));
        else
            bundsigidx(x,y) = -1;
        end
    end
end

[counts, countnums] = histcounts(bundsigidx);
countnumsProp = [mean(countnums(1:2)),mean(countnums(2:3)),mean(countnums(3:4))];

sigNelec = counts(3);
totNelec = counts(2)+counts(3);

pBCtx          =  myBinomTest(sigNelec,totNelec,0.05,'one');
sprintf('Ratio of significant channels: %d / %d (%.2f %%)', sigNelec,totNelec, round(pBCtx*100,2))

% sigN        =  sum(sum(cellfun(@sum,zvalsig)));
% totN        =  sum(sum(cellfun(@numel,zvalsig)));
pBCtx         =  myBinomTest(sigN,totN,0.05,'one');

sprintf('Ratio of significant channels: %d / %d (%.1f %%)', sigN,totN, round(pBCtx*100,2))

%%

AllSigERPbase = cell(size(CorrMatCtx,1),size(CorrMatCtx,2));

for x = 1:size(chans,2) % cycle through subjets
    for y = 1:size(chans{1,x},2) % cycle through ctx macro electrodes
        if chans{1,x}(1,y) ~= 0 && ~isempty(microSelIC{x})
            for  y2 = 1:size(zvalCtx{x,y},2)
                if ~isempty(microSelIC{x}.trialinfo)
                    if selchanCtx{x,y}(y2) == 1
                        subtrl = find(contains(AllMacro.StimSite{1,x}.Labels,lbl{1,y}));
                        
                        cfg = [];
                        cfg.trials      = any( microSelIC{x}.trialinfo == subtrl,2);
                        %cfg.latency     = [0.04,1.2];
                        selmicDat       = ft_selectdata(cfg, microSelIC{1,x}); % select data without NANs (Freq analysis doesn work otherwise)
                        if ~isempty(selmicDat.trialinfo)
                            
                            cfg = [];
                            cfg.latency = [-0.1 2];
                            cfg.channel  = mchan{x,y}(y2);
                            AllSigERP{x,y}{y2}  = ft_timelockanalysis(cfg,selmicDat);
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
                            
                            if zvalsigCtx{x,y}{y2} % only plot the significant channels
                                
                                
                                %%
                                maxt = size(macroDat.trial,2);  % determine amount of trials
                                
                                cnum = 360;
                                cirCmap = phasemap(cnum);                        % select a circular colormap
                                ccatnum = [1 91 181 271];
                                
                                
                                figx = PhaseInfCtx{x,y}{y2};
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
                                        cfg.channel  = mchan{x,y}(y2);
                                        cfg.latency = [-0.1 2];
                                        timeVar = ft_timelockanalysis(cfg,selmicDat);
                                        timeVar.label = {'ElecLabel'};
                                        
                                        cfg = [];
                                        cfg.baseline = [-0.1 0];
                                        timeVarB = ft_timelockbaseline(cfg,timeVar);
                                        %ampvalERP{x,y}{y2}(t) = max(abs(timeVarB.avg(chans{1,x}(y2),3000:3400)))
                                        
                                        dofs(c) = timeVar.dof(1);
                                        %cval = round(((PhaseInf{x,y}{y2}(sortI(c))+pi)/(2*pi))*cnum); % pick color based on the phase value. In this case phase value os translated from -pi -> pi to 0->256
                                        if dofs(c)>1
                                            catfigC{c} = shadedErrorBar(timeVarB.time,timeVarB.avg,sqrt(timeVar.var)/sqrt(timeVar.dof(1)),'lineProps', {'color',cirCmap(ccatnum(c),:)});
                                        else
                                            catfigC{c} = shadedErrorBar(timeVarB.time,timeVarB.avg,ones(1,length(timeVar.var))*0.001,     'lineProps', {'color',cirCmap(ccatnum(c),:)});
                                        end
                                    else
                                        catfigC{c}.mainLine = plot(zeros(1,160),'linewidth', 1.5,'color', [1, 1, 1]);
                                    end
                                end
                                hold off
                                xlim([timeVarB.time(1) timeVarB.time(end)])
                                legend([catfigC{1}.mainLine,catfigC{2}.mainLine,catfigC{3}.mainLine,catfigC{4}.mainLine],'0','90','180','270');
                                %%
                                mAmp = zeros(1,4);
                                sAmp = zeros(1,4);
                                figure
                                hold on
                                for c = 1:4
                                    mAmp(c) = mean(ampvalCtx{x,y}{y2}(phaseCat{1,c}));
                                    sAmp(c) = std(ampvalCtx{x,y}{y2}(phaseCat{1,c}))/sqrt(timeVar.dof(c));
                                    
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
                                    mAmp(c) = median((ampvalCtx{x,y}{y2}(phaseCat{1,c})-min(ampvalCtx{x,y}{y2}))/(max(ampvalCtx{x,y}{y2}-min(ampvalCtx{x,y}{y2}))));
                                    
                                    sAmp(c) = std((ampvalCtx{x,y}{y2}(phaseCat{1,c})-min(ampvalCtx{x,y}{y2}))/(max(ampvalCtx{x,y}{y2})-min(ampvalCtx{x,y}{y2})))/sqrt(timeVar.dof(c));
                                    
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
rectangle('Position', [-0.05,-1000, 0.1, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
title(['Grand Average'])
hold off

%% 
%% SMOL Pie
hp = figure
hp.Renderer = 'painters';
pie([sigN,totN-sigN],[ 1 0 ],{[num2str(sigN) ' Channels - ' num2str(round(sigN/totN*100,2)) '%'],[num2str(totN-sigN) ' Channels - ' num2str(round((((totN-sigN)/totN)) *100,2)) '%']})
colormap([0 0 0;0 0 1])
legend('PhaseDependency','No Phasedependency')
%%

[pBc,zvalc,zvalsigc,CorrMatc] = MacroPhaseDepICAControlFreq(AllMicro, PeakFreq, microSelIH,ctxICnoH);