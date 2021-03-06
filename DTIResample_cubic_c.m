function DT = DTIResample_cubic_c(DT, diffeoField, Def, mat, VG, VF)
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

M = inv(VF.mat);
new_posit          = zeros(size(Def),'single');
new_posit(:,:,:,1) = M(1,1)*Def(:,:,:,1)+M(1,2)*Def(:,:,:,2)+M(1,3)*Def(:,:,:,3)+M(1,4);
new_posit(:,:,:,2) = M(2,1)*Def(:,:,:,1)+M(2,2)*Def(:,:,:,2)+M(2,3)*Def(:,:,:,3)+M(2,4);
new_posit(:,:,:,3) = M(3,1)*Def(:,:,:,1)+M(3,2)*Def(:,:,:,2)+M(3,3)*Def(:,:,:,3)+M(3,4);


Dcell = DT2Matrix(DT);
Dcell_logm = cellfun(@logm_adj, Dcell, 'UniformOutput', false);
[Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, Dcell_logm);

%---%
d = [1 1 1 0 0 0];

cxx = spm_diffeo('bsplinc', single(Dxx), d);
Dxx_cubic = spm_diffeo('bsplins', cxx, new_posit, d);
cxy = spm_diffeo('bsplinc', single(Dxy), d);
Dxy_cubic = spm_diffeo('bsplins', cxy, new_posit, d);
cxz = spm_diffeo('bsplinc', single(Dxz), d);
Dxz_cubic = spm_diffeo('bsplins', cxz, new_posit, d);
cyy = spm_diffeo('bsplinc', single(Dyy), d);
Dyy_cubic = spm_diffeo('bsplins', cyy, new_posit, d);
cyz = spm_diffeo('bsplinc', single(Dyz), d);
Dyz_cubic = spm_diffeo('bsplins', cyz, new_posit, d);
czz = spm_diffeo('bsplinc', single(Dzz), d);
Dzz_cubic = spm_diffeo('bsplins', czz, new_posit, d);

DT_cubic = cat(4, Dxx_cubic, Dxy_cubic, Dxz_cubic, Dyy_cubic, Dyz_cubic, Dzz_cubic);
Dcell_cubic = DT2Matrix(DT_cubic);
Dcell_cubic_expm = cellfun(@expm, Dcell_cubic, 'UniformOutput', false);
%---%
temp = cell(size(Dcell_cubic_expm));
spm_progress_bar('Init', 1);
for aa = 1:size(Def, 3)
    for bb = 1:size(Def, 2)
        for cc = 1:size(Def, 1)
            F_temp = reshape(J(cc, bb, aa, :, :), 3,3);
            if sum(sum(isnan(F_temp))) || sum(sum(isinf(F_temp)))
                temp{cc, bb, aa} = zeros(3);
            else
                F = F_temp + eye(3);
                F = pinv(F);
                R = sqrtm(F*F')\F;  %FS method
                Dt = Dcell_cubic_expm{cc, bb, aa};
                Dt_adj = R*Dt*R';
                temp{cc, bb, aa} = Dt_adj;  
            end
        end
    end
    spm_progress_bar('Set',aa/size(Def, 3));
end
spm_progress_bar('Clear');


[Dxx, Dxy, Dxz, Dyy, Dyz, Dzz] = cellfun(@Matrix2DT, temp);
DT = zeros([size(Def(:, :, :, 1)), 6]);
DT(:, :, :, 1) = Dxx;
DT(:, :, :, 2) = Dxy;
DT(:, :, :, 3) = Dxz;
DT(:, :, :, 4) = Dyy;
DT(:, :, :, 5) = Dyz;
DT(:, :, :, 6) = Dzz;
DT(DT > 0.01) = 0;

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
% if ~isequal(val, conj(val))
%     val = zeros(3);
% end


