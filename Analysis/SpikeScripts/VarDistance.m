function [DUA,allpks,sildur,x,subx,pksd,pkse,allpkloc, CellInfo] = VarDistance(EleCoord,MicroLoc, DataSU,SUA,Chanlist)
trlsize = [1000:3000;3000:5000];
figidflag = [];
while isempty(figidflag)
    figid = input('Do you want Figures? (y,n)','s');
    if figid == 'y'
        disp('Figures are being made')
        figidflag = 1;
    elseif figid == 'n'
        disp('Figures are not being made')
        figidflag = 0;
    else
        disp('Please give either a ''y'' or a ''n'' as input')
    end
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
            subx(x) = subjidx;          
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
            DUA{x} = dumsel;
            CellInfo(x,:) = [subjidx, ses, chan, su];
            mtrL = mean(cell2mat(DUA{x}.trial'),'omitnan');
            medtrL =  median(cell2mat(DUA{x}.trial'));
            [pk, pkloc] = findpeaks(mtrL(3000:3500));
            [pkmed, ~] = findpeaks(medtrL(3000:3500));
            
            if isempty(max(pk))
                allpks(x) = 0;
                sildur(x) = 0;
            elseif min(mtrL(1900:2900)) <= max(pk) && ...
                    max(pk) <= max(mtrL(1900:2900))+max(pk)/sqrt(size(DUA{x}.trial,2))+abs(mean(mtrL(1900:2900))*(10/100))
                allpks(x) = 0;
                sildur(x) = 0;
                if figidflag == 1
                    fig = figure();
                    til = tiledlayout(fig, 'flow');
                    nexttile
                    plot(dumsel.time{1,1}(2000:4000),medtrL(2000:4000),'k','LineWidth',2.5)
                    title([num2str([subjidx,ses,chan,su]),string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds})])
                    nexttile
                    shadedErrorBar(dumsel.time{1,1}(2000:4000),mtrL(2000:4000),msd(2000:4000)/sqrt(size(DUA{x}.trial,2)))
                    title(['N O'])
                    saveas(gcf, ['Z:\RDS\Mircea\Datasaves\FIGS\SUA\Distfigs\',num2str([subjidx,ses,chan,su]),char(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),'.jpg'])
                end
            else
                allpks(x)    = max(pk);
                if isempty(pkmed)
                    allmedpks(x) = 0;
                else
                    allmedpks(x) = max(pkmed);
                end
                
                msd = std(cell2mat(DUA{x}.trial'));
                pklocid = pkloc(pk == max(pk));
                allpkloc(x) = pklocid(1);
                pksd(x) = msd(3000-1+pklocid(1));
                pkse(x) = pksd(x)/sqrt(size(DUA{x}.trial,2));
                sillim = [];
                silper = [];
                silper = mtrL([trlsize(2,:)]) <= mean(mtrL([trlsize(1,:)-100]));
                %silper = mtrL(3000:4000) == min(mtrL(3000:4000));
                sillim = find(diff([0;silper(:)])==1);
                endlim = find(diff([0;silper(:)])==-1);
                                
                if isempty(sillim)
                    sillim = [0, 0];
                elseif length(sillim) == 1
                    sillim = [0 sillim];
                end
                                
                temlim = sillim(sillim >= allpkloc(x));
                temendlim = endlim(endlim >= allpkloc(x));
                if isempty(temlim)
                    temlim(1) = 0;                   
                end 
                if isempty(temendlim)
                     temendlim(1) = 0;
                end 
                
                temdur = diff([temlim(1),temendlim(1)]);
                j = 1;
                while temdur <= 30                  
                    if length(temlim)==j
                        break
                    elseif length(temendlim) == j
                        break
                    end
                    
                    j=j+1;                 
                    temdur = diff([temlim(j),temendlim(j)]);
                end
                
                while any(0 < (temlim-temendlim(j)) & (temlim-temendlim(j)) < 35)
                    if length(temendlim)==j
                        break 
                    end 
                    temendlim(j) = [];
                end
                if any(temlim ~= 0) && any(temendlim == 0)
                    sildur(x) = NaN;
                else
                    sildur(x) = diff([temlim(j),temendlim(j)]);
                end
                
                %sildur{x}(su,conds) = max(diff(sillim)); Original
                %definition of picking the largest silent period
                if figidflag == 1
                    fig = figure();
                    til = tiledlayout(fig, 'flow');
                    nexttile
                    plot(dumsel.time{1,1}(2000:4000),medtrL(2000:4000),'k','LineWidth',2.5)
                    title([num2str([subjidx,ses,chan,su]),string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds})])
                    nexttile
                    hold on
                    shadedErrorBar(dumsel.time{1,1}([trlsize(1,:),trlsize(2,:)]),mtrL([trlsize(1,:),trlsize(2,:)]),msd([trlsize(1,:),trlsize(2,:)])/sqrt(size(DUA{x}.trial,2)))
                    plot(dumsel.time{1,1}(3000-1+pklocid(1)),max(pk),'r*')
                    line([dumsel.time{1,1}(3000+temlim(j)),dumsel.time{1,1}(3000+temendlim(j))],[medtrL(3000+temlim(j)),medtrL(3000+temendlim(j))],'Color','red','LineWidth',2)
                    axis('tight')
                    line(dumsel.time{1,1},ones(1,length(dumsel.time{1,1}))*prctile(mtrL(:,param.bswin),97.5),'Color', 'k','LineStyle','--');
                    line(dumsel.time{1,1},ones(1,length(dumsel.time{1,1}))*prctile(mtrL(:,param.bswin),2.5), 'Color', 'k','LineStyle','--');
                    xlim([-1 1])
                    ylim([-20 35])
                    title(['silent period: ', num2str(sildur(x)), ';  Peak: ',num2str(allpks(x))])
                    saveas(gcf, ['Z:\RDS\Mircea\Datasaves\FIGS\SUA\Distfigs\',num2str([subjidx,ses,chan,su]),char(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),'.jpg'])
                end
            end
        end
    end
    close all
    
    
end
end
