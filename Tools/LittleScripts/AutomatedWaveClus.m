Subjidx = {'P07', 'P072','P08', 'P082', 'P09'};
for x = 1:5
    path = [Basepath, 'Mircea\Datasaves\SPK\Sorted\', Subjidx{x} '\Wav'];
    cd(path)
    BatchRenameFiles
    
    Get_spikes('all', 'parallel' , true);
    Do_clustering('all', 'parallel' , true);
end


%% By Hand

edit set_parameters

wave_clus()
