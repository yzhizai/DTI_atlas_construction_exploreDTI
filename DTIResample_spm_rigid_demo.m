function DTIResample_spm_rigid_demo

filenames = spm_select(2, 'image');
filenames = cellstr(filenames);
VG = spm_vol(filenames{1});
VF = spm_vol(filenames{2});
x = spm_coreg(VG, VF);

DTFile = spm_select(1, 'image', 'choose a ExploreDTI dataset to move');
[pat, tit, ext, ~] = spm_fileparts(DTFile);
DT = spm_read_vols(spm_vol(fullfile(pat, [tit, ext])));

DT2 = DTIResample_rigid(DT, spm_matrix(x(:)'), VG, VF);

DWI_con_for_Resample(DT2, 1);