function d = JS_divergence(P,Q)
    M = (P+Q)/2;
    d = (KL_divergence(P,M) + KL_divergence(Q,M))/2;
end