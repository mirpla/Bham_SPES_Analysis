function [Out_E, Out_H] = select_E(Data)
    csvdata = readtable('\\analyse4\project0304\RDS\Mircea\3 - SPES\Datasaves\E-Locs.csv');

    strings_column = csvdata{:, 3}; % third column contains epileptic tissue
    result_vector = ones(size(strings_column));
    result_vector(strcmp(strings_column, 'NaN') | strcmp(strings_column, 'Nhipp')) = 0;


    % Get field names of the original struct
    field_names = fieldnames(Data);

    % Initialize both output structs
    Out_E = struct();
    Out_H = struct();

    % Get indices for 0s and 1s
    zero_indices = find(result_vector == 0);
    one_indices = find(result_vector == 1);

    % Process all fields
    for i = 1:length(field_names)
        current_field = field_names{i};
        
        % Initialize cell arrays for both outputs
        Out_E.(current_field) = cell(1, length(Data.(current_field)));
        Out_H.(current_field) = cell(1, length(Data.(current_field)));

        if strcmp(current_field, 'Session') || strcmp(current_field, 'SessionNorm')
            % Handle zero trials (only for Out_H)
            for j = 1:length(zero_indices)
                Out_H.(current_field){zero_indices(j)} = Data.(current_field){zero_indices(j)};
            end

            % Handle one trials (for both Out_E and Out_H)
            for j = 1:length(one_indices)
                trial_idx = one_indices(j);
                first_letter = strings_column{trial_idx}(1);
                current_data = Data.(current_field){trial_idx};
                channels = current_data.label;

                if first_letter == 'L' || first_letter == 'R'
                    % Define channel selection based on first letter
                    pattern_to_match = [first_letter];
                    
                    % Select channels for Out_H (excluding pattern)
                    keep_idx_H = ~contains(channels, pattern_to_match, 'IgnoreCase', false);
                    cfg_H = [];
                    cfg_H.channel = channels(keep_idx_H);
                    Out_H.(current_field){trial_idx} = ft_selectdata(cfg_H, current_data);

                    % Select channels for Out_E (including pattern)
                    keep_idx_E = contains(channels, pattern_to_match, 'IgnoreCase', false);
                    cfg_E = [];
                    cfg_E.channel = channels(keep_idx_E);
                    Out_E.(current_field){trial_idx} = ft_selectdata(cfg_E, current_data);
                else
                    % If no L/R pattern, keep all channels
                    Out_H.(current_field){trial_idx} = current_data;
                    Out_E.(current_field){trial_idx} = current_data;
                end
            end
        else
            % For non-Session fields
            % Copy zero trials to Out_H
            for j = 1:length(zero_indices)
                Out_H.(current_field){zero_indices(j)} = Data.(current_field){zero_indices(j)};
            end
            
            % Copy one trials to both outputs
            for j = 1:length(one_indices)
                trial_idx = one_indices(j);
                Out_H.(current_field){trial_idx} = Data.(current_field){trial_idx};
                Out_E.(current_field){trial_idx} = Data.(current_field){trial_idx};
            end
        end
    end

    % Clean up empty cells in Out_E
    for i = 1:length(field_names)
        current_field = field_names{i};
        non_empty_idx = ~cellfun(@isempty, Out_E.(current_field));
        Out_E.(current_field) = Out_E.(current_field)(non_empty_idx);
    end
end

%% Do Analyses on Epileptic and non-epileptic tissue
% Select the Hippocampal and non-hippocampal channels/sites:
% clear
% load in the data
if ~exist('AllMacro', 'var')
    % load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroDataNF.mat'])
    load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroDataNF.mat'])
    load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/MacroDataLP.mat'])
end

