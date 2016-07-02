function DT = DTIResample(DT, diffeoField, Def)
%DTIRESAMPLE - use FS method to resample the DTs of DTI image.
%
%Input:
%  DT - the diffusion tensor, same with ExploreDTI datatype.
%  diffeoField - the deformation field of registration
%
%See also: DT_RECON DWI_RECON
%
%Shaofeng Duan
%Institute of High Energy Physics
%2016-06-28


J = spm_diffeo('def2jac', single(diffeoField));

niifile = spm_select(1, 'image', 'choose a subj space nii file');
V = spm_vol(niifile);

M            = inv(V.mat);

new_x = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
new_y = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
new_z = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);

new_x(new_x <= 0 | new_x > V.dim(1)) = NaN;
new_y(new_y <= 0 | new_y > V.dim(2)) = NaN;
new_x(new_z <= 0 | new_z > V.dim(3)) = NaN;

Dcell = DT2Matrix(DT);
temp = cell(size(Dcell));
h_wait = waitbar(0, 'please wait...');
for aa = 1:size(Def, 3)
    for bb = 1:size(Def, 2)
        for cc = 1:size(Def, 1)
            if(~isnan(new_x(cc,bb,aa) + new_y(cc,bb,aa) + new_z(cc,bb,aa)))
            F = reshape(J(cc, bb, aa, :, :), 3,3) + eye(3);
            R = (F*F')^(-1/2)*F;  %FS method
            Dt = Dcell{ceil(new_x(cc,bb,aa)),ceil(new_y(cc,bb,aa)), ceil(new_z(cc,bb,aa))};  % use nearest method to resample.
            R = pinv(R);
            Dt_adj = R*Dt*R';
            temp{cc, bb, aa} = Dt_adj;  
            end
        end
    end
    waitbar(aa/size(Def, 3));
end
close(h_wait);

[Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, temp);
DT = {Dxx, Dxy, Dxz, Dyy, Dyz, Dzz};

function Dcell = DT2Matrix(DT)
Dxx = DT{1};
Dxy = DT{2};
Dxz = DT{3};
Dyy = DT{4};
Dyz = DT{5};
Dzz = DT{6};


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
    dxx = DT_temp(1, 1);
    dxy = DT_temp(1, 2);
    dxz = DT_temp(1, 3);
    dyy = DT_temp(2, 2);
    dyz = DT_temp(2, 3);
    dzz = DT_temp(3, 3);
end






