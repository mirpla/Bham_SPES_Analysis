%% Subsequent Memory Power Analysis
% This script aims to identify the differences in neocortical (NC) and
% medial temporal (MTL) power between later remembered and later forgotten
% pairs.
clearvars
close all
clc

% define key directory
home_dir = 'Y:/George/hippcortex-interactions-original';
data_dir = 'Y:/George/Data';

D_patient = dir(data_dir); p_N = []; err = [];
for d = 1:length(D_patient)
    if(contains(D_patient(d).name, 'P') == 1 && contains(D_patient(d).name, 'ERL') ~= 1)
        p_N = [p_N; str2double(D_patient(d).name(end))];
        %p_N = [p_N; str2double(D_patient(d).name(3))];
    end
end
p_N(isnan(p_N)==1) = []; p_t = [];
% load peak frequencies
load([home_dir,'\peak_frequencies.mat'])

% add subfunctions
addpath([home_dir,'\additional_functions'])

% define key parameters
%subj_no = 1:8;

%% Get Time-Frequency Data
% cycle through every participant
for p = 1:length(p_N)
    try 
        disp(['LOADING LOCALISED ELECTRODES for P' int2str(p_N(p))]);
        [~,~,xcl_data] = xlsread([data_dir '/electrode_coords_v5_postMatlab.xlsx'], sprintf('P0%d', p_N(p)));
        xcl_data = xcl_data(3:end, :);
        x = find(cellfun(@ischar, xcl_data(:,1))==0, 1, 'first');
        if(isempty(x) ~= 1); xcl_data = xcl_data(1:x-1,:); end
    catch; err = 'ELECTRODES NOT YET LOCALISED';
    end
    try 
        disp(['LOADING DATA for P' int2str(p_N(p))]);
        load([data_dir '/P' int2str(p_N(p)) '/restructured_data.mat']);
        %load([data_dir '/p0' int2str(p_N(p)) '.mat']);
    catch; err = 'DATA NOT YET RE-STRUCTURED'; 
    end
    if(isempty(err) == 1)
        p_t = [p_t; p_N(p)];
        disp(['EXTRACTING CONTACT LOCATIONS for P' int2str(p_N(p))]);
        contact_locations = zeros(length(data{1}.label), 3); 
        for i = 1:length(data{1}.label)
            c_i = contains(xcl_data(:, 17), data{1}.label{i});
            if(sum(c_i) ~= 0); contact_locations(i, :) = cell2mat(xcl_data(c_i, 18:20)); end
        end
        % pre-define cell for time-frequency data
        freq = cell(size(data));

        % predefine time window of interest based on encoding/retrieval data
        toi{1} = 0 : 0.025 : 1.5;
        toi{2} = 0 : 0.025 : 1.5;

        % cycle through encoding and retrieval data
        for di = 1 : numel(data)

            % --- get time-frequency data --- %
            % calculate time-frequency
            cfg            = [];
            cfg.keeptrials = 'yes';
            cfg.method     = 'wavelet'; 
            cfg.width      = 5; 
            cfg.output     = 'pow';	
            cfg.pad        = 'nextpow2';
            cfg.foi        = 1 : 0.5 : 100;          
            cfg.toi        = toi{di};
            freq           = ft_freqanalysis(cfg, data{di});

            % subtract 1/f noise
            cfg         = [];
            cfg.toi     = [toi{di}(1) toi{di}(end)];
            freq        = sd_subtr1of(cfg, freq);

            % z-transform across frequencies
            freq        = sd_ztransform_freq(freq);

            % smooth data
            cfg         = [];
            cfg.fwhm_t  = 0.2;
            cfg.fwhm_f  = 1;
            freq        = smooth_TF_GA(cfg,freq);

            % --- split by trial type --- %
            % select hits
            cfg        = [];
            cfg.trials = freq.trialinfo == 1;
            freqtmp{1} = ft_selectdata(cfg,freq);

            % select misses
            cfg        = [];
            cfg.trials = freq.trialinfo == 0;
            freqtmp{2} = ft_selectdata(cfg,freq);

            % average over trials
            cfg        = [];
            freqtmp{1} = ft_freqdescriptives(cfg, freqtmp{1});
            freqtmp{2} = ft_freqdescriptives(cfg, freqtmp{2});

            % --- split into peak frequencies --- %
            % define frequency fields
            freq_field = fieldnames(peak_frequencies);

            % define temporary cell for frequency data
            tmp = cell(numel(freq_field),numel(freqtmp));

            % cycle through hits and misses
            for hi = 1 : numel(freqtmp)

                % cycle through each frequency band
                for fi = 1 : numel(freq_field)

                    % for bands with no peak frequency, replace with NaNs
                    if any(isnan(peak_frequencies.(freq_field{fi})(subj,:)))

                        % select frequencies between sidebands defined in [peak_frequencies] and average
                        cfg             = [];
                        cfg.frequency   = round(nanmean(peak_frequencies.(freq_field{fi})));
                        cfg.avgoverfreq = 'yes';
                        tmp{fi,hi}      = ft_selectdata(cfg, freqtmp{hi});

                        % swap out for NaNs
                        tmp{fi,hi}.powspctrm = nan(size(tmp{fi,hi}.powspctrm));

                    % for every other band, select peak frequencies
                    else
                        % select frequencies between sidebands defined in [peak_frequencies] and average
                        cfg             = [];
                        cfg.frequency   = peak_frequencies.(freq_field{fi})(subj,:);
                        cfg.avgoverfreq = 'yes';
                        tmp{fi,hi}      = ft_selectdata(cfg, freqtmp{hi});
                    end
                end

                % append frequencies
                cfg             = [];
                cfg.parameter   = 'powspctrm';
                cfg.appenddim   = 'freq';
                freqtmp{hi}     = ft_appendfreq(cfg,tmp{:,hi});

                % re-value frequencies for consistency across participants
                freqtmp{hi}.freq   = [4 10 60 45];
            end  

            % --- split by channels --- %
            % define roi fields
            chan_field = fieldnames(contact_locations);

            % define temporary cell for frequency data
            tmp = cell(numel(chan_field),numel(freqtmp));

            % cycle through hits and misses
            for hi = 1 : numel(freqtmp)

                % cycle through each roi
                for ci = 1 : numel(chan_field)

                    % select frequencies between sidebands define in [para] and average
                    cfg             = [];
                    cfg.channel     = freqtmp{hi}.label(contact_locations.(chan_field{ci}){subj,1});
                    cfg.avgoverchan = 'yes';
                    tmp{ci,hi}      = ft_selectdata(cfg, freqtmp{hi});
                end

                % append channels
                cfg             = [];
                cfg.parameter   = 'powspctrm';
                cfg.appenddim   = 'chan';
                freqtmp{hi}     = ft_appendfreq(cfg,tmp{:,hi});

                % re-value frequencies for consistency across participants
                freqtmp{hi}.label = chan_field;
                freqtmp{hi}.cfg   = [];
            end   

            % rename freqtmp into more readable variables
            freq_hits 	= freqtmp{1};
            freq_misses = freqtmp{2};

            % save data
            if di == 1; save([data_dir,'\data\power\pp',num2str(subj),'_freq_encoding.mat'],'freq_hits','freq_misses');
            else; save([data_dir,'\data\power\pp',num2str(subj),'_freq_retrieval.mat'],'freq_hits','freq_misses');
            end

            % clear all non-essential variables
            keep home_dir data_dir peak_frequencies contact_locations subj_no subj toi data
        end   
    else; disp([err ' for P' int2str(p_N(p))]);
    end
    
    % clear subject data
    clear data toi
