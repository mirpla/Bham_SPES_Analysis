function [pB,zval,zvalsig,CorrMat] = MacroPhaseDepICAControlFreq(AllMicro, PeakFreq, microSelIH,ctxICnoH) 
gmean = 1.618;
ContFreq{1,1} = cellfun(@(x) x*gmean,PeakFreq,'un',0);
ContFreq{1,2} = cellfun(@(x) x/gmean,PeakFreq,'un',0);

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

manselchan = ...
    [1	1	1;
    1	1	3;
    1	1	2;
    1	2	1;
    1	2	2;
    1	2	3;
    1	3	1;
    1	3	2;
    1	3	3;
    2	2	2;
    3	2	3;
    3	3	3;
    5	1	1;
    5	2	1;
    5	2	2;
    5	3	1;
    5	3	2;
    5	3	3;
    6	1	2;
    6	2	1;
    6	2	2;
    6	3	2;
    7	1	1;
    7	2	2;
    8	3	3;
    9	1	1;
    9	1	3;
    9	3	1;
    9	3	3;
    10	1	1;
    11	2	2;];
for cv = 1:size(ContFreq,2)
    kk = 2;
    %
    clear selchan
    clear selchanp
    stimloc = 1;
    for x = subs
        for y = 1:size(mchan,2)
            if ~isempty(mchan{x,y})
                
                if x==1
                    dstrl   = find(contains(AllMicro.StimSite{1,x}.Labels,lbl{1,y}));
                    subtrl = dstrl(kk);
                else
                    subtrl = find(contains(AllMicro.StimSite{1,x}.Labels,lbl{1,y}));
                end
                
                cfg = [];
                cfg.channel     = [mchan{x,y}];
                cfg.trials      = any(microSelIH{1,x}.trialinfo == subtrl,2);
                cfg.latency     = [-3,-0.021];
                selmicDat       = ft_selectdata(cfg, microSelIH{1,x}); % select data without NANs (Freq analysis doesn work otherwise)
                
                cfg = [];
                cfg.trials      =  any(microSelIH{1,x}.trialinfo == subtrl,2);
                macroDat        = ft_selectdata(cfg,ctxICnoH{1,x});
                
                cfg        = [];
                cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
                CompsICA = ft_componentanalysis(cfg, selmicDat); % run ICA to find theta component shared across channels
                
                cfg              = [];
                cfg.output       = 'pow';
                cfg.method       = 'mtmfft';
                cfg.taper        = 'hanning';
                cfg.foi          = 1:1:15;
                cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;
                cfg.toi          = -.55:0.05:-0.05;
                cfg.keeptrials = 'yes';
                freqICA = ft_freqanalysis(cfg, CompsICA);   % run FFT on the last 500 ms to find theta peak before stimulation
                
                for dumtrl = 1:length(selmicDat.trial)
                    [~,b(dumtrl)] = max(max(squeeze(freqICA.powspctrm(dumtrl,:,round(ContFreq{1,cv}{x,y}(dumtrl)))),[],2));  % calculate component that has most dominant theta in power spectrum across the channels
                    [~,I] = max(max(squeeze(freqICA.powspctrm(dumtrl,:,round(ContFreq{1,cv}{x,y}(dumtrl)))),[],1));
                end
                
                %             mpFreq(x,y) = mean(PeakFreq{x,y});
                
                %             histogram(PeakFreq{x,y})
                %             xlabel('Frequencey in Hz')
                %             ylabel('Count')
                %             title([sprintf('Phase S%d / E%d / C%d',x,y,y2)])
                %             saveas(gcf, [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDep\HistS',num2str(x),'E',num2str(y),'C',num2str(y2),'.png']);
                %
                peakcounts      = histcounts(b,1:length(freqICA.label));  % find component that has most theta components per trial
                [~, SelComp]    = max(peakcounts);
                for y2 = 1:size(mchan,2)
                    if ~isempty(mchan{x,y2})
                        for t = 1:size(CompsICA.trial,2)
                            dumPhase(t,:)   = angle(hilbert(CompsICA.trial{1,t}(SelComp,1980:2980)));
                            PhaseInf{x,y}{y2}(t,:)   = dumPhase(t,1001);
                            
                            ampval{x,y}{y2}(t)      = max( abs(macroDat.trial{1,t}(chans{1,x}(y2),3025:3425)));  % find cortical amplitude during hippocampal stimulation
                            postresp{x,y}{y2}(t)  = max(abs(macroDat.trial{1,t}(chans{1,x}(y2),3025:3425)));
                            preresp{x,y}{y2}(t)   = max(abs(macroDat.trial{1,t}(chans{1,x}(y2),2580:2980)));
                            
                            %                         hold on
                            %                         plot(1:1401,macroDat.trial{1,t}(chans{1,x}(y2),2000:3400))
                            %                         hold off
                        end
                        
                        [selchan{x,y}(y2),selchanp{x,y}(y2)] = ttest( postresp{x,y}{y2},preresp{x,y}{y2});
                        %                     if ismember([x,y,y2], manselchan,'rows')
                        %                         selchan{x,y}(y2) = 1;
                        %                     else
                        %                         selchan{x,y}(y2) = 0;
                        %                     end
                        %selchan{x,y}(y2) =
                        [CorrMat{x,y}{y2}] = circ_corrcl(  PhaseInf{x,y}{y2},ampval{x,y}{y2});
                    end
                end
            end
        end
    end
    
    
    % Statistical testing
    % Permute Phase Info and Amplitude within Subject per trial and perform
    % Z-test
    clear zval
    clear zvalsig
    chanC = 1;
    nperm = 10000;
    tic
    zcrit=norminv(0.95,0,1);
    sigN = 0;
    totN = 0;
    for x = 1:size(CorrMat,1)
        for y = 1:size(CorrMat,2)
            for y2 = 1:size(CorrMat{x,y},2)
                if ~isempty(CorrMat{x,y})
                    if  ~isempty(CorrMat{x,y}{y2})
                        if selchan{x,y}(y2) == 1
                            for p = 1:nperm
                                phaseperm     = PhaseInf{x,y}{y2}(randperm(length(PhaseInf{x,y}{y2})))';
                                ampperm       = ampval{x,y}{y2}(randperm(length(ampval{x,y}{y2})));
                                [CorrDist{x,y}(p,y2)]    = circ_corrcl(phaseperm, ampperm);
                            end
                            zval{x,y}{y2} = (CorrMat{x,y}{y2}-mean(CorrDist{x,y}(:,y2)))/std(CorrDist{x,y}(:,y2));
                            %[~,pCorr{x,y}(y2)] = ztest(CorrMat{x,y}{y2},mean(CorrDist{x,y}(:,y2)),std(CorrDist{x,y}(:,y2)));
                            %sigchannels(chanC) = pCorr{x,y}(y2)<0.05;
                            chanC = chanC+1;
                            zvalsig{x,y}{y2} = zval{x,y}{y2}>zcrit;
                            totN = totN+1;
                            if zvalsig{x,y}{y2} ==1
                                sigN = sigN+1;
                            end
                        end
                    end
                end
            end
        end
    end
    toc
    
    % sigN        =  sum(sum(cellfun(@sum,zvalsig)));
    % totN        =  sum(sum(cellfun(@numel,zvalsig)));
    pB(cv)          =  myBinomTest(sigN,totN,0.05,'one');
    
    sprintf('Ratio of significant channels: %d / %d (%.1f %%)', sigN,totN, round(pB(cv)*100,2))
end
