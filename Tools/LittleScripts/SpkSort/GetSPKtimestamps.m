function [SPKTime] = GetSPKtimestamps(p2d)

[CSCfiles] = dir([p2d,'*.ncs']);
cd(p2d)
cfg = [];
cfg.fc = {CSCfiles(1,1).name}; % cell array with filenames to load
csc = LoadCSC(cfg);
SPKTime = csc.tvec(1,1)*1000; 

end