end

%% Calculate Group Averages
% define encoding and retrieval file labels
file_label = {'encoding','retrieval'};

% cycle through each file label
for fi = 1 : numel(file_label)

    % create group cell
    group_freq = cell(max(subj_no),2);

    % cycle through each participant
    for subj = subj_no

        % load data
        load([data_dir,'\data\power\pp',num2str(subj),'_freq_',file_label{fi},'.mat']);

        % add hits and misses to group structure
        group_freq{subj,1} = freq_hits;
        group_freq{subj,2} = freq_misses;
    end

    % get grand average
    grand_freq          = cell(2,1);
    cfg                 = [];
    cfg.keepindividual  = 'yes';
    for di = 1 : size(group_freq,2)
        grand_freq{di,1} = ft_freqgrandaverage(cfg,group_freq{subj_no,di});
        grand_freq{di,1}.cfg = [];
    end

    % save
    save([data_dir,'\data\power\grand_',file_label{fi},'.mat'],'grand_freq')

    % clear all non-essential variables
    keep home_dir data_dir peak_frequencies contact_locations subj_no file_label
end

%% Run Inferential Statistics
% define encoding and retrieval file labels
file_label = {'encoding','retrieval'};

% create stat cell
p_fdr	= nan(2,2,7);
d       = nan(2,2,7);

