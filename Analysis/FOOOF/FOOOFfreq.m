function [DlFoofready] = FOOOFfreq(Dataf,fLat, M, Basepath)
% Prepares Dta in Foof format in dedicated folders. Flat ist the latency
% windows pre and post stimulus, M = 1 = micro, M =2  = Macro data,
% Basepath is the path needed for further saving 
Lbl{1} = 'Local';
Lbl{2} = 'Distal';
Lbl{3} = 'Pre';
Lbl{4} = 'Post';

Vers{1} = 'Micro';
Vers{2}  = 'MacroC';
Vers{3}  = 'MacroH';

Path = [Basepath,'Mircea\3 - SPES\Datasaves\FOOOF\',Vers{M},'\'];

for b = 1:size(Dataf,2)
    cfg = [];
    cfg.latency = fLat(2,:);
    Datapp{1,b} = ft_selectdata(cfg, Dataf{1,b}); % Pre Local
    Datapp{2,b} = ft_selectdata(cfg, Dataf{2,b}); % Pre Distal
    
    
    cfg = [];
    cfg.latency = fLat(1,:);
    Datapp{3,b} = ft_selectdata(cfg, Dataf{1,b}); %post Local
    Datapp{4,b} = ft_selectdata(cfg, Dataf{2,b}); %Post Distal
    for x = 1:size(Datapp,1)
        Datapp{x,b}.hdr.nTrials    =length(Datapp{x,b}.trial);
        
        cfg = [];
        cfg.output = 'pow';
        cfg.method = 'mtmfft';
        cfg.foi = 1:1:30;
        cfg.tapsmofrq = 1;
        cfg.keeptrials = 'yes';
        FFTl{x,b} = ft_freqanalysis(cfg, Datapp{x,b});
        
        cfg = [];
        cfg.variance      = 'yes';
        FFTlv{x,b} = ft_freqdescriptives(cfg,FFTl{x,b});
        
        cfg = [];
        cfg.output = 'pow';
        cfg.method = 'mtmfft';
        cfg.foi = 30:4:150;
        cfg.keeptrials = 'yes';
        cfg.tapsmofrq = 2;
        FFTh{x,b} = ft_freqanalysis(cfg, Datapp{x,b});
        
        cfg = [];
        cfg.variance      = 'yes';
        FFThv{x,b} = ft_freqdescriptives(cfg,FFTh{x,b});
        
       
        if length(FFTlv{x,b}.label) == 1            
            cfg                 = [];
            cfg.trials          = 'all';
            DlFoofready{x,b}    = ft_selectdata(cfg, FFTlv{x,b});
            DhFoofready{x,b}    = ft_selectdata(cfg, FFThv{x,b});
        else
            cfg                 = [];
            cfg.trials          = 'all';
            if M == 1
                cfg.avgoverrpt      = 'yes';
            end
            cfg.avgoverchan     = 'yes';
            DlFoofready{x,b}    = ft_selectdata(cfg, FFTlv{x,b});
            DhFoofready{x,b}    = ft_selectdata(cfg, FFThv{x,b});
        end
    end
end


for x = 1:size(DlFoofready,1)
    for y = 1:size(DlFoofready,2)
        FFTGA{x,1}(y,:) = DlFoofready{x,y}.powspctrm;
    end     
end
figure 
hold on
h1 = shadedErrorBar(DlFoofready{1,3}.freq,mean(FFTGA{3,1}),std(FFTGA{3,1})/sqrt(size(FFTGA{3,1},1)),'lineProps', '-b');
h2 = shadedErrorBar(DlFoofready{1,1}.freq,mean(FFTGA{1,1}),std(FFTGA{1,1})/sqrt(size(FFTGA{1,1},1)),'lineProps', '-r');
set(gca, 'YScale', 'log')
legend([h1.mainLine h2.mainLine],'Post Local Stimulation', 'Pre Local Stimulation')
hold off
figure 
hold on
h3 = shadedErrorBar(DlFoofready{1,4}.freq,mean(FFTGA{4,1}),std(FFTGA{4,1})/sqrt(size(FFTGA{4,1},1)),'lineProps', '-b')
h4 = shadedErrorBar(DlFoofready{1,2}.freq,mean(FFTGA{2,1}),std(FFTGA{2,1})/sqrt(size(FFTGA{2,1},1)),'lineProps', '-r')
legend([h3.mainLine h4.mainLine],'Post Distal Stimulation', 'Pre Distal Stimulation')
set(gca, 'YScale', 'log')
hold off

for x = 1:size(DlFoofready,1)
    if x == 1
        y = 1;
        z = 3;
    elseif x == 2
        y = 2;
        z = 3;
    elseif x == 3
        y = 1;
        z = 4;
        
    elseif x == 4
        y = 2;
        z = 4;
    end
    psds = [];
    structarrayl = [DlFoofready{x,:}];
    psds = vertcat(structarrayl(:).powspctrm);
    save([Path, sprintf('%sL%sAllpsds',Lbl{y},Lbl{z})],'psds')
    
    psds = [];
    structarrayh = [DhFoofready{x,:}];
    psds = vertcat(structarrayh(:).powspctrm);
    save([Path, sprintf('%sH%sAllpsds',Lbl{y},Lbl{z})],'psds')  
end
freqs = DlFoofready{1,1}.freq';
save([Path,'\AllfreqsL'],'freqs')
freqs = DhFoofready{1,1}.freq';
save([Path,'\AllfreqsH'],'freqs')

end