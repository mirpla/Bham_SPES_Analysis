DataLocationIC = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/']; 
ICstim = [Basepath, 'Mircea\3 - SPES\Datasaves/Macro/stringstimsite/',subjID,'/' subjID,'_StimInfo.mat'];
ICfile = [DataLocationIC, subjID,'_ICtrials.mat'];
load(ICstim)
load(ICfile)
clear ICstim ICfile

if strcmp(subjID, 'P10') || strcmp(subjID, 'P102')
     ICtrials.label{91} = 'U';
end 

%% make a trialinfo in the Datafile
ICtrials.trialinfo = zeros(length(ICtrials.trial),1);
for catgs =  1:length(StimSiteInfo.Indices)
    for catcond = 1:length(StimSiteInfo.Indices{1,catgs})
        ICtrials.trialinfo(StimSiteInfo.Indices{1,catgs}) = catgs.* ones(length(StimSiteInfo.Indices{1,catgs}),1);
    end 
end

%% preprocessing with filtering for noise etc (probably remove padding and baseline window)

cfg = [];
cfg.demean			=	'yes';
%cfg.baselinewindow	=	'all';
cfg.lpfilter		=	'yes';
cfg.lpfreq			=	300;
cfg.bsfilter        =   'yes';
cfg.bsfreq          =   [48 52; 98 102; 148 152];
%cfg.bsfilttype      =   'but';  

ICpreproc	=	ft_preprocessing(cfg, ICtrials);

%% remove Stimulation artefact of stimulation
fsample =  round(ICpreproc.fsample);

precut = 0.02 *fsample; % how many ms cut before stimulus onset
postcut = 0.024 * fsample;

for i = 1:length(ICpreproc.trial)
    ArtArray(i,:) = [round((3.0*fsample)- precut)+(ICpreproc.sampleinfo(i,1)),  round((3*fsample)+ postcut) + (ICpreproc.sampleinfo(i,1))];
end 

cfg = [];
cfg.artfctdef.visual.artifact =  ArtArray;
cfg.artfctdef.reject = 'nan';
ICdataClean = ft_rejectartifact(cfg, ICpreproc);
% 
% cfg             =	[];
% cfg.viewmode	=	'vertical';
% ft_databrowser(cfg,	ICtrialsCh);


%% Rereference Electrodes Individually and split for conditions
for i = 1:length(StimSiteInfo.TrialLabels)
    ICdataClean.trialinfo(i,1) = find(strcmp(StimSiteInfo.TrialLabels(1,i), char(StimSiteInfo.Labels)));
end

%IEEGRereference
IEEGRereferenceLaplace

%% Artifact rejection

cfg             =	[];
cfg.viewmode	=	'vertical';
cfg.allowoverlap = 'yes';   
cfg_ICART       =	ft_databrowser(cfg,	ICReref);

cfg_ICART.artfctdef.reject = 'complete';
[ICdataArt]     = ft_rejectartifact(cfg_ICART,ICReref);

cfg             = [];
cfg.method      = 'channel';
ICprocessedLP     = ft_rejectvisual(cfg, ICdataArt);


%% Repeated Artifact Rejection
%  cfg          = [];
%  cfg.method   = 'summary';
%  ICprocessed  = ft_rejectvisual(cfg,ICReref);

%% Save Relevant Variables
% filnam = [DataLocationIC, sprintf('%s_ICartifactlist', subjID)];
% save(filnam, 'cfg_ICART');

filnam = [DataLocationIC, sprintf('%s_ProcessedLP', subjID)];
save(filnam, 'ICprocessedLP', '-v7.3');

