subjID	=	'TBS';

MRIpath = 'Path';
Pialpath = 'Path'; %o	freesurfer/surf/lh.pial>)
CTpath = 'Path';
HDRpath = 'Pathtorecordingfiles';


%% anatomical MRI

mri =	ft_read_mri(MRIpath);

ft_determine_coordsys  % determine native orientations of MRI left right axis


% align origin at AC and y axis going to PC and Z axis at midling at top of
% brain

cfg					=	[];
cfg.method			=	'interactive';	
cfg.coordsys		=	'acpc';
mri_acpc            =	ft_volumerealign(cfg,	mri);

% write processed MRI to file

cfg																					 =	[];
cfg.filename					=	[subjID '_MR_acpc'];
cfg.filetype							=	'nifti';
cfg.parameter =	'anatomy';
ft_volumewrite(cfg,	mri_acpc);

%% Cortical Surface Extraction with FreeSurfer (TBdownloaded separately if this step needed)

fshome	=	<path	to	freesurfer	home	directory>;
subdir	=	<path	to	subject directory>;
mrfile	=	<path	to	subject	MR_acpc.nii>;
system(['export	FREESURFER_HOME='	fshome	';	'	...
			 'source $FREESURFER_HOME/SetUpFreeSurfer.sh;	'	...
             'mri_convert	-c	-oc	0	0	0	'	mrfile	'	'	[subdir	'/tmp.nii']	';	'	...
			 'recon-all	-i	'	[subdir	'/tmp.nii']	'	-s	'	'freesurfer'	'	-sd	'	subdir	'	-all'])


pial_lh	=	ft_read_headshape(Pialpath);
pial_lh.coordsys	=	'acpc';
ft_plot_mesh(pial_lh);
lighting	gouraud;	
camlight;

fsmri_acpc =	ft_read_mri(); %<path	to	freesurfer/mri/T1.mgz>)
fsmri_acpc.coordsys	=	'acpc';


%% CT

ct	=	ft_read_mri(CTpath);

	ft_determine_coordsys
   
% alignement usiing nasion, a point on the midline, and preauricular points(ear canal in front)

cfg																					 =	[];
cfg.method		=	'interactive';	
cfg.coordsys	=	'ctf';
ct_ctf =	ft_volumerealign(cfg,	ct);


ct_acpc =	ft_convert_coordsys(ct_ctf,	'acpc');


%% Fuse CT with MRI

cfg	 =	[];
cfg.method     =	'spm';
cfg.spmversion =	'spm12';
cfg.coordsys   =	'acpc';
cfg.viewresult =	'yes';
ct_acpc_f =	ft_volumerealign(cfg,	ct_acpc,	fsmri_acpc);

cfg																					 =	[];
cfg.filename				 =	[subjID '_CT_acpc_f'];
cfg.filetype							=	'nifti';
cfg.parameter =	'anatomy';
ft_volumewrite(cfg,	ct_acpc_f);

%% Electrode placement

hdr =	ft_read_header(HDRpath);

cfg			 =	[];
cfg.channel	 =	hdr.label;
elec_acpc_f  =	ft_electrodeplacement(cfg,	ct_acpc_f,	fsmri_acpc);

%before saving one should check that elecpos and chanpos are correct,
%electrode and chan pos start out same but shifr depending on referencing
%as well

save([subjID '_elec_acpc_f.mat'],	'elec_acpc_f');

%% Freesurfer to do brainshift compensation
cfg			=	[];
cfg.method	=	'cortexhull';
cfg.headshape	=	<path	to freesurfer/surf/lh.pial>;
cfg.fshome		=	<path	to	freesurfer	home	directory>;
hull_lh	=	ft_prepare_mesh(cfg);
save([subjID '_hull_lh.mat'],	hull_lh);



%% only relevant for electrode grid? 
% elec_acpc_fr	=	elec_acpc_f;
% grids	=	{'LPG*',	'LTG*'};
% for	g	=	1:numel(grids)
% 		 		cfg																										=	[];
% 		 		cfg.channel										=	grids{g};
% cfg.keepchannel	=	'yes';
% cfg.elec																		=	elec_acpc_fr;
% 		cfg.method											=	'headshape';
% cfg.headshape					=	hull_lh;
% 		cfg.warp															=	'dykstra2012';
% 		cfg.feedback							 =	'yes';
% elec_acpc_fr	=	ft_electroderealign(cfg);
% end


%% visualize cortex with electrodes

ft_plot_mesh(pial_lh);
ft_plot_sens(elec_acpc_fr);
view([-55	10]);	
material	dull;	
lighting	gouraud;	
camlight;

save([subjID '_elec_acpc_fr.mat'],	'elec_acpc_fr');

%% Volume-based registration for generalization to other brains

cfg																										=	[];
cfg.nonlinear					 =	'yes';
cfg.spmversion			=	'spm12';
fsmri_mni =	ft_volumenormalise(cfg,	fsmri_acpc);

elec_mni_frv	=	elec_acpc_fr;
elec_mni_frv.elecpos	=	ft_warp_apply(fsmri_mni.params,	elec_acpc_fr.elecpos, 'individual2sn');
elec_mni_frv.chanpos	=	ft_warp_apply(fsmri_mni.params,	elec_acpc_fr.chanpos, 'individual2sn');
elec_mni_frv.coordsys	=	'mni';

% overlay with brain atlas and check whether still correct

load(<path	to	fieldtrip/template/anatomy/surface_pial_left.mat>);
ft_plot_mesh(mesh);
ft_plot_sens(elec_mni_frv);
view([-90	20]);	
material	dull;	
lighting	gouraud;	
camlight;

save([subjID '_elec_mni_frv.mat'],	'elec_mni_frv');

%% Anatomical labelling

atlas	=	ft_read_atlas(<path	to	fieldtrip/template/atlas/aal/ROI_MNI_V4.nii>);

cfg																										=	[];
cfg.roi	 				=	elec_mni_frv.chanpos(match_str(elec_mni_frv.label, 'LHH2'),:);
		 cfg.atlas 			 =	atlas;
		 cfg.inputcoord				=	'mni';
cfg.output								 			=	'label';
labels	=	ft_volumelookup(cfg,	atlas);
[~,	indx]	=	max(labels.count);
labels.name(indx)
ans	= 'ParaHippocampal_L'


