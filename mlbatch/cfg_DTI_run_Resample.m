function out = cfg_DTI_run_Resample(job)

refFileName = job.ref_file;
srcFileName = job.src_file;
DTFileName = job.DT_file;
DefFileName = job.Def_file;
outFileName = job.out_file;

VG = spm_vol(refFileName{1});
VF = spm_vol(srcFileName{1});

[Def, mat] = get_def(DefFileName{1});

DT = spm_read_vols(spm_vol(DTFileName{1}));

x = 1:VG.dim(1);
y = 1:VG.dim(2);
z = 1:VG.dim(3);
 
[X, Y] = ndgrid(x, y);
 
tmp = zeros([numel(x),numel(y),numel(z),3],'single' );
 
for j=1:length(z)
    
    Mult = VG.mat;
   
    X2= Mult(1,1)*X + Mult(1,2)*Y + (Mult(1,3)*z(j) + Mult(1,4));
    Y2= Mult(2,1)*X + Mult(2,2)*Y + (Mult(2,3)*z(j) + Mult(2,4));
    Z2= Mult(3,1)*X + Mult(3,2)*Y + (Mult(3,3)*z(j) + Mult(3,4));
 
    tmp(:,:,j,1) = single(X2);
    tmp(:,:,j,2) = single(Y2);
    tmp(:,:,j,3) = single(Z2);
end

% diffeoField = Def - tmp;
diffeoField = Def;

DT_res = DTIResample_cubic_c(DT, diffeoField, Def, mat, VG, VF);

%write the image
fname = [outFileName, '.nii'];
dt = VG(1).dt(1);
sf  = VG(1).pinfo(1);
off = VG(1).pinfo(2);
ni = nifti;
ni.dat = file_array(fname,...
                        [VG(1).dim size(DT_res, 4)],...
                        [dt spm_platform('bigend')],...
                        0,...
                        sf,...
                        off);
ni.mat = VG(1).mat;
ni.mat0 = VG(1).mat;
ni.descrip = 'Diffusion tensor';

create(ni);
for i=1:size(ni.dat,4)
    ni.dat(:,:,:,i) = DT_res(:, :, :, i);
end

out = fname;
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