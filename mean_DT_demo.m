function mean_DT_demo

DTFiles = spm_select(Inf, '^DT', 'choose the resampled DT files');
DTFiles = cellstr(DTFiles);

VG = spm_vol(DTFiles{1});
DT_Matrix = [];
for aa = 1:numel(DTFiles);
    DT = spm_read_vols(spm_vol(DTFiles{aa}));
    DT_Matrix = cat(5, DT_Matrix, DT);
end

mean_DT(DT_Matrix, VG, 'meanDT');