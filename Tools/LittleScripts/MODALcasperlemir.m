%% Investigate whether there are oscillations in the data.
%Step 1: Start with raw (unfiltered) time series data. This is the classifier output. 
%Step 2: Create a plateau-shaped bandpass filter that is based on the power exceeding the 1/f corrected data (as Watrous and Jacobs described).
%Step 3: Apply the filter to the raw data.
%Step 4: Obtain the analytic signal by applying the Hilbert transform to the filtered signal.
%Step 5: Extract the phase angle time series. PATS = angle(hilbertOfFreq1);
%Step 6: Frequency sliding is defined as the temporal derivative of the phase angle time series (using the sampling
%rate s and 2*pi to scale the result to frequencies in hertz). freqSlid = 1024*diff(unwrap(PATS ))/(2*pi);
%Step 7. Apply 10 median filters. Take the median of the filters.
%Step 8. Remove frequencies that did not exceed the robust fit, linear regression line. 


%%
fs = 1000;

for ppp = 1:length(Datapre{1,1}.trial)
    
   % My data was a time series of 1639 samples. I was only interested in
   % the time from 200ms after cue onset (sample 358) to 1200 ms into the
   % trial (sample 1358).
    dataset = Datapre{1,1}.trial{1,ppp} %randn(1,1639); 
    cfg             = [];
    data            = [];
    a = size(dataset,1);
    data.trial = {dataset(1,:)};
    data.time = { Datapre{1,1}.time{1,ppp}};
    data.label = {'sem'};
    data.sampleinfo = [1 1026];
    cfg.method      = 'mtmfft';
    cfg.output      = 'pow';
    cfg.taper      = 'hanning';
    cfg.keeptrials = 'yes';
    
    cfg.foi =  1:1:30;
   
    cfg.toi         = data.time;
    Frequency_data  = ft_freqanalysis(cfg, data);
    
    cfg = [];
    Frequency_data = ft_freqdescriptives(cfg,Frequency_data);
    
    pow.lgpow=log10(Frequency_data.powspctrm);% Log transform power data
    logfrq=log10(Frequency_data.freq);% Log transform freqency vector
    
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Robustfit
    X = logfrq';% we add the ones so that the intercept is also fitted
    y = pow.lgpow';
    b = robustfit(X,y);
    bls = regress(y,[ones(30,1) X]); % Get the regression intercept and slope
    temp=y-(b(1)+b(2)*X);
%             powdif = 10.^temp;
%             scatter(X,y)
%             hold on
%             plot(X,b(1)+b(2)*X,'r-', X,bls(1)+bls(2)*X,'m:')
%     
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    powdif = 10.^temp;
    
    allnewReal(ppp,:) = temp;
    
    allsubjFFT(ppp,:) = Frequency_data.powspctrm;
    
    % Find values exceeding the 1/f curve and use these values as the
    % values as to which I limit the bandpass filter.
    found = find(temp>0);
    Lowerband = min(found);
    UpperBand = max(found);
    foundall(ppp,1:length(found)) = found;
    
    
    %% 2: Create a plateau-shaped bandpass filter. 
    % Such a filter is preferred over, e.g., a Gaussian-shaped filter such as a Morlet wavelet to prevent a potential peak frequency bias toward the peak frequency.
    % Bandpass filtering is useful to constrain frequency sliding to a specific frequency range of a priori interest.
    
    %% Step 3: Apply the filter to the raw data
    
    % Use a FIR twopass filter to bandpass.

    cfg             = [];
    data            = [];
    data.trial = {dataset(1,:)}; % This is the averaged d-value, remove the NaNs.
    data.time = {Datapre{1,1}.time{1,ppp}};
    data.label = {'sem'};
   % data.sampleinfo = [1 1639];
    cfg = [];
    cfg.bpfilter      = 'yes';
    cfg.bpfreq        = [Lowerband UpperBand];
    cfg.bpfilttype = 'fir';
    
    freq = ft_preprocessing(cfg, data);


