function dmri_get_r_mat(DefFileName, FileName_R2Write)
%Usage
% obtaining the deformation matrix and the mat of VG
%  Def - a matrix with size same to VG, storing the physical coordinates
% of VF. "Def" and "mat" come from get_def function in spm_deformations.
%  mat - VG.mat
[Def, mat] = get_def(DefFileName);

% obtaining the Jacobian matrix, its size is size(VG)*9
J = spm_diffeo('def2jac', single(Def));

% Generating R matrix
temp = cell(size(Def, 1), size(Def, 2), size(Def, 3));
h = waitbar(0, 'waiting...');
for aa = 1:size(Def, 3)
  for bb = 1:size(Def, 2)
    for cc = 1:size(Def, 1)
      F_temp = reshape(J(cc, bb, aa, :, :), 3,3);
      if sum(sum(isnan(F_temp))) || sum(sum(isinf(F_temp)))
        temp{cc, bb, aa} = zeros(3);
      else
        F = F_temp + eye(3);
        F = pinv(F);
        R = sqrtm(F*F')\F; %FS method
        temp{cc, bb, aa} = R;
      end
    end
  end
  waitbar(aa/size(Def, 3));
end
delete(h);
% Transforming the cell to 4D matrix.
temp_cell = cellfun(@(x)reshape(x, 1, 1, 1, []), temp, 'UniformOutput', false);
R_mat = reshape(cat(1, temp_cell{:}), size(Def, 1), size(Def, 2), size(Def,3), []);
R_mat = single(R_mat);

fname = FileName_R2Write;
ni = nifti;
% To understand function file_array, type `help file_array`.
ni.dat = file_array(fname,...
                        size(R_mat),...
                        [spm_type('float32') spm_platform('bigend')],...
                        0,...
                        1,...
                        0);
ni.mat = mat;
ni.mat0 = mat;
ni.descrip = 'rotation matrix';
create(ni);
for i=1:size(ni.dat,4)
    ni.dat(:,:,:,i) = R_mat(:, :, :, i);
end

%==========================================================================
% function [Def,mat] = get_def(job)
%==========================================================================
function [Def,mat] = get_def(filename)
% Load a deformation field saved as an image
Nii = nifti(filename);
Def = single(Nii.dat(:,:,:,1,:));
d   = size(Def);
if d(4)~=1 || d(5)~=3, error('Deformation field is wrong!'); end
Def = reshape(Def,[d(1:3) d(5)]);
mat = Nii.mat;
