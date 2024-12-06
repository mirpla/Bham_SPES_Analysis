VisualChans
bundnum = 8;
MicroLoc = zeros(bundnum, length(subjIDspk)*3);
for subjidx = 1:length(subjIDspk)
    for bundle = 1:bundnum
        if ~isempty(VisLoc{subjidx,bundle})
            [EleCoord(1+(8*(bundle-1)):8+(8*(bundle-1)),1+(3*(subjidx-1)):3+(3*(subjidx-1))),...
                MicroLoc(bundle,1+(3*(subjidx-1)):3+(3*(subjidx-1)))] = CalcChanLoc(VisLoc{subjidx,bundle}(1,:), VisLoc{subjidx,bundle}(2,:));
        end
    end
end

[ChanlistSel] = ChanlistConversion(Chanlist{1,1}, SUAnERP{1,1});
[ChanlistInvSel] = ChanlistConversion(abs(Chanlist{1,1}-1), SUAnERP{1,1});

[wChanlistSel] = ChanlistConversion(wChanlist{1,1}, wSUAnERP);
[wChanlistInvSel] = ChanlistConversion(abs(wChanlist{1,1}-1), wSUAnERP);

%%
[DUA,allpks,sildur,subsessnum,subvec,pksd,pkse,allpkloc, CellInfo] = VarDistance(EleCoord,MicroLoc, DataSU,SUA,ChanlistSel);
neurvec = [1;find(diff(sum(CellInfo.^2,2)))];

[DUAm] = VarDistanceCat(EleCoord,MicroLoc, DataSU,SUA,ChanlistSel);
[DUAmI] = VarDistanceCat(EleCoord,MicroLoc, DataSU,SUA,ChanlistInvSel);
[wDUAm] = WhiteMatterMeanSUA(DataSU, SUA, ChanlistSel, wTRLCOND);

[DUARel,DUAbinInfor] = VarDistanceReloaded(EleCoord,MicroLoc, DataSU,SUA,ChanlistSel);

[R,P] = SUAScatters(DUARel,allpks,sildur,subvec,neurvec,allpkloc); % no norm

%%

DUAbinInfor
%% White Matter
for wCntr = 1:3
        mtrL{wCntr}    = mean(cell2mat(wDUAm{wCntr}.trial'),'omitnan');
        medtrL{wCntr}  = median(cell2mat(wDUAm{wCntr}.trial'),'omitnan');
        stdtrL{wCntr}  = std(cell2mat(wDUAm{wCntr}.trial'),'omitnan');
        
        fig = figure();
        til = tiledlayout(fig, 'flow');
        nexttile
        plot(wDUAm{wCntr}.time{1,1},medtrL{wCntr},'k','LineWidth',2.5)
        xlim([-0.1 1])
        % title(['<= ' ,num2str(5*mc)])
        nexttile
        shadedErrorBar(wDUAm{wCntr}.time{1,1},mtrL{wCntr},stdtrL{wCntr})%/sqrt(size(DUAm{mc}.trial,2)))
        xlim([-0.1 1])
        %ylim([-10 150])
end

allmtrL     = mean([mtrL{1};mtrL{2};mtrL{3}]);
strallmtrL  = mean([stdtrL{1};stdtrL{2};stdtrL{3}]);


figure 
shadedErrorBar(wDUAm{1}.time{1,1},allmtrL,strallmtrL/sqrt(3))%/sqrt(size(DUAm{mc}.trial,2)))
xlim([-0.1 1])