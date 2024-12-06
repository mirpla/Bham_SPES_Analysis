subjectID = 'P12';
Basepath        =   ['\\analyse4.psy.gla.ac.uk\project0304\RDS\Mircea\3 - SPES\Datasaves\Macro\',subjectID,'\'];
DataLoc{1,1}    =   ['\\analyse4.psy.gla.ac.uk\project0304\RDS\Mircea\3 - SPES\SPES Data Macro - round 2\','P10','-SL-SPES.edf'];

for x = 1:length(DataLoc)
    k=1;
    for i = 5000:5000:200000
        cfg = [];
        cfg.dataset = DataLoc{1,x};
        cfg.channel = 'all';
        %cfg.trl = [(i*1024)-(4999.999*1024) i*1024 1];
        cfg.continuous = 'yes';
        IC = ft_preprocessing(cfg);
        save([Basepath, num2str(x),'/',  subjectID, sprintf('_%d', k)], 'IC', '-v7.3')
        k=k+1;        
    end
end

%% Make figures to find the stimulation Spots
for x =  1    
        for i2 = 1:5 %1:k-1
            load([Basepath, num2str(x),'/', subjectID,sprintf('_%d', i2)])
            for j = 2:length(IC.label)
                figure
                
                plot(IC.time{1,1}, IC.trial{1,1}(j,:))
                axis tight
                saveas(gcf, [Basepath, num2str(x),'/',subjectID,'_Part',num2str(i2),'_Chan',num2str(j),'.png']);
                close all
            end
            close all
        end   
end

%% Cut out relevant parts

StimTStamp{1,1} = [13500*1024 16000*1024 0];
StimTStamp{1,2} = [500*1024 5000*1024 0];
StimTStamp{1,3} = [16000*1024 20000*1024 0];

for x = 1 %1:length(DataLoc)
            cfg             = [];
            cfg.dataset     = DataLoc{1,x};
            cfg.channel     = 'trig';
            cfg.trl         = StimTStamp{1,x};
            cfg.continuous  = 'yes';
            IC              = ft_preprocessing(cfg);
            %save([Basepath,'Ses', num2str(x),'/',  subjID, '_IC'], 'IC', '-v7.3')
            %clear IC
end 
