function cfg = cfg_DTI_Resample_master

cfg = cfg_repeat;
cfg.name = 'DTI Resample Progress';
cfg.tag = 'DTI_Resample_Progress';
cfg.values = {cfg_DTI_Resample, cfg_DWI_Recon};
cfg.forcestruct = true;
cfg.help = {'These modules are used for DTI resample'};

