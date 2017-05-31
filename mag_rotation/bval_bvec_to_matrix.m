function bmatrix = bval_bvec_to_matrix(bval, bvec, xyz_perm, xyz_sign)
%BVAL_BVEC_TO_MATRIX - a function to transform the bval and bvec to
% bmatrix. It was verified by comparing with the b in exploreDTI.
%
%Usage: bmatrix = BVAL_BVEC_TO_MATRIX(bval, bvec, xyz_perm, xyz_sign)
%
%Input:
%  bval - the data loaded from bval file, a 1*N matrix
%  bvec - the data loaded from bvec file, a 3*N matrix
%  xyz_perm - a 1*3 matrix reprensted to change x, y, z order, such as [2,
%  1, 3] means same to [y, x, z] in exploreDTI
%  xyz_sign - a 1*3 matrix reprented to change the direction of x, y, z,
%  such as [-1, 1, 1] means same to [-x, y, z] in exploreDTI
%
%Shaofeng Duan
%Institute of High Energy Physics
%2016-07-20
N = numel(bval);
if nargin > 2
    bvec = bvec(xyz_perm, :);
    bvec = bvec.*repmat(xyz_sign', 1, N);
end
bvec = bvec';

grad_a = bvec(:, 1);
grad_b = bvec(:, 2);
grad_c = bvec(:, 3);

bmatrix =  zeros(N, 6);

bmatrix(:, 1) = grad_a.^2;
bmatrix(:, 2) = 2*grad_a.*grad_b;
bmatrix(:, 3) = 2*grad_a.*grad_c;
bmatrix(:, 4) = grad_b.^2;
bmatrix(:, 5) = 2*grad_b.*grad_c;
bmatrix(:, 6) = grad_c.^2;

bmatrix = bmatrix.*repmat(bval', 1, 6);
