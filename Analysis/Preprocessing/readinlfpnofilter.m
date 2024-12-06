function [CSCdatNF, CSCdatSPKint] = readinlfpnofilter(p2d, subjID)

%% Same as rest but for subject 13 session 2: The problem here was that this session was recorded as part of a difference session for Marijes STREAM task and has already been converted to .mat files
if strcmp(subjID, 'P112')
    FieldSelection(1) = 1; %timestamps
    FieldSelection(2) = 0; %Channel Numbers
    FieldSelection(3) = 0; %Sample Frequency
    FieldSelection(4) = 0; %Number of Valid Samples
    FieldSelection(5) = 1; %Samples
    ExtractHeader = 1;
    ExtractMode = 1; % 1 = extract all samples
    ModeArray = [];
    
    
    [CSCfiles] = dir([p2d,'*.mat']);
    
    [dum2] = cell(1,length(CSCfiles));
    
    for it = 1:length(CSCfiles)
        chanLab = CSCfiles(it).name;
        chanLab(regexp(chanLab,'_')) = [];
        chanLab(regexp(chanLab,'CSC'):regexp(chanLab,'CSC')+2) = [];
        chanLab(regexp(chanLab,'4200-6240s.mat'):end) = [];
        
        load([p2d, CSCfiles(it).name],'data');
        
        Fs = 32000;
        [TimeStampPerSample] = 1/Fs*1e6;
        
        [CSCTime] = 0:1/Fs:(length(data)-1)/Fs;
        
%         dum{it} = [];
%         dum{it}.trial{1}    = data;
%         dum{it}.time{1}     = CSCTime;
%         dum{it}.label       = {chanLab};
%         dum{it}.fsample  = Fs;
%         
        par = set_parameters_Bham(Fs); %can be a sctript of own design if special requests for specific parameters
      
        [spikeWaveforms1,~,spikeTimestamps1] = amp_detect(data, par);
        
        n = size(spikeWaveforms1,2);
        
        dum2{it} = [];
        if isempty(spikeTimestamps1)
            fprintf(['No Spikes Detected!', '\n', 'No Spike Interpolation performed..'])
            dum2{it}.NoInterp = 1;
        else
            [dataSamplesCSC] = interpLFP(data, spikeTimestamps1, [0.002 0.006], Fs, 'linear');
        end
        
        %LFP data structure
        
        dum2{it}.trial{1} = dataSamplesCSC;
        dum2{it}.time{1}  = CSCTime;
        dum2{it}.label    = {chanLab};
        dum2{it}.fsample  = Fs;
        
    end
    
%     [CSCdatNF] = ft_appenddata ( [], dum{:} );
%     clear dum1
    CSCdatNF ='dummy'
    [CSCdatSPKint] = ft_appenddata( [], dum2{:} );
    clear dum2
    
else
    
    %% Rest of Participants/Sessions
    FieldSelection(1) = 1; %timestamps
    FieldSelection(2) = 0; %Channel Numbers
    FieldSelection(3) = 0; %Sample Frequency
    FieldSelection(4) = 0; %Number of Valid Samples
    FieldSelection(5) = 1; %Samples
    ExtractHeader = 1;
    ExtractMode = 1; % 1 = extract all samples
    ModeArray = [];
    
    [CSCfiles] = dir([p2d,'*.ncs']);
    
    [dum1] = cell(1,length(CSCfiles));
    
    for it = 1:length(CSCfiles)
        chanLab = CSCfiles(it).name;
        chanLab(regexp(chanLab,'_')) = [];
        chanLab(regexp(chanLab,'CSC'):regexp(chanLab,'CSC')+2) = [];
        chanLab(regexp(chanLab,'.ncs'):end) = [];
        
        [timestampsCSC, dataSamplesCSC, hdrCSC] = Nlx2MatCSC_v3([p2d, CSCfiles(it).name], FieldSelection, ExtractHeader, ExtractMode, []);
        
        chck = regexp(hdrCSC, 'ADBitVolts');
        selIdx = [];
        for jt = 1:length(chck);
            selIdx(jt) = ~isempty(chck{jt});
        end
        selIdx = find(selIdx~=0);
        scalef = str2double(hdrCSC{selIdx} (min(regexp(hdrCSC{selIdx},'\d')):end));
        
        chck = regexp(hdrCSC, 'SamplingFrequency');
        selIdx = [];
        for jt = 1:length(chck);
            selIdx(jt) = ~isempty(chck{jt});
        end
        selIdx = find(selIdx~=0);
        Fs = str2double(hdrCSC{selIdx}(min(regexp(hdrCSC{selIdx},'\d')):end));
        
        par = set_parameters_Bham(Fs); %can be a sctript of own design if special requests for specific parameters
        [TimeStampPerSample] = 1/Fs*1e6;
        
        dataSamplesCSC = double(dataSamplesCSC(:))'; %flattening by applying scaling factor
        dataSamplesCSC = dataSamplesCSC.*scalef.*1e6;
        
        [CSCTime] = 0:1/Fs:(length(dataSamplesCSC)-1)/Fs;
        
        %timevector of CSCtime
        [SPKTime] = uint64(timestampsCSC(1):TimeStampPerSample:timestampsCSC(1)+(length(dataSamplesCSC)-1)*TimeStampPerSample);
        
        %% Spikedetection without Sorting for spike interpolation
        [spikeWaveforms1,~,spikeTimestamps1] = amp_detect(dataSamplesCSC, par);
        
        n = size(spikeWaveforms1,2);
        %    wft = linspace(0,(n-1)/Fs,n);
        %     dum3{it} = [];
        %     dum3{it}.hdr = hdrCSC;
        %     dum3{it}.label = {['sig_',chanLab,'_all_wvf']};
        %     dum3{it}.waveform{1}(1,:,:) = spikeWaveforms1';
        %     dum3{it}.timestamp{1} = SPKTime(spikeTimestamps1);
        %     dum3{it}.unit{1} = zeros(1, length(spikeTimestamps1));
        %     dum3{it}.waveformdimord = '{chan}_lead_time_spike';
        %     dum3{it}.waveformtime = wft;
        %
        
        dum1{it} = [];
        dum1{it}.trial{1} = dataSamplesCSC;
        dum1{it}.time{1}  = CSCTime;
        dum1{it}.label    = {chanLab};
        dum1{it}.cfg.hdr  = hdrCSC;
        dum1{it}.fsample  = Fs;
        
%         dum2{it} = [];
%         if isempty(spikeTimestamps1)
%             fprintf(['No Spikes Detected!', '\n', 'No Spike Interpolation performed..'])
%             dum2{it}.NoInterp = 1;
%         else
%             [dataSamplesCSC] = interpLFP(dataSamplesCSC, spikeTimestamps1, [0.002 0.006], Fs, 'linear');
%         end
%         
%         %LFP data structure
%         
% %         dum2{it}.trial{1} = dataSamplesCSC;
% %         dum2{it}.time{1}  = CSCTime;
% %         dum2{it}.label    = {chanLab};
% %         dum2{it}.cfg.hdr  = hdrCSC;
% %         dum2{it}.fsample  = Fs;
        clear dataSamplesCSC
    end
    
    [CSCdatNF] = ft_appenddata ( [], dum1{:} );
    clear dum1
    
end
end