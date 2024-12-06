% like other pipeline:
cfg = [];
cfg.dataset = '

%   define trial from eventfile?
%

%% preprocessing with filtering for noise etc (probably remove padding and baseline window)
cfg.demean			=	'yes';
cfg.baselinewindow	=	'all';
cfg.lpfilter		=	'yes';
cfg.lpfreq			=	200;
cfg.padding			=	2;
cfg.padtype			=	'data';
cfg.bsfilter		=	'yes';	
cfg.bsfiltord		=	3;
cfg.bsfreq			=	[59	61;	119	121;	179	181];
data	=	ft_preprocessing(cfg);

%% add electrode information

data.elec	=	elec_acpc_fr;
save([subjID '_data.mat'],	'data');

%% Artifact rejection
cfg																										=	[];
cfg.viewmode						=	'vertical';
cfg	=	ft_databrowser(cfg,	data);

data	=	ft_rejectartifact(cfg,	data);

%% Rereference (in this case average, but will do white matter 

cfg																										=	[];
cfg.channel										=	{'LPG*',	'LTG*'};
cfg.reref						 				=	'yes';
cfg.refchannel                                  =	'WHITEMATTERCHANNELS';
reref_grids =	ft_preprocessing(cfg,	data);

%% they apply a bipolar montage to depth electrodes?? WUUUT
%this might be where whitematter reference has to happen instead of bipolar
%one

depths	=	{'RAM*', 'RHH*', 'RTH*', 'ROC*', 'LAM*', 'LHH*', 'LTH*'};
for	d =	1:numel(depths)
		cfg																																					=	[];
		cfg.channel																					=	ft_channelselection(depths{d},	data.label);
		cfg.montage.labelold	=	cfg.channel;
        cfg.montage.labelnew	= strcat(cfg.channel(1:end-1),'-',cfg.channel(2:end));
        cfg.montage.tra 		=	...
        [1 -1  0  0  0  0  0  0
         0  1 -1  0	 0	0  0  0
         0					0					1				-1					0					0					0					0
         0					0					0					1				-1					0					0					0
         0					0					0					0					1				-1					0					0
         0					0					0					0					0					1				-1					0
         0					0					0					0					0					0					1				-1];
		cfg.updatesens									=	'yes';
		reref_depths{d}	=	ft_preprocessing(cfg,	data);
end

%% bring surface and depth electrodes to same type (probably not relevant)

cfg																									=	[];
cfg.appendsens		=	'yes';
reref	=	ft_appenddata(cfg,	reref_grids,	reref_depths{:});
save([subjID '_reref.mat'],	reref);

%% TFR (adapt parameters)
cfg																										=	[];
cfg.method											=	'mtmconvol';
cfg.foi																			 =	5:5:200;
cfg.toi																				=	-.3:0.01:.8;
cfg.t_ftimwin							=	ones(length(cfg.foi),1).*0.2;
cfg.taper															=	'hanning';
cfg.output												=	'pow';
freq	=	ft_freqanalysis(cfg,	reref);


%% Plots (adapt)

cfg																										=	[];
cfg.headshape					= pial_lh;
cfg.projection						=	'orthographic';
cfg.channel										=	{'LPG*',	'LTG*'};
cfg.viewpoint							=	'left';
cfg.mask															=	'convex';
cfg.boxchannel			=	{'LTG30',	'LTG31'};
lay	=	ft_prepare_layout(cfg,	freq);


cfg																										=	[];
cfg.baseline									 =	[-.3	-.1];
cfg.baselinetype		=	'relchange';
freq_blc	=	ft_freqbaseline(cfg,	freq);

cfg																										=	[];
cfg.layout													=	lay;
cfg.showoutline		=	'yes';
ft_multiplotTFR(cfg,	freq_blc);

%% Ecog representation on surface (probably not relevant)

cfg																										=	[];
cfg.frequency						=	[70	150];
cfg.avgoverfreq		=	'yes';
cfg.latency											=	[0	0.8];
cfg.avgovertime =	'yes';
freq_sel =	ft_selectdata(cfg,	freq_blc);

cfg																														=	[];
cfg.funparameter			=	'powspctrm';
cfg.funcolorlim							=	[-.5	.5];
cfg.method														=	'surface';
cfg.interpmethod			=	'sphere_weighteddistance';
cfg.sphereradius					=	8;
cfg.camlight												=	'no';
ft_sourceplot(cfg,	freq_sel, pial_lh);
view([-90	20]);	
material	dull;	
lighting	gouraud;	
camlight;

ft_plot_sens(elec_acpc_fr);

%% Depth electrode SEEG data representation

%first creation of mask on segmentation by freesurfer
atlas	=	ft_read_atlas('freesurfer/mri/aparc+aseg.mgz');
atlas.coordsys	=	'acpc';
cfg																															=	[];
cfg.inputcoord									=	'acpc';
cfg.atlas																				=	atlas;
cfg.roi																								=	{'Right-Hippocampus',	'Right-Amygdala'};
mask_rha =	ft_volumelookup(cfg,	atlas);

% create surface mesh based on mask (smoothed)
seg	=	keepfields(atlas,	{'dim',	'unit','coordsys','transform'});
seg.brain	=	mask_rha;
cfg																															=	[];
cfg.method															 =	'iso2mesh';
cfg.radbound												=	2;
cfg.maxsurf															=	0;
cfg.tissue																				=	'brain';
cfg.numvertices							=	1000;
cfg.smooth																=	3;
mesh_rha =	ft_prepare_mesh(cfg,	seg)

% identify electrodes of interest
cfg																													 =	[];
cfg.channel	 =	{'RAM*',	'RTH*',	'RHH*'};	
freq_sel2	 =	ft_selectdata(cfg,	freq_sel);

% Interpolate	the	high-frequency-band	activity	in	the	bipolar	channels	on	a	
%spherical	cloud	around	the	channel	positions,	while	overlaying	the	neural	activity	
%with	the	above	mesh???????????????
cfg																														=	[];
cfg.funparameter		=	'powspctrm';
cfg.funcolorlim							=	[-.5	.5];
cfg.method															=	'cloud';
cfg.slice																					=	'3d';
cfg.nslices																	=	2;
cfg.facealpha											=	.25;
ft_sourceplot(cfg,	freq_sel2,	mesh_rha);
view([120	40]);
lighting	gouraud;	
camlight;

%

cfg.slice									=	'2d';
ft_sourceplot(cfg,	freq_sel2,	mesh_rha);




