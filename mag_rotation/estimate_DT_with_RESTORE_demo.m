bvec = load(spm_select(1, 'grad', 'bvec'));
bval = load(spm_select(1, 'bval', 'bval'));
b_matrix = bval_bvec_to_matrix(bval', bvec);
S0 = 500;
DT0 = diag([1, 0.3, 0.4])*1e-3;
y_exp = S0*exp(-b_matrix*[DT0(1, 1:3), DT0(2, 2:3), DT0(3, 3)]');

DT = estimate_DT_with_RESTORE(b_matrix, y_exp);