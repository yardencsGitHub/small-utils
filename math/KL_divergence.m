function d = KL_divergence(P,Q)
    d = sum(P.*log(P./(Q+1e-20)+1e-20));
end