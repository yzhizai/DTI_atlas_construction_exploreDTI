function detFilter_demo

filename = spm_select(1, '^DT', 'choose subj DT file');
volDT  = spm_vol(filename);
DTmat = spm_read_vols(volDT);

dtMask = detFilter(DTmat); 

V = volDT(1);
V.fname = 'dt_mask.nii';

V = spm_create_vol(V);

spm_write_vol(V, dtMask);

