function extent_from_91_to_128_demo

filename = spm_select(1, 'nii');
[pat, tit, ext] = fileparts(filename);
fname = fullfile(pat, [tit, '_128', ext]);
V = spm_vol(filename);

extent_from_91_to_128(V, fname);