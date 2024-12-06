function [SPKSort, Rest] = ReadDataWC(Basepath, subjID, Direction)
% subjID is a cell array with each Subject to be analysed while basepath
% leads to the folderstructure to be used
for k = 1:length(subjID)
    Direct = [Basepath, 'Mircea/3 - SPES/Spike/', subjID{k},'/'];
    for m = 1:length(dir(Direct))-2
        NewDirect =  [Basepath,'Mircea/3 - SPES/Spike/', subjID{k},'/ses-',num2str(m),'/'];
        NewDirecty = accumarray(ones(length(NewDirect),1),[1:length(NewDirect)]',[],@(x){[NewDirect(x)]});
        cd(NewDirecty{1})
              
        if ~exist(Direction, 'dir')
            mkdir(Direction)
        end
        if ~(strcmp(subjID{k}, 'sub-0013') && m == 2)
            [SR] = findSR(NewDirecty{1});
        else
            SR = 32000;
        end
        par = set_parameters();
        par.detection = Direction;
        par.sr = SR;
        % Do spike Detection and Clustering for each Channel in the folder
        if ~(strcmp(subjID{k}, 'sub-0013') && m == 2)
            Get_spikes('all', 'parallel', true, 'par', par);
        else
            Get_spikes('sort.txt', 'parallel', true, 'par', par)
        end
        movefile('*_spikes.mat', Direction); % moves all .mat files that include the just detected spikes into the clusering folder
        
        % positive clustering
        cd(Direction)
        Do_clustering('all', 'parallel', true, 'make_plots', true);
    end
end