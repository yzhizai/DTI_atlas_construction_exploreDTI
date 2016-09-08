function out = cfg_DT_run_mean(job)

DTFiles = job.DT_file;
outFile = job.outFile;

firstFile = DTFiles{1};
VG = spm_vol(firstFile);
[pat, ~, ~, ~] = spm_fileparts(firstFile);

DT_Matrix = [];
for aa = 1:numel(DTFiles);
    DT = spm_read_vols(spm_vol(DTFiles{aa}));
    DT_Matrix = cat(5, DT_Matrix, DT);
end

outFileName = fullfile(pat, [outFile, '.nii']);
mean_DT(DT_Matrix, VG, outFileName);

out = {outFileName};