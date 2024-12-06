%% Databrowser Mark trials with databrowser
ICfile = [DataLocationIC, subjID,'_IC.mat']; % change path

%% Load the data
load(ICfile) 
clear ICfile 
clear ICDatafile

if exist('IC2', 'var')
    IC = IC2;
    clear IC2
end 
%% Check whether samples start at 0 or not
if IC.sampleinfo <=2 
    InfoSI = 1;
else 
    InfoSI = 0;
end 
if InfoSI == 0
    sampleinfoOriginal = IC.sampleinfo;
    IC.sampleinfo = [0, length(IC.time{1,1})-1];
    InfoSI = 1;
end
%% For the datasets of patient 7 the channel labels have to be changed
RewriteLabels

%% Macro Stimulation sites and Label creation for conditions
findstimsiteNeighMax

%% Crosscorrelate Macro and Micro stimulation trials
if ~strcmp(subjID, 'P06')
    LFPlabelIndxHPeak
else 
    LFPlabelIndxHPeakSplit
end