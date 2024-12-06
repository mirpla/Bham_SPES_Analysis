DummyHits = vertcat(cell2mat(HitRate));

x = 97;  % Subject to Highlight 

f1 = figure('Position', fig_position);
subplot(2,1,1)

h1 = raincloud_plot(DummyHits(:,1), 'box_on', 1, 'color', cb(4,:),'MarkerEdgeColor', [0 0 0], 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
plot([0.4 0.4], get(gca,'ylim'),'k')
plot([HitRate{x,1}, HitRate{x,1}], (get(gca,'ylim')/4)+1.2,'b')
plot([HitRate{x,1}, HitRate{x,1}-0.02], [0.1 0.5],'b')
plot([HitRate{x,1}, HitRate{x,1}+0.02], [0.1 0.5],'b')
title(['Session 1'])

subplot(2,1,2)
h1 = raincloud_plot(DummyHits(:,2), 'box_on', 1, 'color', cb(4,:),'MarkerEdgeColor', [0 0 0], 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
plot([0.4 0.4], get(gca,'ylim'),'k')
plot([HitRate{x,2}, HitRate{x,2}], (get(gca,'ylim')/4)+1.2,'b')
plot([HitRate{x,2}, HitRate{x,2}-0.02], [0.1 0.5],'b')
plot([HitRate{97,2}, HitRate{x,2}+0.02], [0.1 0.5],'b')
title(['Session 2'])