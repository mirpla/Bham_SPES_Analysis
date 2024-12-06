function MicroDataResponse(Basepath, AllMicro, CSCHippCondLFP, TrialSelCondLFP)

condidx = 8;
CumSumPath = [Basepath 'Mircea/Datasaves/CumSum/'];
condName = ['Local at Hippocampal Channels'];

postLat = [0.026 1.026];
fLat = [0.026 1.026];
fLat(2,:) = [-1.022 -0.022];
subs = [7,8,9,10,11,12];

% Separate analysis by electrode bundle where {local distal,subject}{1 = selected channels 2 = trlinfo,bundlenumber}

% choose channel
bundlelist{1,1}{1,1} = 1:3;
bundlelist{1,1}{1,2} = 4:7;
bundlelist{1,1}{1,3} = 8:11;
bundlelist{1,2}{1,1} = 1:7;
bundlelist{1,3}{1,1} = 1:4;
bundlelist{1,3}{1,2} = 5:8;
bundlelist{1,4}{1,1} = 1:8;
bundlelist{1,4}{1,2} = 9:16;
bundlelist{1,5}{1,1} = 1:4;
bundlelist{1,5}{1,2} = 5:8;
bundlelist{1,5}{1,3} = 9:12;
bundlelist{1,6}{1,1} = 1:5;
bundlelist{1,6}{1,2} = 6:10;
bundlelist{1,6}{1,3} = 11:15;
bundlelist{1,7}{1,1} = 1:4;
bundlelist{1,7}{1,2} = 5:9;
bundlelist{1,7}{1,3} = 11:14;
bundlelist{1,8}{1,1} = 1:8;
bundlelist{1,9}{1,1} = 1:5;
bundlelist{1,9}{1,2} = 6:12;
bundlelist{1,10}{1,1} = [3,5,6];
bundlelist{1,11}{1,1} = [1:8];
bundlelist{1,12}{1,1} = [2,7,12];
bundlelist{1,12}{1,2} = [3:5];
bundlelist{1,12}{1,3} = [8:11];

% corresponding
bundlelist{1,1}{2,1} = [7,8];
bundlelist{1,1}{2,2} = [13,14];
bundlelist{1,1}{2,3} = 19;
bundlelist{1,2}{2,1} = [1,2];
bundlelist{1,3}{2,1} = [8,9];
bundlelist{1,3}{2,2} = [15,16];
bundlelist{1,4}{2,1} = [8,9];
bundlelist{1,4}{2,2} = [15:16];
bundlelist{1,5}{2,1} = [1:2];
bundlelist{1,5}{2,2} = [7:8];
bundlelist{1,5}{2,3} = [21 22];
bundlelist{1,6}{2,1} = [1:2];
bundlelist{1,6}{2,2} = [7:8];
bundlelist{1,6}{2,3} = [13:14];
bundlelist{1,7}{2,1} = [1:2];
bundlelist{1,7}{2,2} = [7:8];
bundlelist{1,7}{2,3} = [13:14];
bundlelist{1,8}{2,1} = [5:6];
bundlelist{1,9}{2,1} = [1:2];
bundlelist{1,9}{2,2} = [8:9];
bundlelist{1,10}{2,1} = [1 2];
bundlelist{1,11}{2,1} = [4 5];
bundlelist{1,12}{2,1} = [14 15];
bundlelist{1,12}{2,2} = [25 26];
bundlelist{1,12}{2,3} = [36 37];

count = 1;
for subjidx = subs
    ID = AllMicro.SubjID{1,subjidx};
    Data{1,subjidx} = eval(sprintf('CSCHippCondLFP.%s.Conditions{1,condidx}', ID));
    
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
   
    for b = 1:size(bundlelist{1,subjidx},2)
        
        trl = [];
        trl = find(ismember(Datae{1,subjidx}.trialinfo,bundlelist{1,subjidx}{2,b}))';
        
        cfg = [];
        cfg.channel = bundlelist{1,subjidx}{1,b};
        cfg.trials = trl;
        Datab{1,count} = ft_selectdata(cfg, Data{1,subjidx});
        
        cfg = [];
        cfg.viewmode = 'vertical';
        ft_databrowser(cfg, Datab{1,count})
        disp(ID);
        disp(b)        
        
        count = count+1;
    end
end
end