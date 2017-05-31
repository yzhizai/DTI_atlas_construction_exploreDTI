filenames = cellstr(spm_select(Inf, 'nii'));
maskfiles = cellstr(spm_select(Inf, 'nii', ...
    'select two mean FA map'));
% fnames = {'asym_cov_wm.nii', 'sym_cov_wm.nii'};

figure
for aa = 1:numel(filenames)
    filename = filenames{aa};
    V = spm_vol(filename);
    Y = spm_read_vols(V);
    maskfile = maskfiles{aa};
    mask_wm = spm_read_vols(spm_vol(maskfile));
    
    %% This part for output.
    Y(mask_wm < 0.1) = 0;
    Y_to_show = flipud(permute(Y, [2, 1, 3]));
    Y_show = cat(2, Y_to_show(:, :, 40), Y_to_show(:, :, 45), Y_to_show(:, :, 50));
    subplot(2, 4, [(aa - 1)*4 + 1, (aa - 1)*4 + 2])
    imagesc(Y_show, [0, 0.6]) 
%     fname = fnames{aa};
%     V.fname = fname;
%     V = spm_create_vol(V);
%     spm_write_vol(V, Y);
    
    %% This part for plot
    Y_mask_wm = Y(mask_wm > 0.25);
    [f, x] = ecdf(Y_mask_wm);
    subplot(2, 4, [3, 4, 7, 8])
    plot(x, f, 'LineWidth', 4)
    hold on
end

xlabel('COV');
ylabel('CDF');
xlim([0, 1]);
