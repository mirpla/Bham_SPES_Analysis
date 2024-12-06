%% Select the conditions in preprocessed Macro and Micro data
function [CSCHippCondLFP, SPKcondLFP, TrialSelCondLFP, TrialSelCondiEEG, ICConditions] = SelectedConditions_IEEG_I_LFP_E( MicroE, MacroE,AllMicro, AllMacro)
% 
% cfg = [];
% cfg.viewmode = 'vertical';
% ft_databrowser(cfg, AllMacro.Session{6}) % Can be used to Determine the Channels
if isempty(AllMicro)
    p = 0;
else
    p = 1;
end 

if isempty(AllMacro)
    q = 0;
else 
    q = 1;
end

CSCHippCondLFP = [];
SPKcondLFP = [];
TrialSelCondLFP = [];
TrialSelCondiEEG = [];
ICConditions = [];

if p == 1
%% Select Channels that respond most to Local Stimulation

AllMicro.Session{1,1}.label
% P07 Right
LFPSelChans{1,1} = [1 2 7];         %AH
LFPSelChans{1,2} = [18 19 20 22];     %MH
LFPSelChans{1,3} = [23 26 27 30];     %PH

% P072 Left
LFPSelChans{2,1} = [];         %AH
LFPSelChans{2,2} = [9 10 12 13 14 15 16];     %MH
LFPSelChans{2,3} = [];     %PH


% P08 Right
LFPSelChans{3,1} = [];                %AH
LFPSelChans{3,2} = [26 28 30 32];     %MH
LFPSelChans{3,3} = [43 44 46 47];     %PH (from Distal)

% P082 Left
LFPSelChans{4,1} = [];             %AH
LFPSelChans{4,2} = [17 18 19 20 21 22 23 24];     %
LFPSelChans{4,3} = [33 34 35 36 37 38 39 40];     %PH (from Distal)

% P09 Left
LFPSelChans{5,1} = [1 2 6 7];         %AH
LFPSelChans{5,2} = [17 21 23 24];     %MH
LFPSelChans{5,3} = [49 50 51 55];     %PH
%LFPSelChans{5,4} = [36 37 38 39];     %PHG

% P10 Right Huge line noise in right channels following trial 74
LFPSelChans{6,1} = [12 13 14 15 16]; %12 16     %AH
LFPSelChans{6,2} = [25 26 28 31 32];     %MH
LFPSelChans{6,3} = [59 60 61 62 63];     %PH
%LFPSelChans{6,4} = [];     %PHG

% P102 Left
LFPSelChans{7,1} = [2, 4, 6, 7, 8];     %AH
LFPSelChans{7,2} = [16 17 18 19 20 21 23];     %MH
LFPSelChans{7,3} = [48 49 52 53 54];     %PH
%LFPSelChans{7,4} = [];     %PHG

%P11 Left
LFPSelChans{8,1} = []; %12 16     %AH
LFPSelChans{8,2} = [];     %MH
LFPSelChans{8,3} = [21:28];     %PH

% P112 Right
LFPSelChans{9,1} = [8, 9, 11, 12, 13];     %AH
LFPSelChans{9,2} = [];                     %MH
LFPSelChans{9,3} = [30:36];                %PH

% P12 Left
LFPSelChans{10,1} = [9:16];                 %AH
LFPSelChans{10,2} = [1:8];                  %MH
LFPSelChans{10,3} = [17:24];                %PH


% P12 Right          
%LFPSelChans{10,2} = [25:30];                %MH

% P06 Left
LFPSelChans{11,1} = [1:8];                  %AH

% P06 Right
LFPSelChans{12,1} = [9,17,23:28];           %AH
LFPSelChans{12,2} = [29,10:13];             %MH
LFPSelChans{12,3} = [14:16,18:22];          %PH


