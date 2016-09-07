filename = 'res_TPM';
dim = [128, 128, 64];

mat = eye(4)*2;

mat(1, 4) = -128;
mat(2, 4) = -128;
mat(3, 4) = -50;
mat(4, 4) = 1;

Def_3d_resample(dim ,mat, filename);