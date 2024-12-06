function [StatC,StatH,DlFoofreadyC, DlFoofreadyH] = MacroData(Basepath, AllMacro, ICConditions, TrialSelCondiEEG)
condidx = 8;    
condidxhipp = 4;
CumSumPath = [Basepath 'Mircea/3 - SPES/Datasaves/CumSum/'];

postLat = [0.05 1.026];
fLat = [0.026 1.026];
fLat(2,:) = [-1.022 -0.022];
subj = [1,2,3,4,5,6,7,8,9,10,11];

condName = ' Local vs. Distal Stimulation at Cortical Channels';
for subjidx = subj
    clear chanlistH
    clear chanlistC
    ID = AllMacro.SubjID{1,subjidx};
    Data{1,subjidx} = eval(sprintf('ICConditions.%s.Conditions{1,condidx}', ID));
    Data{2,subjidx} = eval(sprintf('ICConditions.%s.Conditions{1,condidxhipp}', ID));
    
    chanlistClabel = eval(sprintf('ICConditions.%s.AllChan(2,:)',ID))';
    CtxIdx = contains(chanlistClabel,'Ctx');
    HippIdx = contains(chanlistClabel,'Hipp');
    chanlistC = eval(sprintf('ICConditions.%s.AllChan(1,CtxIdx)',ID));
    chanlistH = eval(sprintf('ICConditions.%s.AllChan(1,HippIdx)',ID));
      
    [DataSelCtx{1,subjidx},  DatafC{1,subjidx}] = IEEGdynSel(subjidx,Data{1,subjidx},chanlistC,1);
    [DataSelHipp{1,subjidx}, DatafH{1,subjidx}] = IEEGdynSel(subjidx,Data{2,subjidx},chanlistH,2);
    
    Ctxstim = max(cell2mat(chanlistC(1,:)'),[],2)';
    cfg = [];
    cfg.channel = sort(Ctxstim(~(Ctxstim == 0)));
    cfg.trials = TrialSelCondiEEG{subjidx,4}';
    if subjidx == 5
        cfg.channel = cfg.channel(1,3);
    elseif subjidx == 7
        cfg.channel = cfg.channel(1,1:2);
    end 
    cfg.avgoverchan = 'yes';
    DataSelCtx{2,subjidx}  = ft_selectdata(cfg, AllMacro.Session{1,subjidx});
    DataSelCtx{2,subjidx}.label = {'A'};
    
    HippS = cell2mat(chanlistH(1,:)'); 
    HippS(HippS==0) = NaN;
    Hippstim = nanmin(HippS,[],2)';  
    cfg = [];
    cfg.channel = sort(Hippstim(~(Hippstim == 0)));
    if subjidx == 5
        cfg.channel = cfg.channel(1,1);
    end 
    cfg.trials = TrialSelCondiEEG{subjidx,8}';
    cfg.avgoverchan = 'yes';
    DataSelHipp{2,subjidx}  = ft_selectdata(cfg, AllMacro.Session{1,subjidx});
    DataSelHipp{2,subjidx}.label = {'A'};
%    
%     cfg = [];
%     cfg.viewmode = 'vertical';
%     %cfg.allowoverlap = 'yes';
%     ft_databrowser(cfg, DataSelCtx{2,subjidx});
%         
%      
%     cfg = [];
%     cfg.viewmode = 'vertical';
%     cfg.allowoverlap = 'yes';
%     ft_databrowser(cfg, AllMacro.Session{1,subjidx});
    
    
    %DataSelCtx{2,subjidx}.trial = cellfun(@(x) x*-1,DataSelCtx{2,subjidx}.trial ,'un',0);
    %DataSelHipp{2,subjidx}.trial = cellfun(@(x) x*-1,DataSelHipp{2,subjidx}.trial ,'un',0);
    
    
    
    cfg = [];
    cfg.channel = sort(Ctxstim(~(Ctxstim == 0)));
    cfg.trials = TrialSelCondiEEG{subjidx,4}';
    cfg.avgoverchan = 'no';
    DatafC{2,subjidx}  = ft_selectdata(cfg, AllMacro.Session{1,subjidx});
    cfg = [];
    cfg.channel         = sort(Hippstim(~(Hippstim ==0)));
    cfg.trials          = TrialSelCondiEEG{subjidx,8}';
    cfg.avgoverchan     = 'no';
    DatafH{2,subjidx}    = ft_selectdata(cfg, AllMacro.Session{1,subjidx});
    
    figure
    tiledlayout(2,2)
    ax1 = nexttile;
    plot(DataSelCtx{1,subjidx}.time{1,1}, mean(cell2mat(DataSelCtx{1,subjidx}.trial')))
    axis('tight')
    title('Local Ctx')
    ax2 = nexttile;
    plot(DataSelCtx{1,subjidx}.time{1,1}, mean(cell2mat(DataSelCtx{2,subjidx}.trial')))
    axis('tight')
    title('Distal Ctx')   
    ax3 = nexttile;
    plot(DataSelHipp{1,subjidx}.time{1,1}, mean(cell2mat(DataSelHipp{1,subjidx}.trial')))
    axis('tight')
    title('Local Hipp')
    ax4 = nexttile;
    plot(DataSelHipp{2,subjidx}.time{1,1}, mean(cell2mat(DataSelHipp{2,subjidx}.trial')))
    axis('tight')
    title('Distal Hipp')
    linkaxes([ax1,ax2,ax3,ax4])
end
%%
condName = ['Local vs. Distal Stimulation at Cortical Channels'];
StatC = ERPCumSumiEEG(DataSelCtx , postLat,condName);
condName = ['Local vs. Distal Stimulation at Hippocampal Channels'];
StatH = ERPCumSumiEEG(DataSelHipp  , postLat,condName);

[DlFoofreadyC] = FOOOFfreq(DatafC,fLat,2,Basepath);
[DlFoofreadyH] = FOOOFfreq(DatafH,fLat,3,Basepath);
end 