for k = 1:length(MicroE.Session)
    LFPData{1,1} = MicroE.Session{1,k};
    LFPData{2,1} = MicroE.SessionNorm{1,k};
    %LFPData{3,1} = AllMicro.MUAs{1,k};
    
    for b = 1:length(LFPData)
        %%
        clear TrialSelCondLFP
        if ~isempty(MicroE.SubjID{1,k})
            
            AllMicroIdx = strcmp(AllMicro.SubjID, MicroE.SubjID{1,k});

            switch MicroE.SubjID{1,k}              
                case 'P07'
                    
               
                    [~,~,LocalChanAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{1,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{1,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{1,3}),MicroE.Session{1,k}.label);
                    
                    CSCHippCondLFP.P07.AllChan = {LocalChanAHLFP,LocalChanMHLFP,LocalChanPHLFP; 'LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                    
                    LocalStimHippAHLFP  = [7:8];
                    LocalStimHippMHLFP  = [13:14];
                    LocalStimHippPHLFP  = [19];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippLFP    = [11, 12,17, 22];
                    RCtxStimOLFP      = [1:3];
                    RCtxStimPLFP      = [4:6];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    %% All Hippocampus
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    
                    
                    %%
                    CSCHippCondLFP.P07.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC', 'LH'};
                    SPKcondLFP.P07.Labels = CSCHippCondLFP.P07.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P07.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P07.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                            %                       MUAeCond.P07.COnditions{b,i} = ft_selectdata(cfg, MUAsERP{1,1})
                            
                        end
                        
                    end
                    
                case 'P072'
                    
                    LocalChanRAHLFP  = [1:8];
                    LocalChanRMHLFP  = [17:23];
                    LocalChanRPHLFP  = [24:30];
                    
                    [~,~,LocalChanMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{2,2}),MicroE.Session{1,k}.label);

                    CSCHippCondLFP.P072.AllChan = { LocalChanMHLFP; 'LocalChanMH'};
                    
                    
                    LocalStimHippMHLFP  = [1,2,3];
                    
                    %DistalStimHippMH  = [LLocalStimHippAH, LLocalStimHippPH];
                    
                    
                    LCtxStimHippLFP    = [6, 7];
                    
                    %                     RCtxStimCLFP       = [9:13];
                    %                     RCtxStimOLFP       = [14:16];
                    %                     RCtxStimPLFP       = [17:21];
                    %                     RCtxStimOFLFP      = [22:27];
                    
                    %% Local
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    TrialSelCondLFP{k,8} = LHMHLFP;
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( LCtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  LCtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    
                    
                    %%
                    CSCHippCondLFP.P072.Labels  = {'LHMH','DC','LH'};
                    SPKcondLFP.P072.Labels = CSCHippCondLFP.P072.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P072.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P072.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    end
                case 'P08'
                    [~,~,LocalChanAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{3,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{3,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{3,3}),MicroE.Session{1,k}.label);

                    [~,~,LocalChanCAH] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{4,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanCMH] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{4,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanCPH] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{4,3}),MicroE.Session{1,k}.label);
                    
                    CSCHippCondLFP.P08.AllChan = {LocalChanAHLFP, LocalChanMHLFP, LocalChanPHLFP,LocalChanCAH,LocalChanCMH,LocalChanCPH; 'LocalChanAH', 'LocalChanMH', 'LocalChanPH','ContralateralChanAH','ContralateralChanMH','ContralateralChanPH'};
                    
                    LocalStimHippAHLFP  = [1, 2];
                    LocalStimHippMHLFP  = [8,9];
                    LocalStimHippPHLFP  = [15,16];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [6,7];
                    CtxStimHippMHLFP  = [13, 14];
                    CtxStimHippPHLFP  = [20, 21];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P08.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC','LH'};
                    SPKcondLFP.P08.Labels = CSCHippCondLFP.P08.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P08.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P08.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                case 'P082'
                    [~,~,LocalChanAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{4,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{4,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{4,3}),MicroE.Session{1,k}.label);

                    [~,~,LocalChanCAH] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{3,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanCMH] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{3,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanCPH] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{3,3}),MicroE.Session{1,k}.label);
                    
                    
                    CSCHippCondLFP.P082.AllChan = {LocalChanAHLFP, LocalChanMHLFP, LocalChanPHLFP,LocalChanCAH,LocalChanCMH,LocalChanCPH; 'LocalChanAH', 'LocalChanMH', 'LocalChanPH','ContralateralChanAH','ContralateralChanMH','ContralateralChanPH'};
                    
                    LocalStimHippAHLFP  = [1,2];
                    LocalStimHippMHLFP  = [8,9];
                    LocalStimHippPHLFP  = [15,16];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [6,7];
                    CtxStimHippMHLFP  = [13, 14];
                    CtxStimHippPHLFP  = [20, 21];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    
                    %%
                    CSCHippCondLFP.P082.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC'};
                    SPKcondLFP.P082.Labels = CSCHippCondLFP.P082.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P082.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P082.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                case 'P09'
                    [~,~,LocalChanRAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label([9:16]),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label([25:32]),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label([57:64]),MicroE.Session{1,k}.label);

                    [~,~,LocalChanLAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{5,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{5,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{5,3}),MicroE.Session{1,k}.label);
                    
                    %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                    %                     LocalChanRParaHLFP = [41:48];
                    %
                    CSCHippCondLFP.P09.AllChan = {LocalChanLAHLFP, LocalChanLMHLFP, LocalChanLPHLFP,LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanLAH', 'LocalChanLMH', 'LocalChanLPH','LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                    
                    LocalStimHippAHLFP  = [1,2];
                    LocalStimHippMHLFP  = [8];
                    LocalStimHippPHLFP  = [22];
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [6,7];
                    CtxStimHippMHLFP  = [13,14];
                    CtxStimHippPHLFP  = [26,27];
                    %CtxStimHippPHGLFP = [19,20];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    %                     LHPparaHLFP = [];
                    %                     for i = 1:length( LocalStimHippPHGLFP )
                    %                         LHPparaHLFP = [LHPparaHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHGLFP(i))];
                    %                     end
                    %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P09.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC', 'PHG'};
                    SPKcondLFP.P09.Labels = CSCHippCondLFP.P09.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P09.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P09.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                case 'P10'
                    [~,~,LocalChanRAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{7,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{7,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{7,3}),MicroE.Session{1,k}.label);

                    [~,~,LocalChanLAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{6,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{6,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{6,3}),MicroE.Session{1,k}.label);

                    
                    %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                    %                     LocalChanRParaHLFP = [41:48];
                    %
                    CSCHippCondLFP.P10.AllChan = {LocalChanLAHLFP, LocalChanLMHLFP, LocalChanLPHLFP,LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanLAH', 'LocalChanLMH', 'LocalChanLPH','LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                    
                    LocalStimHippAHLFP  = [1,2];
                    LocalStimHippMHLFP  = [7];
                    LocalStimHippPHLFP  = [13];
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [5,6];
                    CtxStimHippMHLFP  = [12];
                    CtxStimHippPHLFP  = [18];
                    %CtxStimHippPHGLFP = [19,20];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    %                     LHPparaHLFP = [];
                    %                     for i = 1:length( LocalStimHippPHGLFP )
                    %                         LHPparaHLFP = [LHPparaHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHGLFP(i))];
                    %                     end
                    %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P10.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC', 'PHG'};
                    SPKcondLFP.P10.Labels = CSCHippCondLFP.P10.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P10.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P10.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                    %%
                case 'P102'
                    [~,~,LocalChanRAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{7,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{7,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{7,3}),MicroE.Session{1,k}.label);

                    [~,~,LocalChanLAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{6,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{6,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{6,1}),MicroE.Session{1,k}.label);

                    %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                    %                     LocalChanRParaHLFP = [41:48];
                    %
                    CSCHippCondLFP.P102.AllChan = {LocalChanLAHLFP, LocalChanLMHLFP, LocalChanLPHLFP,LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanLAH', 'LocalChanLMH', 'LocalChanLPH','LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                    
                    LocalStimHippAHLFP  = [1 2];
                    LocalStimHippMHLFP  = [7];
                    LocalStimHippPHLFP  = [13];
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [5,6];
                    CtxStimHippMHLFP  = [12];
                    CtxStimHippPHLFP  = [18];
                    %CtxStimHippPHGLFP = [19,20];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    %                     LHPparaHLFP = [];
                    %                     for i = 1:length( LocalStimHippPHGLFP )
                    %                         LHPparaHLFP = [LHPparaHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHGLFP(i))];
                    %                     end
                    %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P102.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC', 'PHG'};
                    SPKcondLFP.P102.Labels = CSCHippCondLFP.P102.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P102.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P102.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                case 'P11'

                    [~,~,LocalChanLPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{8,3}),MicroE.Session{1,k}.label);
                    
                    CSCHippCondLFP.P11.AllChan = {LocalChanLPHLFP; 'LocalChanLPH'};
                    
                    LocalStimHippPHLFP  = [5,6];
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippPHLFP];
                    
                    CtxStimHippPHLFP  = [10,11];
                    
                    CtxStimHippLFP    = [CtxStimHippPHLFP];
                    
                    %% Local
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    %% Distal HIpp
                    
                    DHPHLFP = [];
                    for i = 1:length(   CtxStimHippLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P11.Labels  = {'LHPH','DHPH','DC', 'PHG'};
                    SPKcondLFP.P11.Labels = CSCHippCondLFP.P11.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(size(TrialSelCondLFP,1))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P11.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P11.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                case 'P112'
                    [~,~,LocalChanRAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{9,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{9,3}),MicroE.Session{1,k}.label);

                    CSCHippCondLFP.P112.AllChan = {LocalChanRAHLFP,LocalChanRPHLFP;'LocalChanRAH','LocalChanRPH'};
                    
                    LocalStimHippAHLFP  = [1,2];
                    LocalStimHippPHLFP  = [8,9];
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP];
                    
                    CtxStimHippAHLFP  = [6,7];
                    CtxStimHippPHLFP  = [12,13];
                    %CtxStimHippPHGLFP = [19,20];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    %                     LHPparaHLFP = [];
                    %                     for i = 1:length( LocalStimHippPHGLFP )
                    %                         LHPparaHLFP = [LHPparaHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHGLFP(i))];
                    %                     end
                    %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P112.Labels  = {'LHAH','LHPH','DHAH','DHPH','DC'};
                    SPKcondLFP.P112.Labels = CSCHippCondLFP.P112.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(length(TrialSelCondLFP))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P112.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P112.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                case 'P12'
                    [~,~,LocalChanLAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{10,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanLMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{10,2}),MicroE.Session{1,k}.label);                  
                    
                    CSCHippCondLFP.P12.AllChan = {LocalChanLAHLFP , LocalChanLMHLFP ; 'LocalChanLAH','LocalChanLMH'};
                    
                    LocalStimHippAHLFP  = [1,2];
                    LocalStimHippMHLFP  = [7,8];
                    
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [6,11];
          
                    
                    CtxStimHippLFP    = [CtxStimHippAHLFP];
                    
                    %% Local
                    
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                     LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    %% LEft Distal Cortex
                    TrialSelCondLFP{k,3} = [];
                    TrialSelCondLFP{k,4} = [];
                    TrialSelCondLFP{k,5} = [];
                    TrialSelCondLFP{k,6} = [];
                        
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P12.Labels  = {'LHAH','LHMH','LH','DC'};
                    SPKcondLFP.P12.Labels = CSCHippCondLFP.P12.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P12.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P12.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                    end
                    
                case 'P06'
                    [~,~,LocalChanLAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{11,1}),MicroE.Session{1,k}.label);
            
                    CSCHippCondLFP.P06.AllChan = {LocalChanLAHLFP; 'LocalChanLAH'};
                    
                    LocalStimHippAHLFP  = [4,5];

                    LocalStimHippLFP   =  [LocalStimHippAHLFP];
               
                    CtxStimHippAHLFP  = [9];

                    CtxStimHippLFP    = [CtxStimHippAHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P06.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC'};
                    SPKcondLFP.P06.Labels = CSCHippCondLFP.P06.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P06.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P06.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                        
                    end
                case 'P062'
                    [~,~,LocalChanRAHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{12,1}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRMHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{12,2}),MicroE.Session{1,k}.label);
                    [~,~,LocalChanRPHLFP] = intersect( AllMicro.Session{1,AllMicroIdx}.label(LFPSelChans{12,3}),MicroE.Session{1,k}.label);

                    %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                    %                     LocalChanRParaHLFP = [41:48];
                    %
                    CSCHippCondLFP.P062.AllChan = {LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                    
                    LocalStimHippAHLFP  = [14,15];
                    LocalStimHippMHLFP  = [25,26];
                    LocalStimHippPHLFP  = [36,37];
                    %                     LocalStimHippPHGLFP = [14,15];
                    LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                    
                    
                    DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                    DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                    DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                    
                    CtxStimHippAHLFP  = [18,19];
                    CtxStimHippMHLFP  = [30,31];
                    CtxStimHippPHLFP  = [41,42];
                    %CtxStimHippPHGLFP = [19,20];
                    CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                    
                    %% Local
                    LHAHLFP = [];
                    for i = 1:length( LocalStimHippAHLFP )
                        LHAHLFP = [LHAHLFP ; find(LFPData{b,1}.trialinfo ==  LocalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,1} = LHAHLFP;
                    
                    LHMHLFP = [];
                    for i = 1:length( LocalStimHippMHLFP )
                        LHMHLFP = [LHMHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,2} = LHMHLFP;
                    
                    LHPHLFP = [];
                    for i = 1:length( LocalStimHippPHLFP )
                        LHPHLFP = [LHPHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,3} = LHPHLFP;
                    
                    %                     LHPparaHLFP = [];
                    %                     for i = 1:length( LocalStimHippPHGLFP )
                    %                         LHPparaHLFP = [LHPparaHLFP; find(LFPData{b,1}.trialinfo ==   LocalStimHippPHGLFP(i))];
                    %                     end
                    %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                    
                    %% Distal HIpp
                    DHAHLFP = [];
                    for i = 1:length( DistalStimHippAHLFP )
                        DHAHLFP = [DHAHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippAHLFP(i))];
                    end
                    TrialSelCondLFP{k,4} = DHAHLFP;
                    
                    DHMHLFP = [];
                    for i = 1:length( DistalStimHippMHLFP )
                        DHMHLFP = [DHMHLFP; find(LFPData{b,1}.trialinfo ==  DistalStimHippMHLFP(i))];
                    end
                    TrialSelCondLFP{k,5} = DHMHLFP;
                    
                    DHPHLFP = [];
                    for i = 1:length(  DistalStimHippPHLFP )
                        DHPHLFP = [DHPHLFP; find(LFPData{b,1}.trialinfo ==   DistalStimHippPHLFP(i))];
                    end
                    TrialSelCondLFP{k,6} = DHPHLFP;
                    
                    %% LEft Distal Cortex
                    
                    DCLFP = [];
                    for i = 1:length( CtxStimHippLFP )
                        DCLFP = [DCLFP; find(LFPData{b,1}.trialinfo ==  CtxStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,7} = DCLFP;
                    
                    LHLFP = [];
                    for i = 1:length( LocalStimHippLFP )
                        LHLFP = [LHLFP; find(LFPData{b,1}.trialinfo ==  LocalStimHippLFP(i))];
                    end
                    TrialSelCondLFP{k,8} = LHLFP;
                    
                    %%
                    CSCHippCondLFP.P062.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC', 'PHG'};
                    SPKcondLFP.P062.Labels = CSCHippCondLFP.P062.Labels;
                    %% select the Data{b,1}
                    if b == 3
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            SPKcondLFP.P062.Conditions{1,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                    else
                        for i = 1:(size(TrialSelCondLFP,2))
                            cfg = [];
                            cfg.trials = TrialSelCondLFP{k,i};
                            CSCHippCondLFP.P062.Conditions{b,i} = ft_selectdata(cfg, LFPData{b,1});
                        end
                        
                        
                    end
            end
        end
    end
end
%%
end
clear iEEGData
if q == 1
    % P07 Hipp
    SelChansiEEG{1,1} = [28 29 30];     % AH
    SelChansiEEG{1,2} = [36 37 38];     % MH
    SelChansiEEG{1,3} = [44 45 46];     % PH
    SelChansiEEG{1,4} = [23 24 25];     % AH
    SelChansiEEG{1,5} = [31 32 33];     % MH
    SelChansiEEG{1,6} = [39 40 41];     % PH
    
    % P072 Hipp
    
    SelChansiEEG{2,1} = [];             % AH
    SelChansiEEG{2,2} = [105 106 107];  % MH
    SelChansiEEG{2,3} = [];             % PH
    SelChansiEEG{2,4} = [];             % AH
    SelChansiEEG{2,5} = [100 101 102];  % MH
    SelChansiEEG{2,6} = [];             % PH
    
    % P08 Hipp
    SelChansiEEG{3,1} = [6 7 8];        % AH
    SelChansiEEG{3,2} = [14 15 16];     % MH
    SelChansiEEG{3,3} = [22 23 24];     % PH
    SelChansiEEG{3,4} = [1 2 3];          % AH
    SelChansiEEG{3,5} = [9 10 11];         % MH
    SelChansiEEG{3,6} = [17 18 19];        % PH
    
    % P082 Hipp
    SelChansiEEG{4,1} = [29 30 31];     % AH
    SelChansiEEG{4,2} = [37 38 39];     % MH
    SelChansiEEG{4,3} = [45 46 47];     % PH
    SelChansiEEG{4,4} = [24 25 26];     % AH
    SelChansiEEG{4,5} = [32 33 34];     % MH
    SelChansiEEG{4,6} = [40 41 42];     % PH
    
    % P09 Hipp
    SelChansiEEG{5,1} = [58 59 60];     % LAH
    SelChansiEEG{5,2} = [66 67 68];     % LMH
    SelChansiEEG{5,3} = [74 75 76];     % LPH
    %SelChansiEEG{5,7} = [90 91 92];     % LPHG
    SelChansiEEG{5,4} = [53 54 55];        % LAH
    SelChansiEEG{5,5} = [61 62 63];        % LMH
    SelChansiEEG{5,6} = [69 70 71];        % LPH
    %SelChansiEEG{5,8} = [85 86];        % LPHG
    
    % P10 Hipp
    SelChansiEEG{6,1} = [6 7 8];     % LAH
    SelChansiEEG{6,2} = [14 15 16];     % LMH
    SelChansiEEG{6,3} = [22 23 24];     % LPH
    SelChansiEEG{6,4} = [1 2 3];        % LAH
    SelChansiEEG{6,5} = [9 10 11];        % LMH
    SelChansiEEG{6,6} = [17 18 19];        % LPH
    
    % P102
    SelChansiEEG{7,1} = [38 39 40];     % LAH
    SelChansiEEG{7,2} = [46 47 48];     % LMH
    SelChansiEEG{7,3} = [54 55 56];     % LPH
    
    SelChansiEEG{7,4} = [33 34 35];        % LAH
    SelChansiEEG{7,5} = [41 42 43];        % LMH
    SelChansiEEG{7,6} = [49 50 51];        % LPH
    
    % P11
    SelChansiEEG{8,1} = [];     % LAH
    SelChansiEEG{8,2} = [];     % LMH
    SelChansiEEG{8,3} = [38 39 40];     % LPH
    
    SelChansiEEG{8,4} = [];        % LAH
    SelChansiEEG{8,5} = [];        % LMH
    SelChansiEEG{8,6} = [33 34 35];        % LPH
    
    
    % P112
    SelChansiEEG{9,1} = [6 7 8];     % LAH
    SelChansiEEG{9,2} = [];     % LMH
    SelChansiEEG{9,3} = [14 15 16];     % LPH
    
    SelChansiEEG{9,4} = [1 2 3];        % LAH
    SelChansiEEG{9,5} = [];        % LMH
    SelChansiEEG{9,6} = [9 10 11];        % LPH
    
    % P12
    SelChansiEEG{10,1} = [13 14 15];     % LAH
    SelChansiEEG{10,2} = [];     % LMH
    SelChansiEEG{10,3} = [];     % LPH
    
    SelChansiEEG{10,4} = [8 9 10];        % LAH
    SelChansiEEG{10,5} = [];        % LMH
    SelChansiEEG{10,6} = [];        % LPH
    
    % P06
    SelChansiEEG{11,1} = [];     % LAH
    SelChansiEEG{11,2} = [30 31 32];     % LMH
    SelChansiEEG{11,3} = [];     % LPH
    
    SelChansiEEG{11,4} = [];        % LAH
    SelChansiEEG{11,5} = [25 26 27];        % LMH
    SelChansiEEG{11,6} = [];        % LPH
    
    % P062
    SelChansiEEG{12,1} = [6 7 8 ];     % LAH
    SelChansiEEG{12,2} = [14 15 16];     % LMH
    SelChansiEEG{12,3} = [22 23 24];     % LPH
    
    SelChansiEEG{12,4} = [1 2 3];        % LAH
    SelChansiEEG{12,5} = [9 10 11];        % LMH
    SelChansiEEG{12,6} = [17 18 19];        % LPH
    
    for k = 1:length(MacroE.Session)
        iEEGData = MacroE.Session{1,k};
        %%
        AllMacroIdx = strcmp(AllMacro.SubjID, MacroE.SubjID{1,k});

        switch MacroE.SubjID{1,k}      
            case 'P07'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                ICConditions.P07.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [7:8]; % Trialinfo names
                HippStimMHiEEG  = [13:14];
                HippStimPHiEEG  = [19:20];
                
                HippStimiEEG    = [HippStimAHiEEG, HippStimMHiEEG, HippStimPHiEEG];
                
                CtxStimAHiEEG   = [10, 11,12];
                CtxStimMHiEEG   = [16 17, 0];
                CtxStimPHiEEG   = [22, 23 0 ];
                
                CtxStimiEEG     = [CtxStimAHiEEG, CtxStimMHiEEG, CtxStimPHiEEG];
                %% Hippocampal Stimulation
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG)
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                
                LHiEEG = []; % All channels Together
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Local Ctx Stimulation
                
                LCAHiEEG = [];
                for i = 1:length(CtxStimAHiEEG)
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==  CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(CtxStimMHiEEG)
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==  CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(CtxStimPHiEEG)
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==  CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(CtxStimiEEG)
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==  CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                %%
                ICConditions.P07.Labels  = {'LHAH','LHMH','LHPH', 'LH', 'LCAH','LCMH','LCPH','LC'};
                
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P07.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
            case 'P072'
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
        
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                
                ICConditions.P072.AllChan = { [],LocalCtxChanMHiEEG,[], [], LocalHippChanMHiEEG,[]; 'LocalCtxChanAH','LocalCtxChanMH','LocalCtxChanPH','LocalHippChanAH', 'LocalHippChanMH','LocalHippChanPH'};
                
                HippStimMHiEEG  = [1, 2,3];
                HippStimiEEG    = [HippStimMHiEEG];
                
                CtxStimMHiEEG   = [5, 6, 7];
                CtxStimiEEG     = [CtxStimMHiEEG];
                %% Local
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHiEEG = []; % All channels Together
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                
                %% LEft Distal Cortex
                
                LCMHiEEG = [];
                for i = 1:length( CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==  CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCiEEG = [];
                for i = 1:length(CtxStimiEEG)
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==  CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                %%
                ICConditions.P072.Labels  = {'LHMH','LH','LCMH','LC'};
                
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P072.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
                
            case 'P08'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
               
                ICConditions.P08.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [1,2];
                HippStimMHiEEG  = [8,9];
                HippStimPHiEEG  = [15,16];
                HippStimiEEG    = [HippStimAHiEEG,  HippStimMHiEEG, HippStimPHiEEG];
                
                CtxStimAHiEEG  = [5, 6,7];
                CtxStimMHiEEG  = [12,13, 14];
                CtxStimPHiEEG  = [19,20, 21];
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp Stim
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==  HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==   HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                
                
                %% Ctx stim
                LCAHiEEG = [];
                for i = 1:length( CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==  CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(   CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==    CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                
                LCiEEG = [];
                for i = 1:length(   CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==    CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                
                %%
                ICConditions.P08.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC'};
                
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P08.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
            case 'P082'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                ICConditions.P082.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [1,2];
                HippStimMHiEEG  = [8,9];
                HippStimPHiEEG  = [15,16];
                HippStimiEEG    = [HippStimAHiEEG,  HippStimMHiEEG, HippStimPHiEEG];
                
                CtxStimAHiEEG  = [6,7];
                CtxStimMHiEEG  = [13, 14];
                CtxStimPHiEEG  = [20, 21];
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp Stim
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==  HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==   HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                
                
                %% Ctx stim
                LCAHiEEG = [];
                for i = 1:length( CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==  CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(   CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==    CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                
                LCiEEG = [];
                for i = 1:length(   CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==    CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                
                %%
                ICConditions.P082.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC'};
                
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P082.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
            case 'P09'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                %LocalCtxChanParaHiEEG  = SelChansiEEG{k,7};
                %LocalHippChanParaHiEEG  = SelChansiEEG{k,8};
                
                
                ICConditions.P09.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [1,2];
                HippStimMHiEEG  = [8 9];
                HippStimPHiEEG  = [22];
                HippStimPHGiEEG = [15,16];
                HippStimiEEG    = [HippStimAHiEEG,HippStimMHiEEG,HippStimPHiEEG,HippStimPHGiEEG];
                
                
                CtxStimAHiEEG  = [6,7];
                CtxStimMHiEEG  = [13,14];
                CtxStimPHiEEG  = [26,27];
                CtxStimPHGiEEG = [20,21];
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHPHGiEEG = [];
                for i = 1:length( HippStimPHGiEEG )
                    LHPHGiEEG = [LHPHGiEEG; find(iEEGData.trialinfo ==   HippStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,9} = LHPHGiEEG;
                
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                LCPHGiEEG = [];
                for i = 1:length(CtxStimPHGiEEG )
                    LCPHGiEEG = [LCPHGiEEG; find(iEEGData.trialinfo ==   CtxStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,10} = LCPHGiEEG;
                %%
                ICConditions.P09.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC', 'LHPHG', 'LCPHG'};
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P09.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
            case 'P10'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);               
                
                ICConditions.P10.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [1,2];
                HippStimMHiEEG  = [7 8];
                HippStimPHiEEG  = [13 14];
                
                HippStimiEEG    = [HippStimAHiEEG,HippStimMHiEEG,HippStimPHiEEG,HippStimPHGiEEG];
                
                
                CtxStimAHiEEG  = [6];
                CtxStimMHiEEG  = [11,12];
                CtxStimPHiEEG  = [17,18];
                
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                %%
                ICConditions.P10.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC'};
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P10.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
            case 'P102'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                               
                %LocalCtxChanParaHiEEG  = SelChansiEEG{k,7};
                %LocalHippChanParaHiEEG  = SelChansiEEG{k,8};
                    
                ICConditions.P102.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [1,2];
                HippStimMHiEEG  = [7, 8];
                HippStimPHiEEG  = [13 14];
                HippStimiEEG    = [HippStimAHiEEG,HippStimMHiEEG,HippStimPHiEEG];
                
                
                CtxStimAHiEEG  = [5,6];
                CtxStimMHiEEG  = [11,12];
                CtxStimPHiEEG  = [17,18];
                
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                %%
                ICConditions.P102.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC'};
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P102.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
            case 'P11'
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                           
                ICConditions.P11.AllChan = {[],[],LocalCtxChanPHiEEG,[],[], LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG','LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimPHiEEG  = [5 6];
                HippStimiEEG    = [HippStimPHiEEG];
                
                CtxStimPHiEEG  = [10,11];
                CtxStimiEEG    = [CtxStimPHiEEG];
                
                %% Hipp
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                
                %%
                ICConditions.P11.Labels  = {'LHPH','LH','LCPH','LC'};
                for i = 1:(length(TrialSelCondiEEG))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P11.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
            case 'P112'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                %             LocalCtxChanParaHiEEG  = SelChansiEEG{k,7};
                %             LocalHippChanParaHiEEG  = SelChansiEEG{k,8};
                
                ICConditions.P112.AllChan = {LocalCtxChanAHiEEG,[],LocalCtxChanPHiEEG, LocalHippChanAHiEEG,[],LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [0 2 3];
                HippStimPHiEEG  = [8 9 10];
                HippStimiEEG    = [HippStimAHiEEG,HippStimPHiEEG];
                
                
                CtxStimAHiEEG  = [0,6 0];
                CtxStimPHiEEG  = [12,13 0];
                CtxStimiEEG    = [CtxStimAHiEEG, CtxStimPHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                
                %%
                ICConditions.P112.Labels  = {'LHAH','LHPH','LH','LCAH','LCPH','LC'};
                for i = 1:(size(TrialSelCondiEEG,2))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P112.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
            case 'P12'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                %LocalCtxChanParaHiEEG  = SelChansiEEG{k,7};
                %LocalHippChanParaHiEEG  = SelChansiEEG{k,8};
                                
                ICConditions.P12.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [7,8];
                HippStimMHiEEG  = [1,2];
                HippStimPHiEEG  = [];
                HippStimPHGiEEG = [];
                HippStimiEEG    = [HippStimAHiEEG,HippStimMHiEEG,HippStimPHiEEG,HippStimPHGiEEG];
                
                
                CtxStimAHiEEG  = [11];
                CtxStimMHiEEG  = [6];
                CtxStimPHiEEG  = [];
                CtxStimPHGiEEG = [];
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHPHGiEEG = [];
                for i = 1:length( HippStimPHGiEEG )
                    LHPHGiEEG = [LHPHGiEEG; find(iEEGData.trialinfo ==   HippStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,9} = LHPHGiEEG;
                
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                LCPHGiEEG = [];
                for i = 1:length(CtxStimPHGiEEG )
                    LCPHGiEEG = [LCPHGiEEG; find(iEEGData.trialinfo ==   CtxStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,10} = LCPHGiEEG;
                %%
                ICConditions.P12.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC', 'LHPHG', 'LCPHG'};
                for i = 1:(size(TrialSelCondiEEG,2))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P12.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
            case 'P06'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                %LocalCtxChanParaHiEEG  = SelChansiEEG{k,7};
                %LocalHippChanParaHiEEG  = SelChansiEEG{k,8};
                
                
                ICConditions.P06.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [];
                HippStimMHiEEG  = [4, 5];
                HippStimPHiEEG  = [];
                HippStimPHGiEEG = [];
                HippStimiEEG    = [HippStimAHiEEG,HippStimMHiEEG,HippStimPHiEEG,HippStimPHGiEEG];
                
                
                CtxStimAHiEEG  = [];
                CtxStimMHiEEG  = [9];
                CtxStimPHiEEG  = [];
                CtxStimPHGiEEG = [];
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHPHGiEEG = [];
                for i = 1:length( HippStimPHGiEEG )
                    LHPHGiEEG = [LHPHGiEEG; find(iEEGData.trialinfo ==   HippStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,9} = LHPHGiEEG;
                
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                LCPHGiEEG = [];
                for i = 1:length(CtxStimPHGiEEG )
                    LCPHGiEEG = [LCPHGiEEG; find(iEEGData.trialinfo ==   CtxStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,10} = LCPHGiEEG;
                %%
                ICConditions.P06.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC', 'LHPHG', 'LCPHG'};
                for i = 1:(size(TrialSelCondiEEG,2))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P06.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
                
            case 'P062'
                [~,~,LocalCtxChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,1}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,2}),MacroE.Session{1,k}.label);
                [~,~,LocalCtxChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,3}),MacroE.Session{1,k}.label);

                [~,~,LocalHippChanAHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,4}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanMHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,5}),MacroE.Session{1,k}.label);
                [~,~,LocalHippChanPHiEEG] = intersect( AllMacro.Session{1,AllMacroIdx}.label(SelChansiEEG{AllMacroIdx,6}),MacroE.Session{1,k}.label);
                
                %LocalCtxChanParaHiEEG  = SelChansiEEG{k,7};
                %LocalHippChanParaHiEEG  = SelChansiEEG{k,8};
                
                ICConditions.P062.AllChan = {LocalCtxChanAHiEEG,LocalCtxChanMHiEEG,LocalCtxChanPHiEEG, LocalHippChanAHiEEG,LocalHippChanMHiEEG,LocalHippChanPHiEEG; 'LocalCtxChanAHiEEG','LocalCtxChanMHiEEG','LocalCtxChanPHiEEG', 'LocalHippChanAHiEEG','LocalHippChanMHiEEG','LocalHippChanPHiEEG'};
                
                HippStimAHiEEG  = [14,15];
                HippStimMHiEEG  = [25 26];
                HippStimPHiEEG  = [36 37];
                HippStimPHGiEEG = [];
                HippStimiEEG    = [HippStimAHiEEG,HippStimMHiEEG,HippStimPHiEEG,HippStimPHGiEEG];
                
                
                CtxStimAHiEEG  = [18,19];
                CtxStimMHiEEG  = [30 31];
                CtxStimPHiEEG  = [41 42];
                CtxStimPHGiEEG = [];
                CtxStimiEEG    = [CtxStimAHiEEG,  CtxStimMHiEEG, CtxStimPHiEEG];
                
                %% Hipp
                LHAHiEEG = [];
                for i = 1:length( HippStimAHiEEG )
                    LHAHiEEG = [LHAHiEEG ; find(iEEGData.trialinfo ==  HippStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,1} = LHAHiEEG;
                
                LHMHiEEG = [];
                for i = 1:length( HippStimMHiEEG )
                    LHMHiEEG = [LHMHiEEG; find(iEEGData.trialinfo ==  HippStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,2} = LHMHiEEG;
                
                LHPHiEEG = [];
                for i = 1:length( HippStimPHiEEG )
                    LHPHiEEG = [LHPHiEEG; find(iEEGData.trialinfo ==   HippStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,3} = LHPHiEEG;
                
                LHPHGiEEG = [];
                for i = 1:length( HippStimPHGiEEG )
                    LHPHGiEEG = [LHPHGiEEG; find(iEEGData.trialinfo ==   HippStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,9} = LHPHGiEEG;
                
                
                LHiEEG = [];
                for i = 1:length( HippStimiEEG )
                    LHiEEG = [LHiEEG; find(iEEGData.trialinfo ==  HippStimiEEG(i))];
                end
                TrialSelCondiEEG{k,4} = LHiEEG;
                
                %% Ctx
                LCAHiEEG = [];
                for i = 1:length(  CtxStimAHiEEG )
                    LCAHiEEG = [LCAHiEEG; find(iEEGData.trialinfo ==   CtxStimAHiEEG(i))];
                end
                TrialSelCondiEEG{k,5} = LCAHiEEG;
                
                LCMHiEEG = [];
                for i = 1:length(  CtxStimMHiEEG )
                    LCMHiEEG = [LCMHiEEG; find(iEEGData.trialinfo ==   CtxStimMHiEEG(i))];
                end
                TrialSelCondiEEG{k,6} = LCMHiEEG;
                
                LCPHiEEG = [];
                for i = 1:length(  CtxStimPHiEEG )
                    LCPHiEEG = [LCPHiEEG; find(iEEGData.trialinfo ==   CtxStimPHiEEG(i))];
                end
                TrialSelCondiEEG{k,7} = LCPHiEEG;
                
                LCiEEG = [];
                for i = 1:length(  CtxStimiEEG )
                    LCiEEG = [LCiEEG; find(iEEGData.trialinfo ==   CtxStimiEEG(i))];
                end
                TrialSelCondiEEG{k,8} = LCiEEG;
                
                LCPHGiEEG = [];
                for i = 1:length(CtxStimPHGiEEG )
                    LCPHGiEEG = [LCPHGiEEG; find(iEEGData.trialinfo ==   CtxStimPHGiEEG(i))];
                end
                TrialSelCondiEEG{k,10} = LCPHGiEEG;
                %%
                ICConditions.P062.Labels  = {'LHAH','LHMH','LHPH','LH','LCAH','LCMH','LCPH','LC', 'LHPHG', 'LCPHG'};
                for i = 1:(size(TrialSelCondiEEG,2))
                    cfg = [];
                    cfg.trials = TrialSelCondiEEG{k,i};
                    ICConditions.P062.Conditions{1,i} = ft_selectdata(cfg, iEEGData);
                end
        end
    end
end
%clearvars('-except', 'AllMacro',  'CSCHippCond', 'SPKcond', 'TrialSelCond', MUAeCond)

clearvars('-except', 'CSCHippCondLFP', 'SPKcondLFP', 'TrialSelCondLFP', 'TrialSelCondiEEG', 'ICConditions')
end