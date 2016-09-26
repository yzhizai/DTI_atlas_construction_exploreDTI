function mean_DT_adv(DT_Matrix, mask_explicit, VG, outFileName)
%MEAN_DT_ADV - a function used to average the DTs from resampled DT
%
%Input:
%  DT_Matrix -  the cat(4, DT1, DT2, ...)
%  mask_explicit - a mask used to reduce calculation quantity.
%  VG - a reference image vol
%  outFileName - a string to name the output DT file
%
%Institute of High Energy Physics
%Shaofeng Duan
%2016-09-24

[~, ~, ~, dim4, dim5] = size(DT_Matrix);
mask_explicit_rep = repmat(mask_explicit, 1, 1, 1, dim4);  %generate a mask with size same as DT matrix
DT_sum = zeros(numel(find(mask_explicit == 1)), dim4);
DT_flg_sum = zeros(numel(find(mask_explicit == 1)), 1);
spm_progress_bar('Init', 100, '', 'processing');
for aa = 1:dim5
    DT = DT_Matrix(:, :, :, :, aa); 
    DT_res  = reshape(DT(mask_explicit_rep  == 1), [], dim4);  %discard the unmask element.
    DT_res(isinf(DT_res) | isnan(DT_res)) = 0;
    Dcell = DT2Matrix_adv(DT_res);
%     Dcell_logm = cellfun(@logm_adj, Dcell, 'UniformOutput', false);
    [Dcell_logm, Dcell_flg] = cellfun(@logm_adj, Dcell, 'UniformOutput', false);
    [Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, Dcell_logm);
    
    DT_new = cat(2, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz);
    DT_sum = DT_sum + DT_new; 
    DT_flg_sum = DT_flg_sum + cell2mat(Dcell_flg);
    spm_progress_bar('Set', 'Height', aa/dim5*100);
end
spm_progress_bar('Clear');

% DT_mean = DT_sum/dim5;
DT_mean = DT_sum./(repmat(DT_flg_sum, 1, dim4));
Dcell_new = DT2Matrix_adv(DT_mean);
Dcell_expm = cellfun(@expm, Dcell_new, 'UniformOutput', false);

[Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, Dcell_expm);
DT = zeros(size(mask_explicit_rep));
DT(mask_explicit_rep == 1) = cat(1, Dxx, Dxy, Dxz, Dyy, Dyz, Dzz);
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



function [val, abn_f] = logm_adj(DT)

if det(DT) <= 0 || ~isreal(eig(DT)) || sum(eig(DT) < 0) == 2
    val = zeros(3);
    abn_f = 0;
else 
    val = logm(DT);
    abn_f = 1;
end
    

% function val = logm_adj(DT)
% if isequal(DT, zeros(3))
%     val = DT;
%     return;
% end
% [V, D] = eig(DT);
% [eigV, idx] = sort(diag(D), 'descend');
% V = V(:,idx);
% eigV(eigV <= 0) = 0.001;
% D = diag(eigV);
% val = logm(V*D/V);