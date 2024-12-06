subjS = {'P07','P08','P09'};
for x = 1:length(subjS)
    subjID = subjS{x};
    
    if length(subjID) >= 4
        ses = 2;
    else
        ses = 1;
    end
    switch subjID
        case 'P04'
        case 'P05'
            DataLocation = [Basepath, 'Archive/MICRO/P05/STIM/2016-12-06_10-29-05/'];
        case 'P06'
            DataLocation = [Basepath, 'Archive/MICRO/P06/SPES/2017-03-31_10-56-36/'];
        case 'P07'
            DataLocation = [Basepath, 'Archive/MICRO/P07/SPES/2017-05-03_13-22-25/'];
        case 'P072'
            DataLocation = [Basepath, 'Archive/MICRO/P07/SPES/2017-05-04_13-53-58/'];
        case 'P08'
            DataLocation = [Basepath, 'Archive/MICRO/P08/SPES/2017-06-06_10-12-13/'];
        case 'P082'
            DataLocation = [Basepath, 'Archive/MICRO/P08/SPES/2017-06-07_10-17-19/'];
        case 'P09'
            DataLocation = [Basepath, 'Archive/MICRO/P09/SPES/2017-08-31_13-10-20/'];
    end
    
    DataLocationIC = [Basepath, 'Mircea/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    DataLocationMC = [Basepath, 'Mircea/Datasaves/Micro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    
    % trial-parameters
    pre = 3;
    post = 3;
    
    SpkIntFil = sprintf(['%s_Base.mat'], subjID);
    load([DataLocationMC, SpkIntFil], 'CSCdatSPKint')
    SpkIntFil = sprintf(['%s_trlMatrixes.mat'], subjID);
    load([DataLocationMC, SpkIntFil])
    
    %% Resampling of data
    
    cfg = [];
    cfg.resamplefs = 1e3;
    %cfg.detrend = 'yes';
    cfg.demean = 'yes';
    [CSCdatintLinres] = ft_resampledata( cfg, CSCdatSPKint);
    
    %% Lowpass filter
    cfg                 =   [];
    cfg.lpfilter        =   'yes';
    cfg.lpfreq          =   300;
    cfg.bsfilttype      =   'fir';
    cfg.demean          =   'yes';
    cfg.bsfilter        =   'yes';
    cfg.bsfreq          =   [48 52; 98 102; 148 152];
    CSCdatintLinpre = ft_preprocessing(cfg, CSCdatintLinres);
    
    clear CSCdatinLinres    
    %%
    newMTrlres = [floor(newMTrl(:,1:3)/32) newMTrl(:,4)];
    
    cfg = [];
    cfg.continuous = 'yes';
    cfg.trl = newMTrlres;
    
    [CSCdatIntNaN] = ft_redefinetrial( cfg, CSCdatintLinpre); % creation of dummy variable defined according to above trl
    clear  CSCdatSPKint
    clear CSCdatintLinpre
    
   
    % CSCdatintLinpre.trialLinNoise = CSCdatintLinpre.trial;
    %
    % for trls = 1:length(CSCdatintLinpre.trial)
    %     for chans = 1:length(CSCdatintLinpre.label)
    %         CSCdatintLinpre.trial{1,trls}(chans,:) = ft_preproc_dftfilter(CSCdatintLinpre.trialLinNoise{1,trls}(chans,:), 32000, [50, 100, 150], 'Flreplace', 'zero');
    %     end
    % end
    
    %% Cut the artifact out
    
    precut = 0.02 *CSCdatIntNaN.fsample; % how many ms cut before stimulus onset
    postcut = 0.024 * CSCdatIntNaN.fsample;
    %simplest way but updated to sampleinfo method
    % for i = 0:(length(CSCdatIntNaN.trial)-1)
    %     ArtArray(i+1,:) = [int32((3.001*CSCdatIntNaN.fsample)- precut)+int32(i*6.001*CSCdatIntNaN.fsample),  int32((3.001*CSCdatintLinres.fsample)+ postcut) + int32(i*6.001*CSCdatintLinres.fsample)];
    % end
    for i = 1:(length(CSCdatIntNaN.trial))
        ArtArray(i,:) = [(int32(CSCdatIntNaN.sampleinfo(i,1))+3001 - precut), (int32(CSCdatIntNaN.sampleinfo(i,1))+3001 + postcut)];
    end
    
    cfg = [];
    cfg.artfctdef.visual.artifact =  ArtArray;
    cfg.artfctdef.reject = 'nan';
    CSCdatPreProc = ft_rejectartifact(cfg, CSCdatIntNaN);
    
    %%
    
    filnam = sprintf('LFP_IntL10T_%s_FIR', subjID);
    save([DataLocationMC, filnam], 'CSCdatPreProc', '-v7.3');
    clearvars -except x subjS Basepath
end
subjS = {'P07','P08','P09'};
for x = 1:length(subjS)
    
    subjID = subjS{x};
    
    if length(subjID) >= 4
        ses = 2;
    else
        ses = 1;
    end
    
    switch subjID
        case 'P04'
        case 'P05'
            DataLocation = [Basepath, 'Archive/MICRO/P05/STIM/2016-12-06_10-29-05/'];
        case 'P06'
            DataLocation = [Basepath, 'Archive/MICRO/P06/SPES/2017-03-31_10-56-36/'];
        case 'P07'
            DataLocation = [Basepath, 'Archive/MICRO/P07/SPES/2017-05-03_13-22-25/'];
        case 'P072'
            DataLocation = [Basepath, 'Archive/MICRO/P07/SPES/2017-05-04_13-53-58/'];
        case 'P08'
            DataLocation = [Basepath, 'Archive/MICRO/P08/SPES/2017-06-06_10-12-13/'];
        case 'P082'
            DataLocation = [Basepath, 'Archive/MICRO/P08/SPES/2017-06-07_10-17-19/'];
        case 'P09'
            DataLocation = [Basepath, 'Archive/MICRO/P09/SPES/2017-08-31_13-10-20/'];
    end
    
    DataLocationIC = [Basepath, 'Mircea/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    DataLocationMC = [Basepath, 'Mircea/Datasaves/Micro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    
    % trial-parameters
    pre = 3;
    post = 3;
    
    SpkIntFil = sprintf(['%s_Base.mat'], subjID);
    load([DataLocationMC, SpkIntFil], 'CSCdatSPKint')
    SpkIntFil = sprintf(['%s_trlMatrixes.mat'], subjID);
    load([DataLocationMC, SpkIntFil])
    
    %% Resampling of data
    
    cfg = [];
    cfg.resamplefs = 1e3;
    %cfg.detrend = 'yes';
    %cfg.demean = 'yes';
    [CSCdatintLinpre] = ft_resampledata( cfg, CSCdatSPKint);
        
    clear CSCdatinLinres    
    %%
    newMTrlres = [floor(newMTrl(:,1:3)/32) newMTrl(:,4)];
    
    cfg = [];
    cfg.continuous = 'yes';
    cfg.trl = newMTrlres;
    
    [CSCdatIntNaN] = ft_redefinetrial( cfg, CSCdatintLinpre); % creation of dummy variable defined according to above trl
    clear  CSCdatSPKint
    clear CSCdatintLinpre
   
  
    
    %% Cut the artifact out
    
    precut = 0.02 *CSCdatIntNaN.fsample; % how many ms cut before stimulus onset
    postcut = 0.024 * CSCdatIntNaN.fsample;
    %simplest way but updated to sampleinfo method
    % for i = 0:(length(CSCdatIntNaN.trial)-1)
    %     ArtArray(i+1,:) = [int32((3.001*CSCdatIntNaN.fsample)- precut)+int32(i*6.001*CSCdatIntNaN.fsample),  int32((3.001*CSCdatintLinres.fsample)+ postcut) + int32(i*6.001*CSCdatintLinres.fsample)];
    % end
    for i = 1:(length(CSCdatIntNaN.trial))
        ArtArray(i,:) = [(int32(CSCdatIntNaN.sampleinfo(i,1))+3001 - precut), (int32(CSCdatIntNaN.sampleinfo(i,1))+3001 + postcut)];
    end
    
    cfg = [];
    cfg.artfctdef.visual.artifact =  ArtArray;
    cfg.artfctdef.reject = 'nan';
    CSCdatPreProc = ft_rejectartifact(cfg, CSCdatIntNaN);
    
    %%
    
    filnam = sprintf('LFP_IntL10T_%s_NoFilter', subjID);
    save([DataLocationMC, filnam], 'CSCdatPreProc', '-v7.3');
    clearvars -except x subjS Basepath
end