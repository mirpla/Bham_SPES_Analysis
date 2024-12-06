
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
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [11:22];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [23:30];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [31:38];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [39:46];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [47:54];
    ChanDum{1,6} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [55:62];
    ChanDum{1,7} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [63:70];
    ChanDum{1,8} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [71:78];
    ChanDum{1,9} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [79:86];
    ChanDum{1,10}= ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [87:98];
    ChanDum{1,11} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [99:106];
    ChanDum{1,12} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [107:114];
    ChanDum{1,13} = ft_selectdata(cfg, ICtrialsCh);
    
   
elseif strcmpi(subjID, 'P082')
    cfg = [];
    cfg.channel = [1:8];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [25:32];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [33:40];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [41:48];
    ChanDum{1,6} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [55:64];
    ChanDum{1,7} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [65:76];
    ChanDum{1,8} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:86];
    ChanDum{1,9} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [87:98];
    ChanDum{1,10} = ft_selectdata(cfg, ICtrialsCh);
        
elseif strcmpi(subjID, 'P08')
    cfg = [];
    cfg.channel = [1:8];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [25:32];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [33:40];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [41:48];
    ChanDum{1,6} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [55:64];
    ChanDum{1,7} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [65:76];
    ChanDum{1,8} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:86];
    ChanDum{1,9} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [87:98];
    ChanDum{1,10} = ft_selectdata(cfg, ICtrialsCh);
    
elseif strcmpi(subjID, 'P09')
    cfg = [];
    cfg.channel = [1:8];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [25:32];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [33:40];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [41:52];
    ChanDum{1,6} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [53:60];
    ChanDum{1,7} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [61:68];
    ChanDum{1,8} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [69:76];
    ChanDum{1,9} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:84];
    ChanDum{1,10} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [85:92];
    ChanDum{1,11} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [93:102];
    ChanDum{1,12} = ft_selectdata(cfg, ICtrialsCh);
    
elseif strcmpi(subjID, 'P10')
    cfg = [];
    cfg.channel = [2:9];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [10:17];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [18:25];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [26:33];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [34:41];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [42:49];
    ChanDum{1,6} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [50:57];
    ChanDum{1,7} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
    ChanDum{1,8} = ft_selectdata(cfg, ICtrialsCh);
    
elseif strcmpi(subjID, 'P102')
    cfg = [];
    cfg.channel = [2:9];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [10:17];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [18:25];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [26:33];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [34:41];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [42:49];
    ChanDum{1,6} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [50:57];
    ChanDum{1,7} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
    ChanDum{1,8} = ft_selectdata(cfg, ICtrialsCh);
    
elseif strcmpi(subjID, 'P11')
    cfg = [];
    cfg.channel = [30:37];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [38:45];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [46:53];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [88:95];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [96:103];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
%   RPHG = ft_selectdata(cfg, ICtrialsCh);

elseif strcmpi(subjID, 'P112')
    cfg = [];
    cfg.channel = [30:37];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [38:45];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [46:53];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [88:95];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [96:103];
    ChanDum{1,5} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [58:65];
%   RPHG = ft_selectdata(cfg, ICtrialsCh);
elseif strcmpi(subjID, 'P12')
    cfg = [];
    cfg.channel = [1:8];
%    LEN = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:23];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [24:31];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:83];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);   

elseif strcmpi(subjID, 'P06')  || strcmpi(subjID, 'P062')
    cfg = [];
    cfg.channel = [1:8];
    ChanDum{1,1} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [9:16];
    ChanDum{1,2} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [17:24];
    ChanDum{1,3} = ft_selectdata(cfg, ICtrialsCh);
    
    cfg = [];
    cfg.channel = [77:84];
    ChanDum{1,4} = ft_selectdata(cfg, ICtrialsCh);   
end

%% Subtract Reference
ChanDum2 = ChanDum;
for ridx = 1:length(ChanDum)
    % bipolar reference of first and last channel
    chanidx = 1;
    for t = 1 : numel(ChanDum{1,ridx}.trial)
        ChanDum2{1,ridx}.trial{t}(chanidx,:) = ChanDum{1,ridx}.trial{t}(chanidx,:) - ChanDum{1,ridx}.trial{t}(chanidx+1,:);
    end
    chanidx = length(ChanDum{1,ridx}.label);
    for t = 1 : numel(ChanDum{1,ridx}.trial)
        ChanDum2{1,ridx}.trial{t}(chanidx,:) = ChanDum{1,ridx}.trial{t}(chanidx,:) - ChanDum{1,ridx}.trial{t}(chanidx-1,:);
    end
    
    % Laplacian reference of other Channels
    for chanidx = 2:length(ChanDum{1,ridx}.label)-1
        for t = 1 : numel(ChanDum{1,ridx}.trial)
            ChanDum2{1,ridx}.trial{t}(chanidx,:) = ChanDum{1,ridx}.trial{t}(chanidx,:) - (ChanDum{1,ridx}.trial{t}(chanidx-1,:)+ ChanDum{1,ridx}.trial{t}(chanidx+1,:)/2);
        end
    end
end


%%
cfg = [];
ICReref = ft_appenddata(cfg, ChanDum2{1,:});
    


