
function [alpha] = tls(A, b)
    n = size(A,2);
    C = [A b]; % C: augmented matrix
    [~, ~, V] = svd(C);
    VXY = V(1:n, 1+n:end);
    VYY = V(1+n:end, 1+n:end);
    if VYY == 0
        disp("Value Error: VYY should not be all 0s! not TLS solution!");
        alpha = zeros(n,1);
        return;
    end
    alpha = -VXY/VYY;
end