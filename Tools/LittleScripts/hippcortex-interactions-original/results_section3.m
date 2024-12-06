%% Resonating Frequency Analysis
% This script aims to identify the differences in neocortical (NC) and
% hippocampal resonating frequencies.
clearvars
close all
clc

% define key directory
home_dir = 'Y:/George/hippcortex-interactions-original';
data_dir = 'Y:/George/Data';
%data_dir = 'Y:/George/Original Data';

if(exist([data_dir '/Frequency Analysis'], 'dir') ~= 7)
    mkdir([data_dir '/Frequency Analysis'])
end

D_patient = dir(data_dir); p_N = []; err = [];
for d = 1:length(D_patient)
    if(contains(D_patient(d).name, 'P') == 1 && contains(D_patient(d).name, 'ERL') ~= 1)
        p_N = [p_N; str2double(D_patient(d).name(end))];
        %p_N = [p_N; str2double(D_patient(d).name(3))];
    end
end
p_N(isnan(p_N)==1) = []; p_t = [];

% add subfunctions
addpath([home_dir '/additional_functions'])

%% Get Time-Frequency Spectrum
% predefine matrix to hold slope values of TF data
beta = [];

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
        toi{1} = 2 : 0.025 : 3.5; % encoding period
        toi{2} = 2 : 0.025 : 3.5; % retrieval period
        
        % cycle through encoding and retrieval data
        for di = 1 : numel(data)
            % calculate time-frequency (only on hippocampal channels and recalled trials)
            disp(['SELECTING HIPPOCAMPAL DATA for P' int2str(p_N(p))]);
            cfg            = [];
            cfg.channel    = data{di}.label(contact_locations(:,3)==1);
            cfg.keeptrials = 'yes';
            cfg.method     = 'wavelet';
            cfg.width      = 5;
            cfg.output     = 'pow';	
            cfg.pad        = 'nextpow2';
            cfg.foi        = 30 : 0.5 : 100;              
            cfg.toi        = toi{di};        
            freq{di,1}     = ft_freqanalysis(cfg, data{di});

            % subtract 1/f noise
            cfg         = [];
            cfg.toi     = [toi{di}(1) toi{di}(end)];
            freq{di,1}  = sd_subtr1of(cfg, freq{di,1});

            % extract slope beta
            beta(p,di,1,:) = mean(mean(freq{di,1}.slope(freq{di,1}.trialinfo == 1,:,:),2),1);
            beta(p,di,2,:) = mean(mean(freq{di,1}.slope(freq{di,1}.trialinfo == 0,:,:),2),1);

            % smooth data
            cfg         = [];
            cfg.fwhm_t  = 0.2;
            cfg.fwhm_f  = 5;
            freq{di,1}  = smooth_TF_GA(cfg,freq{di,1});

            % rename time bins for consistency between encoding and retrieval
            freq{di,1}.time = linspace(0,1,numel(freq{di,1}.time));
            freq{di,1}.freq = linspace(round(freq{di}.freq(1)),round(freq{di}.freq(end)),numel(freq{di,1}.freq));

            % split data into hits and misses and average
            cfg             = [];
            cfg.trials      = freq{di,1}.trialinfo == 0;
            cfg.avgoverrpt  = 'yes';
            freq{di,2}      = ft_selectdata(cfg,freq{di,1});

            cfg             = [];
            cfg.trials      = freq{di,1}.trialinfo == 1;
            cfg.avgoverrpt  = 'yes';
            freq{di,1}      = ft_selectdata(cfg,freq{di,1});

            % average over channels and time
            cfg             = [];
            cfg.avgovertime	= 'yes';
            cfg.avgoverchan = 'yes';
            freq{di,1}      = ft_selectdata(cfg,freq{di,1});
            freq{di,2}      = ft_selectdata(cfg,freq{di,2});

            % relabel labels for consistency across participants
            freq{di,1}.label{1} = 'hippo';
            freq{di,2}.label{1} = 'hippo';
            freq{di,1}.cfg      = [];
            freq{di,2}.cfg      = [];
        end

        % save data
        save([data_dir '/Frequency Analysis/P' int2str(p_N(p)) '_freq_gamma.mat'], 'freq');

        % clear all non-essential variables
        %keep subj_with_hippo home_dir data_dir contact_locations beta
    else; disp([err ' for P' int2str(p_N(p))]);
    end
end

% save slope data
save([data_dir '/Frequency Analysis/slope_betas.mat'], 'beta');

%% Get Grand Average
% pre-define cell to hold group data
p_N = p_N(ismember(p_N, p_t));
group_freq = cell(length(p_N),2,2);

% cycle through every participant
for p = 1:length(p_N)
    
    % load data
    load([data_dir '/Frequency Analysis/P' int2str(p_N(p)) '_freq_gamma.mat'])
           
    % cycle through encoding and retrieval
    for di = 1 : size(freq,2)
        
        % add to group structure
        group_freq{p,di,1} = freq{di,1}; % add hit data
        group_freq{p,di,2} = freq{di,2}; % add miss data       
    end
