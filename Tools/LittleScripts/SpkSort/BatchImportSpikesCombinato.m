function [SPKSort, Rest] = BatchImportSpikesCombinato(Basepath, subjID)
addpath(genpath([Basepath, 'Mircea\Tools\BonnScripts\combinato_wrappers']),genpath([Basepath, 'Mircea\Tools\NlxWindowsRead']));

for k = 1:length(subjID)
    Direct = [Basepath, 'Mircea/Spike/', subjID{k},'/'];
    for m = 1:length(dir(Direct))-2
        NewDirect =  [Basepath,'Mircea/Spike/', subjID{k},'/ses-',num2str(m),'/'];
        NewDirecty = accumarray(ones(length(NewDirect),1),[1:length(NewDirect)]',[],@(x){[NewDirect(x)]});
        cd(NewDirecty{1})
        
        FieldSelection(1) = 1; %timestamps
        FieldSelection(2) = 0; %Channel Numbers
        FieldSelection(3) = 0; %Sample Frequency
        FieldSelection(4) = 0; %Number of Valid Samples
        FieldSelection(5) = 1; %Samples
        
        ExtractHeader = 1;
        ExtractMode = 1; % 1 = extract all samples
        ModeArray = [];
        
        [CSCfiles] = dir([NewDirecty{1,1},'*.ncs']);
        
        load('cluster_info.mat')
        
        %% get_combinatomatsMimi('sort_pos_mxv', 'sort_neg_mxv', drop, length(dir('*.ncs')))
        for c = 1:length(CSCfiles)
            
            [timestampsCSC, dataSamplesCSC, hdrCSC] = Nlx2MatCSC([NewDirecty{1,1}, CSCfiles(c).name], FieldSelection, ExtractHeader, ExtractMode, ModeArray);
            
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
            
            [TimeStampPerSample] = 1/Fs*1e6;
            
            dataSamplesCSC = double(dataSamplesCSC(:))'; %flattening by applying scaling factor
            dataSamplesCSC = dataSamplesCSC.*scalef.*1e6;
            
            [CSCTime] = 0:1/Fs:(length(dataSamplesCSC)-1)/Fs;
            
            %timevector of CSCtime
            [SPKTime] = uint64(timestampsCSC(1):TimeStampPerSample:timestampsCSC(1)+(length(dataSamplesCSC)-1)*TimeStampPerSample);
            
            ChannelName =  CSCfiles(c).name(1:end-4);
            load([Basepath, 'Mircea/Spike/', subjID{k},'/ses-',num2str(m),'/','times_', ChannelName,'.mat'])
            
            clear SortSpikes
            cd([NewDirecty{1},'CSC',num2str(c),'/sort_pos_mxv/'])
            SortSpikes.classes(:,1)     = double(h5read('sort_cat.h5','/index'));
            SortSpikes.classes(:,2)     = double(h5read('sort_cat.h5','/classes'));
            SortSpikes.group            = h5read('sort_cat.h5','/groups');
            SortSpikes.classes(:,3)     = arrayfun(@(x) SortSpikes.group(2,SortSpikes.group(1,:) == SortSpikes.classes(x,2)),1:length(SortSpikes.classes(:,2)))';
            cd ..
            SortSpikes.times           = h5read(['data_CSC',num2str(c),'.h5'],'/pos/times');
            SortSpikes.spikes          = h5read(['data_CSC',num2str(c),'.h5'],'/pos/spikes');
            
            chanLab     = cluster_info{2,c};
            n = size(SortSpikes.spikes',2);
            wft = linspace(0,(n-1)/Fs,n);% time vector of waveform
            
            dum{c}.hdr                  = hdrCSC;
            dum{c}.waveform{1}(1,:,:)   = SortSpikes.spikes; %spikes';
            dum{c}.timestamp{1}         = SortSpikes.times'; %cluster_class(:,2)'; % in s  (waveclus does it in ms usually)
            dum{c}.unit{1}              = SortSpikes.classes(:,3)';%cluster_class(:,1)';
            dum{c}.waveformdimord       = '{chan}_lead_time_spike';
            dum{c}.waveformtime         = wft;%
            dum{c}.label                = {['sig_',chanLab,'_sorted_wvf']};
            disp([subjID{k}, 'Ses ', num2str(m), dum{c}.label])                     
        end
        [SPKSort{1,k}{1,m}]     = ft_appendspike( [], dum{:} );
        Rest{1,k}{1,m}.tsps     = TimeStampPerSample; 
        Rest{1,k}{1,m}.spktim   = SPKTime;
        Rest{1,k}{1,m}.csctim   = CSCTime;
        
        clear dum
    end
end
end