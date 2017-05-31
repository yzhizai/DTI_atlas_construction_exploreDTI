filename = spm_select(1, 'image');
[pat, tit, ext, ~] = spm_fileparts(filename);

V = spm_vol(filename);

Y = spm_read_vols(V);

Y_128 = zeros(128, 128, 128);

Y_128(20:end-18, 11:end - 9, 20:end - 18) = Y;

V.dim = [128, 128, 128];

fname = fullfile(pat, [tit, '_128', ext]);

V.fname = fname;
V = spm_create_vol(V);

spm_write_vol(V, Y_128);