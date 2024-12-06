function [SUA, TrialSelCond] = SelectedConditions_wSUA_E(Data)

%% Select Channels that respond most to Local Stimulation
% P07 Right
LFPSelChans{1,1} = [1:8];       %AH
LFPSelChans{1,2} = [17:24];     %MH
LFPSelChans{1,3} = [25:32];     %PH

% P072 Left
LFPSelChans{2,1} = [];         %AH
LFPSelChans{2,2} = [9:16];     %MH
LFPSelChans{2,3} = [];         %PH


% P08 Right
LFPSelChans{3,1} = [9:16];     %AH
LFPSelChans{3,2} = [25:32];    %MH
LFPSelChans{3,3} = [41:48];    %PH (from Distal)

% P082 Left
LFPSelChans{4,1} = [1:8];      %AH
LFPSelChans{4,2} = [17:24];    %MH
LFPSelChans{4,3} = [33:40];    %PH (from Distal)

% P09 Left
LFPSelChans{5,1} = [1:8];         %AH
LFPSelChans{5,2} = [17:24];     %MH
LFPSelChans{5,3} = [49:56];     %PH
%LFPSelChans{5,4} = [36 37 38 39];     %PHG

% P10 Right Huge line noise in right channels following trial 74
LFPSelChans{6,1} = [9:16];    %AH
LFPSelChans{6,2} = [25:32];   %MH
LFPSelChans{6,3} = [57:64];   %PH
%LFPSelChans{6,4} = [];       %PHG

% P102 Left
LFPSelChans{7,1} = [1:8];     %AH
LFPSelChans{7,2} = [17:24];   %MH
LFPSelChans{7,3} = [49:56];   %PH
%LFPSelChans{7,4} = [];       %PHG

%P11 Left
LFPSelChans{8,1} = [];        %AH
LFPSelChans{8,2} = [];        %MH
LFPSelChans{8,3} = [25:32];   %PH

% P112 Right
LFPSelChans{9,1} = [9:16];    %AH
LFPSelChans{9,2} = [];        %MH
LFPSelChans{9,3} = [33:40];   %PH

