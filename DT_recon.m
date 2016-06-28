function DT = DT_recon
%DT_RECON is a function used to generate exploreDTI type DT
%parameter. which is a 1*6 cell array, each element represent Dxx, Dxy,
%Dxz, Dyy, Dyz, Dzz, which order is same to the b variable in exploreDTI
%mat file.
%
%Usage: tempDT = DT_RECON;
%
%See also: DWI_CON
%
%Shaofeng Duan
%Institute of High Energy Physics
%2016-05-27
matFileNames = spm_select(Inf, 'mat', 'choose the trafo mat files ...');
matFileNames = cellstr(matFileNames);

for aa = 1:numel(matFileNames)
DT = load(matFileNames{aa}, 'DT');
Dcell = DT2Matrix(DT.DT);
cmdstr1 = sprintf('Dcell_%02d = Dcell;', aa);
eval(cmdstr1);
end
% temp = cellfun(@cstTempDMat, Dcell_01, Dcell_02, Dcell_03, Dcell_04, ...
%     Dcell_05, Dcell_06, Dcell_07, Dcell_08, Dcell_09, Dcell_10, 'UniformOutput', false);
temp = cellfun(@cstTempDMat, Dcell_01, Dcell_02, Dcell_03, Dcell_04, ...
     Dcell_05, Dcell_06, 'UniformOutput', false);
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

%--------------------------------------------------------------------------
% cstTempDMat is a function used Log-Euclidean Frechet mean to
% avergage the Tensors.
function tempD = cstTempDMat(varargin)
bb = 0;
N = nargin;
temp = zeros(3);
for aa = 1:N
    if ~sum(sum(isnan(varargin{aa})))
        temp = temp + logm(varargin{aa});
        bb = bb + 1;
    end
end
if isequal(zeros(3), temp)
    tempD = zeros(3);
else
    tempD = expm(temp/bb);
end

function [dxx, dxy, dxz, dyy, dyz, dzz] = Matrix2DT(DT_temp)
dxx = DT_temp(1, 1);
dxy = DT_temp(1, 2);
dxz = DT_temp(1, 3);
dyy = DT_temp(2, 2);
dyz = DT_temp(2, 3);
dzz = DT_temp(3, 3);