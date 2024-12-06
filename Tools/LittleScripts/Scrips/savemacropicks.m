for i = 1:16
    load(sprintf('P8_%d.mat', i))
    for j = 1:length(IC.label)
        figure
        plot(IC.time{1,1}, IC.trial{1,1}(j,:))
        axis tight
        saveas(gcf, ['P8_Part',num2str(i),'_Chan',num2str(j),'.png']);
    end 
    close all
end 