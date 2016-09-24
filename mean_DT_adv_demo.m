function mean_DT_adv_demo
tic
DTFiles = spm_select(Inf, '^DT', 'choose the resampled DT files');
DTFiles = cellstr(DTFiles);
maskFile = spm_select(1, 'image', 'choose a mask file');

mask_exp = spm_read_vols(spm_vol(maskFile));

VG = spm_vol(DTFiles{1});
DT_Matrix = [];
for aa = 1:numel(DTFiles);
    DT = spm_read_vols(spm_vol(DTFiles{aa}));
    DT_Matrix = cat(5, DT_Matrix, DT);
end

mean_DT_adv(DT_Matrix, mask_exp, VG, 'meanDT.nii');
toc