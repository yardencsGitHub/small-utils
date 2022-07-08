function H = ShannonEnt(p,varargin)
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
    H = -sum(p.*log(p+1e-20),dim)/log(2);
end