function [Stat, DlFoofready] = MicroData(Basepath, AllMicro, CSCHippCondLFP, TrialSelCondLFP)

condidx = 8;
condidxctx = 7;
CumSumPath = [Basepath 'Mircea/Datasaves/CumSum/'];
condName = ['Local vs. Distal Stimulation at Hippocampal Channels'];

postLat = [0.026 1.026];
fLat = [0.026 1.026];
fLat(2,:) = [-1.022 -0.022];
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
            
            cfg = [];
            cfg.channel = bundlelist{d,subjidx}{1,b};
            cfg.avgoverchan = 'yes';
            cfg.trials = trl;
            cfg.nanmean = 'yes';
            Datab{d,count} = ft_selectdata(cfg, Data{d,subjidx});
            Datab{d,count}.label = 'A';
            
            micDat = Datab{d,subjidx};            
            for t = 1:size(micDat.trial,2)
                ampval(t)    = max( abs(micDat.trial{1,t}(1,3000:3400)));  % find cortical amplitude during hippocampal stimulation
                postresp(t)  = max(abs(micDat.trial{1,t}(1,3000:3400)));
                preresp(t)   = max(abs(micDat.trial{1,t}(1,2580:2980)));
                
                %                         hold on
                %                         plot(1:1401,micDat.trial{1,t}(chans{1,x}(y2),2000:3400))
                %                         hold off
            end
            
            [selchan(d,count),selchanp(d,count)] = ttest( postresp,preresp);
            %clear postresp preresp ampval
            
            if selchan(d,count) == 1
                DataS{d,count} = micDat;
            end 
            
            cfg = [];
            cfg.channel = bundlelist{d,subjidx}{1,b};
            cfg.avgoverchan = 'no';
            cfg.trials = trl;
            Dataf{d,count} = ft_selectdata(cfg, Data{d,subjidx});
                        
        end
        count = count+1;
    end
end

%%
Stat = ERPCumSum(DataS, postLat,condName);
[DlFoofready] = FOOOFfreq(Dataf,fLat,1,Basepath);
end 