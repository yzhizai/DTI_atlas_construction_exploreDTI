function out = cfg_DT_run_mean(job)

DTFiles = job.DT_file;
maskFile = job.mask_file;
outFile = job.outFile;

firstFile = DTFiles{1};
VG = spm_vol(firstFile);
[pat, ~, ~, ~] = spm_fileparts(firstFile);
mask_explicit = spm_read_vols(spm_vol(maskFile{1}));

DT_Matrix = [];
for aa = 1:numel(DTFiles);
    DT = spm_read_vols(spm_vol(DTFiles{aa}));
    DT_Matrix = cat(5, DT_Matrix, DT);
end

outFileName = fullfile(pat, [outFile, '.nii']);
mean_DT_adv(DT_Matrix, round(mask_explicit), VG, outFileName);

out = {outFileName};