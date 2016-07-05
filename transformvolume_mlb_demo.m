function transformvolume_mlb_demo

filenames = spm_select(2, 'image');
filenames = cellstr(filenames);
VG = spm_vol(filenames{1});
VF = spm_vol(filenames{2}); %choose two images to registration
Iin = spm_read_vols(VF);
diffeofile = spm_select(1, 'nii', 'choose the deformation field'); %choose the deformation field. Here we made it for spm deformation type.
[Def, mat] = get_def(diffeofile);

dx = 8;
dy = 8;
dz = 8;

for x = 1:dx
    u=(x/dx)-floor(x/dx);
    Bu(mindex2(1,x,4)) = pow((1-u),3)/6;
    Bu(mindex2(2,x,4)) = ( 3*pow(u,3) - 6*pow(u,2) + 4)/6;
    Bu(mindex2(3,x,4)) = (-3*pow(u,3) + 3*pow(u,2) + 3*u + 1)/6;
    Bu(mindex2(4,x,4)) = pow(u,3)/6;
end
  
for y = 1:dy
    v=(y/dy)-floor(y/dy);
    Bv(mindex2(1,y,4)) = pow((1-v),3)/6;
    Bv(mindex2(2,y,4)) = ( 3*pow(v,3) - 6*pow(v,2) + 4)/6;
    Bv(mindex2(3,y,4)) = (-3*pow(v,3) + 3*pow(v,2) + 3*v + 1)/6;
    Bv(mindex2(4,y,4)) = pow(v,3)/6;
end
  


for z = 1:dz
w=(z/dz)-floor(z/dz);
Bw(mindex2(1,z,4)) = pow((1-w),3)/6;
Bw(mindex2(2,z,4)) = ( 3*pow(w,3) - 6*pow(w,2) + 4)/6;
Bw(mindex2(3,z,4)) = (-3*pow(w,3) + 3*pow(w,2) + 3*w + 1)/6;
Bw(mindex2(4,z,4)) = pow(w,3)/6;
end

Y_out = transformvolume_mlb(Bu, Bv, Bw, VF.dim, VG.dim, dx, dy, dz, Def, mat, Iin);
fname = 'bspline_fa.nii';
VG.fname = fname;
V = spm_create_vol(VG);
spm_write_vol(V, Y_out);
  
function val = pow(x, y)
val = x^y;
function val = mindex2(x, y, sizx)
val = (y - 1)*sizx + x;

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
