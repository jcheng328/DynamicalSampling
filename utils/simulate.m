
function observ = simulate(A, f, noise, temporal_size)
%simulate 
    fevo = f;
    dim = size(f,1);
    if temporal_size==0
        temporal_size = 3*dim;
    end
    observ = zeros(size(fevo(:),1),temporal_size);
    for k = 1 : temporal_size
        tmp = fevo;
        if noise("activated")
            if noise("type") == "Additive"
                observ(:,k) = tmp + noise("stdv") * norm(tmp) * randn(size(tmp));
            elseif noise("type") == "Multiplicative"
                observ(:,k) = tmp + noise("stdv") * randn(size(tmp));
            else
                error("[%*c %-5s] %-20s\n",6," ","ERROR",sprintf("No default type of noise specified: '%s'", "Neither additive Gaussian noise nor multiplicative Gaussian noise")); 
            end
        else
            observ(:,k) = tmp; % every column represents a time stamp
        end
        fevo = A * fevo; 
    end
end