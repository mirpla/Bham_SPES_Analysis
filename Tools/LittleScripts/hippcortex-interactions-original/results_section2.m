%% Resonating Frequency Analysis
% This script aims to identify the differences in neocortical (NC) and
% hippocampal resonating frequencies.

clearvars
close all
clc

% define key directory
home_dir = 'Y:/George/hippcortex-interactions-original';
data_dir = 'Y:/George/Data';

if(exist([data_dir '/Frequency Analysis'], 'dir') ~= 7)
    mkdir([data_dir '/Frequency Analysis'])
end

D_patient = dir(data_dir); p_N = []; err = [];
for d = 1:length(D_patient)
    if(contains(D_patient(d).name, 'P') == 1 && contains(D_patient(d).name, 'ERL') ~= 1)
        p_N = [p_N; str2double(D_patient(d).name(end))];
    end
end
p_N(isnan(p_N)==1) = []; p_t = [];

% add subfunctions
addpath([home_dir '/additional_functions'])

%% Get Time-Frequency Spectrum
% cycle through every participant
for p = 1 : length(p_N)
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
        load([data_dir '/P' int2str(p_N(p)) '/cleaned_data.mat']);
    catch; err = 'DATA NOT YET CLEANED'; 
    end
    if(isempty(err) == 1)
        p_t = [p_t; p_N(p)];
        % TAKE SUB-SET OF CHANNELS BASED ON ORIGINAL DATA
        % ['Y:/George/Data/P' int2str(p_N(p)) '/ERP_labels.mat']
        % ['Y:/George/Original Data/P0' int2str(p_N(p)) '_labs.mat']
        if(exist(['Y:/George/Data/P' int2str(p_N(p)) '/ERP_labels.mat'], 'file') == 2)
            load(['Y:/George/Data/P' int2str(p_N(p)) '/ERP_labels.mat'])
            cfg = []; cfg.channel = data.label(contains(data.label, ERP_labs));
            data = ft_selectdata(cfg, data);
        end
        
        disp(['EXTRACTING CONTACT LOCATIONS for P' int2str(p_N(p))]);
        contact_locations = zeros(length(data.label), 3); 
        for i = 1:length(data.label)
            c_i = contains(xcl_data(:, 17), data.label{i});
            if(sum(c_i) ~= 0); contact_locations(i, :) = cell2mat(xcl_data(c_i, 18:20)); end
        end
        
        % EXTRACT ENC/RET TRIALS & RE-WRITE TRIAL-INFO
        disp(['EXTRACTING ENCODING/RETRIEVAL TRIALS for P' int2str(p_N(p))]);
        i = zeros(length(data.trial), 5); 
        for t = 1:length(data.trial) 
            i_t = data.trialinfo{t}.trial_n + data.trialinfo{t}.session * 1000; % trial n
            if(strcmp(data.trialinfo{t}.operation, 'encoding') == 1); i(t, 1) = 1; % ENC
            elseif(sum(data.trialinfo{t}.recall_success) == 2); i(t, 2) = i_t; % RET 2/2
            elseif(sum(data.trialinfo{t}.recall_success) == 1); i(t, 3) = i_t; % RET 1/2
            elseif(sum(data.trialinfo{t}.recall_success) == 0); i(t, 4) = i_t; % RET 0/2
            end
        end
        for t = 1:length(data.trial)
            i_t = data.trialinfo{t}.trial_n + data.trialinfo{t}.session * 1000; % trial n
            if(ismember(i_t, i(:, 2)) == 1); i(t, 5) = 1; % RET 2/2
            elseif(ismember(i_t, i(:, 3)) == 1); i(t, 5) = NaN; % RET 1/2
            elseif(ismember(i_t, i(:, 4)) == 1); i(t, 5) = 0; % RET 0/2
            end
        end
        data.trialinfo = i(:,5);
        
        enc_i = i(:, 1) == 1; ret_i = i(:, 1) == 0;
        % EXTRACT RETRIEVAL
        cfg = []; cfg.trials = enc_i; data_t{1} = ft_selectdata(cfg, data);
        % EXTRACT ENCODING
        cfg = []; cfg.trials = ret_i; data_t{2} = ft_selectdata(cfg, data);
        
        data = data_t; clear data_t;
        save([data_dir '/P' int2str(p_N(p)) '/restructured_data.mat'], 'data');
        
        % pre-define cell for time-frequency data
        freq = cell(size(data));

        % predefine time window of interest based on encoding/retrieval data
        toi{1} = 0 : 0.025 : 1.5; % encoding period
        toi{2} = 0 : 0.025 : 1.5; % retrieval period

        % cycle through encoding and retrieval data
        for di = 1 : numel(data)
            disp(['CALCULATING TIME-FREQUENCY for P' int2str(p_N(p))]);
            % calculate time-frequency
            cfg            = [];
            cfg.keeptrials = 'yes';
            cfg.method     = 'wavelet';
            cfg.width      = 5;
            cfg.output     = 'pow';	
            cfg.pad        = 'nextpow2';
            cfg.foi        = 1 : 0.5 : 100;          
            cfg.toi        = toi{di};
            freq{di}       = ft_freqanalysis(cfg, data{di});

            disp(['REMOVING 1/f for P' int2str(p_N(p))]);
            % subtract 1/f noise
            cfg         = [];
            cfg.toi     = [toi{di}(1) toi{di}(end)];
            freq{di}    = sd_subtr1of(cfg, freq{di});

            disp(['SMOOTHING DATA for P' int2str(p_N(p))]);
            % smooth data
            cfg         = [];
            cfg.fwhm_t  = 0.2;
            cfg.fwhm_f  = 1;
            freq{di}    = smooth_TF_GA(cfg,freq{di});

            % rename time bins for consistency between encoding and retrieval
            freq{di}.time = linspace(0,1,numel(freq{di}.time));
            freq{di}.freq = linspace(round(freq{di}.freq(1)),round(freq{di}.freq(end)),numel(freq{di}.freq));
        end

        % tidy up
        clear cfg di toi data data_t
        Wm_i = contains(freq{1}.label, 'Wmat');

        % concatenate over trials
        cfg            	= [];
        cfg.parameter  	= 'powspctrm';
        freqtmp      	= ft_appendfreq(cfg,freq{:});

        % select hippocampus (averaging over contacts, trials and time)
        disp(['SELECTING HIPPOCAMPAL DATA for P' int2str(p_N(p))]);
        cfg             = [];
        cfg.avgovertime	= 'yes';
        cfg.avgoverrpt	= 'yes';
        cfg.avgoverchan = 'yes';
        cfg.nanmean     = 'yes';
        cfg.channel     = freqtmp.label(contact_locations(:,3)==1 & Wm_i==0);
        if(isempty(cfg.channel) ~= 1)
            freq_roi{1,1} = ft_selectdata(cfg,freqtmp);
        else; freq_roi{1,1} = [];
        end

        % select ATL (averaging over contacts, trials and time)
        disp(['SELECTING ATL DATA for P' int2str(p_N(p))]);
        cfg             = [];
        cfg.avgovertime	= 'yes';
        cfg.avgoverrpt	= 'yes';
        cfg.avgoverchan = 'yes';
        cfg.nanmean     = 'yes';
        cfg.channel     = freqtmp.label(contact_locations(:,1)==1 & Wm_i==0);
        if(isempty(cfg.channel) ~= 1)
            freq_roi{2,1} = ft_selectdata(cfg,freqtmp);
        else; freq_roi{2,1} = [];
        end

        % select PTPR (averaging over contacts, trials and time)
        disp(['SELECTING PTPR DATA for P' int2str(p_N(p))]);
        cfg             = [];
        cfg.avgovertime	= 'yes';
        cfg.avgoverrpt	= 'yes';
        cfg.avgoverchan = 'yes';
        cfg.nanmean     = 'yes';
        cfg.channel     = freqtmp.label(contact_locations(:,2)==1 & Wm_i==0);
        if(isempty(cfg.channel) ~= 1)
            freq_roi{3,1} = ft_selectdata(cfg,freqtmp);
        else; freq_roi{3,1} = [];
        end

        % save data
        save([data_dir '/Frequency Analysis/P' int2str(p_N(p)) '_freq_roi.mat'], 'freq_roi');
    else; disp([err ' for P' int2str(p_N(p))]);
    end
