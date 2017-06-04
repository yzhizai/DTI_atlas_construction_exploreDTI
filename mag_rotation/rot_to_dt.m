function rot_to_dt
% Reading the normalized dwis
dwiFile = spm_select(1, 'image', 'choose the dwi');
% Reading the rotation matrix
rotFile = spm_select(1, 'image', 'choose the rotation');
% Choosing the b matrix 
bvec = load(spm_select(1, 'grad'));
if(size(bvec, 2) < size(bvec, 1)) % Permitting 3*N
    bvec = bvec'; 
end
bval = load(spm_select(1, 'bval')); % Permitting 1*N
if(size(bval, 2) < size(bval, 1))
    bval = bval';
end

dwiFile = dwiFile(1:end - 2);
V = spm_vol(dwiFile);
dwis = spm_read_vols(V);
mat = V.mat;

[dim1, dim2, dim3, ~] = size(dwis);


rotFile = rotFile(1:end - 2);
rotMat = spm_read_vols(spm_vol(rotFile));



DT_cell = cellfun(@(x, y) est_DT_for_rot_dwis(bval, bvec, x, y), ...
    mat2cell(rotMat, ones(1, dim1), ones(1, dim2), ones(1, dim3), size(rotMat, 4)), ...
    mat2cell(dwis, ones(1, dim1), ones(1, dim2), ones(1, dim3), size(dwis, 4)), 'UniformOutput', false);

DT_cell_temp = cellfun(@(x) reshape(x, 1, 1, 1, []), DT_cell, 'UniformOutput', false);
DT_mat = reshape(cat(1, DT_cell_temp{:}), dim1, dim2, dim3, []);
% Writing DT file
ni = nifti;
fname = 'dt_file.nii';
ni.dat = file_array(fname, [dim1, dim2, dim3, 6], ...
    [spm_type('float32'), spm_platform('bigend')]);
ni.mat = mat;
ni.mat0 = mat;
ni.descrip = 'DT matrix';
create(ni);
for i=1:size(ni.dat,4)
    ni.dat(:,:,:,i) = DT_mat(:, :, :, i);
end

function DT = est_DT_for_rot_dwis(bval, bvec, rot, y_exp)
% Excluding the non-brain tissues.
if y_exp(1) < 1 
    DT = zeros(6, 1);
    return;
end
rot = reshape(rot, 3, 3);
bvec_rot = rot*bvec;
b_matrix = bval_bvec_to_matrix(bval, bvec_rot);
DT = estimate_DT_with_RESTORE(b_matrix, y_exp);
