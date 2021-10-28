
function [ observ ] = BlockCadzow(observ, r, max_iter)
%Cadzow 此处显示有关此函数的摘要
%   此处显示详细说明
    cnt = 0;
    Dprev = 0;
    Nblock = size(observ,1);
    height = floor((size(observ,2)-1)/2);
    width = size(observ,2)+1-height;
    H = zeros(Nblock*height, width);
    for id = 1 : Nblock
        H((id-1)*height+1:id*height, :) = hankel(observ(id,1:height), observ(id,height:end));
    end
    D = svd(H);
    figure
    plot(1:numel(D)-1,log(D(1:end-1)./D(2:end)))
    
    while (true) && (cnt<max_iter)
        cnt = cnt + 1;
        H = zeros(Nblock*height, width);
        for id = 1 : Nblock
            H((id-1)*height+1:id*height, :) = hankel(observ(id,1:height), observ(id,height:end));
        end
        [U, S, V] = svd(H);
        D = diag(S);
        if Dprev == D(r+1)
            break
        end
        Dprev = D(r+1);
        if D(r+1) < 10^(-40)
            break;
        end
        D(r+1:end) = 0;
        S(1:size(S,1)+1:(size(D,1)-1)*(size(S,1)+1)+1) = D;
        H = U*S*V';
        for id = 1 : size(observ,1)
            Hpart = rot90(H((id-1)*height+1:id*height, :));
            for i = 1 : sum(size(Hpart))-1
                k = i - size(Hpart,1);
                Diag = diag(Hpart,k);
                part(i) = mean(Diag);
            end
            observ(id,:) = part;
        end
    end
    D = svd(H);
    figure
    plot(1:numel(D)-1,log(D(1:end-1)./D(2:end)))
    
    if cnt >= max_iter
        disp("Number of iteration exceeds the max number of iterations.")
    else
        disp("Number of iteration: " + num2str(cnt));
    end
end
function H = blockhankel(observ)
    L = floor((size(observ,2)-1)/2);
    L1 = floor((size(observ,1)-1)/2);
    H = zeros(L*(size(observ,1)-L1+1),(size(observ,2)-L+1)*L1);
    for id = 1 : size(observ, 1)
        part = observ(id,:);
        Hpart = hankel(part(1:L),part(L:end));
        for k = 1 : id
            if (k > L1) | (id+1-k > size(observ,1)+1-L1)
                continue
            end
            H((id-k)*L+1:(id-k+1)*L,(k-1)*(size(observ,2)-L+1)+1:k*(size(observ,2)-L+1)) = Hpart;
        end
    end
end