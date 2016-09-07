function Def_3d_resample(dim, mat, filename)
%DEF_VG - this function is used to genetrated the resample 3D-images
%deformation field.
%Input:
%  dim - the size of the output image you wanted
%  mat - the mat matrics like V.mat, indicate the voxel size and origin
%
%Institute of High Energy Physics
%Shaofeng Duan
%20160906
x   = 1:dim(1);
y   = 1:dim(2);
z   = 1:dim(3);


[X,Y] = ndgrid(x,y);


Def = zeros([numel(x),numel(y),numel(z),3],'single');

for j=1:length(z)
    
    Mult = mat;
    
    X2= Mult(1,1)*X + Mult(1,2)*Y + (Mult(1,3)*z(j) + Mult(1,4));
    Y2= Mult(2,1)*X + Mult(2,2)*Y + (Mult(2,3)*z(j) + Mult(2,4));
    Z2= Mult(3,1)*X + Mult(3,2)*Y + (Mult(3,3)*z(j) + Mult(3,4));
    
    Def(:,:,j,1) = single(X2);
    Def(:,:,j,2) = single(Y2);
    Def(:,:,j,3) = single(Z2);
end



fname = ['y_', filename, '.nii'];
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
