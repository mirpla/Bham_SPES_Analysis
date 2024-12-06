FieldSelection(1) = 1; %timestamps
FieldSelection(2) = 0; %Channel Numbers
FieldSelection(3) = 0; %Sample Frequency
FieldSelection(4) = 0; %Number of Valid Samples
FieldSelection(5) = 1; %Samples 
ExtractHeader = 1;
ExtractMode = 1; % 1 = extract all samples
ModeArray = [];

[p2d] = 'Z:\Mircea\Data4maria'; %Z:\Mircea\Data4maria; /media/mxv796/rds-share/Mircea/Data4maria
%[CSCfiles] = dir([p2d, '*.ncs']);
cd(p2d);

files = dir;
L = length(files);
index = false(1, L);
for k = 1:L
    M = length(files(k).name);
    if M > 4 && strcmp(files(k).name(M-3:M), '.ncs')
        index(k) = true;
    end
end
CSCfiles= files(index);

dum = cell(1,length(CSCfiles));
for it = 1:length(CSCfiles)
    
    chanLab = CSCfiles(it).name;
    chanLab(regexp(chanLab,'_')) = [];
    chanLab(regexp(chanLab,'CSC'):regexp(chanLab,'CSC')+2) = [];
    chanLab(regexp(chanLab,'.ncs'):end) = [];
    % Nlx2MatCSC_V3(Inputfilenameandpath, FieldselectionArray,
    % extractheader (1 yes, 0 no), Extractionmode, Extractmodearray (if
    % mode ~1)
    
    [timestampsCSC, dataSamplesCSC, hdrCSC] = Nlx2MatCSC_v3([p2d,CSCfiles(it).name], FieldSelection, ExtractHeader, ExtractMode, ModeArray);

    chck = regexp(hdrCSC,'ADBitVolts');
    selIdx = [];
    for jt = 1:length(chck);
        selIdx(jt) = ~isempty(chck{jt});
    end;
    selIdx = find(selIdx~=0);
    scalef = str2double(hdrCSC{selIdx}(min(regexp(hdrCSC{selIdx}, '\d')):end));
       
    chck = regexp(hdrCSC, 'SamplingFrequency');
    selIdx = [];
    for jt = 1:length(chck);
        selIdx(jt) = ~isempty(chck{jt});
    end;
    selIdx = find(selIdx~=0);
    Fs = str2double(hdrCSC{selIdx}(min(regexp(hdrCSC{selIdx}, '\d')):end));
    
    dataSamplesCSC = double(dataSamplesCSC(:))';
    dataSamplesCSC = dataSamplesCSC.*scalef.*1e6;
    
    [CSCTime] = 0:1/Fs:(length(dataSamplesCSC)-1)/Fs;
    
    dum{it} = [];
    dum{it}.trial{1} = dataSamplesCSC;
    dum{it}.time{1}  = CSCTime;
    dum{it}.label    = {chanLab};
    dum{it}.cfg.hdr  = ft_read_header([p2d,CSCfiles(it).name]);hdrCSC;
    dum{it}.fsample  = Fs; 
    dum{it}.nChans   = 1;
    dum{it}.nTrials  = 1;
end;

%% Load in Trigger-events (TTLs)

FieldSelection(1) = 1; %timestamps
FieldSelection(2) = 0; % eventsIds
FieldSelection(3) = 1; %TTLs
FieldSelection(4) = 0; %Extra
FieldSelection(5) = 0; %Event strings

ExtractHeader = 1;
ExtractMode = 1;
ModeArray = [];
%[EVfile] = dir([p2d, '*.nev']);

files = dir;
L = length(files);
index = false(1, L);
for k = 1:L
    M = length(files(k).name);
    if M > 4 && strcmp(files(k).name(M-3:M), '.ncs')
        index(k) = true;
    end
end
[EVfiles] = files(index);


[TimeStampsTTL, ttls, hdrTTL] = Nlx2MatEV_v3( [p2d, EVfile.name], FieldSelection, ExtractHeader, ExtractMode, ModeArray); 

[events] = zeros(size(ttls,2),2);
events(:,1) = TimeStampsTTL';
events(:,2) = ttls';



%% fiedltripcompatbile CSCdata

[CSCdat] = ft_appenddata( [], dum{:} );