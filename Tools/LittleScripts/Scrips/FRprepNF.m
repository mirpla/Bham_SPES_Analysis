 function FRprepNF(Basepath, subjID,ses)
   
    % trial-parameters
    pre = 3;
    post = 3;

    DataLocationIC = [Basepath, '\Mircea\3 - SPES\Datasaves\Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    ICstim = [Basepath, 'Mircea\3 - SPES\Datasaves\Macro/stringstimsite/',subjID,'/' subjID,'_StimInfo.mat'];
    ICfile = [DataLocationIC, subjID,'_ICtrials.mat'];
    ArtPath = [DataLocationIC, subjID,'_ICartifactlist.mat'];
    load(ICstim)
    load(ICfile)
    if isfile(ArtPath)    
        load(ArtPath)
        noArtf = 0;
    else
        warning('No artefact file found, proceeding without it. Double check the no Trials were rejected as intended')
        noArtf = 1 ;
    end 
    clear ICstim ICfile
    
    %% make a trialinfo in the Datafile
    ICtrials.trialinfo = zeros(length(ICtrials.trial),1);
    for catgs =  1:length(StimSiteInfo.Indices)
        for catcond = 1:length(StimSiteInfo.Indices{1,catgs})
            ICtrials.trialinfo(StimSiteInfo.Indices{1,catgs}) = catgs.* ones(length(StimSiteInfo.Indices{1,catgs}),1);
        end
    end
    
    %% preprocessing with filtering for noise etc (probably remove padding and baseline window)
    
    cfg = [];
    cfg.demean = 'yes';   
    if strcmp(subjID, 'P10')
        ICtrials.label{90,1} = 'Dumvar';
%         cfg.channel = [1:56,58:65];
    elseif strcmp(subjID, 'P102')
        ICtrials.label{90,1} = 'Dumvar';
%         cfg.channel = [2:16,18:24,26:65];
    end 
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
    
    %% Rereference Electrodes Individually and split for conditions
    for i = 1:length(StimSiteInfo.TrialLabels)
        ICdataClean.trialinfo(i,1) = find(strcmp(StimSiteInfo.TrialLabels(1,i), char(StimSiteInfo.Labels)));
    end
    
    IEEGRereference
      
    %% Artifact rejection
    if noArtf == 0
        cfg_ICART.artfctdef.reject = 'complete';
        [ICdataArt]     = ft_rejectartifact(cfg_ICART,ICReref);
        
        cfg             = [];
        cfg.method      = 'channel';
        ICprocessed     = ft_rejectvisual(cfg, ICdataArt);
    else
        ICprocessed     = ICReref;
    end 
    
    filnam = [DataLocationIC, sprintf('%s_ProcessedNF', subjID)];
    save(filnam, 'ICprocessed', '-v7.3');
end