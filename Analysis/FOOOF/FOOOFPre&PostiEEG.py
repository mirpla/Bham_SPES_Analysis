import numpy as np
import scipy.io as sio
from fooof import FOOOFGroup
from fooof.analysis import get_band_peak_fg
from fooof.plts.periodic import plot_peak_fits, plot_peak_params
from fooof.plts.aperiodic import plot_aperiodic_params, plot_aperiodic_fits
from os.path import join as pjoin

#%%
freq_range = [1, 30] # Frequency range on which the Analysis is performed
chckindv = 1 # Set to 1 if you want to plot the individual fits per subject 0 if not

# preallocations
fg = []
aperiodicparameters = []
periodicparameters = []
pow_spectra = []

dataDir = 'Z:\RDS\Mircea\Datasaves\FOOOF\Macro'

mat_fname = pjoin(dataDir,'Allfreqs.mat') # name of .mat file to be imported for freq vector (freqx1)
fdata = sio.loadmat(mat_fname)
cntr = 0
# Define frequency bands of interest
bands = {'theta' : [4, 8],'alpha' : [1, 30],'beta' : [10, 20]}

# Set up labels and colors for plotting
colors = ['#2400a8', '#00700b']
labels = ['Local', 'Distal']
#%%
for p in range(2):
    if p == 0:
        prpstname = labels[0]
    if p == 1:
        prpstname = labels[1]
     
    # Load in .mat matrix per condition of powerspectrum of Subj x Freqs format
    mat_psdsname = pjoin(dataDir, '{prpst}PostAllpsds.mat'.format(prpst = prpstname))
 #   mat_psdsname = '{prpst}Allpsds.mat'.format(prpst = prpstname)
    data = sio.loadmat(mat_psdsname)
       
    # Unpack data from dictionary, and squeeze numpy arrays
    freqs = np.squeeze(fdata['freqs']).astype('float')
    psds = np.squeeze(data['psds']).astype('float')
    # ^Note: this also explicitly enforces type as float (type casts to float64, instead of float32)
    #  This is not strictly necessary for fitting, but is for saving out as json from FOOOF, if you want to do that
        
    # Transpose power spectra, to have the expected orientation for FOOOF
    #psds = psds.T  
         
    psiz1 = len(psds)
    
    # Perform the actual fitting,Parameters can be seen in the documentation
    fo = FOOOFGroup(peak_threshold=2,peak_width_limits=[1.0, 5.0], aperiodic_mode= 'fixed')
    fg.append(fo)
    fg[cntr].report(freqs, psds, freq_range)
        
    #plot of fits per subject if specified by chckindv
    if chckindv == 1:
        for x in range(psiz1):
            fm = fg[cntr].get_fooof(ind=x, regenerate=True)
       
            # Print results and plot extracted model fit
            fm.print_results()
            fm.plot()            
            # figures can be manually saved in bulk, standard in png, for svgs you would have to dig in the FOOOF code and alter as below
            # as sent by Tom: plot_fm(fm, save_fig=True, file_name="image.svg")
                
    #print(fg[cntr].group_results) # prints a summary in the console of the objects
        
    # ====== Saving it all ===============================================
    app = fg[cntr].get_params('aperiodic_params')
    pp = fg[cntr].get_params('peak_params')  
    aperiodicparameters.append(app)
    periodicparameters.append(pp)

    fg[cntr].save(pjoin(dataDir,'fooof_results{prpst}All'.format(prpst = prpstname)), save_results=True)
    fg[cntr].save_report(pjoin(dataDir, 'FOOOFGroup_reportAll{prpst}'.format(prpst = prpstname)))
    cntr = cntr + 1
sio.savemat(pjoin(dataDir, 'aperiodicparameters.mat'), {'aperiodicparameters' : aperiodicparameters})
sio.savemat(pjoin(dataDir, 'periodicparameters.mat'), {'periodicparameters' : periodicparameters})
     
#%% Periodic Plots
# Extract alpha peaks from each group
g1_alphas = get_band_peak_fg(fg[0], bands['alpha'])
g2_alphas = get_band_peak_fg(fg[1], bands['alpha'])
   

plot_peak_params([g1_alphas, g2_alphas], freq_range=bands['alpha'],
                 labels=labels, colors=colors)     


# Plot the peak fits of the alpha fits for Group 1
# Compare the peak fits of alpha peaks between groups
plot_peak_fits([g1_alphas, g2_alphas],
               labels=labels, colors=colors)


#%% Aperiodic Plots
# Extract the aperiodic parameters for each group
aps1 = fg[0].get_params('aperiodic_params')
aps2 = fg[1].get_params('aperiodic_params')

# Compare the aperiodic parameters between groups
plot_aperiodic_params([aps1, aps2], labels=labels, colors=colors)


# Plot the aperiodic fits for both groups
plot_aperiodic_fits([aps1, aps2], freq_range,control_offset=True, log_freqs=True, labels=labels, colors=colors)
