
function [ observ_denoised ] = Cadzow(observ, r, max_iter)
%Cadzow 此处显示有关此函数的摘要
%   此处显示详细说明
    observ_denoised = zeros(size(observ));
    for id = 1 : size(observ, 1)
        part = observ(id,:);
        L = floor((length(part)-1)/2);
        Dprev = 0;
        cnt = 0;
        while (true) && (cnt<max_iter)
            cnt = cnt + 1;
            H = hankel(part(1:L),part(L:end));
            [U, S, V] = svd(H);
            D = diag(S);
            if Dprev == D(r+1)
                break
            end
            Dprev = D(r+1);
            if D(r+1) < 10^(-9)
                break;
            end
            D(r+1:end) = 0;
            S(1:size(S,1)+1:(size(D,1)-1)*(size(S,1)+1)+1) = D;
            H = rot90(U*S*V');
            for i = 1 : sum(size(H))-1
                k = i - size(H,1);
                Diag = diag(H,k);
                part(i) = mean(Diag);
            end
        end
        if cnt >= max_iter
            disp("Number of iteration exceeds the max number of iterations.")
        else
            disp("Number of iteration: " + num2str(cnt));
        end
        part_denoised = part;
        observ_denoised(id,:) = part_denoised;
    end
end