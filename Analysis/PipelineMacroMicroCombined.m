%% %%%%% SPES Pipeline %%%%%% %%
%% %%%% known parameters %%%% %%
subjID = 'P12';
%%add 0010

switch subjID
    case 'P07'
        ID  = 'sub-0007';
        Project = 'Project0314';
    case 'P072'
        ID  = 'sub-0007';
        Project = 'Project0314';
    case 'P08'
        ID  = 'sub-0008';
        Project = 'Project0314';
    case 'P082'
        ID  = 'sub-0008';
        Project = 'Project0314';
    case 'P09'
        ID  = 'sub-0009';
        Project = 'Project0315';
    case 'P10'
        ID  = 'sub-0012';
        Project = 'Project0315';
    case 'P102'
        ID  = 'sub-0012';
        Project = 'Project0315';
    case 'P11'
        ID  = 'sub-0013';
        Project = 'Project0316';
    case 'P112'
        ID  = 'sub-0013';
        Project = 'Project0316';
    case 'P05'
        ID  = 'sub-0005';
        Project = 'Project0314';
    case 'P06'
        ID  = 'sub-0006';
        Project = 'Project0314';
    case 'P12'
        ID  = 'sub-0010';
        Project = 'Project0315';
end

%Datapath = ['\\raw.psy.gla.ac.uk\',Project,'\',ID, '\micro\',ID,'_task-spes'];
Datapath = ['//raw/',Project,'/',ID, '/micro/',ID,'_task-spes'];

if length(subjID) >= 4 
    ses = str2num(subjID(4));
else 
    ses = 1;
end 

switch subjID
    case 'P07'
        DataLocation  =  [Datapath,'/2017-05-03_13-22-25/'];
    case 'P072'
        DataLocation  =  [Datapath,'/2017-05-04_13-53-58/'];
    case 'P08'
        DataLocation  =  [Datapath,'/2017-06-06_10-12-13/'];
    case 'P082'
        DataLocation  =  [Datapath,'/2017-06-07_10-17-19/'];
    case 'P09'
        DataLocation  =  [Datapath,'/2017-08-31_13-10-20/'];
    case 'P10'
        DataLocation  =  [Datapath,'/2019-08-22_14-15-45/'];
    case 'P102'
        DataLocation  =  [Datapath,'/2019-08-28_13-24-08/'];
    case 'P11'
        DataLocation  =  [Datapath,'/2019-12-10_11-39-48/'];
    case 'P112'
        DataLocation  =  [Datapath, '/2019-12-17_14-49-15_matfiles/'];
    case 'P05'
        DataLocation  =  [Datapath, '/2016-12-06_10-29-05/'];
    case 'P06'
        DataLocation  =  [Datapath, '/2017-03-31_10-56-36/'];
    case 'P12'
        DataLocation  =  [Datapath, '/2017-10-05_14-18-37/'];
end

DataLocationIC = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
DataLocationMC = [Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID(1:3),'/Ses', num2str(ses),'/'];  

% trial-parameters
pre = 3;
post = 3;
% StimArtFig to explore uncut data
%[SR] = findSR(DataLocation); %Doublecheck the Sampling Rate
%% %%%% Preprocessing %%% %%
%% Read in the Data

[p2d] = DataLocation;
%ReadData        % Reads data: LFP data as CSCdat; Unsorted Spike data as SPKdat; SpikeSorted Data as SortedSPKdat, data always already lowpassfiltered at 300;
[CSCdatNF] = readinlfpnofilter(p2d, subjID); % Output: CSCdatNF | Read in data with no filtering
save([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID, '_Base','.mat'], 'CSCdatNF', '-v7.3')

[ CSCdatSPKint] = readinlfpnofilter(p2d, subjID); % Output: CSCdatNF | Read in data with no filtering
save([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID, '_BaseInt','.mat'], 'CSCdatSPKint', '-v7.3')

%% Create a trial Matrix for the Microwire data that later will be used to
% align to the Macrowire trailMatrix to the microwire data
LFPmicrofirstTrials

%% find trials in IEEG and use Macrodefinition on Microdata 
 %Output: CSCdatintNaNres and CSCdatintLinres | mark trials with databrowser, also resampling to 1000
IEEGfirstround

%% Processing and Analyses for MacroData
% Preprocessing 
IEEGpreProcessing
IEEGpreProcessingNF
IEEGpreProcessingLP

%% Micro Reject Artefacts
if exist('CSCdatPreProc', 'var') == 0
    SpkIntFil = sprintf(['LFP_IntL10T_%s_NoFilter.mat'], subjID);
    load([DataLocationMC, SpkIntFil])
    clear SpkIntFil
end 

Data = CSCdatPreProcNF;
LFPRejectartefactsNoZ % Output: CSCdatIED | Reject infestation of IED

%% Unify all Macro and Micro Data % use RedoAllMicroMacro as shortcut
PatientIDs = {'P07', 'P072', 'P08', 'P082', 'P09', 'P10', 'P102','P11','P112','P12','P06','P062'};
MakeAllMicroMacro(Basepath, PatientIDs)
%IEEGPreprocessingNF
%MakeAllMacroLP(Basepath, PatientIDs)

%% iEEGPreprocessingNoFilt for redo
%% Select Conditions and do Analyses
% clear
if ~exist('AllMacro', 'var')
    % load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroDataNF.mat'])
    load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroDataNF.mat'])
    load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroDataLP.mat'])
end

if ~exist('AllMicro', 'var')
    %load([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/MicroDataF.mat'])
    load([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/MicroData.mat'])
end

% Sort Data into the appropriate Bundles
[CSCHippCondLFP, ~, TrialSelCondLFP, TrialSelCondiEEG, ICConditions] = SelectedConditions_IEEG_I_LFP(AllMicro, AllMacro);

% Fixed Effect Analysis (Per Bundle)
[MicroStat, FreqDat{1,1}] = MicroData(Basepath, AllMicro, CSCHippCondLFP, TrialSelCondLFP);
[MicroStat, FreqDat{1,1}] = MicroDataSel(Basepath, AllMicro, CSCHippCondLFP, TrialSelCondLFP);
MircoWM(Basepath, AllMicro, CSCHippCondLFP, TrialSelCondLFP)
[MacroStat{1,1},MacroStat{1,2},FreqDat{1,2},FreqDat{1,3}] = MacroData(Basepath, AllMacro, ICConditions, TrialSelCondiEEG);

[CSCHippCondLFP, ~, TrialSelCondLFP, TrialSelCondiEEG, ICConditions] = SelectedConditions_IEEG_I_LFP(AllMicro, AllMacroLP);

% FOOOF Analysis
for x = 1:2
    [Aperiodic{1,x}, Periodic{1,x}] = PostFOOOFiEEG(Basepath,x);
    FQ{1,x} = FOOOFPlotsiEEG(Periodic{1,x}, Aperiodic{1,x},FreqDat{1,x});
end 

[Stats]= ERPCumSumSummaryFQ(Basepath, AllMicro, AllMacro, AllMacroLP, [0.026 1.026],0);

%%------------------------------------------------------------------------
%% SS = AllMicro.StimSite
subjIDspk =  {'sub-0007','sub-0008','sub-0009','sub-0012','sub-0013'};

SS = AllMacroLP.StimSite;

%% Spikes 
WaveClusPipline

%Import spikes
[SPKDat,SPKvars] = BatchImportSpikesWC(Basepath, subjIDspk,{'pos','neg'});  % Create variable containing all spike data
save([Basepath, 'Mircea/3 - SPES\Datasaves\','Sorted'], 'SPKDat','SPKvars', '-v7.3')

% Sanity Check to get a feel for the data
% RasterOfUnits(SPKDat{1,5}{1,1}, SPKvars{1,5}{1,1}) 

% Use Micro trial definition to create
for pn = 1:size(SPKDat,1)
    cnt = 1;
    for subj = 1:length(subjIDspk)
        for ses = 1:length(SPKDat{1,subj})
            if cnt == 2 || cnt == 4
                trldef = [(AllMicro.Session{1,cnt}.cfg.previous.previous.previous.trl(:, 1:3))*32 ,AllMicro.Session{1,cnt}.cfg.previous.previous.previous.trl(:,4)];
            elseif cnt == 6 || cnt == 7
                trldef = AllMicro.Session{1,cnt}.cfg.previous.previous.previous.trl;
            elseif cnt == 1               
                trldef = AllMicro.Session{1,cnt}.cfg.previous.previous.previous.previous.previous.trl;
            else
                trldef = AllMicro.Session{1,cnt}.cfg.previous.previous.trl;
            end
            SPKtrls{pn,subj}{1,ses} = make_SUA_trials(SPKDat{pn,subj}{1,ses}, SPKvars{pn,subj}{1,ses}, trldef);
            SPKtrls{pn,subj}{1,ses}.trialinfo = trldef(:,4);
            cnt = cnt + 1;
        end
    end
end

save([Basepath, 'Mircea/3 - SPES\Datasaves\','SpikeTrials'], 'SPKtrls', '-v7.3')

%% Select
for subjidx = 1:length(subjIDspk)
    for ses = 1:length(SPKtrls{1,subjidx})
        for chan = 1:length(SPKtrls{1,subjidx}{1,ses}.label)
            for pn = 1:size(SPKtrls,1)
                DataSUs{pn,subjidx}{1,ses}{1,chan} = SeparateSUnits(SPKtrls{pn,subjidx}{1,ses},chan);
%                 for su = 1:max(SPKtrls{1,subjidx}{1,ses}.unit{1,chan})
%                     RasterFromScratchSUA(DataSUs{pn,subjidx}{1,ses}{1,chan}{1,su},TRLCOND)
%                 end
            end
            DataSU{1,subjidx}{1,ses}{1,chan} = [DataSUs{1,subjidx}{1,ses}{1,chan},DataSUs{2,subjidx}{1,ses}{1,chan}];
        end
    end
end

[SUA,wSUA,TRLCOND,wTRLCOND] = SelectedConditions_wSUA(DataSU);

SUA.stimsite{1,1}{1,1} = SS{1,1};
SUA.stimsite{1,1}{1,2} = SS{1,2};
SUA.stimsite{1,2}{1,1} = SS{1,3};
SUA.stimsite{1,2}{1,2} = SS{1,4};
SUA.stimsite{1,3}{1,1} = SS{1,5};
SUA.stimsite{1,4}{1,1} = SS{1,6};
SUA.stimsite{1,4}{1,2} = SS{1,7};
SUA.stimsite{1,5}{1,1} = SS{1,8};
SUA.stimsite{1,5}{1,2} = SS{1,9};
SUA.stimsite{1,5}{1,2}.Labels;
wSUA.stimsite = SUA.stimsite;

save([Basepath, 'Mircea/3 - SPES\Datasaves\','SortedSpikes'], 'SUA','wSUA','TRLCOND','wTRLCOND', '-v7.3')

%%

param = [];
param.convol    = 50;
param.bswin     = (2000:2750);
param.stimwin   = 2950:3600;
param.maxpercentile     = 97.5;
param.minpercentile     = 2.5;
param.fs                = 1000;
param.trlsize           = 3;
param.clsize            = 50;
[SUAnERP,w] = SUAnalysis(SUA,Basepath,'pos', TRLCOND,0, param);
[wSUAnERP,ww] = SUAnalysis_w(wSUA,Basepath,'pos', wTRLCOND,0, param);
[SUAmERP{1,1}, Chanlist{1,1}] = SelectResponseMd(SUAnERP{1,1},param);
[SUAmERP{1,2}, Chanlist{1,2}] = SelectResponseMd(SUAnERP{1,2},param);
[SUAwERP{1,1}, wChanlist{1,1}] = SelectResponseMd(wSUAnERP,param);

SelDist

SUAplots

%% PhaseDep - Distal (macro)
PhaseDepPreProcLPnoSU
MacroPhaseDepCICA

[ctxICnoC, CutSUA, SUAlbl] = PhaseDepPreProcLP(Basepath);
save([Basepath,'Mircea\3 - SPES\Datasaves\PhasDepVars.mat'],'ctxICnoC','CutSUA','SUAlbl')
%for cluster work load in the variables directly 

savepath = [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDepSpk\Distal\'];
[DAllCorr,ShufCorr, DFR, DHB] = SUAPhaseDep(savepath, ctxICnoC, CutSUA, SUAlbl);
% savepath = [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDepSpk\PT\'];
% [DAllCorrpt, DFRpt, DHBpt] = SUAPhaseDepPerTrial(savepath, ctxICnoC, CutSUA, SUAlbl);

figure
for pp = 1:2
    for s = [1,2,3,5,6,7,8,9]
        AvgPhdSpk = DAllCorr{s,pp}(:);
        AvgPhdSpk = AvgPhdSpk(~cellfun('isempty',AvgPhdSpk));
        AvgPhdSpkM{s} = mean(cat(3,AvgPhdSpk{:}),3,'omitnan');
    end
    subplot(1,2,pp)
    imagesc(mean(cat(3,AvgPhdSpkM{:}),3,'omitnan'))
    colorbar
    title(max(max(AvgPhdSpkM{s})))
    
end
% savepath = [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDepSpk\Local\'];
% [DAllCorr, DFR, DHB] = SUAPhaseDep(savepath, ctxICnoC, CutSUA, SUAlbl)

%% PhaseDep - Local (Micro)
[HippLFP, CutSUAHipp, SUAlblH] = PhaseDepPreProcLmc(Basepath,AllMicro);
save([Basepath,'Mircea\3 - SPES\Datasaves\PhasDepVarsHipp.mat'],'HippLFP','CutSUAHipp','SUAlblH')
%for cluster work load in the variables directly 

savepath = [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDepSpk\Local\'];
[AllCorrH,ShufCorrH, DFRH, DHBH] = SUAPhaseDepH(savepath, HippLFP, CutSUAHipp, SUAlblH);
% savepath = [Basepath,'Mircea\3 - SPES\Datasaves\FIGS\PhaseDepSpk\PT\'];
% [DAllCorrpt, DFRpt, DHBpt] = SUAPhaseDepPerTrial(savepath, ctxICnoC, CutSUA, SUAlbl);

%% PhaseDep - Distal (Macro)
MacroPhaseDepCICA % main analysis
MacroPhaseDepICAControlFreq % control analysis