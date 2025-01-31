%

% Load files from previous scripts if this is a run you are redoing them
% (where they are not loaded). Make sure the 'redo' variable exists
load([DataLocationIC, subjID,'_MacroStimRej.mat']);
load([DataLocationIC, subjID,'_ICtrials.mat']);

load([Basepath, 'Mircea/3 - SPES/Datasaves/Macro/stringstimsite/',subjID,'/',subjID,'_StimInfo.mat']);

if exist('CSCdatNF','var') == 0
    load([DataLocationMC, subjID,'_Base'], 'CSCdatNF')
end

Fsmacro = round(ICtrials.fsample);
Fs = 32000;

%%
cfg_del{1,1} = cfg_delPre;
cfg_del{1,2} = cfg_delMid;
cfg_del{1,3} = cfg_delPost;
clear('temptrl', 'pkmicro', 'locationsmicro', 'newtrl')


for ppv = 1:length(cfg_del)
    temptrl = [cfg_del{1,ppv}.artfctdef.visual.artifact(:,1), cfg_del{1,ppv}.artfctdef.visual.artifact(:,2)+50, zeros(length(cfg_del{1,ppv}.artfctdef.visual.artifact),1)]; %trialmatrix
    
    cfg = [];
    cfg.continuous = 'yes';
    cfg.trl = temptrl;
    [dumCSC] = ft_redefinetrial( cfg, CSCdatNF); % creation of dummy variable defined according to above trl
    
    %pk = zeros(length(CSCdatNF.label), length(cfg_del.artfctdef.visual.artifact));
    %locations = zeros(length(CSCdatNF.label), length(cfg_del.artfctdef.visual.artifact));
    for i=1:length(cfg_del{1,ppv}.artfctdef.visual.artifact);
        dumCSC.trial{1,i} = abs(cell2mat(dumCSC.trial(1,i)));
        for j = 1:length(CSCdatNF.label) % find peak individually for each channel
            [pk, locations] = findpeaks(dumCSC.trial{1,i}(j,:), 'SortStr', 'descend');
            if isempty(pk)
                pkmicro(j,i) = 0 ;
                locationsmicro(j,i) = 0;
            else
                pkmicro(j,i) = pk(1,1);
                locationsmicro(j,i) = locations(1,1);
            end
            
        end
    end
    
    
    %% create a trialsmatrix that is fieldtrip compatible
    
    Fs = 32e3;
    pre = Fs*3;
    post = Fs*3;
    newtrl = [];
    for it = 1:size(temptrl,1);
        locationsNozero = locationsmicro(locationsmicro(:,it)>100,it);
        if isempty(locationsNozero)
            locationsNozero = 0;
        end
        LocMed = mode(locationsNozero)-1;
        
        newtrl(it,:) = [temptrl(it,1)+LocMed-(pre) temptrl(it,1)+LocMed+(post) (-pre)];
    end;
    
    %% crosscorrlelate stim times
    
    Res = 10;
    if exist('InfoSI','var')
    else
        InfoSI = 1;
    end
    if InfoSI == 0
        numer(:,1) = (stimartfdefRej(:,1)+IC.sampleinfoOld(1,1));
    elseif InfoSI == 1
        numer(:,1) = stimartfdefRej(:,1);
    end
    
    ccstimdefMacro = (numer/Fsmacro)';
    ccstimdefMicro = ((newtrl(:,1) - newtrl(:,3))/Fs)';
    
    
    ccstimdefMacroZeros = zeros(1, round(max(ccstimdefMacro)*Res));
    ccstimdefMicroZeros = zeros(1, round(max(ccstimdefMicro)*Res));
    
    
    j = 1;
    for i= 1:length(ccstimdefMacroZeros)
        if i == round(ccstimdefMacro(1,j)*Res)
            ccstimdefMacroZeros(1,i) =  1;
            j = j+1;
        end
    end
    
    j = 1;
    for i= 1:length(ccstimdefMicroZeros)
        if i == round(ccstimdefMicro(1,j)*Res)
            ccstimdefMicroZeros(1,i) =  1;
            j = j+1;
        end
    end
    
    %% pad with zeros so that alignment works better
    if length(ccstimdefMicroZeros) > length(ccstimdefMacroZeros)
        
        lengdiff = length(ccstimdefMicroZeros)-length(ccstimdefMacroZeros);
        ccstimdefMacroZeros = [zeros(1, lengdiff), ccstimdefMacroZeros];
        
    elseif length(ccstimdefMicroZeros) < length(ccstimdefMacroZeros)
        
        lengdiff = length(ccstimdefMacroZeros)-length(ccstimdefMicroZeros);
        ccstimdefMicroZeros = [zeros(1, lengdiff), ccstimdefMicroZeros];
        
    else
        lengdiff{1,ppv} = 0;
    end
    
    
    
    %% Crosscorrelation
    
    [acor, lagg] = xcorr(ccstimdefMacroZeros, ccstimdefMicroZeros);
    
    [~, I] = max(abs(acor));
    lagdiff{1,ppv} = lagg(I);
    
    figure
    plot(lagg, acor)
    a1 = gca;
    a1.XTick = sort([lagdiff{1,ppv}]);
    % lagdiff = 16180
    %% align
    figure
    subplot(2,1,1)
    plot(ccstimdefMacroZeros)
    subplot(2,1,2)
    plot(ccstimdefMicroZeros)
    
    if lagdiff{1,ppv} < 0
        alMacro = [zeros(1, lagdiff{1,ppv}), ccstimdefMacroZeros];
        alMicro = [ccstimdefMicroZeros, zeros(1, lagdiff{1,ppv})];
        
    elseif lagdiff{1,ppv} > 0
        alMacro = [ccstimdefMacroZeros, zeros(1, lagdiff{1,ppv})];
        alMicro = [zeros(1, lagdiff{1,ppv}), ccstimdefMicroZeros];
    elseif lagdiff{1,ppv} == 0
        alMicro = ccstimdefMicroZeros;
        alMacro = ccstimdefMacroZeros;
    else
        disp('ERROR lag is not a real value above below or equal to 0');
    end
    
    %% turn macro definition into new micro definition moved by alignment
    locationsM = [] ;
    temptrl = [];
    newMicroRTrl = [((numer/ICtrials.fsample) - lengdiff/Res - lagdiff{1,ppv}/Res) * Fs];
    temptrl = [round(newMicroRTrl(:,1)-(Fs/Res)*3), round(newMicroRTrl(:,1)+(Fs/Res)*3), zeros(length(newMicroRTrl),1)]; %trialmatrix
    
    removeRows = temptrl(:,1)<0;
    temptrl(removeRows,:) = [];
    
    cfg = [];
    cfg.continuous = 'yes';
    cfg.trl = temptrl;
    [dumCSC] = ft_redefinetrial(cfg, CSCdatNF); % creation of dummy variable defined according to above trl
    
    if strcmp(subjID,'P06')
        chancnt = [1:9,12:26];
    else
        chancnt = [1:length(dumCSC.label)];
    end
    
    pk = zeros(length(dumCSC.label), length(temptrl));
    locations = zeros(length(dumCSC.label), length(temptrl));
    for i=1:length(temptrl)
        dumCSC.trial{1,i} = abs(cell2mat(dumCSC.trial(1,i)));
        
        for j = chancnt % find peak individually for each channel
            
            [pk, locations] = findpeaks(abs(dumCSC.trial{1,i}(j,:)), 'SortStr', 'descend');
            if isempty(pk)
                pkM(j,i) = 0 ;
                locationsM(j,i) = 0;
            else
                pkM(j,i) = pk(1,1);
                locationsM(j,i) = locations(1,1);
                
            end
        end
    end
    
    
    %% determine what electrodes are at stimulation ? still think about it
    
    clear dumCSC
    Fs = 32e3;
    pre = Fs*3;
    post = Fs*3;
    newMicroTrl = [];
    for it = 1:size(temptrl,1);
        locationsNozero = locationsM(locationsM(:,it)>100,it);
        if isempty(locationsNozero)
            locationsNozero = 0;
        end
        
        LocMed = mode(locationsNozero)-1;
        
        newMicroTrl(it,:) = [temptrl(it,1)+LocMed-(pre) temptrl(it,1)+LocMed+(post) (-pre)];
    end
    
    %%
    
    for  i= 1:length(StimSiteInfo.TrialLabels)
        codelabels(i,1) = find(strcmp(StimSiteInfo.TrialLabels(1,i), char(StimSiteInfo.Labels)));
    end
    
    if any(removeRows)==1  %make sure that the removal of negative elements occurs for the labels too
        removeLabels = length(codelabels) - length(temptrl);
        codelabelsZ = codelabels;
        codelabelsZ(1:removeLabels,:) = [];
    end
    
    pre = Fs*3;
    post = Fs*3;
    splitMTrl{1,ppv} = [];
    j = 1;
    for it = 1:size(newMicroTrl,1);
        splitMTrl{1,ppv}(it,:) = [round(newMicroTrl(it,1)) round(newMicroTrl(it,2)) (-pre) codelabels(it+sum(removeRows(:,1)),1)];
    end;
    
    
    %%
    
    cfg = [];
    cfg.continuous = 'yes';
    cfg.trl = splitMTrl{1,ppv};
    
    [newdumCSC{1,ppv}] = ft_redefinetrial( cfg, CSCdatNF); % creation of dummy variable defined according to above trl
    
    %% reverse changes so that labels  and trials can translate back to originals
    
    cfg = [];
    cfg.viewmode = 'vertical';
    cfg = ft_databrowser(cfg, newdumCSC{1,ppv});
    
    cfg.artfctdef.reject = 'complete';
    redCSCdat = ft_rejectartifact(cfg,newdumCSC{1,ppv});
    deftrial = redCSCdat.cfg.trl;
    clear redCSCdat