end

% pre-define cell to hold grand-averaged data
grand_encoding  = cell(size(group_freq,3),1);
grand_retrieval = cell(size(group_freq,3),1);

% cycle through hits and misses
for di = 1 : size(group_freq,3)

    % calculate grand average
    cfg                         = [];
    cfg.keepindividual          = 'yes';
    grand_encoding{di,1}        = ft_freqgrandaverage(cfg,group_freq{:,1,di});
    grand_encoding{di,1}.cfg    = [];
    grand_retrieval{di,1}       = ft_freqgrandaverage(cfg,group_freq{:,2,di});
    grand_retrieval{di,1}.cfg   = [];    
end

% save data
save([data_dir '/Frequency Analysis/grand_gamma.mat'],'grand_encoding','grand_retrieval');

%% FIGURES
fig1 = figure(); set(fig1, 'position', [0 0 1000 500]);
titles = {'Hits', 'Misses'}; 
col_fill = {[1 0.8 0.8], [0.9 0.9 0.9]};
col_line = {[0.75 0.4 0.4], [0.65 0.65 0.65]};
F = grand_encoding{1}.freq;

for i = 1:2
    figure(fig1);
    subplot(2, 2, 2 + (i-1)*2); hold on; 
    X2 = squeeze(grand_retrieval{i,1}.powspctrm); h = [];
    Z2 = zscore(X2')'; M = mean( Z2 ); SDE = std( Z2, [], 1 ) / sqrt( size( Z2, 1 )); 
    h(1) = fill([F fliplr(F)], [M-SDE fliplr(M+SDE)], col_fill{2}, ...
        'edgecolor', col_line{2}, 'linewidth', 2); 
    plot(F, M, 'color', col_line{2}, 'linewidth', 2);
    
    X1 = squeeze(grand_encoding{i,1}.powspctrm); 
    Z1 = zscore(X1')'; M = mean( Z1 );SDE = std( Z1, [], 1 ) / sqrt( size( Z1, 1 )); 
    h(2) = fill([F fliplr(F)], [M-SDE fliplr(M+SDE)], col_fill{1}, ...
        'edgecolor', col_line{1}, 'linewidth', 2);
    plot(F, M, 'color', col_line{1}, 'linewidth', 2);  

    plot([min(F) max(F)], [0 0], 'k'); xlim([min(F) max(F)]); 
    legend(h, 'Retrieval', 'Encoding'); title([titles{i} ' raw power']);
    xlabel('Freq (Hz)'); ylabel('1/f Corrected Power (z)'); ylim([-2 2]); xlim([35 95]); 
    
    subplot(2, 2, 1 + (i-1)*2); hold on;
    Z = Z1 - Z2; M = mean( Z ); SDE = std( Z, [], 1 ) / sqrt( size( Z, 1 )); 
    fill([F fliplr(F)], [M-SDE fliplr(M+SDE)], col_fill{i}, ...
        'edgecolor', col_line{i}, 'linewidth', 2); 
    plot(F, M, 'color', col_line{i}, 'linewidth', 2);
    plot([min(F) max(F)], [0 0], 'k'); xlim([min(F) max(F)]);
    xlabel('Freq (Hz)'); ylabel('1/f Corrected Power (Enc. > Ret.; z)'); 
    title([titles{i} ' Enc. - Ret. power']); xlim([35 95]); %ylim([-2 2])
    
    if( i == 1 ) % figure 2 for hits
        fig2 = figure(); set(fig2, 'position', [0 0 1000 500]);
        sp = 1 : length(p_N)*3; sp(rem(sp,3)==0) = []; sp = sp(3:end);
        subplot(length(p_N), 3, sp); hold on;
        fill([F fliplr(F)], [M-SDE fliplr(M+SDE)], col_fill{i}, ...
            'edgecolor', col_line{i}, 'linewidth', 2); 
        plot(F, M, 'color', col_line{i}, 'linewidth', 2);
        plot([min(F) max(F)], [0 0], 'k'); xlim([min(F) max(F)]);
        xlabel('Freq (Hz)'); ylabel('1/f Corrected Power (Enc. > Ret.; z)');
        
        for p = 1:length(p_N)
           subplot(length(p_N), 3, p * 3); hold on;
           plot(F, Z(p,:), 'color', [0.8 0.3 0.3], 'linewidth', 2);
           plot([min(F) max(F)], [0 0], 'k'); xlim([min(F) max(F)]);
        end
    end
end

saveas(fig1, [data_dir '/Frequency Analysis/Enc-Ret_gamma_raw.jpg']); close(fig1);

%% Run Inferential Statistics
% load data
%load([data_dir,'/data/res/grand_freq_gamma.mat'])

% predefine matrices to house p-values and Cohen's d
p_fdr	= nan(2,7);
d       = nan(2,7);

% cycle through hits and misses
for di = 1 : numel(grand_encoding)

    % convert encoding frequency spectrum to time series
    grand_encoding{di,1}.powspctrm    = permute(grand_encoding{di,1}.powspctrm,[1 2 4 3]);
    grand_encoding{di,1}.time         = grand_encoding{di,1}.freq;
    grand_encoding{di,1}.freq         = 2;

    % convert retrieval frequency spectrum to time series
    grand_retrieval{di,1}.powspctrm    = permute(grand_retrieval{di,1}.powspctrm,[1 2 4 3]);
    grand_retrieval{di,1}.time         = grand_retrieval{di,1}.freq;
    grand_retrieval{di,1}.freq         = 2;
    
    % downsample time domain
    cfg                     = [];
    cfg.win_dur             = 10;
    cfg.toi                 = [grand_encoding{di,1}.time(1) grand_encoding{di,1}.time(end)];
    grand_encoding{di,1}    = sd_downsample_freq(cfg,grand_encoding{di,1});
    grand_retrieval{di,1}   = sd_downsample_freq(cfg,grand_retrieval{di,1});

    % create design matrix
    design      = [];
    design(1,:) = [1:size(grand_encoding{di,1}.powspctrm,1), 1:size(grand_encoding{di,1}.powspctrm,1)];
    design(2,:) = [ones(1,size(grand_encoding{di,1}.powspctrm,1)) ones(1,size(grand_encoding{di,1}.powspctrm,1))+1];

    % define statistic configuration
    cfg                     = [];
    cfg.method              = 'montecarlo';
    cfg.statistic           = 'ft_statfun_depsamplesT';
    cfg.correctm            = 'no'; % will use fdr function to get corrected p-values
    cfg.correcttail         = 'alpha';
    cfg.alpha               = 0.05;
    cfg.numrandomization    = 5000;
    cfg.design              = design;
    cfg.ivar                = 2;
    cfg.uvar                = 1;

    % run statistics
    stat              = ft_freqstatistics(cfg, grand_encoding{di,1}, grand_retrieval{di,1});
    
    % fdr correct p-values
    [~,~,p_fdr(di,:)]       = fdr(squeeze(stat.prob));
    
    % calculate cohens d
    for t = 1 : numel(grand_encoding{di,1}.time)
        d(di,t) = computeCohen_d(squeeze(grand_encoding{di,1}.powspctrm(:,:,:,t)),squeeze(grand_retrieval{di,1}.powspctrm(:,:,:,t)),'paired');
    end
end

figure(fig2);
subplot(length(p_N), 3, sp); hold on;
F = grand_encoding{1,1}.time;
X1 = squeeze(grand_encoding{1,1}.powspctrm);
X2 = squeeze(grand_retrieval{1,1}.powspctrm);
Z1 = zscore(X1')'; Z2 = zscore(X2')';
Z = Z1 - Z2; M = mean( Z );
for i = 1:length(F)
    scatter(ones(size(Z,1),1)*F(i), Z(:,i), 25, 'filled', ...
        'MarkerFaceColor', [0.75 0.4 0.4], 'MarkerEdgeColor', [0.75 0.4 0.4])
end
subplot(length(p_N), 3, [1 2]); hold on;
bar(F, abs(d(1,:)), 'facecolor', [0.7 0.7 0.7], ...
    'edgecolor', [0.3 0.3 0.3], 'linewidth',2)
plot([30 100], [0.05 0.05], 'k');
xlim([30 100]); title('bin significance'); ylabel('P-value');

saveas(fig2, [data_dir '/Frequency Analysis/Enc-Ret_gamma_patients.jpg']); close(fig2);

% % %% Run Statistical Analysis on Beta Slopes
% % load beta data
% load([data_dir,'/data/res/slope_betas.mat'])
% subj_with_hippo = [1 2 3 4 6 7 8];
% 
% % create data
% data_enc = struct('cfg',[],...
%                   'freq',[1 2],...
%                   'label',{{'dummy'}},...
%                   'time',1,...
%                   'dimord','subj_chan_freq_time',...
%                   'powspctrm',mean(beta(subj_with_hippo,1,:,:),4));
% data_ret = struct('cfg',[],...
%                   'freq',[1 2],...
%                   'label',{{'dummy'}},...
%                   'time',1,...
%                   'dimord','subj_chan_freq_time',...
%                   'powspctrm',mean(beta(subj_with_hippo,2,:,:),4));
% 
% % create design matrix
% design      = [];
% design(1,:) = [1:size(data_ret.powspctrm,1), 1:size(data_ret.powspctrm,1)];
% design(2,:) = [ones(1,size(data_ret.powspctrm,1)) ones(1,size(data_ret.powspctrm,1))+1];
% 
% % define statistic configuration
% cfg                     = [];
% cfg.method              = 'montecarlo';
% cfg.statistic           = 'ft_statfun_depsamplesT';
% cfg.correctm            = 'no'; % will use fdr function to get corrected p-values
% cfg.correcttail         = 'alpha';
% cfg.alpha               = 0.05;
% cfg.numrandomization    = 5000;
% cfg.design              = design;
% cfg.ivar                = 2;
% cfg.uvar                = 1;
% 
% % run statistics
% stat              = ft_freqstatistics(cfg, data_enc, data_ret);
