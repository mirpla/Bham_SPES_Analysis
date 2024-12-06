
cfg = [];
if strcmpi(subjID, 'P07') || strcmpi(subjID, 'P072')
    cfg.channel = [1:62,65:116];
elseif strcmpi(subjID, 'P08') || strcmpi(subjID, 'P082')
    cfg.channel = [2:77, 86:107];
elseif strcmpi(subjID, 'P09')
    cfg.channel = [2:53, 66:115];
else
    %disp('No valid Subject Number')
end
ICtrialsCh = ft_selectdata(cfg, ICdataClean);

%%
if strcmpi(subjID, 'P07') || strcmpi(subjID, 'P072')
    
    cfg = [];
    cfg.channel = [1:10];
    ROF = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [11:22];
    RFl = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [23:30];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [31:38];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [39:46];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [47:54];
    RPas = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [55:62];
    RPps = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [63:70];
    ROai = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [71:78];
    ROpi = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [79:86];
    RC= ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [87:98];
    LFl = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [99:106];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [107:114];
    LPO = ft_selectdata(cfg, ICtrialsCh);
    
    %% Subtract Reference
    for chanidx = 1:length(ROF.label)
        for t = 1 : numel(ROF.trial)
            ROF.trial{t}(chanidx,:) = ROF.trial{t}(chanidx,:) - ROF.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RFl.label)
        for t = 1 : numel(RFl.trial)
            RFl.trial{t}(chanidx,:) = RFl.trial{t}(chanidx,:) - RFl.trial{t}(7,:);
        end
    end
    
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPas.label)
        for t = 1 : numel(RPas.trial)
            RPas.trial{t}(chanidx,:) = RPas.trial{t}(chanidx,:) - RPas.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RPps.label)
        for t = 1 : numel(RPps.trial)
            RPps.trial{t}(chanidx,:) = RPps.trial{t}(chanidx,:) - RPps.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(ROai.label)
        for t = 1 : numel(ROai.trial)
            ROai.trial{t}(chanidx,:) = ROai.trial{t}(chanidx,:) - ROai.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(ROpi.label)
        for t = 1 : numel(ROpi.trial)
            ROpi.trial{t}(chanidx,:) = ROpi.trial{t}(chanidx,:) - ROpi.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RC.label)
        for t = 1 : numel(RC.trial)
            RC.trial{t}(chanidx,:) = RC.trial{t}(chanidx,:) - RC.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LFl.label)
        for t = 1 : numel(LFl.trial)
            LFl.trial{t}(chanidx,:) = LFl.trial{t}(chanidx,:) - LFl.trial{t}(6,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LPO.label)
        for t = 1 : numel(LPO.trial)
            LPO.trial{t}(chanidx,:) = LPO.trial{t}(chanidx,:) - LPO.trial{t}(4,:);
        end
    end
    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, ROF,RFl, RAH, RMH, RPH, RPas, RPps, ROai, ROpi, RC, LFl, LMH, LPO);
    
%     
%     cfg             =	[];
%     cfg.viewmode	=	'vertical';
%     ft_databrowser(cfg,	ICReref);
%     
elseif strcmpi(subjID, 'P082')
    cfg = [];
    cfg.channel = [1:8];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [25:32];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [33:40];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [41:48];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [55:64];
    RPO = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [65:76];
    RFl = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:86];
    LPoT= ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [87:98];
    LFl = ft_selectdata(cfg, ICtrialsCh);
    
    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPO.label)
        for t = 1 : numel(RPO.trial)
            RPO.trial{t}(chanidx,:) = RPO.trial{t}(chanidx,:) - RPO.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RFl.label)
        for t = 1 : numel(RFl.trial)
            RFl.trial{t}(chanidx,:) = RFl.trial{t}(chanidx,:) - RFl.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LPoT.label)
        for t = 1 : numel(LPoT.trial)
            LPoT.trial{t}(chanidx,:) = LPoT.trial{t}(chanidx,:) - LPoT.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LFl.label)
        for t = 1 : numel(LFl.trial)
            LFl.trial{t}(chanidx,:) = LFl.trial{t}(chanidx,:) - LFl.trial{t}(4,:);
        end
    end
    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RMH, RPH, LAH, LMH, LPH); % RPoF,RPO, RFl, LPoT,LFl are very noisy so for now leave them out
        
