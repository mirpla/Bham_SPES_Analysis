subjIDspk =  {'sub-0006'};%{'sub-0007','sub-0008','sub-0009','sub-0012','sub-0013'};
direction = {'pos','neg'};
% Perform Spike detection and Automatic Clustering for each subject and channel
for x = 1:length(direction)
    ReadDataWC(Basepath, subjIDspk, direction{x})
end
clear x
%% Perform Manual Control on Automatic Clustering
for pn = 1:length(direction)
    ManualCluster(Basepath, subjIDspk, direction{pn})
end 

%% Import the WaveClus Data to the architecture of the Pipeline

% [SPKDat,SPKvars] = BatchImportSpikesWC(Basepath, subjIDspk,{'pos','neg'});  % Create variable containing all spike data
% save([Basepath, 'Mircea\Datasaves\','SortedSpikes'], 'SPKDat','SPKvars', '-v7.3')

%% Create the Trials based on the micro LFP trial definitions
% if ~exist('SPKDat','var')
%     load([Basepath,'Mircea\Datasaves\SortedSpikes.mat'])
% end
% if ~exist('AllMacro','var')
%     load([Basepath,'Mircea\Datasaves\Macro\MacroData.mat'])
% end
% if ~exist('AllMicro','var')
%     load([Basepath,'Mircea\Datasaves\Micro\MicroData.mat'])
% end
% 
% for j = 1:2 %positive and negative sorting separatly
%     cnt = 1;
%     for subj = 1:length(subjIDspk)
%         for ses = 1:length(SPKDat{1,subj})
%             if cnt == 2 || cnt == 4 || cnt == 6 || cnt == 7 || cnt == 9
%                 trldef = [(AllMicro.Session{1,cnt}.cfg.previous.previous.previous.trl(:, 1:3))*32 ,AllMicro.Session{1,cnt}.cfg.previous.previous.previous.trl(:,4)];
%             elseif cnt == 8
%                 trldef = [(AllMicro.Session{1,cnt}.cfg.previous.previous.trl(:, 1:3))*32 ,AllMicro.Session{1,cnt}.cfg.previous.previous.trl(:,4)];
%             else
%                 trldef = AllMicro.Session{1,cnt}.cfg.previous.previous.previous.previous.previous.trl;
%             end
%             SPKtrls{j,subj}{1,ses} = make_SUA_trials(SPKDat{j,subj}{1,ses}, SPKvars{j,subj}{1,ses}, trldef);
%             SPKtrls{j,subj}{1,ses}.trialinfo = trldef(:,4);
%             cnt = cnt + 1;
%         end
%     end
% end
% 
% % SPKtrls{1,1}{1,2}.trialinfo = AllMacro.Session{1, 2}.cfg.previous.previous{1, 1}.previous.previous.trl  
% % SPKtrls{1,2}{1,2}.trialinfo = AllMacro.Session{1,4}.trialinfo
% 
% save([Basepath, 'Mircea\Datasaves\','SpikeTrials'], 'SPKtrls', '-v7.3')
% 
% %%
% if ~exist('SPKtr;s','var')
%     load([Basepath,'Mircea\Datasaves\SpikeTrials.mat'])
% end
% 
% for j = 1:2
%     x = 1;
%     for subjidx = 1:length(subjIDspk)
%         for ses = 1:length(SPKtrls{1,subjidx})
%             for chan = 1:length(SPKtrls{1,subjidx}{1,ses}.label)
%                 if j == 1
%                     DataSUpos{1,subjidx}{1,ses}{1,chan} = SeparateSUnits(SPKtrls{j,subjidx}{1,ses},chan);
%                 elseif j == 2
%                     DataSUneg{1,subjidx}{1,ses}{1,chan} = SeparateSUnits(SPKtrls{j,subjidx}{1,ses},chan);
%                 end
%                 %             for su = 1:max(SPKtrls{1,subjidx}{1,ses}.unit{1,chan})
%                 %                 FromScratchSUA(DataSU{1,subjidx}{1,chan}{1,su})Raster
%                 %                 title(['Sub',num2str(subjidx),'--Session',num2str(ses), '-- Chan ', num2str(chan), '-- Unit', num2str(su)]);
%                 %                 saveas(gcf,[Basepath,'Mircea\Datasaves\FIGS\Raster\All\Sub',num2str(subjidx),'--Session',num2str(ses), '-- Chan ', num2str(chan), '-- Unit', num2str(su), '.jpg']);
%                 %             end
%                 close all
%             end
%             x = x+1;
%         end
%     end    
% end
% 
% TRLCOND = [];
% [SUA{1,1},TRLCOND] = SelectedConditions_SUA(DataSUpos);
% [SUA{2,1},~] = SelectedConditions_SUA(DataSUneg);
% %%
% for pn = 1:length(SUA)
%     [SUAClean{pn,1}] = RemoveDat(SUA{1,1}.Conditions, Basepath, direction, TRLCOND,[-3 3]);
% end
% 
% for pn = 1:length(SUA)
%     [SUAnERP{pn,1}] = SUAnalysis(SUA{pn,1}, Basepath, direction{pn}, TRLCOND,1);
% end
% 
% % Unify all ERPs (positive and negative) into one variable separated by local and distal
% for LvD = 1:length(SUAnERP{1,1}) % Local vs Distal
%     x = 1;
%     for pn = 1:length(SUAnERP) %positive vs negative
%         for u = 1:length(SUAnERP{pn,1}{1,LvD}) % Individual Units
%             SUAnERPall{1,LvD}.trial(x,1)  = SUAnERP{pn,1}{1,LvD}{1,u}.trial;
%             SUAnERPall{1,LvD}.time(x,1)   = SUAnERP{pn,1}{1,LvD}{1,u}.time;
%             SUAnERPall{1,LvD}.label(x,1)  = SUAnERP{pn,1}{1,LvD}{1,u}.label;
%             x = x + 1;
%         end
%     end
%     SUAnERPall{1,LvD}.fsample = SUAnERP{j,1}{1,LvD}{1,u}.fsample;
% end
% 
