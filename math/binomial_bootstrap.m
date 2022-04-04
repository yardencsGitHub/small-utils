function [p,h] = binomial_bootstrap(n1,k1,n2,k2,varargin)
    if (n1 == 1) || (n2 == 1)
        disp('n valueas must be positive');
        p=1;h=0;
        return;
    end
    tail = 'both';
    alpha = 0.05;
    n_bootstrap = 10000;
    nparams=length(varargin);
    if mod(nparams,2)>0
	    error('Parameters must be specified as parameter/value pairs');
    end
    for i=1:2:nparams
	    switch lower(varargin{i})
		    case 'tail'
			    tail=varargin{i+1};
            case 'alpha'
			    alpha=varargin{i+1};
            case 'n_bootstrap'
			    n_bootstrap=varargin{i+1};
        end
    end
    origvec = zeros(1,n1+n2); origvec(1:k1) = 1; origvec(n1+1:n1+k2) = 1;
    bootstrap_temp = [];
    for nb = 1:n_bootstrap
        newvec = origvec(randperm(n1+n2));
        newp1 = sum(newvec(1:n1))/n1; newp2 = sum(newvec(n1+1:end))/n2;
        bootstrap_temp = [bootstrap_temp; newp1-newp2];
    end
    switch tail
        case 'right'
            p = mean(bootstrap_temp > p1-p2);
        case 'left'
            p = mean(bootstrap_temp < p1-p2);
        case 'both'
            p = min(mean(bootstrap_temp > p1-p2),mean(bootstrap_temp < p1-p2))*2;
    end
    h = 1*(p<alpha);
end