%% 2: Create a plateau-shaped bandpass filter. Such a filter is preferred over, e.g.,
% This gives me almost the same results as using the fieldtrip version.
% tz = .15; % transition zone, in percent
% fbnd = [Lowerband UpperBand]; % freq boundaries
% freqshape = [0 0 1 1 0 0]; 
% frex = [0 fbnd(1)*(1-tz) fbnd fbnd(2)*(1+tz) 1024/2];
% frex = frex./(1024/2);
% % plot(frex, freqshape)
% time = -0.15:1/1024:1.5;
% filt_order     = round((1*1024/(fbnd(1)+2)));
% fkernel = firls(filt_order,frex,freqshape); % The order of the filter, that is the number of
% % points in the filter kernel.
% dataset = dataset(1,52:end); % Remove the NaNs in the beginning.
% freq = filtfilt(fkernel,1,dataset);
% %     
    %% Step 4: Obtain the analytic signal by applying the Hilbert transform to the filtered signal.
    
    % Rotate the matrix so that the hilbert transform is done with the time
    % axis being the first dimension, not the channels.
    data2 = freq.trial{1}';
    % Compute hilbert transform, make sure time is in first dimension.
    hilbertOfFreq1 = hilbert(data2);
    
    %% Step 5: Extract the phase angle time series.
    tmpli   = angle(hilbertOfFreq1);
    %  plot(tmpli)
    %% Step 6: Frequency sliding is defined as the temporal derivative of the phase angle time series (using the sampling
    %  rate s and 2 to scale the result to frequencies in hertz).
    
    freqSlid = 1000*diff(unwrap(tmpli))/(2*pi);
    % One time point gets lost using diff.
    freqSlid(end+1) = NaN;
    %     plot(freqSlid)
    
    
    %% Step 7. Median filter
    % The following step to calculate the medianfilter is taken
    % from Watrous MODAL algorithm.
    % The timewindows for performing the medianfilter.
    time_wins = [.05 .2 .35]; %time windows in fractions of a second from MX Cohen
    orders = time_wins*fs;
    
    %window signal into 10 epochs to make it more
    %tractable. surprisingly parfor doesn't appreciably speed this up...
    numchunks = 10;
    chunks = floor(linspace(1,length(freqSlid),numchunks)); %make epochs
    
    meds = zeros(length(orders),length(freqSlid));
    for iWin = 1:length(orders)%median filter using different window sizes.
        for iChunk = 2:numchunks
            chunkidx = chunks(iChunk-1):chunks(iChunk)-1; %don't double count edges, last sample will be excluded.
            meds(iWin,chunkidx) = medfilt1(freqSlid(chunkidx),round(orders(iWin)));
        end
    end
    
    % Get the median of the median filters.
    median_of_meds = median(meds);
    
 %% Step 8.  NaN out frequency estimates that did not exceed the 1/f
    % robust fit regression line. Do this in a loop where each frequency
    % from the 1/f is matched to the median signal.

    TheRealnumbers = zeros(1,1639);
    for nuCol = 1:size(foundall,2)
        whatNumber = foundall(ppp,nuCol);
        IDX = uint32(1:size(median_of_meds,2));
        where = IDX(median_of_meds(1,:) >= whatNumber & median_of_meds(1,:) < whatNumber+1);
        TheRealnumbers(1,where) = median_of_meds(:,where);
    end

    TheRealnumbers(TheRealnumbers == 0) = nan;
    
    allFreqSl(ppp, :) = TheRealnumbers;
%    clearvars -except allFreqSl ppp  partis currentpath allnewReal allsubjFFT fs foundall AllPPPDvalZscore
end

%save allFreqSl allFreqSl

% 
figure;
for nuppp = 1:62
    subplot(6,4,nuppp)
    plot(allFreqSl(nuppp,358:1383), 'k')
    axis ([202 1200 0 15]) 
end

nanmeanOfAllPPP = nanmean(nanmean(allFreqSl(:,358:1383)));