function [DUAm] = WhiteMatterMeanSUA(DataSU,SUA,Chanlist, trlcnd)
x = 0;
for y = 1:length(Chanlist)
    subjidx     = Chanlist(y,1);
    ses         = Chanlist(y,2);
    trlilabel   = SUA.stimsite{1,subjidx}{1,ses};
    chan        = Chanlist(y,3);
    su          = Chanlist(y,4);
    
    DOI  = DataSU{1,subjidx}{1,ses}{1,chan}{1,su};
    param.trlsize   = round(DOI.trialtime(1,2));
    param.convol    = 50;
    param.bswin     = (2000:2750);
    param.stimwin   = 2950:3600;
    param.fs                = 1000;
    param.trlsize           = 3;
    param.clsize            = 50;
    [~,DUAnERP] = SUA_ConvIn(DOI,param);
    %SUAERP = SUA_ERP(SUA.Conditions{1,1}{1,1}{1,6}{1,3}{1,1},param)
    DUAnERP.label{1,1}(1:4) = [];
    DUAnERP.label{1,1} = [num2str(subjidx),'s',num2str(ses),'c',num2str(chan),'u',num2str(su),DUAnERP.label{1,1}];
    
    dum = DUAnERP;
    for t = 1:size(dum.trial,2)
        dum.time{1,t} = dum.time{1,1};
    end
    x = x+1;
    disp(x)
    subx(x) = subjidx;
    for wCnd = 1:size(trlcnd,3)
        if ~isempty(trlcnd{subjidx,ses,wCnd})
            cfg = [];
            cfg.trials = trlcnd{subjidx,ses,wCnd};
            dumsel = ft_selectdata(cfg, dum);
            
            DUA = dumsel;
            DUAm{wCnd}.time{x}= DUA.time{1};
%             DUAm{wCnd}.alltrl{x} = cell2mat(DUA.trial');
            DUAm{wCnd}.trial{x} = mean(cell2mat(DUA.trial'),'omitnan');
            DUAm{wCnd}.stddev{x} = std(cell2mat(DUA.trial'),'omitnan');
            DUAm{wCnd}.label{x} = dumsel.label;
%             DUAmed{wCnd}.time{x}= DUA.time{1};
%             DUAmed{wCnd}.trial{x} = median(cell2mat(DUA.trial'),'omitnan');
        end
    end
end

end