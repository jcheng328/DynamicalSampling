
function [ observ ] = BlockCadzow2(observ, r, max_iter)
%Cadzow 此处显示有关此函数的摘要
%   此处显示详细说明
    cnt = 0;
    Dprev = 0;
    Nblock = size(observ,1)
    blockheight = floor((Nblock+1)/2);
    blockwidth = Nblock+1-blockheight;
    N = size(observ,2);
    height = floor((N-1)/2);
    width = size(observ,2)+1-height;
    H = zeros(blockheight*height, blockwidth);
    for k = 1 : Nblock
        for j = 1 : min(k,blockheight)
            % block (j,k+1-j) = ((j-1)*height+1:j*height, (k-j)*weight+1:(k-j+1)*weight)
            H((j-1)*height+1:j*height,(k-j)*width+1:(k-j+1)*width) =  hankel(observ(k,1:height), observ(k,height:end));
        end
    end
    D = svd(H);
    spec_quot = D(1:end-1) ./ D(2:end);
    % sort the quotient and find the maximum gap.
    [a, ia] = sort(spec_quot,'descend');
    [~, ic] = max(a(1:end-1) - a(2:end));
    disp("Looooooooook hereeeeeeeeee~!"+num2str(ia(ic)));
    figure
    plot(1:numel(D)-1,log(D(1:end-1)./D(2:end)))
    
    while (true) && (cnt<max_iter)
        cnt = cnt + 1;
        % construct the hankel matrix
        H = zeros(blockheight*height, blockwidth);
        for k = 1 : Nblock
            for j = 1 : min(k,blockheight)
                % block (j,k+1-j) = ((j-1)*height+1:j*height, (k-j)*weight+1:(k-j+1)*weight)
                H((j-1)*height+1:j*height,(k-j)*width+1:(k-j+1)*width) =  hankel(observ(k,1:height), observ(k,height:end));
            end
        end
        [U, S, V] = svd(H);
        D = diag(S);
        if Dprev == D(r+1)
            break
        end
        Dprev = D(r+1);
        if D(r+1) < 10^(-3) * D(r)
            break;
        end
        D(r+1:end) = 0;
        S(1:size(S,1)+1:(size(D,1)-1)*(size(S,1)+1)+1) = D;
        H = U*S*V';
        for k = 1 : Nblock
            Hpart = zeros(height,width);
            for j = 1 : min(k,blockheight)
                Hpart = Hpart + H((j-1)*height+1:j*height,(k-j)*width+1:(k-j+1)*width);
            end
            Hpart = Hpart / min(k,blockheight);
            Hpart = rot90(Hpart);
            for i = 1 : sum(size(Hpart))-1
                l = i - size(Hpart,1);
                Diag = diag(Hpart,l);
                part(i) = mean(Diag);
            end
            observ(k,:) = part;
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