end
%%
newMTrl = [splitMTrl{1,1}(1:53,:); splitMTrl{1,2}([54:71,73:238,240:379],:); splitMTrl{1,3}(383:end,:)];
%%
clear CSCdatNF
if exist('CSCdatSPKint', 'var') == 0
    SpkIntFil = sprintf(['%s_BaseInt.mat'], subjID);
    if ~isfile([DataLocationMC, SpkIntFil])
        SpkIntFil = sprintf(['%s_Base.mat'], subjID);           
    end
    load([DataLocationMC, SpkIntFil], 'CSCdatSPKint')
end 
%% Resampling the Data and cutting of data into trials
% Has to happen before cleaning of line noise, due problems with
% computation time otherwise

RFQ = 1000;

cfg = [];
cfg.resamplefs = RFQ;
%cfg.detrend = 'yes';
cfg.demean = 'yes';
[CSCdatintLinres] = ft_resampledata( cfg, CSCdatSPKint);
clear CSCdatSPKint
newMTrlres = [floor(newMTrl(:,1:3)/32) newMTrl(:,4)];

cfg = [];
cfg.continuous = 'yes';
cfg.trl = newMTrlres;
[CSCdatIntNaN] = ft_redefinetrial( cfg, CSCdatintLinres); % creation of dummy variable defined according to above trl

