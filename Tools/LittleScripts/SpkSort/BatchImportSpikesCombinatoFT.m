genpath([Basepath, 'Mircea\Tools\BonnScripts\combinato_wrappers']);

subjidx = 'P07';
switch subjidx
    case 'P07'
        DataLocation    = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0007\micro\sub-0007_task-spes\2017-05-03_13-22-25/';
        subjID         = {'sub-0007'};
    case 'P072'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0007\micro\sub-0007_task-spes\2017-05-04_13-53-58/';
        subjID         = {'sub-0007'};
    case 'P08'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0008\micro\sub-0008_task-spes\2017-06-06_10-12-13/';
        subjID         = {'sub-0008'};
    case 'P082'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0008\micro\sub-0008_task-spes\2017-06-07_10-17-19/';
        subjID         = {'sub-0008'};
    case 'P09'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0009\micro\sub-0009_task-spes\2017-08-31_13-10-20/';
        subjID         = {'sub-0009'};
    case 'P10'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0012\micro\sub-0012_task-spes\2019-08-22_14-15-45/';
        subjID         = {'sub-0012'};
    case 'P102'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0012\micro\sub-0012_task-spes\2019-08-28_13-24-08/';
        subjID         = {'sub-0012'};
    case 'P11'
        DataLocation  = '\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0013\micro\sub-0013_task-spes\2019-12-10_11-39-48/';
        subjID         = {'sub-0013'};
    case 'P112'
        DataLocation  ='\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0013\micro\sub-0013_task-spes\2019-12-11_09-27-48';
        subjID         = {'sub-0013'};
    case 'P113'
        DataLocation  ='\\its-rds.bham.ac.uk\nr-castles\projects\w\wimberm-ieeg-memory\Archive\sub-0013\micro\sub-0013_task-competition\2019-12-17_14-49-15';
        subjID         = {'sub-0013'};
end


i = 1;
NewDirect = ['Z:\Mircea\Spike\', subjID(i), '\ses-1\'];
NewDirecty = accumarray(ones(length(NewDirect),1),[1:length(NewDirect)]',[],@(x){[NewDirect{x}]});
cd(NewDirecty{1})

%get_combinatomatsMimi('sort_pos_mxv', 'sort_neg_mxv', drop, length(dir('*.ncs')))

%% 
%% define the FieldSelection variable and set the ExtracMode. 
AppendToFileFlag    = 0; % 0 = new file is created  
ExportMode          = 1; % 2 = extract record index range; 4 = extract timestamps range.
ExportModeVector    = 1;

FieldSelection(1) = 1;  % Timestamps
FieldSelection(2) = 0;  % Channel Numbers
FieldSelection(3) = 0;  % Sample Freq
FieldSelection(4) = 0;  % Number of Valid Samples
FieldSelection(5) = 1;  % Samples
FieldSelection(6) = 1;  % Header 

[CSCfiles] = dir([DataLocation,'*.ncs']);

for k = 1:length(CSCfiles)
    % Documentation is wrong, Fieldselection is 2nd instead of 4th
    % parameter
    [timestampsCSC, dataSamplesCSC, hdrCSC]  = Nlx2MatCSC([DataLocation,CSCfiles(k).name], FieldSelection, AppendToFileFlag, ExportMode,ExportModeVector); %, Timestamps, ChannelNumbers, SampleFrequencies, NumberOfValidSamples, Samples, Header)
   
    ChannelName = sprintf('CSC%d',k);
    
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

    
    
    load cluster_info
    load(['times_', ChannelName,'.mat'])
    
    AllSpikesC{1,i}.Info.Label               = label_info;
    AllSpikesC{1,i}.Info.Clusters            = cluster_info;
    AllSpikesC{1,i}.Channel{1,k}.spikes      = spikes;
    AllSpikesC{1,i}.Channel{1,k}.spikeIdx    = cluster_class;
    
    dum2{k}.hdr                  = hdrCSC;
    dum2{k}.waveform{1}(1,:,:)   = sortedSpikes.wavf';
    dum2{k}.timestamp{1}        = SPKTime(sortedSpikes.newSpikeTimes);
    dum2{k}.unit{1}              = sortedSpikes.assignedCluster;
    dum2{k}.waveformdimord       = '{chan}_lead_time_spike';
    dum2{k}.waveformtime         = wft;%
    dum2{k}.label                = {['sig_',chanLab,'_sorted_wvf']};
    
end

[SPKdat] = ft_appendspike( [], dum2{:} );

%cID = unique(dum2{k}.unit{1});
%dum2{k}.label = cell(1,length(cID));
%for jt = 1:length(cID)
%    dum2{k}.label(jt)         ={['sig',num2str(k),'_wvf',num2str(jt)]};
    %end;
save([Basepath, 'Mircea\Datasaves\','AllSpikes'], 'AllSpikes', '-v7.3')