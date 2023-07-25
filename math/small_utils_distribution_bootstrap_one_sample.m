function newdists = small_utils_distribution_bootstrap_one_sample(p_vec,nrep,n_bootstrap)
% This returns n_bootstrap samples from a finite distribution of labels
    p_vec = reshape(p_vec,1,numel(p_vec));
    cump = [0 cumsum(p_vec)]; 
    newdists = zeros(n_bootstrap,numel(p_vec));
    r_all = rand(n_bootstrap,nrep);
    for boot_cnt = 1:n_bootstrap    
        r = r_all(boot_cnt,:);
        [n,x] = hist([1:numel(p_vec)]*(diff(sign(r-cump'))==-2),1:numel(p_vec));
        newdists(boot_cnt,:) = n/sum(n);
    end
end