function [Stats]= ERPCumSumSummaryFQ(Basepath, AllMicro, AllMacro, AllMacroLP, postLat, manual)

[CSCHippCondLFP, ~, TrialSelCondLFP, TrialSelCondiEEG{1,1}, ICConditions{1,1}] = SelectedConditions_IEEG_I_LFP(AllMicro, AllMacro);
[             ~, ~,               ~, TrialSelCondiEEG{1,2}, ICConditions{1,2}] = SelectedConditions_IEEG_I_LFP(AllMicro, AllMacroLP);

%% Micro
condidx = 8;
condidxctx = 7;
condidxhipp = 4;
CumSumPath = [Basepath 'Mircea/Datasaves/CumSum/'];


postLat = [0.026 1.026];
preLat = [-1.022 -0.022];
subs = [1,2,3,4,5,6,8,9,10,11,12];

BundleDef

count = 1;
for subjidx = subs
    %%
    
    ID = AllMicro.SubjID{1,subjidx};
    Data{1,subjidx} = eval(sprintf('CSCHippCondLFP.%s.Conditions{1,condidx}', ID));
    Data{2,subjidx} = eval(sprintf('CSCHippCondLFP.%s.Conditions{1,condidxctx}', ID));
    
    if strcmp(AllMicro.SubjID{1,subjidx},'P072');
        chanlist = eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID));
    elseif strcmp(AllMicro.SubjID{1,subjidx},'P11');
        chanlist = eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID));   
    elseif strcmp(AllMicro.SubjID{1,subjidx},'P112');
        chanlist = [eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,2}',ID))];
    elseif strcmp(AllMicro.SubjID{1,subjidx},'P12');
        chanlist = [eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,2}',ID))];
    elseif strcmp(AllMicro.SubjID{1,subjidx},'P06');
        chanlist = eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID));
    else
        chanlist =  [eval(sprintf('CSCHippCondLFP.%s.AllChan{1,1}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,2}',ID)), eval(sprintf('CSCHippCondLFP.%s.AllChan{1,3}',ID))];
    end
    cfg = [];
    cfg.channel = chanlist;
    Datae{1,subjidx} = ft_selectdata(cfg, Data{1,subjidx});
    Datae{2,subjidx} = ft_selectdata(cfg, Data{2,subjidx});
    
%     cfg = [];
%     cfg.viewmode = 'vertical';
%     ft_databrowser(cfg,Datae{1,subjidx})
%     
    for b = 1:size(bundlelist{1,subjidx},2)
        for d = 1:size(Datae,1)
            trl = [];
            trl = find(ismember(Datae{d,subjidx}.trialinfo,bundlelist{d,subjidx}{2,b}))';
            
%             cfg              = [];
%             cfg.method       = 'channel';
%             cfg.channel      = chanlist(bundlelist{d,subjidx}{1,b});
%             Datar{d,subjidx}   = ft_rejectvisual(cfg, Data{d,subjidx});
             
            cfg = [];            
            cfg.channel = bundlelist{d,subjidx}{1,b};
            cfg.avgoverchan = 'yes';
            cfg.trials = trl;
            cfg.nanmean = 'yes';
            Datab{d,count} = ft_selectdata(cfg, Data{d,subjidx});
            Datab{d,count}.label = 'A';           
            
            cfg = [];
            cfg.channel = bundlelist{d,subjidx}{1,b};
            cfg.avgoverchan = 'no';
            cfg.nanmean = 'yes'; 
            cfg.trials = trl;
            cfg.latency  = postLat;
            Datafpost{d,count} = ft_selectdata(cfg, Data{d,subjidx});
            cfg.latency   = preLat;            
            Datafpre{d,count} = ft_selectdata(cfg, Data{d,subjidx});
        end
        count = count+1;
    end
