function dmri_get_r_mat_demo

DefFile = spm_select(1, 'nii', 'choose a deformation file');
[pat, tit, ext, ~] = spm_fileparts(DefFile);
Img2Write = fullfile(pat, [tit, '_R', ext]);

dmri_get_r_mat(DefFile, Img2Write);