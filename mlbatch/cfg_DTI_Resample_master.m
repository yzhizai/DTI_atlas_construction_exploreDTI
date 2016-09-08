function cfg = cfg_DTI_Resample_master

cfg_dwi_recon = cfg_repeat;
cfg_dwi_recon.name = 'DWI Recon Progress';
cfg_dwi_recon.tag = 'DTI_Recon_Progress';
cfg_dwi_recon.values = {cfg_DWI_Recon, cfg_DWI_Recon_based_b0};
cfg_dwi_recon.forcestruct = true;
cfg_dwi_recon.help = {'These modules are used for DTI resample'};


cfg = cfg_repeat;
cfg.name = 'DTI Resample Progress';
cfg.tag = 'DTI_Resample_Progress';
cfg.values = {cfg_DTI_Resample, cfg_dwi_recon, cfg_DT_mean};
cfg.forcestruct = true;
cfg.help = {'These modules are used for DTI resample'};

