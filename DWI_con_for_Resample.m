function DWI_con_for_Resample(DT, varargin)
%DWI_CON_FOR_RESAMPLE is a function used a DT to generate a simulate dwis files. The b
%value and b vector and B0 image all come from a exploreDTI mat file. The
%default dwi files name is template.nii.
%
%Usage: DWI_CON_FOR_RESAMPLE(DT);
%Inputs:
%  DT - an exploreDTI type DTI cell array, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz
%  varargin - a flag to indicate whether to generate bval and bvec
%  files.
%
%See also: DT_RECON
%
%Shaofeng Duan
%Institute of High Energy Physics
%2016-05-27
matFileName = spm_select(Inf, 'mat', 'choose one trafo mat file ...');
filename = spm_select(1, 'image', 'choose a nii file which header information will be used...');
V = spm_vol(filename);
dwi = load(matFileName, 'b', 'DWIB0');
bmat = dwi.b;
Y0 = dwi.DWIB0;

Y0 = permute(Y0, [2, 1, 3]);
% Y0 = fliplr(Y0);
% Y0 = flipud(Y0);

Y = zeros([size(Y0), size(bmat, 1)]);

Dxx = DT{1};
Dxy = DT{2};
Dxz = DT{3};
Dyy = DT{4};
Dyz = DT{5};
Dzz = DT{6};

for aa = 1:size(bmat, 1)
    Y(:, :, :, aa) = Y0.*exp(-(bmat(aa, 1)*Dxx + bmat(aa, 2)*Dxy + bmat(aa, 3)*Dxz + bmat(aa, 4)*Dyy + bmat(aa, 5)*Dyz + bmat(aa, 6)*Dzz)); 
end

Y = permute(Y, [2, 1, 3, 4]);
Y = rot90(Y, -1);
Y(isnan(Y)) = 0;

fpath = spm_select(1, 'dir', 'choose a directory to store the tempalte file.');
fname = fullfile(fpath, 'template_DTI.nii');
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

if ~isempty(varargin)
    IND = bmat(:,[1 4 6])<0;
    bmat([IND(:,1) false([size(IND,1) 2]) IND(:,2) false([size(IND,1) 1]) IND(:,3)])=0;
    bvals = round(sum(bmat(:,[1 4 6]),2)); % the b-values

    BSign_x = sign(sign(bmat(:,1:3)) + 0.0001); % Adding 0.0001 avoids getting zeros
    BSign_y = sign(sign(bmat(:,[2 4 5])) + 0.0001); % Adding 0.0001 avoids getting zeros
    Bo = bmat(:,1)==0;
    BSign = BSign_x;
    BSign([Bo Bo Bo]) = BSign_y([Bo Bo Bo]);

    grad = BSign .* sqrt(bmat(:,[1 4 6]));
    grad_n = sqrt(sum(grad.*grad,2));
    grad = grad./[grad_n grad_n grad_n]; % the gradient orientations (not unique with respect to sign... think orientation vs. direction)
    grad(isnan(grad)) = 0;
   
    grad(:, 1) = grad(:, 1) * (-1);
    grad = grad(:, [2, 1, 3]);

    fid1 = fopen(fullfile(fpath, 'orient.bval'), 'w+');
    fprintf(fid1, '%f\t', bvals);
    fclose(fid1);

    fid2 = fopen(fullfile(fpath, 'orient.bvec'), 'w+');
    fprintf(fid2, '%f\t', grad(:, 1));
    fprintf(fid2, '\n');
    fprintf(fid2, '%f\t', grad(:, 2));
    fprintf(fid2, '\n');
    fprintf(fid2, '%f\t', grad(:, 3));
    fclose(fid2);
end