function DTIResample_spm_demo

filenames = spm_select(2, 'image');
filenames = cellstr(filenames);
VG = spm_vol(filenames{1});
VF = spm_vol(filenames{2});

diffeofile = spm_select(1, 'nii', 'choose the deformation field');
[Def,~] = get_def(diffeofile);

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

diffeoField = Def - tmp;

DTFile = spm_select(1, 'image', 'choose an ExploreDTI dataset to move');
[pat, tit, ext, ~] = spm_fileparts(DTFile);
DT = spm_read_vols(spm_vol(fullfile(pat, [tit, ext])));
DT2 = DTIResample(DT, diffeoField, Def, VG, VF);

DWI_con_for_Resample(DT2, 1);


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