if ~exist('AllMicro', 'var')
    %load([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/MicroDataF.mat'])
    load([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/MicroData.mat'])
end


%% micro LFP select non-epilepsy
[MicroE, MicroH]        = select_E(AllMicro);
[MacroE, MacroH]        = select_E(AllMacro);
[MacroLPE, MacroLPH]    = select_E(AllMacroLP);
%% 

[Mirco_GA_local_E] = ERPCumSumSummaryE(Basepath, MicroE, MacroE, MacroLPE, AllMicro, AllMacro, AllMacroLP,[0.026 1.026],0,'_E');
[Mirco_GA_local_H] = ERPCumSumSummaryE(Basepath, MicroH, MacroH, MacroLPH, AllMicro, AllMacro, AllMacroLP,[0.026 1.026],0,'_H');

Mirco_GA_local_E
Mirco_GA_local_H{1,1}(3,:) = []

[mstat_diff.clustersG, mstat_diff.p_valuesG, mstat_diff.t_sums, mstat_diff.permutation_distribution ] = permutest(Mirco_GA_local_E{1,1}', Mirco_GA_local_H{1,1}',false,0.05,10000,true);
mstat_diff.sigclust = mstat_diff.p_valuesG<0.05;
%% Spike
subjIDspk =  {'sub-0007','sub-0008','sub-0009','sub-0012','sub-0013'};

load('\\analyse4\project0304\RDS\Mircea\3 - SPES\Datasaves\SpikeTrials.mat')

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

[SUA,TRLCOND] = SelectedConditions_wSUA_E(DataSU);

%%
SUA_E.Conditions = [{SUA.Conditions{1,1}}];
SUA_E.AllChan    = [{SUA.AllChan{1,1}}];
SUA_E.stimsite   = [{SUA.stimsite{1,1}}];
SUA_E.Labels     = SUA.Labels;

SUA_H.Conditions = [{SUA.Conditions{1,2}},{SUA.Conditions{1,3}},{SUA.Conditions{1,4}},{SUA.Conditions{1,5}}];
SUA_H.AllChan    = [{SUA.AllChan{1,2}},{SUA.AllChan{1,3}},{SUA.AllChan{1,4}},{SUA.AllChan{1,5}}];
SUA_H.stimsite   = [{SUA.stimsite{1,2}},{SUA.stimsite{1,3}},{SUA.stimsite{1,4}},{SUA.stimsite{1,5}}];
SUA_H.Labels     = SUA.Labels;

param = [];
param.convol    = 50;
param.bswin     = (2000:2750);
param.stimwin   = 2950:3600;
param.maxpercentile     = 97.5;
param.minpercentile     = 2.5;
param.fs                = 1000;
param.trlsize           = 3;
param.clsize            = 50;
[SUAnERP_E,w] = SUAnalysis(SUA_E,Basepath,'pos', TRLCOND,0, param);
[SUAnERP_H,w] = SUAnalysis(SUA_H,Basepath,'pos', TRLCOND,0, param);

[SUAmERP_E{1,1}, Chanlist_E{1,1}] = SelectResponseMd(SUAnERP_E{1,1},param);
[SUAmERP_E{1,2}, Chanlist_E{1,2}] = SelectResponseMd(SUAnERP_E{1,2},param);

[SUAmERP_H{1,1}, Chanlist_H{1,1}] = SelectResponseMd(SUAnERP_H{1,1},param);
[SUAmERP_H{1,2}, Chanlist_H{1,2}] = SelectResponseMd(SUAnERP_H{1,2},param);

[spkstat_E] = SUAplotsE(SUAmERP_E,SUAnERP_E, Chanlist_E);
[spkstat_H] = SUAplotsE(SUAmERP_H,SUAnERP_H, Chanlist_H);

[spkstat_diff.clustersG, spkstat_diff.p_valuesG, spkstat_diff.t_sums, spkstat_diff.permutation_distribution ] = permutest(SUAmERP_E{1,1}', SUAmERP_H{1,1}',false,0.05,10000,true);
spkstat_diff.sigclust = spkstat_diff.p_valuesG<0.05;