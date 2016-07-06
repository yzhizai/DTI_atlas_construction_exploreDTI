function transformvolume_mlb_simplified_DTI_demo

filenames = spm_select(2, 'image');
filenames = cellstr(filenames);
VG = spm_vol(filenames{1});
VF = spm_vol(filenames{2}); %choose two images to registration
Iin = spm_read_vols(VF);
diffeofile = spm_select(1, 'nii', 'choose the deformation field'); %choose the deformation field. Here we made it for spm deformation type.
[Def, mat] = get_def(diffeofile);



Y_out = transformvolume_mlb_simplified(VF.dim, Def, mat, Iin);
fname = 'bspline_fa2.nii';
VG.fname = fname;
V = spm_create_vol(VG);
spm_write_vol(V, Y_out);

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
