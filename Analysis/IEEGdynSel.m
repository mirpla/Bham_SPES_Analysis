function [DataOut] = IEEGdynSel(subjidx, DataIn, Chanlist,CHflag)
% Dynamically Select the Local Channel dependent on the ongoing stimulation
% Channels
% % Uncomment to debug Noise
%     cfg = [];
%     cfg.viewmode = 'vertical';
%     cfg.allowoverlap = 'yes';
%     ft_databrowser(cfg,DataIn);
%      figure
%  plot(mean(cell2mat(DataOut.trial(1:end)')))
% Choose channels where stimulation did not occur
trlinfo = [];
channels = [];
if CHflag == 1
    switch subjidx
        case  1
            trlinfo{1,1} = [10, 11, 12];
            trlinfo{1,2} = [16, 17, 0];
            trlinfo{1,3} = [22, 23, 0];
        case 2
            trlinfo{1,1} = [];
            trlinfo{1,2} = [5, 6, 7];
            trlinfo{1,3} = [];
            
        case 3
            trlinfo{1,1} = [5, 6, 7];
            trlinfo{1,2} = [12, 13, 14];
            trlinfo{1,3} = [19, 20, 21];
        case 4
            %trlinfo{1,1} = [];
            trlinfo{1,2} = [12, 13, 14];
            trlinfo{1,3} = [19, 20, 21];
            
        case 5
            %trlinfo{1,1} = [5, 0, 6];
            trlinfo{1,2} = [13 14 0];
            trlinfo{1,3} = [26 27 0];
            
        case 6
            trlinfo{1,1} = [5,6, 0];
            trlinfo{1,2} = [11,12,0];
            trlinfo{1,3} = [17,18,0];
            
        case 7
            trlinfo{1,1} = [6, 0, 0];
            trlinfo{1,2} = [12,0,0];
            trlinfo{1,3} = [18, 0, 0];
            
        case 8
            % trlinfo{1,1} = [0 0 0];
            %  trlinfo{1,2} = [0 0 0 ];
            trlinfo{1,3} = [0, 10, 11];
            
        case 9
            trlinfo{1,1} = [0 6 0];
            % trlinfo{1,2} = [0 0 0 ];
            trlinfo{1,3} = [12 0 0];%[0 12 13];
        case 10
            trlinfo{1,1} = [0 6 0];
            %             trlinfo{1,2} = [0 0 0];
            %             trlinfo{1,3} = [0 0 0];
        case 11
            %trlinfo{1,1} = [0 0 0];
            trlinfo{1,2} = [8 9 0];
            %trlinfo{1,3} = [0 0 0];
        case 12
            trlinfo{1,1} = [0 18 19];
            trlinfo{1,2} = [0 30 31];
            trlinfo{1,3} = [0 41 42];
            
    end
elseif CHflag == 2
    switch subjidx
        case  1
            trlinfo{1,1} = [ 7, 13, 18];
            
        case 2
            trlinfo{1,1} = [1];
        case 3
            trlinfo{1,1} = [1, 8, 15];
        case 4
            trlinfo{1,1} = [1,8,15];
            
        case 5
            trlinfo{1,1} = [1, 8,22];
        case 6
            trlinfo{1,1} = [1, 7,13];
        case 7
            trlinfo{1,1} = [1, 7,13];
        case 8
            trlinfo{1,1} = [5];
        case 9
            trlinfo{1,1} = [3 0 10];
        case 10
            trlinfo{1,1} = [1 0 0];
        case 11
            %trlinfo{1,1} = [ 0];
            trlinfo{1,1} = [4];
            %trlinfo{1,3} = [0 0 0];
        case 12
            trlinfo{1,1} = [14 25 36];
    end
end
%%
RelChans = ~cellfun('isempty', trlinfo );
for til = find(RelChans)
    for sl = 1:length(trlinfo{1,til})
        cfg = [];
        cfg.trials = find(DataIn.trialinfo == trlinfo{1,til}(1,sl)); % look for trials that contain the right stim site
        if isempty(cfg.trials)
            continue
        end
        if CHflag == 1
            switch sl
                case 1
                    if (subjidx == 9) && (CHflag == 1)
                        cfg.channel = Chanlist{1,til}(1,2);
                    else
                        cfg.channel = Chanlist{1,til}(1,3);
                    end
                case 2
                    cfg.channel = Chanlist{1,til}(1,3);
                case 3
                    cfg.channel = Chanlist{1,til}(1,1);
            end
        elseif CHflag == 2
            switch sl
                case 1
                    chandx = cellfun(@isempty,Chanlist);
                    if ~any(chandx)                  
                        cfg.channel = [Chanlist{1,1}(1,3),Chanlist{1,2}(1,1), Chanlist{1,3}(1,1)];
                    else
                        ChanlistEx = Chanlist{~chandx};
                        cfg.channel = ChanlistEx(1);
                    end 
                case 2
                    cfg.channel = [Chanlist{1,1}(1,1),                    Chanlist{1,3}(1,1)];
                case 3
                    chandx = cellfun(@isempty,Chanlist);
                    if ~any(chandx)
                        cfg.channel = [Chanlist{1,1}(1,1),Chanlist{1,2}(1,1), Chanlist{1,3}(1,1)];
                    else
                        ChanlistEx = Chanlist{~chandx};
                        cfg.channel = ChanlistEx(1);
                    end 
            end
        end
        if cfg.channel == 0
            continue
        end
        cfg.avgoverchan = 'no';
        DatSellC{til,sl} = ft_selectdata(cfg, DataIn);
        if CHflag == 1
            DatSellC{til,sl}.label = {'A'};
        elseif CHflag == 2
            for x = 1:size(DatSellC{til,sl}.label)
                cfg = [];
                cfg.channel = x;
                DatSelldum{x} = ft_selectdata(cfg, DatSellC{til,sl});
                DatSelldum{x}.label = {'A'};               
            end
            DatSellC{til,sl} = ft_appenddata([],   DatSelldum{:}); 
        end        
    end
end

DatSell = [];
countr = 0;
for sc = 1:(size(DatSellC,1)*size(DatSellC,2))
    if isempty(DatSellC{sc})
       countr = countr +1;
       continue
    end 
    DatSell{sc-countr}= DatSellC{sc};
end
DataOut = DatSell;
% if length(DatSell) == 1
%     DataOut = DatSell{1,1};
% else
%     cfg = [];
%     DataOut = ft_appenddata(cfg,  DatSell{1,:});  
% end 
