function DT = DTIResample(DT, diffeoField)
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

ux = diffeoField(:, :, :, 1);
uy = diffeoField(:, :, :, 2);
uz = diffeoField(:, :, :, 3);

[gxx, gxy, gxz] = imgradientxyz(ux);
[gyx, gyy, gyz] = imgradientxyz(uy);
[gzx, gzy, gzz] = imgradientxyz(uz);

[X, Y, Z] = meshgrid(1:size(ux, 1), 1:size(ux, 2), 1:size(ux, 3));

new_x = X + ux;
new_y = Y + uy;
new_z = Z + uz;

new_x(new_x <= 0 | new_x > size(ux, 1)) = NaN;
new_y(new_y <= 0 | new_y > size(uy, 2)) = NaN;
new_z(new_z <= 0 | new_z > size(uz, 3)) = NaN;

Dcell = DT2Matrix(DT);
temp = cell(size(Dcell));
h_wait = waitbar(0, 'please wait...');
for aa = 1:size(ux, 3)
    for bb = 1:size(ux, 2)
        for cc = 1:size(ux, 1)
            if(~isnan(new_x(cc,bb,aa) + new_y(cc,bb,aa) + new_z(cc,bb,aa)))
            F = [gxx(cc, bb, aa), gxy(cc, bb, aa), gxz(cc, bb, aa); ...
                    gyx(cc, bb, aa), gyy(cc, bb, aa), gyz(cc, bb, aa); ...
                        gzx(cc, bb, aa), gzy(cc, bb, aa), gzz(cc, bb, aa)] + eye(3);
            F = pinv(F);
            R = (F*F').^(-1/2)*F;  %FS method
            Dt = Dcell{ceil(new_x(cc,bb,aa)),ceil(new_y(cc,bb,aa)), ceil(new_z(cc,bb,aa))};  % use nearest method to resample.
            Dt_adj = R*Dt*R';
            temp{cc, bb, aa} = Dt_adj;  
            end
        end
    end
    waitbar(aa/size(ux, 3));
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






