function [SPKSort, Rest] = BatchImportSpikesWC(Basepath, subjID, direction)
for k = 1:length(subjID)
    Direct = [Basepath, 'Mircea/Spike/', subjID{k},'/'];
    for m = 1:length(dir(Direct))-2
        for j = 1:length(direction)
            x = 1;
            NewDirect       =  [Basepath,'Mircea/Spike/', subjID{k},'/ses-',num2str(m),'/'];
            NewDirectdir    =  [NewDirect , direction{j}];
            NewDirecty      = accumarray(ones(length(NewDirect),1),[1:length(NewDirect)]',[],@(x){[NewDirect(x)]});
            cd(NewDirectdir)
            
            if strcmp(subjID{k}, 'sub-0013') && m == 2
                fulldatpath = '\\raw.psy.gla.ac.uk\project0316\sub-0013\micro\sub-0013_task-competition\2019-12-17_14-49-15\';
                
                FieldSelection(1) = 1; %timestamps
                FieldSelection(2) = 0; %Channel Numbers
                FieldSelection(3) = 0; %Sample Frequency
                FieldSelection(4) = 0; %Number of Valid Samples
                FieldSelection(5) = 1; %Samples
                
                ExtractHeader   = 1;
                ExtractMode     = 1; % 1 = extract all samples
                ModeArray       = [];
                dumfiles        = dir([NewDirecty{1,1},'*.mat']);
                [CSCfiles]      = sort_nat({dumfiles.name});
                for c = 1:length(CSCfiles)
                    ChannelName =  CSCfiles{c}(1:end-4);
                    if isfile([NewDirectdir,'/','times_', ChannelName,'.mat'])
                        dumfiles = dir([fulldatpath, '\*.ncs']);
                        CSCrawFiles = sort_nat({dumfiles.name});
                        ridx = strcmp(ChannelName(1:end-11),erase(string(CSCrawFiles),'.ncs'));
                        [~, ~, hdrCSC] = Nlx2MatCSC([fulldatpath, CSCrawFiles{ridx}], FieldSelection, ExtractHeader, ExtractMode, ModeArray);
                        load([NewDirecty{1,1}, CSCfiles{c}], 'data')
                        dataSamplesCSC = data;
                        Fs = 32000;
                        [TimeStampPerSample] = 1/Fs*1e6;
                        [CSCTime] = 0:1/Fs:(length(dataSamplesCSC)-1)/Fs;
                        
                        %timevector of CSCtime
                        [SPKTime] = 0;
                        load([NewDirectdir,'/','times_', ChannelName,'.mat'])
                        
                        clear SortSpikes
                        
                        n = size(spikes,2);
                        wft = linspace(0,(n-1)/Fs,n);% time vector of waveform
                        
                        dum{x}.hdr                  = hdrCSC;
                        dum{x}.par                  = par;
                        dum{x}.waveform{1}(1,:,:)   = spikes'; %spikes';
                        dum{x}.timestamp{1}         = cluster_class(:,2)'; %cluster_class(:,2)'; % in s  (waveclus does it in ms usually)
                        dum{x}.unit{1}              = cluster_class(:,1)';%cluster_class(:,1)';
                        dum{x}.waveformdimord       = '{chan}_lead_time_spike';
                        dum{x}.waveformtime         = wft;%
                        dum{x}.label                = {[ChannelName(1:end-11),direction{j}]};
                        disp([subjID{k}, 'Ses ', num2str(m), dum{x}.label, direction{j}])
                        x = x+1;
                    else
                        disp([subjID{k}, 'Ses ', num2str(m), num2str(x), ' skipped ', direction{j}])
                    end
                end
                
                [SPKSort{j,k}{1,m}]     = ft_appendspike( [], dum{:} );
                Rest{j,k}{1,m}.tsps     = TimeStampPerSample;
                Rest{j,k}{1,m}.spktim   = SPKTime;
                Rest{j,k}{1,m}.csctim   = CSCTime;
                
                clear dum
            else
                FieldSelection(1) = 1; %timestamps
                FieldSelection(2) = 0; %Channel Numbers
                FieldSelection(3) = 0; %Sample Frequency
                FieldSelection(4) = 0; %Number of Valid Samples
                FieldSelection(5) = 1; %Samples
                
                ExtractHeader = 1;
                ExtractMode = 1; % 1 = extract all samples
                ModeArray = [];
                dumfiles = dir([NewDirecty{1,1},'*.ncs']);
                [CSCfiles] = sort_nat({dumfiles.name});
                
                %% get_combinatomatsMimi('sort_pos_mxv', 'sort_neg_mxv', drop, length(dir('*.ncs')))
                for c = 1:length(CSCfiles)
                    ChannelName =  CSCfiles{c}(1:end-4);
                    
                    if isfile([NewDirectdir,'/','times_', ChannelName,'.mat'])
                        [timestampsCSC, dataSamplesCSC, hdrCSC] = Nlx2MatCSC([NewDirecty{1,1}, CSCfiles{c}], FieldSelection, ExtractHeader, ExtractMode, ModeArray);
                        
                        chck = regexp(hdrCSC, 'ADBitVolts');
                        selIdx = [];
                        for jt = 1:length(chck)
                            selIdx(jt) = ~isempty(chck{jt});
                        end
                        selIdx = find(selIdx~=0);
                        scalef = str2double(hdrCSC{selIdx} (min(regexp(hdrCSC{selIdx},'\d')):end));
                        
                        chck = regexp(hdrCSC, 'SamplingFrequency');
                        selIdx = [];
                        for jt = 1:length(chck)
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
                        load([NewDirectdir,'/','times_', ChannelName,'.mat'])
                        
                        clear SortSpikes
                        
                        n = size(spikes,2);
                        wft = linspace(0,(n-1)/Fs,n);% time vector of waveform
                        channame = extractAfter(hdrCSC,'-AcqEntName');
                        channame = channame(~cellfun('isempty',channame));
                        channamefull = {[channame{1},direction{j}]};
                        
                        dum{x}.hdr                  = hdrCSC;
                        dum{x}.par                  = par;
                        dum{x}.waveform{1}(1,:,:)   = spikes'; %spikes';
                        dum{x}.timestamp{1}         = cluster_class(:,2)'; %cluster_class(:,2)'; % in s  (waveclus does it in ms usually)
                        dum{x}.unit{1}              = cluster_class(:,1)';%cluster_class(:,1)';
                        dum{x}.waveformdimord       = '{chan}_lead_time_spike';
                        dum{x}.waveformtime         = wft;%
                        dum{x}.label                = channamefull;
                        disp([subjID{k}, 'Ses ', num2str(m), dum{x}.label, direction{j}])
                        x = x+1;
                    else
                        
                        disp([subjID{k}, 'Ses ', num2str(m), num2str(x), ' skipped ', direction{j}])
                    end
                end
                
                [SPKSort{j,k}{1,m}]     = ft_appendspike( [], dum{:} );
                Rest{j,k}{1,m}.tsps     = TimeStampPerSample;
                Rest{j,k}{1,m}.spktim   = SPKTime;
                Rest{j,k}{1,m}.csctim   = CSCTime;
                
                clear dum
            end
        end
    end
end
end