% cycle through each file label
for fi = 1 : numel(file_label)
    
    % load data
    load([data_dir,'\data\power\grand_',file_label{fi},'.mat'])

    % downsample time domain
    cfg             = [];
    cfg.win_dur     = 0.2;
    cfg.toi         = [grand_freq{1}.time(1) grand_freq{1}.time(end)];
    grand_freq{1}   = sd_downsample_freq(cfg,grand_freq{1});
    grand_freq{2}   = sd_downsample_freq(cfg,grand_freq{2});
    
    % create design matrix
    design      = [];
    design(1,:) = [1:size(grand_freq{1}.powspctrm,1), 1:size(grand_freq{1}.powspctrm,1)];
    design(2,:) = [ones(1,size(grand_freq{1}.powspctrm,1)) ones(1,size(grand_freq{1}.powspctrm,1))+1];
    
    % define default statistic configuration
    cfg                     = [];
    cfg.method              = 'montecarlo';
    cfg.statistic           = 'ft_statfun_depsamplesT';
    cfg.correctm            = 'no'; % use fdr function to get adjusted p-values
    cfg.alpha               = 0.05;
    cfg.numrandomization    = 5000;
    cfg.design              = design;
    cfg.ivar                = 2;
    cfg.uvar                = 1;
    
    % --- test atl alpha/beta desync. --- %
    cfg.frequency           = [9 11];
    cfg.tail                = -1;
    cfg.channel             = 'atl';
    stat                    = ft_freqstatistics(cfg,grand_freq{1},grand_freq{2});
      
    % extract fdr corrected p-value
    [~,~,p_fdr(fi,1,:)] = fdr(squeeze(stat.prob));
    
    % calculate cohen's d
    for t = 1 : numel(grand_freq{1}.time)
        d(fi,1,t)           = computeCohen_d(squeeze(grand_freq{1}.powspctrm(:,1,2,t)),...
                                             squeeze(grand_freq{2}.powspctrm(:,1,2,t)),'paired');
    end
    
    % --- test ptpr alpha/beta desync. --- %
    cfg.frequency           = [9 11];
    cfg.tail                = -1;
    cfg.channel             = 'nc';
    stat                    = ft_freqstatistics(cfg,grand_freq{1},grand_freq{2});
      
    % extract fdr corrected p-value
    [~,~,p_fdr(fi,2,:)] = fdr(squeeze(stat.prob));
    
    % calculate cohen's d
    for t = 1 : numel(grand_freq{1}.time)
        d(fi,2,t)           = computeCohen_d(squeeze(grand_freq{1}.powspctrm(:,3,2,t)),...
                                             squeeze(grand_freq{2}.powspctrm(:,3,2,t)),'paired');
    end    
end

% --- read out significance --- %
trl_label  = {'Encoding','Retrieval'};
chan_label = {'ATL','PTPR'};

% cycle through encoding/retrieval
for ti = 1 : numel(trl_label)
    
    % cycle through channels
    for ci = 1 : numel(chan_label)
        
        % find pfdr < 0.05
        idx = find(p_fdr(ti,ci,:) <= 0.05);
                
        % cycle through each index
        if ~isempty(idx)
            for i = 1:numel(idx)
                fprintf('%s in %s: p = %3.3f, d = %3.3f\n',trl_label{ti},chan_label{ci},p_fdr(ti,ci,idx(i)),abs(d(ti,ci,idx(i))));
            end   
        end
    end
end

% save
save([data_dir,'\data\power\stat_neocorticalAlphaBeta.mat'],'p_fdr','d')

% clear all non-essential variables
keep home_dir data_dir peak_frequencies contact_locations subj_no p_fdr d
