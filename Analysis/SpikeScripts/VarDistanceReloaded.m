function [DUA,OutputT] = VarDistanceReloaded(EleCoord,MicroLoc, DataSU,SUA,Chanlist)
trlsize = [1000:3000;3000:5000]; % Pre and post stim window of interest

% mean distances together after normalizing for neuron firing rate to make
% sure we get reliable measures of peaks and silent periods on average

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
        end 
    end 
end 


%max_DUA_dist = min(cellfun(@(s) s.dist, DUA));
disp('wait')
dstB = 2.5; % Distance binsize for each loop
DUAdist = [];
Distance = []; 
Binsize = []; 
Max_Peak_Loc = [];
Max_Peak_Height = [];
Max_Peak_Loc2nd = [];
Max_Peak_Height2nd = [];
Silent_Period_Length = [];
Num_Neurons = [];

sil = [];
bs_wind = [800 2800]; % baseline window for peakfinding
st_wind = [2900 4900]; % window of interest

neuron_num_cutoff   = 10; % Minimum amount of neurons to get a plot or value in analysis

ctx_ctoff           = 30; % cutoff for non-hippocampal signal

ct_off              = 10; % cutoff percent for peaks and silent period

fig = figure();
tiledlayout('flow')
        
max_DUAdist         = 30; % maximum distance before 'cortex'

distValues = arrayfun(@(x) x.dist, [DUA{:}]); % get all the distance values for the individual neurons and stimulation positions