end

%% Get Grand Average
% get roi names
rN = {'hippo','atl','ptpr'};
p_N = p_N(ismember(p_N, p_t));

% pre-define cell to hold group data
group_roi = cell(length(p_N), numel(rN), 1);
g_i = cell(1, 3); for i=1:3; g_i{i} = []; end
% cycle through every participant
for p = 1 : length(p_N)
    % load data
    load([data_dir '/Frequency Analysis/P' int2str(p_N(p)) '_freq_roi.mat'])
    % cycle through each roi
    for ri = 1 : size(freq_roi,1)
        % add subject data to group cell
        group_roi{p,ri} = freq_roi{ri,1};
        if(isempty(group_roi{p,ri}) ~= 1)
            g_i{ri} = [g_i{ri} p];
        end
        % rename contact to conform across subject
        group_roi{p,ri}.label{1} = rN{ri};
    end
end

%% FIND GRAND AVERAGE & PLOT FIGURE
% pre-define cell to hold grand-averaged data
grand_roi = cell(size(group_roi,2),1);
fig = figure(); set(fig, 'position', [0 0 1000 500])
sp = 1 : length(p_N)*3; sp(rem(sp,3)==0) = [];
col_sh = {[0.9 0.7 0.7], [0.6 0.6 1],  [0.6 0.8 0.6]};
col_ln = {[0.8 0.3 0.3], [0.3 0.3 1],  [0.3 0.6 0.3]};
h = zeros(1,3);

