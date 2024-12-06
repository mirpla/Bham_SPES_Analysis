function clustercorr(channel, limit, bins)
    maxspikes=5000;
    fontSize = 5;
    lineWidth = 0.5;
    
    load(sprintf('times_CSC%i.mat', channel), 'cluster_class');
    numcluster=max(cluster_class(:,1))+1;
    
    for i=1:numcluster
        cluster(i).index_ts=cluster_class(cluster_class(:,1)==i-1,2);        
    end
    h1=figure(800+channel);
    set(h1, 'visible','off');
    set(h1, 'PaperUnits', 'normalized');
    %set(h1, 'PaperSize', 'a4');
    set(h1, 'PaperOrientation', 'Portrait')    
    
    % this doesn't work anymore under 2018b
    %set(gcf, 'PaperUnits', 'Normalized')
    %set(gcf, 'PaperSize', [1.2 1.2+max([(numcluster-4) 0])*0.1])
    %set(gcf, 'PaperPosition', [0 0 1.2 1.2+max([(numcluster-4) 0])*0.1])
    %set(gcf, 'PaperOrientation', 'Portrait')    
 
    
    for i=1:numcluster
        for j=i:numcluster
            subplot(numcluster, numcluster, (i-1)*numcluster+j);
            
            [y maxvalue]=mycorr(cluster(i).index_ts, cluster(j).index_ts, limit/bins, limit);
            y=y./maxvalue;
            bar(-limit:(limit/(bins)):limit, y, 1, 'hist');
            
            title([ 'Cl. ' num2str(i-1) ',' num2str(j-1)], 'FontSize', fontSize);
%             if (i==1)
%                 if (i==j)
%                     title({'Garbage AutoCorr. ', ['Cl. ' num2str(i-1)]}, 'FontSize', fontSize);
%                 else 
%                     title({'Garbage CrossCorr. ', ['Cl. ' num2str(i-1) ',' num2str(j-1)]}, 'FontSize', fontSize);
%                 end
%             elseif (i==j)
%                 title({'AutoCorr. ', ['Cl. ' num2str(i-1)]}, 'FontSize', fontSize);
%             else 
%                 title({'CrossCorr. ',[ 'Cl. ' num2str(i-1) ',' num2str(j-1)]}, 'FontSize', fontSize);
%             end 
            xlim([-limit limit]);
            set(gca,'FontSize',fontSize);
            set(gca,'box','on', 'linewidth', lineWidth);
            xlabel('ms', 'FontSize', fontSize);
            ylabel('corr', 'FontSize', fontSize);
        end
    end
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,['\bf Correlations CSC' '\_ch' num2str(channel)],'HorizontalAlignment','center','VerticalAlignment', 'top','FontSize', fontSize*1.2);
%    print(h1,'-dpng', ['ch' num2str(channel) '_Correlations CSC_']);
    
    % overwrite hard-coded ffont size adjustments
    %set(findall(gcf,'type','text'),'FontSize',fontSize,'fontWeight','normal');
    %set(findall(0,'type','axes'),'FontSize',fontSize,'fontWeight','normal');
    print(h1, '-r150', '-dpng', sprintf('wav_fig2print_ch%i_corr', channel));
    close(h1);
end




