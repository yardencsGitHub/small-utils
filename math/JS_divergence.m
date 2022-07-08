function d = JS_divergence(P,Q,varargin)
    dim = 1;
    nparams=length(varargin);
    if mod(nparams,2)>0
        error('Parameters must be specified as parameter/value pairs');
    end
    for i=1:2:nparams
        switch lower(varargin{i})
	        case 'dim'
		        dim=varargin{i+1};
        end
    end
    M = (P+Q)/2;
    d = (KL_divergence(P,M,'dim',dim) + KL_divergence(Q,M,'dim',dim))/2;
end