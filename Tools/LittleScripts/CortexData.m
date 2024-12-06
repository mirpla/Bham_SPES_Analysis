%% Setting the parameters
TBlckN      = 12;               % Amount of Total Blocks
sesN        = 2;                % Amount of Sessions
BlckN       = TBlckN/sesN;      % Amount of Blocks per session
TrlN        = 192;              % Total Amount of Trials
BlckTN      = TrlN / TBlckN;    % Amount of Trials per Block

BsesStrct    = repmat([ones(1,BlckTN),ones(1,BlckTN)*2],1,BlckN)';

AudDelay    = 10;               % 10 ms Auditory delay set to depend on samples
TrigDelay   = 5;                % 5 ms delay on average due to the trigger
Datapath    = 'C:\Users\mxv796\Study Files';
DataEEG     = [Datapath, '\Data\EEG\'];
DataTest    = [Datapath, '\Data\Behav\TestData\'];   
zeroPoint   = TrigDelay + AudDelay;
warning('OFF', 'MATLAB:table:ModifiedVarnames'); % Turn warning for READTABLE off because i dont use Table variable names anyway 

%% Run Script for every participant and every session
for subjID = 1:length(dir([DataEEG, 's*.*']))     % Subject counter
    if mod(subjID,2) == 1       % Even number means:    Session 1: Experimental Session;    Session 2: Control Session
        SesMont{subjID} = [1,2];
    elseif  mod(subjID,2) == 0  % Odd number means:     Session 1: Control Session;          Session 2: Experimental Session
        SesMont{subjID} = [2,1];
    end
    
    for sescnt = 1:sesN       % Session counter
        CondID = SesMont{subjID}(sescnt);
        %% Load Test CSV Behavioral Data
        
        for b = (1:BlckN) + ((BlckN)*(sescnt-1))
            AllRep  = readtable([DataTest, 'subj', num2str(subjID),'\subj', num2str(subjID),'-block-',num2str(b),'-Test.csv'], 'ReadVariableNames',true); %'Format', '%d%d%d%s%s%s%d%s%s%s%s%s%d%d%d');
            if sescnt == 1
                Rep{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)             = [table2array(AllRep(:,13)),table2array(AllRep(:,14))];
                RepS{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)            = [table2array(AllRep(:,5)), table2array(AllRep(:,6))];
                React{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)           = table2array(AllRep(:,15));
            elseif sescnt == 2
                Rep{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1)-(192/2),:)     = [table2array(AllRep(:,13)),table2array(AllRep(:,14))];
                RepS{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1)-(192/2),:)    = [table2array(AllRep(:,5)), table2array(AllRep(:,6))];
                React{subjID,CondID}((1:BlckTN)+(BlckTN)*(b-1),:)           = table2array(AllRep(:,15));
            else
                warning('WARNING: WRONG SESSION ID')
            end
            if b == 1
                AllRepConc{subjID, CondID} = [AllRep];
            else 
                 AllRepConc{subjID, CondID} = [AllRepConc{subjID, CondID}; AllRep];
            end 
            
        end
        
        %% Reading in the .EEG data        
       
        cfg = [];
        cfg.datafile     = [DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.eeg'];
        cfg.headerfile   = [DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.vhdr'];
        cfg.demean       = 'yes';
        [data{subjID,CondID}] = ft_preprocessing(cfg); % Data split by montage, not session 
        AllTriggers = ft_read_event([DataEEG,'s',num2str(subjID),'\ses',num2str(sescnt),'.vmrk']);
        fs = data{subjID,CondID}.hdr.Fs;
        t = 1;
        t2 = t;
        et = t;
        
        for x = 1:size(AllTriggers, 2)
            if  strcmp(AllTriggers(1,x).value, 'S  8')
                trl{subjID,CondID}(t,1) = AllTriggers(1,x).sample - fs;
                trl{subjID,CondID}(t,2) = AllTriggers(1,x).sample + fs;
                trl{subjID,CondID}(t,3) = -fs;
                t = t+1;
            elseif strcmp(AllTriggers(1,x).value, 'S  2')
                ISI(t2) = AllTriggers(1,x).sample;
                t2 = t2+1;
            else
                empT(et) = AllTriggers(1,x).sample;
                et = et+1;
            end
        end
        clear ISI et
        
        trev = TrlN-1:-1:1-1 ; %% Creation of TrialInfo where 1 = encoding trial and 2 = retrieval Trial and 0 = Practice Trial
        
        % !!!!!!!!! IMPORTANT!!!!!!!!!! DOESNT WORK IF EXPERIMENT EVER WAS PREMATURLY FINISHED
        
        for t = TrlN:-1:1 %% correctly label retrieval trials and encoding trial, Implementation is meant to take into account cancelled first blocks or too late starts
           if length(trl{subjID,CondID}) == trev(t)
               break;
           end            
            indt = length(trl{subjID,CondID})-trev(t); % Account for fact that practice trial or false starts are included in the experiment
            trl{subjID,CondID}(indt,4) = BsesStrct(t,1);
        end 
             
        NewTrl = trl{subjID,CondID}(find(trl{subjID,CondID}(:,4)==1),:);
        
        cfg = [];
        cfg.trl = NewTrl;
        trlData{subjID,CondID} = ft_redefinetrial(cfg, data{subjID,CondID});
  
        %% Determine Phase
        cfg                             =   [];
        cfg.bpfreq                      =   [3,5];
        cfg.bpfilter                    =	'yes';
        cfg.bpfilttype                  =   'fir';
        Dataprefilt{subjID,CondID} =	ft_preprocessing(cfg,  trlData{subjID,CondID}); % Filtering of Data in 4Hz band to account for Noise in the data
       
        %wrapN = @(x, n) (1 + mod(x-1, n));
        
        for trlidx = 1: length(trlData{subjID,CondID}.trial)              
            clear PhaseDiff
            PhaInf  = angle(hilbert(Dataprefilt{subjID,CondID}.trial{1,trlidx}));
            PhaseInf0(1,1) = PhaInf(1000+round(zeroPoint*fs/1000)); %rad2deg(PhaInf(1000+round(zeroPoint*fs/1000)));        % 
            %% LOAD SOUNDFILE   
            dwnsnum     =   22;
            
            % extract the envelope                       
            sPath                   =   strcat(Datapath ,'\Materials\sounds\Theta\',RepS{subjID,CondID}(trlidx,1),'\',table2array(AllRepConc{1,1}(trlidx,6)));
            [SoundFile, soundFs]    =   audioread(sPath{1,1});
            envelStim               =   envelope(SoundFile,2000,'rms');
            %envelAmp                =   envelope(SoundFile,50000,'rms');
            %envelAmpNorm            =   envelStim-max(envelStim)+((max(envelStim)-min(envelStim))/2);
                       
            soundTimes              =   0:1/soundFs:(133800/soundFs)-1/soundFs;
                
            % downsample the audiofile due RAM issues (original matrices will exceed 120 GB)
            DSoundFile              =   downsample(SoundFile, dwnsnum);
            DEnvelStim              =   downsample(envelStim, dwnsnum);
            DsoundTimes             =   downsample(soundTimes, dwnsnum);
            
            % Fit the Sine
            [SinSound] = FitSine4Hz(1:length(DEnvelStim(:,1)),  DEnvelStim(:,1)');
             
            % plot the sound, the envelope and the fitted sine
            figure;
            hold on
            plot(DsoundTimes, DSoundFile(:,1)');
            plot(DsoundTimes, DEnvelStim(:,1)');
            plot(DsoundTimes, SinSound      - min(SinSound))
            %plot(DsoundTimes, -SinSound     + min(SinSound));
            hold off
                       
            % find first zero-point
%             [sinpk, sinlc]      = findpeaks(-SinSound + min(SinSound),1);
%             StimOnset              = sinlc(1,1);
                        
            % Determine Phase
            PhaSine     = angle(hilbert(SinSound)); %unwrap(angle(hilbert(SinSound)));
            PhaSound    = PhaSine(1,1); %rad2deg(PhaSine(1,1));
            
            % Subtract Stim phase from EEG phase for Phase-difference
            PhaseDiff = rad2deg(angdiff(PhaseInf0(1,1), PhaSound)); 
                                
            %% compare with EEG 
            
            if -45<PhaseDiff(1,1) && PhaseDiff(1,1)<=45    % Labels take into account 90° Phase Shift from the Hilber transform
                PhaseDiff(1,2) = int32(1);
            elseif 45<PhaseDiff(1,1) && PhaseDiff(1,1)<=135
                PhaseDiff(1,2) = int32(2);
            elseif (135<PhaseDiff(1,1) && PhaseDiff(1,1)<=180) || (-180<=PhaseDiff(1,1) && PhaseDiff(1,1)<=-135)
                PhaseDiff(1,2) = int32(3);
            elseif -135<PhaseDiff(1,1) && PhaseDiff(1,1)<=-45
                PhaseDiff(1,2) = int32(4);
            else
                disp('Value Not Good')
                PhaseDiff(1,2) = int32(0);
            end
            AllPhaseInf{subjID}(trlidx,:) = PhaseDiff;
        end
        
     
        find( table2array(AllRepConc{subjID,CondID}(:,7)) == 0 )    
        
        %% Exclude <40% performance
        CorrectTrl{subjID,CondID}   = find(Rep{subjID,CondID}(:,1) == Rep{subjID,CondID}(:,2));
        HitRate{subjID,CondID}      = length(CorrectTrl{subjID,CondID})/size(Rep{subjID,CondID},1);
        BadPerfSubj{subjID,CondID}  = HitRate{subjID,CondID}<0.40;
        Rep{subjID,CondID+2} = AllPhaseInf{subjID}(find(trlData{subjID,CondID}.trialinfo == 2),:);     
        OutputRep = [Rep{subjID,CondID},Rep{subjID,CondID}(:,1) == Rep{subjID,CondID}(:,2), Rep{subjID,CondID+2}];
        
%         writematrix(OutputRep,'.csv')
    end 
end 