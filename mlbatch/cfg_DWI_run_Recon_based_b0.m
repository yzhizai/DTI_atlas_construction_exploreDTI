function cfg_DWI_run_Recon_based_b0(job)

DTFileName = job.DT_file;
b0FileName = job.b0_file;
bvalFileName = job.bval_file;
bvecFileName = job.bvec_file;
outFileName = job.out_file;

bval = load(bvalFileName{1});
bvec = load(bvecFileName{1});

bmatrix = bval_bvec_to_matrix(bval, bvec, [2, 1, 3], [-1, 1, 1]); %This place should replaced by user defined.

V_b0 = spm_vol(b0FileName{1});

fname = [outFileName, '.nii'];


DT = spm_read_vols(spm_vol(DTFileName{1}));
DWI_Recon_based_b0(DT, V_b0, bmatrix, fname);