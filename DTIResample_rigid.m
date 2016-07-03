function DT = DTIResample_rigid(DT, affMat, VG, VF)
%DTIRESAMPLE_RIGID - use FS method to resample the DTs of DTI image.
%
%Input:
%  DT - a 4-D matrix generated from 'explore stuff to nii'.
%  affMat - the matrix of affine transformation
%
%See also: DT_RECON DWI_RECON
%
%Shaofeng Duan
%Institute of High Energy Physics
%2016-06-28

F = affMat(1:3, 1:3);
F = inv(F);
R = (F*F')^(-1/2)*F;

niifile = spm_select(1, 'image', 'choose a subj space nii file');
V = spm_vol(niifile);

x = 1:VG.dim(1);
y = 1:VG.dim(2);
z = 1:VG.dim(3);

[X, Y] = ndgrid(x, y);

new_posit = zeros([numel(x),numel(y),numel(z),3],'single');

for j=1:length(z)
    
    Mult = VF.mat\affMat*VG.mat;
    
    X2= Mult(1,1)*X + Mult(1,2)*Y + (Mult(1,3)*z(j) + Mult(1,4));
    Y2= Mult(2,1)*X + Mult(2,2)*Y + (Mult(2,3)*z(j) + Mult(2,4));
    Z2= Mult(3,1)*X + Mult(3,2)*Y + (Mult(3,3)*z(j) + Mult(3,4));

    new_posit(:,:,j,1) = single(X2);
    new_posit(:,:,j,2) = single(Y2);
    new_posit(:,:,j,3) = single(Z2);
end

new_x = new_posit(:, :, :, 1);
new_y = new_posit(:, :, :, 2);
new_z = new_posit(:, :, :, 3);

new_x(new_x <= 0 | new_x > V.dim(1)) = NaN;
new_y(new_y <= 0 | new_y > V.dim(2)) = NaN;
new_x(new_z <= 0 | new_z > V.dim(3)) = NaN;

Dcell = DT2Matrix(DT);
temp = cell(size(Dcell));
h_wait = waitbar(0, 'please wait...');
for aa = 1:64
    for bb = 1:128
        for cc = 1:128
            if(~isnan(new_x(cc,bb,aa) + new_y(cc,bb,aa) + new_z(cc,bb,aa)))
            Dt = Dcell{ceil(new_x(cc,bb,aa)),ceil(new_y(cc,bb,aa)), ceil(new_z(cc,bb,aa))};  % use nearest method to resample.
            Dt_adj = R*Dt*R';
            temp{cc, bb, aa} = Dt_adj;  
            end
        end
    end
    waitbar(aa/64);
end
close(h_wait);

[Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, temp);
DT = zeros(size(DT));
DT(:, :, :, 1) = Dxx;
DT(:, :, :, 2) = Dxy;
DT(:, :, :, 3) = Dxz;
DT(:, :, :, 4) = Dyy;
DT(:, :, :, 5) = Dyz;
DT(:, :, :, 6) = Dzz;


function Dcell = DT2Matrix(DT)
Dxx = DT(:, :, :, 1);
Dxy = DT(:, :, :, 2);
Dxz = DT(:, :, :, 3);
Dyy = DT(:, :, :, 4);
Dyz = DT(:, :, :, 5);
Dzz = DT(:, :, :, 6);


Dcell = arrayfun(@DT2Matrix_assist, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz, 'UniformOutput', false);

function D = DT2Matrix_assist(dxx, dxy, dxz, dyy, dyz, dzz)
D = [dxx, dxy, dxz; dxy, dyy, dyz; dxz, dyz, dzz];

function [dxx, dxy, dxz, dyy, dyz, dzz] = Matrix2DT(DT_temp)
if(isempty(DT_temp))
    dxx = single(0);
    dxy = single(0);
    dxz = single(0);
    dyy = single(0);
    dyz = single(0);
    dzz = single(0);
else
    dxx = single(DT_temp(1, 1));
    dxy = single(DT_temp(1, 2));
    dxz = single(DT_temp(1, 3));
    dyy = single(DT_temp(2, 2));
    dyz = single(DT_temp(2, 3));
    dzz = single(DT_temp(3, 3));
end




