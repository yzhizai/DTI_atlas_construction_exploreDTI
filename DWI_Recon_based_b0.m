function DWI_Recon_based_b0(DT, V_b0, bmatrix, outputFile) 
%DWI_RECON_BASED_B0 is a function used a DT to generate a simulate dwis files. 
%
%Usage: DWI_RECON_BASED_B0(DT, V_b0, bmatrix, outputFile) 
%Inputs:
%  DT - an exploreDTI type DTI cell array, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz
%  V_b0 - a b0 image's head file, spm_vol(b0File)
%  bmatrix - obtained from bval_bvec_to_matrix function.
%  outputFIle - named output file name 
%
%See also: DT_RECON    BVAL_BVEC_TO_MATRIX
%
%Shaofeng Duan
%Institute of High Energy Physics
%2016-07-20

V = V_b0;
bmat = bmatrix;
Y0 = spm_read_vols(V);


Y = zeros([size(Y0), size(bmat, 1)]);

Dxx = DT(:, :, :, 1);
Dxy = DT(:, :, :, 2);
Dxz = DT(:, :, :, 3);
Dyy = DT(:, :, :, 4);
Dyz = DT(:, :, :, 5);
Dzz = DT(:, :, :, 6);

unormal_temp = zeros(size(Y0)); %choose the unormal points.

for aa = 1:size(bmat, 1)
    Y_temp = Y0.*exp(-(bmat(aa, 1)*Dxx + bmat(aa, 2)*Dxy + bmat(aa, 3)*Dxz + bmat(aa, 4)*Dyy + bmat(aa, 5)*Dyz + bmat(aa, 6)*Dzz));
    unormal_temp = unormal_temp | (Y_temp > Y0) | (Y_temp < 0);
end

for aa = 1:size(bmat, 1)
    Y_temp = Y0.*exp(-(bmat(aa, 1)*Dxx + bmat(aa, 2)*Dxy + bmat(aa, 3)*Dxz + bmat(aa, 4)*Dyy + bmat(aa, 5)*Dyz + bmat(aa, 6)*Dzz));
    Y_temp(unormal_temp) = Y0(unormal_temp);
    Y(:, :, :, aa) = Y_temp;
end

Y(isnan(Y)) = 0;

fname = outputFile;
dt = V.dt(1);
sf  = V.pinfo(1);
off = V.pinfo(2);

ni = nifti;
ni.dat = file_array(fname,...
                        [V.dim size(bmat, 1)],...
                        [dt spm_platform('bigend')],...
                        0,...
                        sf,...
                        off);
ni.mat = V.mat;
ni.mat0 = V.mat;
ni.descrip = 'template by Shaofeng';

create(ni);
for i=1:size(ni.dat,4)
    ni.dat(:,:,:,i) = Y(:, :, :, i);
end