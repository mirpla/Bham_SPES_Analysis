function PlotERP(dataC,dataH)
index = ~cellfun('isempty',dataC);

for lpc = 1:size(dataC,1)
    dumdataC = data(lpc,index(lpc,:));
    dumdataH = data(lpc,index(lpc,:));
    for bundle = 1:size(dumdataC,2)
         
        cfg = [];
        cfg.avgoverchan = 'yes';
        ERPcnoGA = ft_timelockanalysis(cfg, dumdataC{1,bundle});
        ERPhnoGA = ft_timelockanalysis(cfg, dumdataH{1,bundle});
        
        cfg = [];
        cfg.avgoverchan = 'yes';
        cfg.keeptrials = 'yes';
        ERPraw{lpc}{1,bundle} = ft_timelockanalysis(cfg, dumdataC{1,bundle});
        ERPraw{lpc}{2,bundle} = ft_timelockanalysis(cfg, dumdataH{1,bundle});
        
        cfg = [];
        cfg.baseline = [-2 -1];
        ERPGA{lpc}{1,bundle} = ft_timelockbaseline(cfg, ERPcnoGA);
        ERPGA{lpc}{2,bundle} = ft_timelockbaseline(cfg, ERPhnoGA);
    end
    
    %%
    cfg = [];
    ERPcGGA = ft_timelockgrandaverage(cfg, ERPGA{lpc}{1,:});
    ERPhGGA = ft_timelockgrandaverage(cfg, ERPGA{lpc}{2,:});
    
    
    figure
    tiledlayout(1,2)
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