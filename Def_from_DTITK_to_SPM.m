function Def_from_DTITK_to_SPM(DefFileName, VG, VF)

Vol = spm_vol(DefFileName);
diffeo_vol = spm_read_vols(Vol);

dim = VG.dim;
x   = 1:dim(1);
y   = 1:dim(2);
z   = 1:dim(3);
mat = VG.mat;

[X, Y, Z] = ndgrid(x, y, z);
Def = cat(4, X, Y, Z);

diffeo_sam = spm_diffeo('resize', single(diffeo_vol), dim);

Def = Def + diffeo_sam; % add is right.

Def = affine(Def, VF.mat);


fname = 'y_test.nii';
dim   = [dim 1 3];
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

%==========================================================================
% function Def = affine(y,M)
%==========================================================================
function Def = affine(y,M)
Def          = zeros(size(y),'single');
Def(:,:,:,1) = y(:,:,:,1)*M(1,1) + y(:,:,:,2)*M(1,2) + y(:,:,:,3)*M(1,3) + M(1,4);
Def(:,:,:,2) = y(:,:,:,1)*M(2,1) + y(:,:,:,2)*M(2,2) + y(:,:,:,3)*M(2,3) + M(2,4);
Def(:,:,:,3) = y(:,:,:,1)*M(3,1) + y(:,:,:,2)*M(3,2) + y(:,:,:,3)*M(3,3) + M(3,4);
