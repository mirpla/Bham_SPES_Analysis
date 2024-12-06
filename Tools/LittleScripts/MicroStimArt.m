% Data = avgCSCdat
% for tril = 1:50:401;
%    for channl = 1:32;
%     channl = 32;
%for tril = 300:1:449;
    figure
        plot(Data.time{1, tril}(1,:), Data.trial{1,tril}(channl,:))
    
        xlim([-0.02 0.04])
         hold on
%         plot(CSCdatintLin.time{1, tril}(1,:), CSCdatintLin.trial{1,tril}(channl,:))
%          legend('Before', 'After')
        x=-0.001;
        x2=0.0035;
        y= get(gca,'ylim');
        plot([x x],y, 'r');
        plot([x2 x2],y, 'r');
%          nam = sprintf('Chan%dTrl%d.png',channl, tril);
%         saveas(gcf, nam)
        hold off
%          close
% end
% end
%    
%%

for tril = 1:50:401
    for channl = 1:4
        figure
        plot(avgCSCda.time{1, tril}(1,:), avgCSCda.trial{1,tril}(channl,:))
        xlim([-0.02 0.02])
        hold on
        plot(avgCSCdat.time{1, tril}(1,:), avgCSCdat.trial{1,tril}(channl,:))
        legend('Before', 'After')
        x=-0.002;
        x2=0.004;
        y= get(gca,'ylim');
        plot([x x],y, 'r');
        plot([x2 x2],y, 'r');
        nam = sprintf('AvgTrl%dChan%d.png', tril, channl);
        saveas(gcf, nam)
        hold off
        close
    end
end