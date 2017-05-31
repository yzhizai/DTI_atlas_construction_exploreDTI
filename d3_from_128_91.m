filenames = cellstr(spm_select(Inf, 'image'));
for aa = 1:numel(filenames)
    filename = filenames{aa};
    
    [pat, tit, ext, ~] = spm_fileparts(filename);

    V = spm_vol(filename);

    Y = spm_read_vols(V);

    Y_91 = Y(20:end-18, 11:end - 9, 20:end - 18);

    V.dim = [91, 109, 91];

    fname = fullfile(pat, [tit, '_91', ext]);

    V.fname = fname;
    V = spm_create_vol(V);

    spm_write_vol(V, Y_91);
end
