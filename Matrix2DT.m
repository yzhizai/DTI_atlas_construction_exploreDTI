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