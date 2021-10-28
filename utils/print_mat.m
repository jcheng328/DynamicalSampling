function [msg] = print_mat(M, print_mat)
% print_mat This function print matrix <M>
%   M           -- mat
%     arguments
%         M double
%         print_mat logical = true
%     end
    out = [];
    for k = 1 : size(M,1)
        if size(M,2)>1
            for s = 1 : size(M,2)-1
                if isreal(M(k,s))
                    out = horzcat(out, [sprintf('%2.4f, ', real(M(k,s)) )]);
                else
                    out = horzcat(out, [sprintf('%2.4f+%2.4fi, ', real(M(k,s)), imag(M(k,s)) )]);
                end
            end
        end
        if isreal(M(k,end))
            out = horzcat(out, [sprintf('%2.4f, ', real(M(k,end)) )]);
        else
            out = horzcat(out, [sprintf('%2.4f+%2.4fi, ', real(M(k,end)), imag(M(k,end)) )]);
        end
        out = horzcat(out, [sprintf('%2.4f', M(k,end))]);
        if k < size(M,1)
             out = horzcat(out, [';']);
        end
    end
    out = horzcat(['['], out, [']']);
    msg = string(out);
    if print_mat
        disp(msg);
    end
end