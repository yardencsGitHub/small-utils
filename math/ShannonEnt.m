function H = ShannonEnt(p)
    H = -sum(p.*log(p+1e-20))/log(2);
end