addpath(genpath('/media/mxv796/rds-share/Mircea/Tools/eeglab14_1_2b'));

[np_data] = np_readdata ('/media/mxv796/rds-share/Mircea/PRAX/20181004165553.EEG', 0, 50, 'time');

Raw = [np_data.data(:,1)', np_data.data(:,65)'];

plot(Raw(1,1:300))