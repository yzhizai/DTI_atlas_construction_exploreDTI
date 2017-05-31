function get_R_with_FS(diffeoField, Def, mat, VG, VF)
%Usage:
%Input:
%  Def, diffeoField - a matrix sized of VG, storing the physical coordinates
%of VF. "Def" and "mat" come from get_def function in spm_deformations.
%  mat - VG.mat
%Output:
%
% Obtain the Jacobian Matrix of diffeoField matrix
J = spm_diffeo('def2jac', single(diffeoField));