elseif strcmpi(subjID, 'P08')
    cfg = [];
    cfg.channel = [1:8];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [25:32];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [33:40];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [41:48];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [55:64];
    RPO = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [65:76];
    RFl = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:86];
    LPoT= ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [87:98];
    LFl = ft_selectdata(cfg, ICtrialsCh);
    
    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPO.label)
        for t = 1 : numel(RPO.trial)
            RPO.trial{t}(chanidx,:) = RPO.trial{t}(chanidx,:) - RPO.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RFl.label)
        for t = 1 : numel(RFl.trial)
            RFl.trial{t}(chanidx,:) = RFl.trial{t}(chanidx,:) - RFl.trial{t}(6,:);
        end
    end
    
    for chanidx = 1:length(LPoT.label)
        for t = 1 : numel(LPoT.trial)
            LPoT.trial{t}(chanidx,:) = LPoT.trial{t}(chanidx,:) - LPoT.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LFl.label)
        for t = 1 : numel(LFl.trial)
            LFl.trial{t}(chanidx,:) = LFl.trial{t}(chanidx,:) - LFl.trial{t}(5,:);
        end
    end
    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RMH, RPH, LAH, LMH, LPH); % RPoF,RPO, RFl, LPoT,LFl are very noisy so for now leave them out
    
elseif strcmpi(subjID, 'P09')
    cfg = [];
    cfg.channel = [1:8];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [25:32];
    RAG = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [33:40];
    RPHG = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [41:52];
    RFl = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [53:60];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [61:68];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [69:76];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:84];
    LAG= ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [85:92];
    LPHG = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [93:102];
    LFl = ft_selectdata(cfg, ICtrialsCh);
    
    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RAG.label)
        for t = 1 : numel(RAG.trial)
            RAG.trial{t}(chanidx,:) = RAG.trial{t}(chanidx,:) - RAG.trial{t}(3,:);
        end
    end
    
    for chanidx = 1:length(RPHG.label)
        for t = 1 : numel(RPHG.trial)
            RPHG.trial{t}(chanidx,:) = RPHG.trial{t}(chanidx,:) - RPHG.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RFl.label)
        for t = 1 : numel(RFl.trial)
            RFl.trial{t}(chanidx,:) = RFl.trial{t}(chanidx,:) - RFl.trial{t}(7,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LAG.label)
        for t = 1 : numel(LAG.trial)
            LAG.trial{t}(chanidx,:) = LAG.trial{t}(chanidx,:) - LAG.trial{t}(1,:);
        end
    end
    
    for chanidx = 1:length(LPHG.label)
        for t = 1 : numel(LPHG.trial)
            LPHG.trial{t}(chanidx,:) = LPHG.trial{t}(chanidx,:) - LPHG.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LFl.label)
        for t = 1 : numel(LFl.trial)
            LFl.trial{t}(chanidx,:) = LFl.trial{t}(chanidx,:) - LFl.trial{t}(7,:);
        end
    end
    
    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RMH, RPH, RAG, RPHG, RFl, LAH, LMH, LPH, LAG, LPHG, LFl);
    
elseif strcmpi(subjID, 'P10')
    cfg = [];
    cfg.channel = [2:9];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [10:17];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [18:25];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [26:33];
    RPHG = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [34:41];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [42:49];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [50:57];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
    LPHG = ft_selectdata(cfg, ICtrialsCh);
    

    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    
    for chanidx = 1:length(RPHG.label)
        for t = 1 : numel(RPHG.trial)
            RPHG.trial{t}(chanidx,:) = RPHG.trial{t}(chanidx,:) - RPHG.trial{t}(4,:);
        end
    end  
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(4,:);
        end
    end
    
    
    for chanidx = 1:length(LPHG.label)
        for t = 1 : numel(LPHG.trial)
            LPHG.trial{t}(chanidx,:) = LPHG.trial{t}(chanidx,:) - LPHG.trial{t}(4,:);
        end
    end
    

    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RMH, RPH, RPHG, LAH, LMH, LPH, LPHG);
