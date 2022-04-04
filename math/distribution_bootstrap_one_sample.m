function newdists = distribution_bootstrap_one_sample(p_vec,nrep,n_bootstrap)
% This returns n_bootstrap samples from a finite distribution of labels
    newdists = [];
    for boot_cnt = 1:n_bootstrap
        cump = [0 cumsum(p_vec)];
        r = rand(1,nrep);
        [n,x] = hist([1:numel(p_vec)]*(diff(sign(r-cump'))==-2),1:numel(p_vec));
        newdists = [newdists; n/sum(n)];
    end
end