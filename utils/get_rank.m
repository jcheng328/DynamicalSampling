
function [r] = get_rank(H, method, threshold, dim)
    % get_rank This function determine the numerical rank r from the observati
    % -ons <observ> at <viewpoints>
    % observ        -- matrix
    % viewpoints    -- vector
    % method        -- string
        switch method
            case "spectrum_gap"
                [~, D, ~] = svd(H);
                D = diag(D);
                % compute the spectrum quotient
                spec_quot = D(1:end-1) ./ D(2:end);
                % sort the quotient and find the maximum gap.
                [a, ia] = sort(spec_quot,'descend');
                [~, ic] = max(a(1:end-1) - a(2:end));
                r = ia(ic);
                
                %r=6;
% %                 
%                 [~, D, ~] = svd(H);
%                 D = abs(diag(D));
%                 r = sum(D>0.5*max(D)*1e-3);

% 
% 
%      [~, D, ~] = svd(H);
%                 D = abs(diag(D));
%                 r = sum(D>0.5*max(D)*1e-1);
%                 r=10;
%                 
%                 if r == 1
%                    % designed for ring graph.
%                     r = ia(2);
%                     disp("setup for ring graph")
%                 end
                
%                 D = sort(abs(diag(D)),'descend');
%                 
%                 r = dim;
%                 for k =1:dim-1
%                     if (D(k+1)/D(k) <threshold) && (D(k+1)<1e-3)
%                         r = k;
%                         break;
%                     end
%                 end
            case "absolute_value"
                [~, D, ~] = svd(H);
                D = abs(diag(D));
                r = sum(D>max(D)*1e-12);
        end
    end