for x=0:round(max_DUAdist/dstB) % bin according to distance
    if (x*dstB) == ctx_ctoff  % make one large bin with distances in the cortex
        distMin = ctx_ctoff;
        distMax = max(distValues);
        
        distIdx =  distValues > ctx_ctoff;
    else
        distMin = 0+(x*dstB);
        distMax = dstB+x*dstB;
              
        distIdx = distValues > distMin & distValues <= distMax;
    end
    
    DUAbs = [];
    DUAmn = [];
    DUAzs = [];
    cntr = 1;
    for didx = find(distIdx) % go through neurons with distance values                
        DUAtrls     = cell2mat(DUA{didx}.trial'); % select specific neuron
        DUAbs{cntr} = mean(DUAtrls(:,bs_wind(1):bs_wind(2)));
        DUAzs{cntr} = ((DUAtrls(:,st_wind(1):st_wind(2))));% -DUAbs{cntr}));%./std(DUAtrls(:,bs_wind(1):bs_wind(2)))+1); % zscore activity for that neuron
        DUAzs{cntr}(isnan(DUAzs{cntr})) = 0;
        DUAmn{cntr} = nanmean(DUAzs{cntr});      
        cntr = cntr+1;       
    end
    DUAdist(x+1,:) = nanmean(cell2mat(DUAmn'));
    
    pkThresh = max(max(mean(cell2mat(DUAbs')))+ abs(max(mean(cell2mat(DUAbs')))) * (ct_off/100)); % set pk threshold to be maximum at baseline + 10% 
%     
%     for cntr = 1:size(DUAmn,2)
%         [mn_pk{cntr}, mn_pkloc{cntr}] = findpeaks(DUAmn{cntr},'MinPeakHeight',pkThresh); % doesn't work very well on single trial basis
%     end
    
    spThresh = min(min(mean(cell2mat(DUAbs')))- abs(min(mean(cell2mat(DUAbs')))) * (ct_off/100)); % set silent peak threshold to be minimum at basline mean - 10%
    [pk{x+1}, pkloc{x+1}] = findpeaks( DUAdist(x+1,:),'MinPeakHeight',pkThresh); % find peaks
    
    
    mx_pkloc = pkloc{x+1}(pk{x+1} == max(pk{x+1})); % determine the location of the maximum peak height
    
    lPkThresh   = find(DUAdist(x+1,1:mx_pkloc) <= pkThresh, 1, 'last'); % find the left peak
    rPkThresh   = lPkThresh + find(DUAdist(x+1,mx_pkloc:end) <= pkThresh, 1, 'first') - 1; % find the right peak
    pkSize      = rPkThresh - lPkThresh; % find the width of the peak
    
    sil_per = find(DUAdist(x+1,:) < spThresh); % find the moments the signal dips below the lower threshold
    
    sil_br      = find(diff(sil_per) ~=1); % find the moments where the sequence breaks (non-consecutive)
    if ~isempty(sil_br)
        sil_start   = [1, sil_br + 1];  % find different starting positions for silent period
        sil_end     = [sil_br, length(sil_per)]; % pick the ending positions
        sil_len     = sil_end - sil_start + 1; %find the different lengths for silent periods
        sil_postim  = sil_start(sil_per(sil_start)>mx_pkloc);
        sil_endstim = sil_end(sil_per(sil_start)>mx_pkloc);
        sil_postlen = sil_len(sil_per(sil_start)>mx_pkloc);
        
        %if any(sil_postlen>pkSize)  % only take the longest silent period that is larger than a peak
            sil(x+1,:)  = sil_per([sil_postim(sil_postlen==max(sil_postlen)),sil_endstim(sil_postlen==max(sil_postlen))]); % take the first longest silent period past the stimulation peak
        %else 
        %    sil(x+1,:) = NaN;
        %end
    end
    
    if size(DUAmn',1) > neuron_num_cutoff
        nexttile
        title(['Stimulation Site Distance: ',num2str(distMin),' - ',num2str( 0+(distMax)),' mm'])
        hold on
        shadedErrorBar(dumsel.time{1,1}([st_wind(1):st_wind(2)]),   nanmean(cell2mat(DUAbs')),  std(cell2mat(DUAbs'),"omitnan")/sqrt(size(DUAbs',1)),'lineprops','k') % plot baseline window
        shadedErrorBar(dumsel.time{1,1}([st_wind(1):st_wind(2)]),   DUAdist(x+1,:),             std(cell2mat(DUAmn'),"omitnan")/sqrt(size(DUAmn',1)),'lineprops','b') % plot stim window
        
        plot(dumsel.time{1,1}(st_wind(1)+mx_pkloc),max(pk{x+1}),'+')
        plot(dumsel.time{1,1}(st_wind(1)+pkloc{x+1}), pk{x+1},'rd')
        
         if ~isempty(sil_br) & ~isnan(sil(x+1,:))
            Silent_Period_Length(x+1,1) = sil(x+1,2) - sil(x+1,1);
            line(dumsel.time{1,1}(st_wind(1)+sil(x+1,1): st_wind(1)+sil(x+1,2)),    ones(1,length(dumsel.time{1,1}(st_wind(1)+sil(x+1,1): st_wind(1)+sil(x+1,2))))*0,  'Color', 'r','LineWidth',3)       
        else 
            Silent_Period_Length(x+1,1) = NaN;
        end 
        
        ylim([-10 50])
        xlim([dumsel.time{1,1}(st_wind(1)), dumsel.time{1,1}(st_wind(2))])
        
        pks = sort(pk{x+1}, 'descend');
         
        Distance(x+1,1) =  distMin;
        Binsize(x+1,1)  =  dstB;
        Max_Peak_Loc(x+1,1)    =  dumsel.time{1,1}(st_wind(1)+mx_pkloc);
        
        Max_Peak_Height(x+1,1) =  max(pk{x+1});
        
        if size(pks,2)>1
            Max_Peak_Loc2nd(x+1,1)     = pks(2);
            Max_Peak_Height2nd(x+1,1)  = dumsel.time{1,1}(st_wind(1)+pkloc{x+1}(pks(2) == pk{x+1}));
        else 
            Max_Peak_Loc2nd(x+1,1)      = NaN;
            Max_Peak_Height2nd(x+1,1)   = NaN;
        end 
       
        Num_Neurons(x+1,1)          = size(DUAmn',1);
        
    end
    
end
linkaxes

OutputT = table(Distance,Binsize,Max_Peak_Loc,Max_Peak_Height, Max_Peak_Loc2nd,  Max_Peak_Height2nd,Silent_Period_Length, Num_Neurons);

OutputT(Binsize == 0,:) = [];

writetable(OutputT,'\\analyse4\project0304\RDS\Mircea\3 - SPES\Datasaves\Spike_Regression.csv')
%Distance    = 
%DistanceBin =  

%ModelInput = table 
% 
%             CellInfo(x,:) = [subjidx, ses, chan, su];
%             mtrL = mean(cell2mat(DUA{x}.trial'),'omitnan');
%             medtrL =  median(cell2mat(DUA{x}.trial'));
%             [pk, pkloc] = findpeaks(mtrL(3000:3500));
%             [pkmed, ~] = findpeaks(medtrL(3000:3500));
%             
%             if isempty(max(pk))
%                 allpks(x) = 0;
%                 sildur(x) = 0;
%             elseif min(mtrL(1900:2900)) <= max(pk) && ...
%                     max(pk) <= max(mtrL(1900:2900))+max(pk)/sqrt(size(DUA{x}.trial,2))+abs(mean(mtrL(1900:2900))*(10/100))
%                 allpks(x) = 0;
%                 sildur(x) = 0;
%                 if figidflag == 1
%                     fig = figure();
%                     til = tiledlayout(fig, 'flow');
%                     nexttile
%                     plot(dumsel.time{1,1}(2000:4000),medtrL(2000:4000),'k','LineWidth',2.5)
%                     title([num2str([subjidx,ses,chan,su]),string(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds})])
%                     nexttile
%                     shadedErrorBar(dumsel.time{1,1}(2000:4000),mtrL(2000:4000),msd(2000:4000)/sqrt(size(DUA{x}.trial,2)))
%                     title(['N O'])
%                     saveas(gcf, ['Z:\RDS\Mircea\Datasaves\FIGS\SUA\Distfigs\',num2str([subjidx,ses,chan,su]),char(SUA.stimsite{1,subjidx}{1,ses}.Labels{1,conds}),'.jpg'])
%                 end
%             else
%                 allpks(x)    = max(pk);
%                 if isempty(pkmed)
%                     allmedpks(x) = 0;
%                 else
%                     allmedpks(x) = max(pkmed);
%                 end
%                 
%                 msd = std(cell2mat(DUA{x}.trial'));
%                 pklocid = pkloc(pk == max(pk));
%                 allpkloc(x) = pklocid(1);
%                 pksd(x) = msd(3000-1+pklocid(1));
%                 pkse(x) = pksd(x)/sqrt(size(DUA{x}.trial,2));
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
%                 temlim = sillim(sillim >= allpkloc(x));
%                 temendlim = endlim(endlim >= allpkloc(x));
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
%                     sildur(x) = NaN;
%                 else
%                     sildur(x) = diff([temlim(j),temendlim(j)]);
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
%                     shadedErrorBar(dumsel.time{1,1}([trlsize(1,:),trlsize(2,:)]),mtrL([trlsize(1,:),trlsize(2,:)]),msd([trlsize(1,:),trlsize(2,:)])/sqrt(size(DUA{x}.trial,2)))
%                     plot(dumsel.time{1,1}(3000-1+pklocid(1)),max(pk),'r*')
%                     line([dumsel.time{1,1}(3000+temlim(j)),dumsel.time{1,1}(3000+temendlim(j))],[medtrL(3000+temlim(j)),medtrL(3000+temendlim(j))],'Color','red','LineWidth',2)
%                     axis('tight')
%                     line(dumsel.time{1,1},ones(1,length(dumsel.time{1,1}))*prctile(mtrL(:,param.bswin),97.5),'Color', 'k','LineStyle','--');
%                     line(dumsel.time{1,1},ones(1,length(dumsel.time{1,1}))*prctile(mtrL(:,param.bswin),2.5), 'Color', 'k','LineStyle','--');
%                     xlim([-1 1])
%                     ylim([-20 35])
%                     title(['silent period: ', num2str(sildur(x)), ';  Peak: ',num2str(allpks(x))])
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