elseif strcmpi(subjID, 'P102')
    cfg = [];
    cfg.channel = [2:9];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [10:17];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [18:25];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [26:33];
    RPHG = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [34:41];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [42:49];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [50:57];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
    LPHG = ft_selectdata(cfg, ICtrialsCh);
    

    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    
    for chanidx = 1:length(RPHG.label)
        for t = 1 : numel(RPHG.trial)
            RPHG.trial{t}(chanidx,:) = RPHG.trial{t}(chanidx,:) - RPHG.trial{t}(4,:);
        end
    end  
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(4,:);
        end
    end
    
    
    for chanidx = 1:length(LPHG.label)
        for t = 1 : numel(LPHG.trial)
            LPHG.trial{t}(chanidx,:) = LPHG.trial{t}(chanidx,:) - LPHG.trial{t}(4,:);
        end
    end
    

    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RMH, RPH, RPHG, LAH, LMH, LPH, LPHG);
elseif strcmpi(subjID, 'P11')
    cfg = [];
    cfg.channel = [30:37];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [38:45];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [46:53];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    
    cfg = [];
    cfg.channel = [88:95];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [96:103];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
%   RPHG = ft_selectdata(cfg, ICtrialsCh);
    

    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(5,:);
        end
    end

    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RPH,LAH, LMH, LPH);
elseif strcmpi(subjID, 'P112')
    cfg = [];
    cfg.channel = [30:37];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [38:45];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [46:53];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    
    cfg = [];
    cfg.channel = [88:95];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [96:103];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
%   RPHG = ft_selectdata(cfg, ICtrialsCh);
    

    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(5,:);
        end
    end

    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RPH,LAH, LMH, LPH);
elseif strcmpi(subjID, 'P12')
    cfg = [];
    cfg.channel = [1:8];
    LEN = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    LAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:23];
    LMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [24:31];
    LPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:83];
    RMH = ft_selectdata(cfg, ICtrialsCh);   

    %% Subtract Reference
    for chanidx = 1:length(LEN .label)
        for t = 1 : numel(LEN .trial)
            LEN.trial{t}(chanidx,:) = LEN.trial{t}(chanidx,:) - LEN.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LMH.label)
        for t = 1 : numel(LMH.trial)
            LMH.trial{t}(chanidx,:) = LMH.trial{t}(chanidx,:) - LMH.trial{t}(5,:);
        end
    end
    
    for chanidx = 1:length(LPH.label)
        for t = 1 : numel(LPH.trial)
            LPH.trial{t}(chanidx,:) = LPH.trial{t}(chanidx,:) - LPH.trial{t}(5,:);
        end
    end

    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RMH,LAH, LMH, LPH, LEN);
elseif strcmpi(subjID, 'P06')  || strcmpi(subjID, 'P062')
    cfg = [];
    cfg.channel = [1:8];
    RAH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    RMH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    RPH = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:84];
    LAH = ft_selectdata(cfg, ICtrialsCh);

    %% Subtract Reference
    for chanidx = 1:length(RAH.label)
        for t = 1 : numel(RAH.trial)
            RAH.trial{t}(chanidx,:) = RAH.trial{t}(chanidx,:) - RAH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(RMH.label)
        for t = 1 : numel(RMH.trial)
            RMH.trial{t}(chanidx,:) = RMH.trial{t}(chanidx,:) - RMH.trial{t}(5,:);
        end
    end
           
    for chanidx = 1:length(RPH.label)
        for t = 1 : numel(RPH.trial)
            RPH.trial{t}(chanidx,:) = RPH.trial{t}(chanidx,:) - RPH.trial{t}(4,:);
        end
    end
    
    for chanidx = 1:length(LAH.label)
        for t = 1 : numel(LAH.trial)
            LAH.trial{t}(chanidx,:) = LAH.trial{t}(chanidx,:) - LAH.trial{t}(4,:);
        end
    end
    


    %%
    cfg = [];
    ICReref = ft_appenddata(cfg, RAH, RMH, RPH,LAH);

end



