function Dcell = DT2Matrix_adv(DT)
Dxx = DT(:, 1);
Dxy = DT(:, 2);
Dxz = DT(:, 3);
Dyy = DT(:, 4);
Dyz = DT(:, 5);
Dzz = DT(:, 6);


Dcell = arrayfun(@DT2Matrix_assist, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz, 'UniformOutput', false);

function D = DT2Matrix_assist(dxx, dxy, dxz, dyy, dyz, dzz)
D = [dxx, dxy, dxz; dxy, dyy, dyz; dxz, dyz, dzz];