end
%% MacroLP
if manual == 1
    for lpc = 1:2 % counter for laplace and nonlaplace
        for subjidx =[ 1 2 3 4 5 7 8 9 10 11 12 ]
            if lpc == 1
                Macrodat = AllMacro.Session{1,subjidx};
            elseif lpc == 2
                Macrodat = AllMacroLP.Session{1,subjidx};
            end
            clear chanlistH
            clear chanlistC
            ID = AllMacro.SubjID{1,subjidx};
            
            chanlistClabel = eval(sprintf('ICConditions{1,lpc}.%s.AllChan(2,:)',ID))';
            CtxIdx = contains(chanlistClabel,'Ctx');
            HippIdx = contains(chanlistClabel,'Hipp');
            chanlistC = eval(sprintf('ICConditions{1,lpc}.%s.AllChan(1,CtxIdx)',ID));
            chanlistH = eval(sprintf('ICConditions{1,lpc}.%s.AllChan(1,HippIdx)',ID));
            
            Ctxstim = max(cell2mat(chanlistC(1,:)'),[],2)';
            chancnt = 0;
            disp('initialising Ctx')
            for chanidx = sort(Ctxstim(~(Ctxstim == 0)))
                chancnt = chancnt+1;
                
                cfg = [];
                cfg.channel = chanidx;
                cfg.trials = TrialSelCondiEEG{1,lpc}{subjidx,4}';
                %             if subjidx == 5
                %                 cfg.channel = cfg.channel(1,3);
                %             elseif subjidx == 7
                %                 cfg.channel = cfg.channel(1,1:2);
                %             end
                cfg.avgoverchan = 'no';
                DataSelCtx  = ft_selectdata(cfg,Macrodat);
                
                cfg                         = [];
                cfg.method                  = 'channel';
                DataSelCtxRej{chancnt,1}    = ft_rejectvisual(cfg, DataSelCtx);
                
                A = unique(DataSelCtxRej{chancnt,1}.trialinfo);
                A(end+1) = 2; % Add a new isolating point end
                B = find(diff(A)~=1); % Find indexes of isolating points
                n = size(B,1);
                Start_Idx = 1 ; % Set start index
                Trlclust = cell(n,1);
                for i = 1:n
                    End_Idx = B(i); % Set end index
                    Trlclust{i,1} = A(Start_Idx:End_Idx); % Find consecuative sequences
                    Start_Idx = End_Idx + 1;
                    % update start index for the next consecuitive sequence
                end
                
                for tc = 1:size(Trlclust,1)
                    cfg = [];
                    cfg.trials = ismember(DataSelCtxRej{chancnt,1}.trialinfo, Trlclust{tc});
                    DataSelCFF{lpc,subjidx}{chancnt}{tc}  = ft_selectdata(cfg,DataSelCtxRej{chancnt,1});
                    
                    figure
                    plot(DataSelCFF{lpc,subjidx}{chancnt}{tc}.time{1,1}, mean(cell2mat(DataSelCFF{lpc,subjidx}{chancnt}{tc}.trial')))
                    axis('tight')
                    title('Distal Ctx') % Record Ctx stim hippocampus
                    saveas(gcf, [Basepath, 'Mircea\3 - SPES\Datasaves\FIGS\IndvERP\DistCtxLp',num2str(lpc),'s',num2str(subjidx),'chan',num2str(chancnt),'tc',num2str(tc),'.png'])
                end
            end
            
            chancnt = 0;
            disp('initialising Hipp')
            HippS = cell2mat(chanlistH(1,:)');
            HippS(HippS==0) = NaN;
            Hippstim = min(HippS,[],2)';
            for chanidx = sort(Hippstim(~(Hippstim == 0)))
                chancnt = chancnt+1;
                
                cfg = [];
                cfg.channel = chanidx;
                %             if subjidx == 5
                %                 cfg.channel = cfg.channel(1,1);
                %             end
                cfg.trials = TrialSelCondiEEG{1,lpc}{subjidx,8}';
                DataSelHipp  = ft_selectdata(cfg,Macrodat);
                
                cfg                         = [];
                cfg.method                  = 'channel';
                DataSelHippRej{chancnt,1}   = ft_rejectvisual(cfg, DataSelHipp);
                
                A = unique(DataSelHippRej{chancnt,1}.trialinfo);
                A(end+1) = 2; % Add a new isolating point end
                B = find(diff(A)~=1); % Find indexes of isolating points
                n = size(B,1);
                Start_Idx = 1 ; % Set start index
                Trlclust = cell(n,1);
                for i = 1:n
                    End_Idx = B(i); % Set end index
                    Trlclust{i,1} = A(Start_Idx:End_Idx) % Find consecuative sequences
                    Start_Idx = End_Idx + 1;
                    % update start index for the next consecuitive sequence
                end
                
                for tc = 1:size(Trlclust,1)
                    cfg = [];
                    cfg.trials = ismember(DataSelHippRej{chancnt,1}.trialinfo, Trlclust{tc});
                    DataSelHFF{lpc,subjidx}{chancnt}{tc}  = ft_selectdata(cfg,DataSelHippRej{chancnt,1});
                    
                    figure
                    plot(DataSelHFF{lpc,subjidx}{chancnt}{tc}.time{1,1}, mean(cell2mat(DataSelHFF{lpc,subjidx}{chancnt}{tc}.trial')))
                    axis('tight')
                    title('Distal Hipp') % Record in Hippocampus, stimulat in Ctx
                    saveas(gcf, [Basepath, 'Mircea\3 - SPES\Datasaves\FIGS\IndvERP\DistHippLp',num2str(lpc),'s',num2str(subjidx),'chan',num2str(chancnt),'tc',num2str(tc),'.png'])
                    
                end
            end
            close all
        end
        disp(['sub - ', num2str(subjidx)])
        
    end
    
    %%
    
    for subjidx =[1 2 3 4 5 7 8 9 10 11 12 ]
        condidx = 8;
        condidxhipp = 4;
        
        clear chanlistH
        clear chanlistC
        ID = AllMacro.SubjID{1,subjidx};
        LocalMac{1,subjidx} = eval(sprintf('ICConditions{1,2}.%s.Conditions{1,condidx}', ID));
        LocalMac{2,subjidx} = eval(sprintf('ICConditions{1,2}.%s.Conditions{1,condidxhipp}', ID));
        
        chanlistClabel = eval(sprintf('ICConditions{1,2}.%s.AllChan(2,:)',ID))';
        CtxIdx = contains(chanlistClabel,'Ctx');
        HippIdx = contains(chanlistClabel,'Hipp');
        chanlistCL = eval(sprintf('ICConditions{1,2}.%s.AllChan(1,CtxIdx)',ID));
        chanlistHL = eval(sprintf('ICConditions{1,2}.%s.AllChan(1,HippIdx)',ID));
        
        [DataSelL{1,subjidx}] = IEEGdynSel(subjidx,LocalMac{1,subjidx},chanlistCL,1);
        [DataSelL{2,subjidx}] = IEEGdynSel(subjidx,LocalMac{2,subjidx},chanlistHL,2);
        
        %     DataLocal{1,subjidx}   = DataSelCL{1,subjidx};
        %     DataLocal{2,subjidx}   = DataSelHL{1,subjidx};
        %
        
        HClabel = {'Cortex','Hippocampus'};
        for HC = 1:2
            for chan = 1:size(DataSelL{HC,subjidx},2)
                cfg                         = [];
                cfg.method                  = 'channel';
                DataLocal{HC,subjidx,chan}   = ft_rejectvisual(cfg, DataSelL{HC,subjidx}{chan});
                
                if ~isempty(DataLocal{HC,subjidx,chan})
                    A = unique( DataLocal{HC,subjidx,chan}.trialinfo);
                    A(end+1) = 2; % Add a new isolating point end
                    B = find(diff(A)~=1); % Find indexes of isolating points
                    n = size(B,1);
                    Start_Idx = 1 ; % Set start index
                    Trlclust = cell(n,1);
                    for i = 1:n
                        End_Idx = B(i); % Set end index
                        Trlclust{i,1} = A(Start_Idx:End_Idx) % Find consecuative sequences
                        Start_Idx = End_Idx + 1;
                        % update start index for the next consecuitive sequence
                    end
                    
                    for tc = 1:size(Trlclust,1)
                        cfg = [];
                        cfg.trials = ismember( DataLocal{HC,subjidx,chan}.trialinfo, Trlclust{tc});
                        DataBundleCL{HC,subjidx,chan}{tc}  = ft_selectdata(cfg, DataLocal{HC,subjidx,chan});
                        
                        figure
                        plot(DataBundleCL{HC,subjidx,chan}{tc}.time{1,1}, mean(cell2mat(DataBundleCL{HC,subjidx,chan}{tc}.trial')))
                        axis('tight')
                        title(['Local',HClabel(HC)])
                        saveas(gcf, [Basepath, 'Mircea\3 - SPES\Datasaves\FIGS\IndvERP\Local',num2str(HC),'_s',num2str(subjidx),'chan',num2str(chan),'tc',num2str(tc),'.png'])
                    end
                end
            end
        end
    end
else
    load([Basepath,'\Mircea\3 - SPES\Datasaves\Macro\DataCtxRej.mat'])
    load([Basepath,'\Mircea\3 - SPES\Datasaves\Macro\DataHippRej.mat'])
    load([Basepath,'\Mircea\3 - SPES\Datasaves\Macro\DataLocalRej.mat'])
end
%% plot Micro ERP
%%
%% %%%%%%%%% % CUMSUM
% Function computing the Cumulative Sum alongside ERPs for every
% Subject/Bundle. Requires Data in the Shape of Datab{1,:} for all the
% first condition and Datab{2,;} for the second condition. condName is a
% string containing the figure Title
%% ERP 
for bundle = 1:size(Datab,2)
    for ld = 1:2
        if ~isempty(Datab{ld,bundle})
            cfg = [];
            cfg.avgoverchan = 'yes';          
            dumERP = ft_timelockanalysis(cfg, Datab{ld,bundle});
          
            cfg = [];
            cfg.baseline = [-2 -1];
            ERPGAbs{ld,bundle} = ft_timelockbaseline(cfg, dumERP);
           
            %% Compute CumSum
            cfg = [];
            cfg.latency = postLat;
            postlatGA{ld} = ft_selectdata(cfg, ERPGAbs{ld,bundle});
           
            AbsERP{ld}  = abs(postlatGA{ld}.avg);
            ERPcSum{ld} = cumsum(AbsERP{ld},2);
            normERPGA{ld}(:,bundle) = ERPcSum{ld} ./ ERPcSum{ld}(:,end);
        end
    end
end

sel = ~cellfun('isempty',ERPGAbs);
%sel(1,11) = logical(0);
cfg = [];
ERPlGGA = ft_timelockgrandaverage(cfg, ERPGAbs{1,sel(1,:)});
ERPdGGA = ft_timelockgrandaverage(cfg, ERPGAbs{2,sel(2,:)});

%%
lmicrofig = figure;
hold on
shadedErrorBar(ERPlGGA.time,ERPlGGA.avg, sqrt(ERPlGGA.var)/ERPlGGA.dof(1),'lineProps', 'b')
axis('tight');
lim = axis;
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
title('Micro Local')
%ylim([-200 400])
hold off

dmicrofig = figure
hold on
shadedErrorBar(ERPdGGA.time,ERPdGGA.avg, sqrt(ERPdGGA.var)/ERPdGGA.dof(1),'lineProps', 'r')
axis('tight');
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
title('Micro Distal')
hold off
%% plot Macro ERP Local
%%
dumdata = [];
ERPSectLocal = [];

indexLocal = ~cellfun('isempty',DataBundleCL);
dumdata{1,1} = DataBundleCL(1,indexLocal(1,:));
dumdata{1,2} = DataBundleCL(2,indexLocal(2,:));
ERPGALocal = cell(size(dumdata,2),size(dumdata{1,1},2));

for hc = 1:size(dumdata,2)
    for bundle = 1:size(dumdata{1,hc},2)
        for chan = 1:size(dumdata{1,hc}{1,bundle},2)
            if ~isempty(dumdata{1,hc}{1,bundle}{chan})
                ERPSectLocal{1,hc}{1,bundle}{chan} = ft_timelockanalysis([], dumdata{1,hc}{1,bundle}{chan});
%                 figure
%                 plot(ERPSectLocal{1,hc}{1,bundle}{chan}.avg)
%                 title(num2str([hc,bundle,chan]))
            end
        end
        
        if ~isempty(ERPSectLocal{1,hc}{1,bundle}{chan}.label)
            ERPGALocal{hc,bundle} = ft_timelockgrandaverage([], ERPSectLocal{1,hc}{1,bundle}{~cellfun('isempty', ERPSectLocal{1,hc}{1,bundle})});
        else
            continue
        end
    end
end

ERPidx = ~cellfun('isempty', ERPGALocal);

cfg = [];
ERPcLGA = ft_timelockgrandaverage(cfg, ERPGALocal{1,ERPidx(1,:)});
ERPhLGA = ft_timelockgrandaverage(cfg, ERPGALocal{2,ERPidx(2,:)});

lax1 = figure;
hold on
shadedErrorBar(ERPcLGA.time,ERPcLGA.avg, sqrt(ERPcLGA.var)/ERPcLGA.dof(1),'lineProps', 'b')
axis('tight');
lim = axis;
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
title('Macro Local Ctx')
hold off


lax2 = figure;
hold on
shadedErrorBar(ERPhLGA.time,ERPhLGA.avg, sqrt(ERPhLGA.var)/ERPhLGA.dof(1),'lineProps', 'b')
axis('tight');
lim = axis;
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
title('Macro Local Hipp')
hold off
%linkaxes([lax1,lax2])
disp('end')


%% plot Macro ERP Distal
dumdata = [];
ERPGA = [];
index = ~cellfun('isempty',DataSelHFF);
for lpc = 1:size(DataSelCFF,1)
    dumdata{1,1} = DataSelCFF(lpc,index(lpc,:));
    dumdata{1,2} = DataSelHFF(lpc,index(lpc,:));
    for hc = 1:size(dumdata,2)
        
        for bundle = 1:size(dumdata{1,hc},2)
            for chan = 1:size(dumdata{1,hc}{1,bundle},2)
                if ~isempty(dumdata{1,hc}{1,bundle}{chan})
                    for tc = 1:size(dumdata{1,hc}{1,bundle}{chan},2)                       
                        cfg = [];
                        cfg.avgoverchan = 'yes';
                        ERPSect{1,hc}{lpc,bundle}{chan}{tc} = ft_timelockanalysis(cfg, dumdata{1,hc}{1,bundle}{chan}{tc});
                        ERPSect{1,hc}{lpc,bundle}{chan}{tc}.label = {'A'};
                    end
                    
                    cfg = [];
                    cfg.avgoverchan = 'yes';
                    ERPChanAvg{1,hc}{lpc,bundle}{chan} = ft_timelockgrandaverage(cfg,ERPSect{1,hc}{lpc,bundle}{chan}{~cellfun('isempty',ERPSect{1,hc}{lpc,bundle}{chan})});
                end
            end
            cfg = [];
            ERPGA{lpc}{hc,bundle} = ft_timelockgrandaverage(cfg,ERPChanAvg{1,hc}{lpc,bundle}{~cellfun('isempty',ERPChanAvg{1,hc}{lpc,bundle})});
        end
    end
   
    %%
    cfg = [];
    ERPcGGA = ft_timelockgrandaverage(cfg, ERPGA{lpc}{1,:});
    ERPhGGA = ft_timelockgrandaverage(cfg, ERPGA{lpc}{2,:});
    
    
    figure
    %tiledlayout(1,2)
    ax3 = nexttile;
    hold on
    shadedErrorBar(ERPcGGA.time,ERPcGGA.avg, sqrt(ERPcGGA.var)/ERPcGGA.dof(1),'lineProps', 'r')
    axis('tight');
    lim = axis;
    rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
    axis(lim);
    xlim([-0.1 1.2]);
    xlabel(['time in s']);
    ylabel(['Amplitude in ',char(181),'V'])
    title('Distal Ctx')
    hold off
    
    figure
    ax4 = nexttile;
    hold on
    shadedErrorBar(ERPhGGA.time,ERPhGGA.avg, sqrt(ERPhGGA.var)/ERPhGGA.dof(1),'lineProps', 'r')
    axis('tight');
    lim = axis;
    rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
    axis(lim);
    xlim([-0.1 1.2]);
    xlabel(['time in s']);
    ylabel(['Amplitude in ',char(181),'V'])
    title('Distal Hipp')
    hold off
    linkaxes([ax3,ax4])
    disp('end')
    
end

%% MacroCumsum
SigRespMat
dumdata = [];
locnormcumsum = [];
% Local 
for LclIdx = 1:size(manselLocal,1)
    
    hc      = manselLocal(LclIdx,1);
    s       = manselLocal(LclIdx,2);
    chan    = manselLocal(LclIdx,3);
    tc      = manselLocal(LclIdx,4);
    
    
    dumdata =  DataBundleCL(hc,:,:);
   
    cfg = [];
    cfg.latency = postLat;
    dumERP =  ft_timelockanalysis(cfg, dumdata{s,chan}{tc});
    
    csERP   = cumsum(abs(dumERP.avg),2);
    
    locnormcumsum{hc,s}{chan}(:,tc) =   (csERP ./ csERP(:,end))';
end

NCSBL = cell(1,2);
for hc = 1:2
    for bundle = 1:size(locnormcumsum,2)
        if ~isempty(locnormcumsum{hc,bundle})
            for chan = find(~cellfun(@isempty,locnormcumsum{hc,bundle}))
                locnormcumsum{hc,bundle}(:,any(locnormcumsum{hc,bundle}{chan} == 0))=[];
                NCSCL{hc,bundle}{chan} = mean(locnormcumsum{hc,bundle}{chan},2);
            end
            
            if ~isempty( NCSCL{hc,bundle})
                NCSBL{hc} = [NCSBL{hc}, cell2mat(NCSCL{hc,bundle})];
            end
        end
    end
    NCumSumL{hc} = mean(NCSBL{hc},2);
end

%% Macro Distal Cumsum 

for hc = 1:size(manselDist,2) % Distal
    for DistCtxidx = 1:size(manselDist{hc},1)
        
        lpc = manselDist{hc}(DistCtxidx,1);
        bundle = manselDist{hc}(DistCtxidx,2);
        chan = manselDist{hc}(DistCtxidx,3);
        tc = manselDist{hc}(DistCtxidx,4);
        
        if hc == 1
            dumdata{1,hc} = DataSelCFF(lpc,:);
        elseif hc == 2
            dumdata{1,hc} = DataSelHFF(lpc,:);
        end
        
        cfg = [];
        cfg.latency = postLat;
        dumERP =  ft_timelockanalysis(cfg, dumdata{1,hc}{1,bundle}{chan}{tc});
        dumERP.label = {'A'};
        
        csERP   = cumsum(abs(dumERP.avg),2);
        
        normcumsum{lpc,hc}{1,bundle}{chan}(:,tc) =   (csERP ./ csERP(:,end))';
    end
end 

NCSB = cell(2,2);
for lpc = 1:2
    for hc = 1:2
        for bundle = 1:size(normcumsum{lpc,hc},2)
            if ~isempty(normcumsum{lpc,hc}{1,bundle})
                for chan = find(~cellfun(@isempty,normcumsum{lpc,hc}{1,bundle}))
                    normcumsum{lpc,hc}{1,bundle}{chan}(:,any(normcumsum{lpc,hc}{1,bundle}{chan} == 0))=[];
                    NCSC{lpc,hc}{1,bundle}{chan} = mean(normcumsum{lpc,hc}{1,bundle}{chan},2);
                end
                
                if ~isempty( NCSC{lpc,hc}{1,bundle})
                      NCSB{lpc,hc} = [NCSB{lpc,hc}, cell2mat(NCSC{lpc,hc}{1,bundle})];
                end
            end
        end
        NCumSum{lpc,hc} = mean(NCSB{lpc,hc},2);
    end
end
%% DistalMacro ERP

for lpc = 1:2
    for bundle = 1:size( ERPSect{1,hc},2)
        dataCb{1} = ERPSect{1,hc}{lpc,bundle}{chan}{~cellfun('isempty',ERPSect{1,hc}{lpc,bundle}{chan})};
        for hc = 1:size(dataCb,2)
            cfg = [];
            cfg.avgoverchan = 'yes';           
            dumERP = ft_timelockanalysis(cfg, dataCb{hc});
            
            cfg = [];
            cfg.baseline = [-2 -1];
            ERPcGA{lpc,hc}{1,bundle} = ft_timelockbaseline(cfg, dumERP);
            
            %% Compute CumSum
            cfg = [];
            cfg.latency = postLat;
            dumERP = ft_selectdata(cfg, ERPcGA{lpc,hc}{1,bundle});
             
            csERP   = cumsum(abs(dumERP.avg),2);
            
            normERPGAc{lpc,hc}(:,bundle) =   (csERP ./ csERP(:,end))';
        end
    end
end
mactime = dumERP.time;

%% Micro - Macro 
ctxdum = NCSB{2,1}; % lp distal ctx
resdum = resample([ctxdum;flip(ctxdum)],AllMicro.Session{1,1}.hdr.Fs*2,round(AllMacro.Session{1,1}.hdr.Fs*2));
normERPGA{2,1} =  resdum(1:(end/2),:);

ctxdum = NCSB{2,2}; % lp distal hipp
resdum = resample([ctxdum;flip(ctxdum)],AllMicro.Session{1,1}.hdr.Fs*2,round(AllMacro.Session{1,1}.hdr.Fs*2));
normERPGA{2,2} =  resdum(1:(end/2),:);

% 
% ctxdum = NCSBL{1}; % macro local ctx
% resdum = resample([ctxdum;flip(ctxdum)],AllMicro.Session{1,1}.hdr.Fs*2,round(AllMacro.Session{1,1}.hdr.Fs*2));
% normERPGA{3,1} =  resdum(1:(end/2),:);
% 
% ctxdum = NCSBL{2}; % maro local hipp
% resdum = resample([ctxdum;flip(ctxdum)],AllMicro.Session{1,1}.hdr.Fs*2,round(AllMacro.Session{1,1}.hdr.Fs*2));
% normERPGA{3,2} =  resdum(1:(end/2),:);
% 

AreaNormERPGA = cell(1,2);
for y = 1:2
    cumdum = normERPGA{y,y};
    for bndl = 1:size(cumdum,2)  
        normDum = cumdum(:,bndl)-linspace(0,1,size(cumdum,1))';
        AreaNormERPGA{1,y}(:,bndl) = normDum./trapz(normDum',1:size(cumdum,1));
    end 
end

% for y = 1:2
%     cumdum = normERPGA{3,y};
%     for bndl = 1:size(cumdum,2)  
%         normDum = cumdum(:,bndl)-linspace(0,1,size(cumdum,1))';
%         AreaNormERPGA{2,y}(:,bndl) = normDum./trapz(normDum',1:size(cumdum,1));
%     end 
% end


% cumdum = normERPGA{2,1};
% for bndl = 1:size(cumdum,2)
%     normDum = cumdum(:,bndl)-linspace(0,1,size(cumdum,1))';
%     AreaNormERPGA{3,1}(:,bndl) = normDum./trapz(normDum',1:size(cumdum,1));
% end

areaNormERPGA{1,1} = AreaNormERPGA{1,1}(:,1:18);
[Stat.clusters, Stat.p_values, Stat.t_sums, Stat.permutation_distribution ] = permutest( AreaNormERPGA{1,1}, AreaNormERPGA{1,2},false,0.05,10000,false);

mArea{1,1} = -mean(areaNormERPGA{1,1},2);
mArea{1,2} = -mean(AreaNormERPGA{1,2},2);

xPt(1) = dsearchn(cumtrapz(mArea{1,1}),0.025);
xPt(2) = dsearchn(cumtrapz(mArea{1,2}),0.025);

%% Micro ERP
figure
hold on
shadedErrorBar(ERPlGGA.time,ERPlGGA.avg, sqrt(ERPlGGA.var)/ERPlGGA.dof(1),'lineProps', 'b')
axis('tight');
lim = axis;
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
%ylim([-200 400])
hold off

figure
hold on
shadedErrorBar(ERPdGGA.time,ERPdGGA.avg, sqrt(ERPdGGA.var)/ERPdGGA.dof(1),'lineProps', 'r')
axis('tight');
lim = axis;
rectangle('Position', [-0.022,-1000, 0.045, 2000], 'FaceColor', 'w','EdgeColor','w')
axis(lim);
xlim([-0.1 1.2]);
xlabel(['time in s']);
ylabel(['Amplitude in ',char(181),'V'])
hold off
%% Macro-MicroCumsum
% Comupute COMSUM grand Average

figure
hold on
%shadedErrorBar(postlatGA{1}.time,-mean(AreaNormERPGA{2,1},2)', std(AreaNormERPGA{2,1}')/sqrt(size(AreaNormERPGA{2,1},2)),'lineProps', 'b')
%shadedErrorBar(postlatGA{1}.time,-mean(AreaNormERPGA{2,2},2)', std(AreaNormERPGA{2,2}')/sqrt(size(AreaNormERPGA{2,2},2)),'lineProps', 'r')
%shadedErrorBar(postlatGA{1}.time,-mean(AreaNormERPGA{3,1},2)', std(AreaNormERPGA{3,1}')/sqrt(size(AreaNormERPGA{3,1},2)),'lineProps', 'r')


shadedErrorBar(postlatGA{1}.time,-mean(AreaNormERPGA{1,1}(:,1:18),2)', std(AreaNormERPGA{1,1}(:,1:18)')/sqrt(size(AreaNormERPGA{1,1}(:,1:18),2)),'lineProps', 'b')
shadedErrorBar(postlatGA{1}.time,-mean(AreaNormERPGA{1,2}        ,2)', std(AreaNormERPGA{1,2}')/sqrt(size(AreaNormERPGA{1,2},2)),'lineProps', 'r')

plot(postlatGA{1}.time(xPt(1)),mArea{1,1}(xPt(1)),'k*')
%  find(round(mArea{1,2},5)==round(mArea{1,1}(xPt(1)),5))
plot(postlatGA{1}.time(148),mArea{1,2}(148),'k*')
line([postlatGA{1}.time(xPt(1)), postlatGA{1}.time(148)],[mArea{1,1}(xPt(1)) mArea{1,1}(xPt(1))], 'Color', 'k')

xlabel(['time in s']);
xlim(postLat);
ylim([0 inf])
ylabel(['Cumulative Sum'])
%title([condName])
% sigclust = Stat2.p_values<0.05;
% if ~isempty(find(sigclust, 1))
%     for clustid = 1:length(find(sigclust))
%         plot([postlatGA{1}.time(Stat2.clusters{1,clustid}(1,1)),postlatGA{1}.time(Stat2.clusters{1,clustid}(1,end))],[0,0],'r','LineWidth',3)
%     end
% end
hold off
%% Micro Freq
for prepost = 1:2
    if prepost == 1
       fdata = Datafpre;
    elseif prepost == 2
       fdata = Datafpost;
    end 
    
    for b = 1:size(fdata,2)
        %figure
        %tiledlayout(4,5)
        for ld = 1:size(fdata,1)
            
            cfg               = [];
            cfg.foilim        = [1 150];
            cfg.tapsmofrq     = 2;
            cfg.method        = 'mtmfft';
            cfg.output        = 'fooof_aperiodic';
            FreqdataMicro{prepost,ld,b,1} = ft_freqanalysis(cfg, fdata{ld,b}); % Aperiodic
            cfg.output        = 'pow';
            FreqdataMicro{prepost,ld,b,2} = ft_freqanalysis(cfg, fdata{ld,b}); % original
            
            % subtract the fractal component from the power spectrum
            cfg               = [];
            cfg.parameter     = 'powspctrm';
            cfg.operation     = 'x2-x1';
            FreqdataMicro{prepost,ld,b,3} = ft_math(cfg, FreqdataMicro{prepost,ld,b,1}, FreqdataMicro{prepost,ld,b,2}); % Oscillatory
            
            for fqs = 1:size(FreqdataMicro,4) % mean over channels              
                FreqdataMicro{prepost,ld,b,fqs}.powspctrm   = mean(FreqdataMicro{prepost,ld,b,fqs}.powspctrm,1);
                FreqdataMicro{prepost,ld,b,fqs}.label       = 'A';
            end        
        end
    end
end


%% Macro Freq

index = ~cellfun('isempty',DataSelCFF);
DataFreqMac{1,:} = DataSelCFF(1,index(1,:));
DataFreqMac{2,:} = DataSelCFF(2,index(2,:));
for ref = 1:size(DataFreqMac,1)
    for b = 1:size(DataFreqMac{ref},2)
        for c = 1:size(DataFreqMac{ref}{b},2)
            for t = 1:size(DataFreqMac{ref}{b}{c},2)
                DataFreqMac{ref}{b}{c}{t}.label = {'A'};
                
                cfg = [];
                cfg.avgoverchan = 'no';
                cfg.latency  = postLat;
                DataFreqMacro{ref,b}{1,c}{t}= ft_selectdata(cfg, DataFreqMac{ref}{b}{c}{t});
                cfg.latency   = preLat;
                DataFreqMacro{ref,b}{2,c}{t} = ft_selectdata(cfg,DataFreqMac{ref}{b}{c}{t});
                
                for prepost = 1:2
                    cfg               = [];
                    cfg.foilim        = [1 150];
                    cfg.tapsmofrq     = 2;
                    cfg.method        = 'mtmfft';
                    cfg.output        = 'fooof_aperiodic';
                    FreqdataMacro{prepost,ref,b,c,t,1} = ft_freqanalysis(cfg, DataFreqMacro{ref,b}{prepost,c}{t}); % Aperiodic
                    cfg.output        = 'pow';
                    FreqdataMacro{prepost,ref,b,c,t,2} = ft_freqanalysis(cfg, DataFreqMacro{ref,b}{prepost,c}{t}); % original
                    
                    % subtract the fractal component from the power spectrum
                    cfg               = [];
                    cfg.parameter     = 'powspctrm';
                    cfg.operation     = 'x2-x1';
                    FreqdataMacro{prepost,ref,b,c,t,3} = ft_math(cfg,  FreqdataMacro{prepost,ref,b,c,t,1},  FreqdataMacro{prepost,ref,b,c,t,2}); % Oscillatory
                end
            end
        end 
    end
end
%%
for prepost = 1:size(FreqdataMacro,1)
    for ref = 1:size(FreqdataMacro,2)
        for b = 1:size(FreqdataMacro,3)
            for c = 1:size(DataFreqMac{ref}{b},2)
                for t = 1:size(DataFreqMac{ref}{b}{c},2)
                    if 1 < size(DataFreqMac{ref}{b}{c},2)
                        for f = 1:3
                            dum = {FreqdataMacro{prepost,ref,b,c,:,f}};
                            figdumchan{prepost,ref,b,c,f}   = ft_freqgrandaverage([], dum{~cellfun(@isempty,dum)});
                        end
                    else
                        for f = 1:3
                            figdumchan{prepost,ref,b,c,f} = FreqdataMacro{prepost,ref,b,c,t,f};
                        end
                    end
                end
                if 1 < size(DataFreqMac{ref}{b},2)
                    for f = 1:3
                        dum = {figdumchan{prepost,ref,b,:,f}};
                        FreqdataMacroA{prepost,ref,b,f}   = ft_freqgrandaverage([], dum{~cellfun(@isempty,dum)});
                    end
                else
                    for f = 1:3
                        FreqdataMacroA{prepost,ref,b,f} = figdumchan{prepost,ref,b,c,f};
                    end
                end
            end
        end 
    end
end 
%%
tiledlayout(3,1)
for f = [2,1,3]
    for ld = 1:2
        for prepost = 1:2
            if ld  == 1 
                data = {FreqdataMicro{prepost ,ld,:,f}};
            elseif ld ==2
                data = {FreqdataMacroA{prepost,ref,:,f}};
                data = {data{~cellfun(@isempty,data)}};
            end 
            cfg = [];
            cfg.keepindividual = 'yes';
            figdum{prepost ,ld,f}       = ft_freqgrandaverage([],   data{:});
            figdum{prepost ,ld,f}       = ft_freqgrandaverage([],   data{:});
            figdumvar{prepost ,ld,f}    = ft_freqgrandaverage(cfg,  data{:});
            figdumvar{prepost ,ld,f}    = ft_freqgrandaverage(cfg,  data{:});
        end
        cfg               = [];
        cfg.parameter     = 'powspctrm';
        cfg.operation     = 'x2-x1';
        Freqdiff{ld,f}  = ft_math(cfg, figdum{1 ,ld,f}, figdum{2 ,ld,f}); % post - pre
        Freqdiffvar{ld,f} = ft_math(cfg, figdumvar{1 ,ld,f}, figdumvar{2 ,ld,f}); % post - pre
    end

    nexttile
    hold on
    Lcl = shadedErrorBar(log(Freqdiff{1,f}.freq),log(Freqdiff{1,f}.powspctrm),log(std(squeeze(Freqdiffvar{1,f}.powspctrm)))/sqrt(size(squeeze(Freqdiffvar{1,f}.powspctrm),1)),'lineProps', 'b');
    Dstl = shadedErrorBar(log(Freqdiff{2,f}.freq),log(Freqdiff{2,f}.powspctrm),log(std(squeeze(Freqdiffvar{2,f}.powspctrm)))/sqrt(size(squeeze(Freqdiffvar{2,f}.powspctrm),1)),'lineProps', 'r');
    legend([Lcl.mainLine, Dstl.mainLine],'LocalDiff', 'Distaldiff')
    hold off   
end

%% Pies
pierats = [20 34; 4,32;11 24; 2 20; 28,66;14,57; 17, 24;12, 27];

for x = 1:size(pierats,1)
    hp = figure
    hp.Renderer = 'painters';
    pie([pierats(x,1),pierats(x,2)-pierats(x,1)],[ 1 0 ],{[num2str(pierats(x,1)) ' Channels - ' num2str(round(pierats(x,1)/pierats(x,2)*100,2)) '%'],[num2str(pierats(x,2)-pierats(x,1)) ' Channels - ' num2str(round((((pierats(x,2)-pierats(x,1))/pierats(x,2))) *100,2)) '%']})
    colormap([0 0 1;0 0 0])
    legend('Response','No Response')
end
%end 
