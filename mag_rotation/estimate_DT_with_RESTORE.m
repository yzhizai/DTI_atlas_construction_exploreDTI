function DT = estimate_DT_with_RESTORE(b_matrix, y_exp)
% Usage:
% Input:
%   b_matrix - a n*6 matrix, n represents the number of diffusion
%   gradiensts. each row is corresponding to dxx, dxy, dxz, dyy, dyz, dzz.
%   y_exp - a vector consists of S(i) for each diffusion gradient
%   directions.
% Output:
% 
DT0 = [0.5, 0, 0, 0.5, 0, 0.5]'*1e-3;
options = optimoptions('lsqnonlin','OptimalityTolerance',1e-10, 'FunctionTolerance', 1e-10);
DT = lsqnonlin(@(x)objective_func_nonls(x, b_matrix, y_exp), DT0,[0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 1], options);

y_est = y_exp(1) * exp(-b_matrix*DT);
r = y_exp - y_est;
if sum(r > std(y_exp)) > 0
    while sum(r > std(y_exp)) > 0
       [DT, ~, ~, exitflag, ~] =  lsqnonlin(@(x)objective_func_nonls(x, b_matrix, y_exp, r), DT0,[0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 1], options);
       y_est = y_exp(1) * exp(-b_matrix*DT);
       r = y_exp - y_est;
       if exitflag ~= 1  % Deciding whether the processing is convergence or not.
           continue;
       else
           break;
       end
    end
    L_outlier = find((r > std(y_exp) == 1));
    b_matrix_exclude = b_matrix;
    b_matrix_exclude(L_outlier, :) = [];
    y_exp_exclude = y_exp;
    y_exp_exclude(L_outlier) = [];
    DT = lsqnonlin(@(x)objective_func_nonls(x, b_matrix_exclude, y_exp_exclude), DT0,[0, 0, 0, 0, 0, 0], [1, 1, 1, 1, 1, 1], options);
else
    return;
end
% This section follows the introduction of nonlinear least squares in
% Matlab Documentation.
function x2 = objective_func_nonls(DT, b_matrix, y_exp, r)
y_est = y_exp(1)*exp(-b_matrix*DT);
if nargin < 4
    x2 = 1/std(y_exp)*(y_exp - y_est).^2;
else
    r_median = median(r(:));
    C = median(abs(r - r_median))*1.4826;
    x2 = 1/(r.^2 + C^2).*(y_exp - y_est).^2;
end


