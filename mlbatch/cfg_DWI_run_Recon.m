function cfg_DWI_run_Recon(job)

DTFileName = job.DT_file;
RefFileName = job.ref_file;
matFileName = job.ref_mat;
outFileName = job.out_file;

fname = [outFileName, '.nii'];

DT = spm_read_vols(spm_vol(DTFileName{1}));
DWI_con_for_Resample(DT, matFileName{1}, RefFileName{1}, fname, 1);