% cfg = [];
% cfg.viewmode = 'vertical';
% ft_databrowser(cfg, CSCdatIntNaN);
%     

%% Using Freds Scripts to Remove Line Noise
CSCdatIntNaN2 = CSCdatIntNaN;

addpath(genpath([Basepath, 'Common/chronux_2_11']))

tic
for x = 1:length(CSCdatIntNaN2.label)
    
    for y = 1:length(CSCdatIntNaN.trial)      
        CSCdatIntNaN2.trial{1,y}(x,:) = cleanLFPfromLineNoise( CSCdatIntNaN.trial{1,y}(x,:),RFQ,1,(length(CSCdatIntNaN.time{1,y}(1,:))-1)/RFQ); %[CSCdatF.trial{1,1}(x,:), noise{1,x}] = CleanLineNoise(CSCdatSPKint.trial{1,1}(x,:));      
    end
end
toc

rmpath(genpath([Basepath, 'Common/chronux_2_11'])); % remove Chronux again from path due to overlapping 'findpeaks' function
clear CSCdatIntNaN

%%
filnam = sprintf('%s_trlMatrixes', subjID);
save([DataLocationMC, filnam], 'newMTrl', 'newMicroTrl', 'newMicroRTrl','deftrial');

%% Cut the artifact out

precut = 0.02 *CSCdatIntNaN2.fsample; % how many ms cut before stimulus onset
postcut = 0.024 * CSCdatIntNaN2.fsample;
%simplest way but updated to sampleinfo method
% for i = 0:(length(CSCdatIntNaN.trial)-1)
%     ArtArray(i+1,:) = [int32((3.001*CSCdatIntNaN.fsample)- precut)+int32(i*6.001*CSCdatIntNaN.fsample),  int32((3.001*CSCdatintLinres.fsample)+ postcut) + int32(i*6.001*CSCdatintLinres.fsample)];
% end 
for i = 1:(length(CSCdatIntNaN2.trial))
    ArtArray(i,:) = [(int32(CSCdatIntNaN2.sampleinfo(i,1))+3001 - precut), (int32(CSCdatIntNaN2.sampleinfo(i,1))+3001 + postcut)];
end

cfg = [];
cfg.artfctdef.visual.artifact =  ArtArray;
cfg.artfctdef.reject = 'nan';
CSCdatPreProcNF = ft_rejectartifact(cfg, CSCdatIntNaN2);

%%
clear CSCdatIntNaN2
clear CSCdatintLinres
%%

filnam = sprintf('LFP_IntL10T_%s_NoFilter', subjID);
save([DataLocationMC, filnam], 'CSCdatPreProcNF', '-v7.3');

%% free up space
clear redCSCdat
clear dumCSC
clear newdumCSC
clear CSCdatIntNaN
clear CSCdatintLinpre
clear CSCdatintLin
clear CSCdatNF
clear CSCdatSPKint