for ri = fliplr(1 : size(grand_roi,1))
% calculate grand average
    cfg                 = [];
    cfg.keepindividual  = 'yes';
    grand_roi{ri,1}     = ft_freqgrandaverage(cfg,group_roi{g_i{ri},ri});

    grand_roi{ri,1}.powspctrm = single(grand_roi{ri,1}.powspctrm);
    grand_roi{ri,1}.freq      = single(grand_roi{ri,1}.freq);
    grand_roi{ri,1}.cfg       = [];
    
    %[L, U, M] = bootstrap(squeeze(grand_roi{ri}.powspctrm), 10000, []);
    M = mean( squeeze( grand_roi{ri}.powspctrm ) );
    SD = std( squeeze( grand_roi{ri}.powspctrm ) ) / sqrt( size( grand_roi{ri}.powspctrm, 1 ));
    F = grand_roi{ri}.freq;
    F(isnan(M)==1) = []; SD(isnan(M)==1) = []; M(isnan(M)==1) = [];
    L = M - SD; U = M + SD;
    subplot(length(p_N), 3, sp); hold on; 
    h(ri) = fill([F fliplr(F)], [L fliplr(U)], col_sh{ri}, 'edgecolor', col_ln{ri});
    plot(F, M, 'color', col_ln{ri}, 'linewidth', 2);
    if(ri == 1); alpha(0.85); legend(h, rN); xlabel('Freq. (Hz)'); ylabel('1/f Corrected Power (z)'); end
    
    for p = 1 : length(g_i{ri})
        subplot(length(p_N), 3, g_i{ri}(p) * 3); hold on;
        plot(grand_roi{ri}.freq, grand_roi{ri,1}.powspctrm(p,:), 'color', col_ln{ri}, 'linewidth', 2);
        plot(grand_roi{ri}.freq, grand_roi{ri,1}.powspctrm(p,:), 'color', col_ln{ri}, 'linewidth', 2);
        plot(grand_roi{ri}.freq, grand_roi{ri,1}.powspctrm(p,:), 'color', col_ln{ri}, 'linewidth', 2);
    end
    %xlabel('Freq. (Hz)');
end
% save figure & data
saveas(fig, [data_dir '/Frequency Analysis/spectral_signatures.jpg']); close();
save([data_dir '/Frequency Analysis/grand_roi.mat'], 'grand_roi');

