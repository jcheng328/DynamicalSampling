
function [H] = construct_hankel(observ, viewpoints, colsize)
    N = size(observ, 2);
    L = colsize-1;
    H = zeros((N-L)*size(viewpoints,1), L+1);
    for id = 1 : size(viewpoints,1)
        part = observ(viewpoints(id), :);
        H((id-1)*(N-L)+1 : id*(N-L), :) = hankel(part(1:N-L), part(N-L:end));
    end
end