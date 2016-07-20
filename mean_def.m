function mean_def(filenames, outName)

[Def, mat] = get_def(filenames{1});
for aa = 2:numel(filenames)
    [Def_ot, mat] = get_def(filenames{aa});
    Def = Def + Def_ot;
end
Def = Def/numel(filenames);

save_def(Def, mat, outName) 
    
    
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

function fname = save_def(Def,mat, fname)
% Save a deformation field as an image

fname = ['y_mean_', fname, '.nii'];
dim   = [size(Def,1) size(Def,2) size(Def,3) 1 3];
dtype = 'FLOAT32-LE';
off   = 0;
scale = 1;
inter = 0;
dat   = file_array(fname,dim,dtype,off,scale,inter);

N      = nifti;
N.dat  = dat;
N.mat  = mat;
N.mat0 = mat;
N.mat_intent  = 'Aligned';
N.mat0_intent = 'Aligned';
N.intent.code = 'VECTOR';
N.intent.name = 'Mapping';
N.descrip     = 'Deformation field';
create(N);
N.dat(:,:,:,1,1) = Def(:,:,:,1);
N.dat(:,:,:,1,2) = Def(:,:,:,2);
N.dat(:,:,:,1,3) = Def(:,:,:,3);