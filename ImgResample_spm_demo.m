function ImgResample_spm_demo

filenames = spm_select(2, 'image');
filenames = cellstr(filenames);

VF = spm_vol(filenames{2});
Y_org = spm_read_vols(VF);
VG = spm_vol(filenames{1});


diffeofile = spm_select(1, 'nii', 'choose the deformation field');
[Def,mat] = get_def(diffeofile);

M = inv(VF.mat);

tmp          = zeros(size(Def),'single');
tmp(:,:,:,1) = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
tmp(:,:,:,2) = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
tmp(:,:,:,3) = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);


c = spm_diffeo('bsplinc', single(Y_org), [1 1 1 0 0 0]);
Y_reg = spm_diffeo('bsplins', c, tmp, [1 1 1 0 0 0]);

fname = inputdlg({'Output file name'}, 'Specified filename');
fname = fname{1};
VG.fname = fname;
V = spm_create_vol(VG);
spm_write_vol(V, Y_reg);


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