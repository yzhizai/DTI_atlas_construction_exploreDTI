function mean_DT(DT_Matrix, VG, outFileName)
%MEAN_DT - a function used to average the DTs from resampled DT
%
%Input:
%  DT_Matrix -  the cat(4, DT1, DT2, ...)
%  VG - a reference image vol
%  outFileName - a string to name the output DT file
%
%Institute of High Energy Physics
%Shaofeng Duan
%2016-09-07

[dim1, dim2, dim3, dim4, dim5] = size(DT_Matrix);

DT_sum = zeros(dim1, dim2, dim3, dim4);
spm_progress_bar('Init', 100, '', 'processing');
for aa = 1:dim5
    DT = DT_Matrix(:, :, :, :, aa);
    DT(isinf(DT) | isnan(DT)) = 0;
    Dcell = DT2Matrix(DT);
    Dcell_logm = cellfun(@logm_adj, Dcell, 'UniformOutput', false);
    [Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, Dcell_logm);
    
    DT_new = cat(4, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz);
    DT_sum = DT_sum + DT_new; 
    spm_progress_bar('Set', 'Height', aa/dim5*100);
end
spm_progress_bar('Clear');

DT_mean = DT_sum/dim5;
Dcell_new = DT2Matrix(DT_mean);
Dcell_expm = cellfun(@expm, Dcell_new, 'UniformOutput', false);

[Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, Dcell_expm);
DT = zeros(dim1, dim2, dim3, 6);
DT(:, :, :, 1) = Dxx;
DT(:, :, :, 2) = Dxy;
DT(:, :, :, 3) = Dxz;
DT(:, :, :, 4) = Dyy;
DT(:, :, :, 5) = Dyz;
DT(:, :, :, 6) = Dzz;
DT(DT > 0.01) = 0;

fname = outFileName;
dt = VG(1).dt(1);
sf  = VG(1).pinfo(1);
off = VG(1).pinfo(2);
ni = nifti;
ni.dat = file_array(fname,...
                        [VG(1).dim size(DT, 4)],...
                        [dt spm_platform('bigend')],...
                        0,...
                        sf,...
                        off);
ni.mat = VG(1).mat;
ni.mat0 = VG(1).mat;
ni.descrip = 'Diffusion tensor';

create(ni);
for i=1:size(ni.dat,4)
    ni.dat(:,:,:,i) = DT(:, :, :, i);
end



function val = logm_adj(DT)
if isequal(DT, zeros(3))
    val = DT;
    return;
end
[V, D] = eig(DT);
[eigV, idx] = sort(diag(D), 'descend');
V = V(:,idx);
eigV(eigV <= 0) = 0.001;
D = diag(eigV);
val = logm(V*D/V);