for k = 1:length(Data)
    for b = 1:length(Data{1,k})
        for chan = 1:length(Data{1,k}{1,b})
            if ~isempty(Data{1,k}{1,b}{1,chan})
                for su = 1:length(Data{1,k}{1,b}{1,chan})
                    switch k
                        case 1
                            if b == 1
                                LocalChanAHLFP  = LFPSelChans{1,1};
                                LocalChanMHLFP  = LFPSelChans{1,2};
                                LocalChanPHLFP  = LFPSelChans{1,3};
                                
                                SUA.AllChan{1,k}{1,b} = {LocalChanAHLFP,LocalChanMHLFP,LocalChanPHLFP; 'LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                                
                                LocalStimHippAHLFP  = [7:8];
                                LocalStimHippMHLFP  = [13:14];
                                LocalStimHippPHLFP  = [19];
                                LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                                
                                
                                DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                                DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                                DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                                
                                CtxStimHippLFP    = [11, 12,17,18, 22,23];
                                
                                wmStimHippAH = [9];
                                wmStimHippMH = [15];
                                wmStimHippPH = [20];
                                wmStimHipp = [ wmStimHippAH, wmStimHippMH, wmStimHippPH];
                                
                                %% Local
                                LHAHLFP = [];
                                for i = 1:length( LocalStimHippAHLFP )
                                    LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,1} = LHAHLFP;
                                
                                LHMHLFP = [];
                                for i = 1:length( LocalStimHippMHLFP )
                                    LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,2} = LHMHLFP;
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                
                                
                                %% Distal HIpp
                                DHAHLFP = [];
                                for i = 1:length( DistalStimHippAHLFP )
                                    DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,4} = DHAHLFP;
                                
                                DHMHLFP = [];
                                for i = 1:length( DistalStimHippMHLFP )
                                    DHMHLFP = [DHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,5} = DHMHLFP;
                                
                                DHPHLFP = [];
                                for i = 1:length(  DistalStimHippPHLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                %% All Hippocampus
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                                
                                
                            elseif b ==2
                                LocalChanMHLFP  = LFPSelChans{2,2};
                                
                                SUA.AllChan{1,k}{1,b} = { LocalChanMHLFP; 'LocalChanMH'};
                                
                                LocalStimHippMHLFP  = [1,2,3];
                                
                                %DistalStimHippMH  = [LLocalStimHippAH, LLocalStimHippPH];
                                
                                LCtxStimHippLFP    = [6, 7];
                                
                                wmStimHippMH = [4];
                                wmStimHipp = [ wmStimHippMH];
                                
                                %                     RCtxStimCLFP       = [9:13];
                                %                     RCtxStimOLFP       = [14:16];
                                %                     RCtxStimPLFP       = [17:21];
                                %                     RCtxStimOFLFP      = [22:27];
                                
                                %% Local
                                
                                LHMHLFP = [];
                                for i = 1:length( LocalStimHippMHLFP )
                                    LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,2} = LHMHLFP;
                                TrialSelCond{k,b,8} = LHMHLFP;
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( LCtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LCtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                              end
                        case 2
                            if b == 1
                                LocalChanAHLFP  = LFPSelChans{3,1};
                                LocalChanMHLFP  = LFPSelChans{3,2};
                                LocalChanPHLFP  = LFPSelChans{3,3};
                                
                                LocalChanCAH  = LFPSelChans{4,1};
                                LocalChanCMH  = LFPSelChans{4,1};
                                LocalChanCPH  = LFPSelChans{4,1};
                                
                                SUA.AllChan{1,k}{1,b} = {LocalChanAHLFP, LocalChanMHLFP, LocalChanPHLFP,LocalChanCAH,LocalChanCMH,LocalChanCPH; 'LocalChanAH', 'LocalChanMH', 'LocalChanPH','ContralateralChanAH','ContralateralChanMH','ContralateralChanPH'};
                                
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
                                
                                wmStimHippAH = [4];
                                wmStimHippMH = [11];
                                wmStimHippPH = [18];
                                wmStimHipp = [ wmStimHippAH, wmStimHippMH, wmStimHippPH];
                                
                                %% Local
                                LHAHLFP = [];
                                for i = 1:length( LocalStimHippAHLFP )
                                    LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,1} = LHAHLFP;
                                
                                LHMHLFP = [];
                                for i = 1:length( LocalStimHippMHLFP )
                                    LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,2} = LHMHLFP;
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                
                                
                                %% Distal HIpp
                                DHAHLFP = [];
                                for i = 1:length( DistalStimHippAHLFP )
                                    DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,4} = DHAHLFP;
                                
                                DHMHLFP = [];
                                for i = 1:length( DistalStimHippMHLFP )
                                    DHMHLFP = [DHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,5} = DHMHLFP;
                                
                                DHPHLFP = [];
                                for i = 1:length(  DistalStimHippPHLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                                
                                                                
                            elseif b == 2
                                LocalChanAHLFP  = LFPSelChans{4,1};
                                LocalChanMHLFP  = LFPSelChans{4,2};
                                LocalChanPHLFP  = LFPSelChans{4,3};
                                
                                LocalChanCAH  = LFPSelChans{3,1};
                                LocalChanCMH  = LFPSelChans{3,1};
                                LocalChanCPH  = LFPSelChans{3,1};
                                
                                SUA.AllChan{1,k}{1,b} = {LocalChanAHLFP, LocalChanMHLFP, LocalChanPHLFP,LocalChanCAH,LocalChanCMH,LocalChanCPH; 'LocalChanAH', 'LocalChanMH', 'LocalChanPH','ContralateralChanAH','ContralateralChanMH','ContralateralChanPH'};
                                
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
                                
                                wmStimHippAH = [4];
                                wmStimHippMH = [11];
                                wmStimHippPH = [18];
                                wmStimHipp = [ wmStimHippAH, wmStimHippMH, wmStimHippPH];
                                
                                %% Local
                                LHAHLFP = [];
                                for i = 1:length( LocalStimHippAHLFP )
                                    LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,1} = LHAHLFP;
                                
                                LHMHLFP = [];
                                for i = 1:length( LocalStimHippMHLFP )
                                    LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,2} = LHMHLFP;
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                
                                %% Distal HIpp
                                DHAHLFP = [];
                                for i = 1:length( DistalStimHippAHLFP )
                                    DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,4} = DHAHLFP;
                                
                                DHMHLFP = [];
                                for i = 1:length( DistalStimHippMHLFP )
                                    DHMHLFP = [DHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,5} = DHMHLFP;
                                
                                DHPHLFP = [];
                                for i = 1:length(  DistalStimHippPHLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                                
                             end
                        case 3
                            LocalChanRAHLFP  = [9:16];
                            LocalChanRMHLFP  = [25:32];
                            LocalChanRPHLFP  = [57:64];
                            
                            LocalChanLAHLFP  = LFPSelChans{5,1};
                            LocalChanLMHLFP  = LFPSelChans{5,2};
                            LocalChanLPHLFP  = LFPSelChans{5,3};
                            
                            %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                            %                     LocalChanRParaHLFP = [41:48];
                            %
                            SUA.AllChan{1,k}{1,b} = {LocalChanLAHLFP, LocalChanLMHLFP, LocalChanLPHLFP,LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanLAH', 'LocalChanLMH', 'LocalChanLPH','LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                            
                            LocalStimHippAHLFP  = [1,2];
                            LocalStimHippMHLFP  = [7,8];
                            LocalStimHippPHLFP  = [21,22];
                            %                     LocalStimHippPHGLFP = [14,15];
                            LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                            
                            
                            DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                            DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                            DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                            
                            CtxStimHippAHLFP  = [5,6];
                            CtxStimHippMHLFP  = [12,13];
                            CtxStimHippPHLFP  = [25,26];
                            CtxStimHippPHGLFP = [19,20];
                            CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHGLFP, CtxStimHippPHLFP];
                            
                            wmStimHippAH = [4];
                            wmStimHippMH = [10];
                            wmStimHippPH = [23];
                            wmStimHipp = [ wmStimHippAH, wmStimHippMH, wmStimHippPH,17:18];
                            
                            %% Local
                            LHAHLFP = [];
                            for i = 1:length( LocalStimHippAHLFP )
                                LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                            end
                            TrialSelCond{k,b,1} = LHAHLFP;
                            
                            LHMHLFP = [];
                            for i = 1:length( LocalStimHippMHLFP )
                                LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                            end
                            TrialSelCond{k,b,2} = LHMHLFP;
                            
                            LHPHLFP = [];
                            for i = 1:length( LocalStimHippPHLFP )
                                LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                            end
                            TrialSelCond{k,b,3} = LHPHLFP;
                            
                            %                     LHPparaHLFP = [];
                            %                     for i = 1:length( LocalStimHippPHGLFP )
                            %                         LHPparaHLFP = [LHPparaHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHGLFP(i))];
                            %                     end
                            %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                            
                            %% Distal HIpp
                            DHAHLFP = [];
                            for i = 1:length( DistalStimHippAHLFP )
                                DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                            end
                            TrialSelCond{k,b,4} = DHAHLFP;
                            
                            DHMHLFP = [];
                            for i = 1:length( DistalStimHippMHLFP )
                                DHMHLFP = [DHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippMHLFP(i))];
                            end
                            TrialSelCond{k,b,5} = DHMHLFP;
                            
                            DHPHLFP = [];
                            for i = 1:length(  DistalStimHippPHLFP )
                                DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                            end
                            TrialSelCond{k,b,6} = DHPHLFP;
                            
                            %% LEft Distal Cortex
                            
                            DCLFP = [];
                            for i = 1:length( CtxStimHippLFP )
                                DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                            end
                            TrialSelCond{k,b,7} = DCLFP;
                            
                            LHLFP = [];
                            for i = 1:length( LocalStimHippLFP )
                                LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                            end
                            TrialSelCond{k,b,8} = LHLFP;
                            
                          
                        case 4
                            if b == 1
                                LocalChanRAHLFP  = LFPSelChans{7,1};
                                LocalChanRMHLFP  = LFPSelChans{7,2};
                                LocalChanRPHLFP  = LFPSelChans{7,3};
                                
                                LocalChanLAHLFP  = LFPSelChans{6,1};
                                LocalChanLMHLFP  = LFPSelChans{6,2};
                                LocalChanLPHLFP  = LFPSelChans{6,3};
                                
                                %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                                %                     LocalChanRParaHLFP = [41:48];
                                %
                                SUA.AllChan{1,k}{1,b} = {LocalChanLAHLFP, LocalChanLMHLFP, LocalChanLPHLFP,LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanLAH', 'LocalChanLMH', 'LocalChanLPH','LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                                
                                LocalStimHippAHLFP  = [1,2];
                                LocalStimHippMHLFP  = [7,8];
                                LocalStimHippPHLFP  = [13,14];
                                LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                                
                                
                                DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                                DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                                DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                                
                                CtxStimHippAHLFP  = [5,6];
                                CtxStimHippMHLFP  = [11,12];
                                CtxStimHippPHLFP  = [17,18];
                                CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                                
                                wmStimHippAH = [4];
                                wmStimHippMH = [10];
                                wmStimHippPH = [16];
                                wmStimHipp = [ wmStimHippAH, wmStimHippMH, wmStimHippPH];
                                %% Local
                                LHAHLFP = [];
                                for i = 1:length( LocalStimHippAHLFP )
                                    LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,1} = LHAHLFP;
                                
                                LHMHLFP = [];
                                for i = 1:length( LocalStimHippMHLFP )
                                    LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,2} = LHMHLFP;
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                %                     LHPparaHLFP = [];
                                %                     for i = 1:length( LocalStimHippPHGLFP )
                                %                         LHPparaHLFP = [LHPparaHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHGLFP(i))];
                                %                     end
                                %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                                
                                %% Distal HIpp
                                DHAHLFP = [];
                                for i = 1:length( DistalStimHippAHLFP )
                                    DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,4} = DHAHLFP;
                                
                                DHMHLFP = [];
                                for i = 1:length( DistalStimHippMHLFP )
                                    DHMHLFP = [DHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,5} = DHMHLFP;
                                
                                DHPHLFP = [];
                                for i = 1:length(  DistalStimHippPHLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                               
                            elseif b == 2
                                LocalChanRAHLFP  = LFPSelChans{7,1};
                                LocalChanRMHLFP  = LFPSelChans{7,2};
                                LocalChanRPHLFP  = LFPSelChans{7,3};
                                
                                LocalChanLAHLFP  = LFPSelChans{6,1};
                                LocalChanLMHLFP  = LFPSelChans{6,2};
                                LocalChanLPHLFP  = LFPSelChans{6,3};
                                
                                %                     LocalChanLParaHLFP = LFPSelChans{3,4};
                                %                     LocalChanRParaHLFP = [41:48];
                                %
                                SUA.AllChan{1,k}{1,b} = {LocalChanLAHLFP, LocalChanLMHLFP, LocalChanLPHLFP,LocalChanRAHLFP,LocalChanRMHLFP,LocalChanRPHLFP; 'LocalChanLAH', 'LocalChanLMH', 'LocalChanLPH','LocalChanRAH','LocalChanRMH','LocalChanRPH'};
                                
                                LocalStimHippAHLFP  = [1 2];
                                LocalStimHippMHLFP  = [7,8];
                                LocalStimHippPHLFP  = [13,14];
                                LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                                
                                
                                DistalStimHippAHLFP  = [LocalStimHippMHLFP, LocalStimHippPHLFP];
                                DistalStimHippMHLFP  = [LocalStimHippAHLFP, LocalStimHippPHLFP];
                                DistalStimHippPHLFP  = [LocalStimHippAHLFP, LocalStimHippMHLFP];
                                
                                CtxStimHippAHLFP  = [5,6];
                                CtxStimHippMHLFP  = [11,12];
                                CtxStimHippPHLFP  = [17,18];
                                CtxStimHippLFP    = [CtxStimHippAHLFP,  CtxStimHippMHLFP, CtxStimHippPHLFP];
                                
                                wmStimHippAH = [4];
                                wmStimHippMH = [10];
                                wmStimHippPH = [16];
                                wmStimHipp = [ wmStimHippAH, wmStimHippMH, wmStimHippPH];
                                
                                %% Local
                                LHAHLFP = [];
                                for i = 1:length( LocalStimHippAHLFP )
                                    LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,1} = LHAHLFP;
                                
                                LHMHLFP = [];
                                for i = 1:length( LocalStimHippMHLFP )
                                    LHMHLFP = [LHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,2} = LHMHLFP;
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                %                     LHPparaHLFP = [];
                                %                     for i = 1:length( LocalStimHippPHGLFP )
                                %                         LHPparaHLFP = [LHPparaHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHGLFP(i))];
                                %                     end
                                %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                                
                                %% Distal HIpp
                                DHAHLFP = [];
                                for i = 1:length( DistalStimHippAHLFP )
                                    DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,4} = DHAHLFP;
                                
                                DHMHLFP = [];
                                for i = 1:length( DistalStimHippMHLFP )
                                    DHMHLFP = [DHMHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippMHLFP(i))];
                                end
                                TrialSelCond{k,b,5} = DHMHLFP;
                                
                                DHPHLFP = [];
                                for i = 1:length(  DistalStimHippPHLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                                
                            end
                        case 5
                            if b == 1
                                LocalChanLPHLFP  = LFPSelChans{8,3};
                                
                                SUA.AllChan{1,k}{1,b} = {LocalChanLPHLFP; 'LocalChanLPH'};
                                
                                LocalStimHippPHLFP  = [5,6];
                                %                     LocalStimHippPHGLFP = [14,15];
                                LocalStimHippLFP   =  [LocalStimHippAHLFP,LocalStimHippMHLFP,LocalStimHippPHLFP];
                                
                                CtxStimHippPHLFP  = [10,11];
                                
                                CtxStimHippLFP    = [CtxStimHippPHLFP];
                                
                                wmStimHippPH = [8];
                                wmStimHipp = [ wmStimHippPH];
                                
                                %% Local
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                %% Distal HIpp
                                
                                DHPHLFP = [];
                                for i = 1:length(   CtxStimHippLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                                                             
                            elseif b == 2
                                LocalChanRAHLFP  = LFPSelChans{9,1};
                                LocalChanRPHLFP  = LFPSelChans{9,3};
                                SUA.AllChan{1,k}{1,b} = {LocalChanRAHLFP,LocalChanRPHLFP;'LocalChanRAH','LocalChanRPH'};
                                
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
                                
                                wmStimHippAH = [4];
                                wmStimHippMH = [11];
                                wmStimHipp = [ wmStimHippAH, wmStimHippMH];
                                
                                %% Local
                                LHAHLFP = [];
                                for i = 1:length( LocalStimHippAHLFP )
                                    LHAHLFP = [LHAHLFP ; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,1} = LHAHLFP;
                                
                                LHPHLFP = [];
                                for i = 1:length( LocalStimHippPHLFP )
                                    LHPHLFP = [LHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,3} = LHPHLFP;
                                
                                %                     LHPparaHLFP = [];
                                %                     for i = 1:length( LocalStimHippPHGLFP )
                                %                         LHPparaHLFP = [LHPparaHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   LocalStimHippPHGLFP(i))];
                                %                     end
                                %                     TrialSelCondLFP{k,9} = LHPparaHLFP;
                                
                                %% Distal HIpp
                                DHAHLFP = [];
                                for i = 1:length( DistalStimHippAHLFP )
                                    DHAHLFP = [DHAHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  DistalStimHippAHLFP(i))];
                                end
                                TrialSelCond{k,b,4} = DHAHLFP;
                                
                                DHPHLFP = [];
                                for i = 1:length(  DistalStimHippPHLFP )
                                    DHPHLFP = [DHPHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==   DistalStimHippPHLFP(i))];
                                end
                                TrialSelCond{k,b,6} = DHPHLFP;
                                
                                %% LEft Distal Cortex
                                
                                DCLFP = [];
                                for i = 1:length( CtxStimHippLFP )
                                    DCLFP = [DCLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  CtxStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,7} = DCLFP;
                                
                                LHLFP = [];
                                for i = 1:length( LocalStimHippLFP )
                                    LHLFP = [LHLFP; find(Data{1,k}{1,b}{1,chan}{1,su}.trialinfo ==  LocalStimHippLFP(i))];
                                end
                                TrialSelCond{k,b,8} = LHLFP;
                            end
                    end
                    
                    SUA.Labels  = {'LHAH','LHMH','LHPH','DHAH','DHMH','DHPH','DC', 'LH'};
                    for i = 1:size(TrialSelCond,3)
                        cfg = [];
                        cfg.trials = TrialSelCond{k,b,i};
                        SUA.Conditions{1,k}{1,b}{1,chan}{1,su}{1,i} = ft_spike_select(cfg,Data{1,k}{1,b}{1,chan}{1,su});
                    end
                end
            end
        end
    end
end
end