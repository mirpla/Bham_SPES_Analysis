% smoothes fieldtrip time frequency single trial data with gaussian kernel

%settings: FWHM for time and frequency
%cfg.fwhm_t=time in sec i.e. 0.2
%cfg.fwhm_f=freq in Hz i.e 2

% matlab image processing toolbox needed!

 
% script by Marie-Christin Fellner mariefellner@gmx.de

function [data_smoothed]=smooth_TF_GA(cfg,data,parameter)

switch nargin
    case 2
        if ~isstruct(cfg); error('cfg input must be a structure'); end
        if ~isstruct(data); error('data input must be a structure'); end
    case 3
        if ~isstruct(cfg); error('cfg input must be a structure'); end
        if ~isstruct(data); error('data input must be a structure'); end
        if ~ischar(parameter); error('parameter input must be a string'); end
    otherwise
        error('incorrect number of input arguements')
end

% default parameter
if ~exist('parameter', 'var'); parameter = 'powspctrm'; end            
        
% settings for smoothing kernel
fwhm_time=cfg.fwhm_t; % in sec
fwhm_freq=cfg.fwhm_f; % in Hz

% get bin sizes
resol_t=data.time(1,2)-data.time(1,1);
resol_f=data.freq(1,2)-data.freq(1,1);

%get fwhm in bins
fwhm_t=fwhm_time/resol_t;
fwhm_f=fwhm_freq/resol_f;

% calculate std based on fwhm (fwhm~=2.355*std)
std_t=fwhm_t/2.355;
std_f=fwhm_f/2.355;

% filt size should at least be 5 times std (if it should be near zero at the edges), needs to be odd
size_t=round(std_t*5);
size_t=size_t+(mod(size_t,1)==0);
size_f=round(std_f*5);
size_f=size_f+(mod(size_f,1)==0);

%  no nans (no smearing of Nans!), data zero padded
nan_ind=find(isnan(data.(parameter)));
data.powspctrm(nan_ind)=0;

% create filters with both std
h_t=fspecial('gaussian',[1,double(size_t)],double(std_t));
h_f=fspecial('gaussian',[double(size_f),1],double(std_f));
h=h_f*h_t;

% to check smoothing kernel plot:
%figure
%surf(h)

if strcmpi(parameter,'fourierspctrm')
    powspctrm=abs(data.(parameter));
else
    powspctrm=data.(parameter);
end

%loop over channels and trials
fprintf('Smoothing data...\n\n')
for trial=1:size(powspctrm,1)
    for chan=1:size(powspctrm,2)
% use imfilter, conv2 smears data to different tf bins, and is slower!
%w = conv2(squeeze(freq.powspctrm(1,1,:,:)),h); 
        powspctrm(trial,chan,:,:)=imfilter(squeeze(powspctrm(trial,chan,:,:)),h,'symmetric','conv'); 
    end


%display(strcat ('smoothed trial ',num2str(trial)));
end

% replace with nan_inds with nan
powspctrm(nan_ind)=NaN;
data_smoothed=data;
data_smoothed.powspctrm=powspctrm;
data_smoothed.cfg.smoothingkernel=h;
