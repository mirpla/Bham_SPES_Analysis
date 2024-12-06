
cfg = [];
cfg.viewmode = 'vertical';
cfg.allowoverlap = 'true';
[cfg_art] = ft_databrowser(cfg, Data);

cfg_art.artfctdef.reject = 'complete';
[CSCdatIEDchan] = ft_rejectartifact(cfg_art,Data);
IEDTrial = CSCdatIEDchan.cfg.trl;


cfg = [];
cfg.method = 'channel';
CSCdatIED = ft_rejectvisual(cfg, CSCdatIEDchan);

%%

filnam = sprintf('ArtDef%s(IEDTrial)', subjID);
save([DataLocationMC, filnam], 'IEDTrial');

filnam = sprintf('LFP_artT_%s', subjID);
save([DataLocationMC, filnam], 'CSCdatIED');

% 
clear CSCdatIEDchan
clear CSCdatPreProc

%% MEH

% cfg = [];
% cfg.trl = IEDTrial;
% CSCdatIEDchan = ft_redefinetrial(cfg, Data);


% %% IF REPEAT FAST LANE
% 
% 
% cfg = [];
% cfg.continuous = 'yes';
% cfg.trl = newMTrl;
% 
% [CSCdatIntNaN] = ft_redefinetrial( cfg, CSCdatSPKint); % creation of dummy variable defined according to above trl
% clear  CSCdatSPKint
% 
% filnam = sprintf('%s_trlMatrixes', subjID);
% save(filnam, 'newMTrl', 'newMicroTrl', 'newMicroRTrl','deftrial');
% 
% %% Lowpass filter
% cfg = [];
% cfg.lpfilter = 'yes';
% cfg.lpfreq = 300;
% cfg.lpfilttype = 'fir';
% cfg.demean = 'yes';
% cfg.dftfilter = 'yes';
% CSCdatintLinpre = ft_preprocessing(cfg, CSCdatIntNaN);
% % CSCdatintLinpre.trialLinNoise = CSCdatintLinpre.trial;
% % 
% % for trls = 1:length(CSCdatintLinpre.trial)
% %     for chans = 1:length(CSCdatintLinpre.label)
% %         CSCdatintLinpre.trial{1,trls}(chans,:) = ft_preproc_dftfilter(CSCdatintLinpre.trialLinNoise{1,trls}(chans,:), 32000, [50, 100, 150], 'Flreplace', 'zero');
% %     end
% % end
% 
% clear CSCdatIntNaN
% 
% %% Resampling of data
% 
% cfg = [];
% cfg.resamplefs = 1e3;
% %cfg.detrend = 'yes';
% cfg.demean = 'yes';
% [CSCdatintLinres] = ft_resampledata( cfg, CSCdatintLinpre);
% clear CSCdatintLinpre
% 
% %% Cut the artifact out
% 
% precut = 0.02 *CSCdatintLinres.fsample; % how many ms cut before stimulus onset
% postcut = 0.024 * CSCdatintLinres.fsample;
% 
% for i = 0:length(CSCdatintLinres.trial)-1
%     ArtArray(i+1,:) = [((3.001*CSCdatintLinres.fsample)- precut)+(i*6.001*CSCdatintLinres.fsample),  ((3.001*CSCdatintLinres.fsample)+ postcut) + (i*6.001*CSCdatintLinres.fsample)];
% end 
% 
% cfg = [];
% cfg.artfctdef.visual.artifact =  ArtArray;
% cfg.artfctdef.reject = 'nan';
% CSCdatPreProc = ft_rejectartifact(cfg, CSCdatintLinres);
% 
% 
% clear CSCdatintLinres
% 
% 
% %%
% 
% filnam = sprintf('LFP_IntL10T_%s', subjID);
% save(filnam, 'CSCdatPreProc');
% 
% 
% 
% %% free up space
% clear redCSCdat
% clear dumCSC
% clear newdumCSC
% clear CSCdatIntNaN
% clear CSCdatintLinpre
% clear CSCdatintLin
% clear CSCdatNF
% clear CSCdatSPKint
% 
% %%
% Data = CSCdatPreProc;
% 
% %% 
% cfg          = [];
% cfg.method   = 'summary';
% cfg.alim     = 1e-12; 
% CSCdatIED     = ft_rejectvisual(cfg,Data); 

% %%
% 
% % filnam = sprintf('ArtDef%s(IEDTrial)', subjID);
% % save(filnam, 'IEDTrial');
% 
% filnam = sprintf('LFP_artT_%s', subjID);
% save(filnam, 'CSCdatIED');
% 
% % 
% clear CSCdatIEDchan
% clear CSCdatPreProc
% 
% % plot(CSCdatIED.time{1,1}, CSCdatIED.trial{1,1})
% % xlim([-0.02 0.02])
