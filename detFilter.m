function dtMask = detFilter(DTmat)

DTmat(isinf(DTmat) | isnan(DTmat)) = 0;
Dcell = DT2Matrix(DTmat);
dtMask = cellfun(@det_sign, Dcell);


function signF = det_sign(DT)

if det(DT) <= 0 || ~isreal(eig(DT)) || sum(eig(DT) < 0) == 2
    signF = 0;
else
    signF = 1;
end