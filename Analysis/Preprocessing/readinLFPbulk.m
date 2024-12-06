subjall = {'P05','P06','P12'};
for cnt = 1:3
    subjID = subjall{cnt};
    %%add 0010
    
    switch subjID
        case 'P07'
            ID  = 'sub-0007';
            Project = 'Project0314';
        case 'P072'
            ID  = 'sub-0007';
            Project = 'Project0314';
        case 'P08'
            ID  = 'sub-0008';
            Project = 'Project0314';
        case 'P082'
            ID  = 'sub-0008';
            Project = 'Project0314';
        case 'P09'
            ID  = 'sub-0009';
            Project = 'Project0315';
        case 'P10'
            ID  = 'sub-0012';
            Project = 'Project0315';
        case 'P102'
            ID  = 'sub-0012';
            Project = 'Project0315';
        case 'P11'
            ID  = 'sub-0013';
            Project = 'Project0316';
        case 'P112'
            ID  = 'sub-0013';
            Project = 'Project0316';
        case 'P05'
            ID  = 'sub-0005';
            Project = 'Project0314';
        case 'P06'
            ID  = 'sub-0006';
            Project = 'Project0314';
        case 'P12'
            ID  = 'sub-0010';
            Project = 'Project0315';
    end
    
    %Datapath = ['\\raw.psy.gla.ac.uk\',Project,'\',ID, '\micro\',ID,'_task-spes'];
    Datapath = ['//raw/',Project,'/',ID, '/micro/',ID,'_task-spes'];
    
    if length(subjID) >= 4
        ses = str2num(subjID(4));
    else
        ses = 1;
    end
    
    switch subjID
        case 'P07'
            DataLocation  =  [Datapath,'/2017-05-03_13-22-25/'];
        case 'P072'
            DataLocation  =  [Datapath,'/2017-05-04_13-53-58/'];
        case 'P08'
            DataLocation  =  [Datapath,'/2017-06-06_10-12-13/'];
        case 'P082'
            DataLocation  =  [Datapath,'/2017-06-07_10-17-19/'];
        case 'P09'
            DataLocation  =  [Datapath,'/2017-08-31_13-10-20/'];
        case 'P10'
            DataLocation  =  [Datapath,'/2019-08-22_14-15-45/'];
        case 'P102'
            DataLocation  =  [Datapath,'/2019-08-28_13-24-08/'];
        case 'P11'
            DataLocation  =  [Datapath,'/2019-12-10_11-39-48/'];
        case 'P112'
            DataLocation  =  [Datapath, '/2019-12-17_14-49-15_matfiles/'];
        case 'P05'
            DataLocation  =  [Datapath, '/2016-12-06_10-29-05/'];
        case 'P06'
            DataLocation  =  [Datapath, '/2017-03-31_10-56-36/'];
        case 'P12'
            DataLocation  =  [Datapath, '/2017-10-05_14-18-37/'];
    end
    
    DataLocationIC = [Basepath, 'Mircea/3 - SPES/Datasaves/Macro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    DataLocationMC = [Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID(1:3),'/Ses', num2str(ses),'/'];
    
    % trial-parameters
    pre = 3;
    post = 3;
    % StimArtFig to explore uncut data
    %[SR] = findSR(DataLocation); %Doublecheck the Sampling Rate
    %% %%%% Preprocessing %%% %%
    %% Read in the Data
    
    [p2d] = DataLocation;
    %ReadData        % Reads data: LFP data as CSCdat; Unsorted Spike data as SPKdat; SpikeSorted Data as SortedSPKdat, data always already lowpassfiltered at 300;
    [CSCdatNF] = readinlfpnofilter(p2d, subjID); % Output: CSCdatNF | Read in data with no filtering
    save([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID, '_Base','.mat'], 'CSCdatNF', '-v7.3')
    clear CSCdatNF
    [ CSCdatSPKint] = readinlfpnofilterSpkInt(p2d, subjID); % Output: CSCdatNF | Read in data with no filtering
    save([Basepath, 'Mircea/3 - SPES/Datasaves/Micro/',subjID, '_BaseInt','.mat'], 'CSCdatSPKint', '-v7.3')
    clearvars -except subjall cnt Basepath
end