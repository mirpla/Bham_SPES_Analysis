function [DUAm] = VarDistanceCat(EleCoord,MicroLoc, DataSU,SUA,Chanlist)
for distcnt = 1:14
    DUA{distcnt} = {};
end

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
    for conds = unique(DUAnERP.trialinfo)
        if contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),["AH","MH","PH"])
            dum = DUAnERP;
            
            for t = 1:size(dum.trial,2)
                dum.time{1,t} = dum.time{1,1};
            end
            x = x+1;
            disp(x)
            cfg = [];
            cfg.trials = dum.trialinfo==conds;
            dumsel = ft_selectdata(cfg, dum);
            
            if contains(dumsel.label{1,1},'ant')
                if contains(dumsel.label{1,1},'R')
                    dumsel.coord = MicroLoc(4,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                else
                    dumsel.coord = MicroLoc(1,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                end
            elseif contains(dumsel.label{1,1},'mid')
                if contains(dumsel.label{1,1},'R')
                    dumsel.coord = MicroLoc(5,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                else
                    dumsel.coord = MicroLoc(2,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                end
            elseif contains(dumsel.label{1,1},'post')
                if contains(dumsel.label{1,1},'R')
                    dumsel.coord = MicroLoc(6,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                else
                    dumsel.coord = MicroLoc(3,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                end
            elseif contains(dumsel.label{1,1},'para')
                if contains(dumsel.label{1,1},'L')
                    dumsel.coord = MicroLoc(7,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                else
                    dumsel.coord = MicroLoc(8,1+(3*(subjidx-1)):3+(3*(subjidx-1)));
                end
            end
            sChan = regexp(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds},'\d*','Match');
            
            if contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"AH")
                if contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"R")
                    bundleidx = 3;
                else
                    bundleidx = 0;
                end
            elseif contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"MH")
                if contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"R")
                    bundleidx = 4;
                else
                    bundleidx = 1;
                end
            elseif contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"PHG")
                if contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"R")
                    bundleidx = 8;
                else
                    bundleidx = 7;
                end
            elseif contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"PH")
                if contains(string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),"R")
                    bundleidx = 5;
                else
                    bundleidx = 2;
                end
            end
            
            dumsel.stimcoord = EleCoord(str2double(sChan{1,1})+(8*(bundleidx)),...
                1+(3*(subjidx-1)):1+2+(3*(subjidx-1)));
            
            dumsel.dist = sqrt((dumsel.coord(1)-dumsel.stimcoord(1))^2 + (dumsel.coord(2)-dumsel.stimcoord(2))^2 + (dumsel.coord(3)-dumsel.stimcoord(3))^2);
            
            for distc = 1:14
                if dumsel.dist <= 5*distc
                    if isempty(DUA{distc})
                        DUA{distc} = dumsel;
                        DUA{distc}.label = ['<= ' ,num2str(5*distc)];
                        DUAm{distc}.time{1}= DUA{distc}.time{1};
                        %DUAm{distc}.alltrl{1} = cell2mat(DUA{distc}.trial');
                        DUAm{distc}.trial{1} = mean(cell2mat(DUA{distc}.trial'),'omitnan');
                        DUAm{distc}.stddev{1} = std(cell2mat(DUA{distc}.trial'),'omitnan');
                        DUAm{distc}.label{1} = dumsel.label;
%                         DUAmed{distc}.time{1}= DUA{distc}.time{1};
%                         DUAmed{distc}.trial{1} = median(cell2mat(DUA{distc}.trial'),'omitnan');
                        break
                    else
                        dumsel.label = ['<= ' ,num2str(5*distc)];
                        DUA{distc}.trial = [DUA{distc}.trial, dumsel.trial];
                        DUA{distc}.time = [DUA{distc}.time, dumsel.time];
                        DUAm{distc}.trial{end+1} = mean(cell2mat(DUA{distc}.trial'),'omitnan');
                        %DUAm{distc}.alltrl{end+1} = cell2mat(DUA{distc}.trial');
                        DUAm{distc}.stddev{end+1} = std(cell2mat(DUA{distc}.trial'),'omitnan');
                        DUAm{distc}.time{end+1} = DUA{distc}.time{1};
                        DUAm{distc}.label{1} = dumsel.label;
%                         DUAmed{distc}.trial{end+1} = median(cell2mat(DUA{distc}.trial'),'omitnan');
%                         DUAmed{distc}.time{end+1} = DUA{distc}.time{1};                        
                        break
                    end                   
                end
            end
        end
    end
end

% for mc = 1:14    
%     
%     mtrL{mc} = mean(cell2mat(DUAm{mc}.trial'),'omitnan');
%     medtrL{mc} = median(cell2mat(DUAm{mc}.trial'),'omitnan');
%   
%     fig = figure();
%     til = tiledlayout(fig, 'flow');
%     nexttile
%     plot(DUAmed{mc}.time{1,1},medtrL{mc},'k','LineWidth',2.5)
%     xlim([-1 1])
%     title(['<= ' ,num2str(5*mc)])
%     nexttile
%     shadedErrorBar(DUAm{mc}.time{1,1},mtrL{mc},std(cell2mat(DUAm{mc}.trial')))%/sqrt(size(DUAm{mc}.trial,2)))
%     xlim([-1 1])
%     ylim([-10 150])
%     saveas(gcf, ['Z:\RDS\Mircea\Datasaves\FIGS\SUA\Dist_',num2str(5*mc),'.jpg'])
% end
disp('done')
%             dumsel = dumsel;
%             mtrL = mean(cell2mat(dumsel.trial'),'omitnan');
%             medtrL =  median(cell2mat(dumsel.trial'));
%             [pk, pkloc] = findpeaks(mtrL(3000:3500));
%             [pkmed, ~] = findpeaks(medtrL(3000:3500));
%             
%             if isempty(max(pk))
%                 allpks{x}(su,conds) = 0;
%                 sildur{x}(su,conds) = 0;
%             elseif min(mtrL(1900:2900)) <= max(pk) && ...
%                     max(pk) <= max(mtrL(1900:2900))+max(pk)/sqrt(size(dumsel.trial,2))+abs(mean(mtrL(1900:2900))*(10/100))
%                 allpks{x}(su,conds) = 0;
%                 sildur{x}(su,conds) = 0;
%                 if figidflag == 1
%                     fig = figure();
%                     til = tiledlayout(fig, 'flow');
%                     nexttile
%                     plot(dumsel.time{1,1}(2000:4000),medtrL(2000:4000),'k','LineWidth',2.5)
%                     title([num2str([subjidx,ses,chan,su]),string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds})])
%                     nexttile
%                     shadedErrorBar(dumsel.time{1,1}(2000:4000),mtrL(2000:4000),msd(2000:4000)/sqrt(size(dumsel.trial,2)))
%                     title(['N O'])
%                     saveas(gcf, ['Z:\RDS\Mircea\Datasaves\FIGS\SUA\Distfigs\',num2str([subjidx,ses,chan,su]),char(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),'.jpg'])
%                 end
%             else
%                 allpks{x}(su,conds)    = max(pk);
%                 if isempty(pkmed)
%                     allmedpks{x}(su,conds) = 0;
%                 else
%                     allmedpks{x}(su,conds) = max(pkmed);
%                 end
%                 
%                 msd = std(cell2mat(dumsel.trial'));
%                 pklocid = pkloc(pk == max(pk));
%                 allpkloc{x}(su,conds) = pklocid(1);
%                 pksd{x}(su,conds) = msd(3000-1+pklocid(1));
%                 pkse{x}(su,conds) = pksd{x}(su,conds)/sqrt(size(dumsel.trial,2));
%                 sillim = [];
%                 silper = [];
%                 silper = mtrL([trlsize(2,:)]) <= mean(mtrL([trlsize(1,:)-100]));
%                 %silper = mtrL(3000:4000) == min(mtrL(3000:4000));
%                 sillim = find(diff([0;silper(:)])==1);
%                 endlim = find(diff([0;silper(:)])==-1);
%                                 
%                 if isempty(sillim)
%                     sillim = [0, 0];
%                 elseif length(sillim) == 1
%                     sillim = [0 sillim];
%                 end
%                                 
%                 temlim = sillim(sillim >= allpkloc{x}(su,conds));
%                 temendlim = endlim(endlim >= allpkloc{x}(su,conds));
%                 if isempty(temlim)
%                     temlim(1) = 0;                   
%                 end 
%                 if isempty(temendlim)
%                      temendlim(1) = 0;
%                 end 
%                 
%                 temdur = diff([temlim(1),temendlim(1)]);
%                 j = 1;
%                 while temdur <= 30                  
%                     if length(temlim)==j
%                         break
%                     elseif length(temendlim) == j
%                         break
%                     end
%                     
%                     j=j+1;                 
%                     temdur = diff([temlim(j),temendlim(j)]);
%                 end
%                 
%                 while any(0 < (temlim-temendlim(j)) & (temlim-temendlim(j)) < 35)
%                     if length(temendlim)==j
%                         break 
%                     end 
%                     temendlim(j) = [];
%                 end
%                 if any(temlim ~= 0) && any(temendlim == 0)
%                     sildur{x}(su,conds) = NaN;
%                 else
%                     sildur{x}(su,conds) = diff([temlim(j),temendlim(j)]);
%                 end
%                 
%                 %sildur{x}(su,conds) = max(diff(sillim)); Original
%                 %definition of picking the largest silent period
%                 if figidflag == 1
%                     fig = figure();
%                     til = tiledlayout(fig, 'flow');
%                     nexttile
%                     plot(dumsel.time{1,1}(2000:4000),medtrL(2000:4000),'k','LineWidth',2.5)
%                     title([num2str([subjidx,ses,chan,su]),string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds})])
%                     nexttile
%                     hold on
%                     shadedErrorBar(dumsel.time{1,1}([trlsize(1,:),trlsize(2,:)]),mtrL([trlsize(1,:),trlsize(2,:)]),msd([trlsize(1,:),trlsize(2,:)])/sqrt(size(dumsel.trial,2)))
%                     plot(dumsel.time{1,1}(3000-1+pklocid(1)),max(pk),'r*')
%                     line([dumsel.time{1,1}(3000+temlim(j)),dumsel.time{1,1}(3000+temendlim(j))],[medtrL(3000+temlim(j)),medtrL(3000+temendlim(j))],'Color','red','LineWidth',2)
%                     hold off
%                     axis('tight')
%                     title(['silent period: ', num2str(sildur{x}(su,conds)), ';  Peak: ',num2str(allpks{x}(su,conds))])
%                     saveas(gcf, ['Z:\RDS\Mircea\Datasaves\FIGS\SUA\Distfigs\',num2str([subjidx,ses,chan,su]),char(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),'.jpg'])
%                 end
%             end
%         end
%     end
%     close all
%     
%     
% end
end
