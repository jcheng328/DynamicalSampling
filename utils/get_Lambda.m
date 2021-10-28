%% Dynamical Sampling for random synthetic system
% Script: get_Lambda
% Author: Sui Tang, Jiahui Cheng
% All right reserved.
% This script get Lambda from hankel matrix.


sympref("MatrixWithSquareBrackets",'default');
observ = [-3.0000, 11.0000, 56.0000, 510.0000, 4156.0000, 34564.0000, 286272.0000, 2373032.0000, 19667600.0000, 163010352.0000, 1351063168.0000, 11197906144.0000, 92810656704.0000, 769234756160.0000, 6375583606784.0000, 52842212505216.0000, 437967658002688.0000, 3629970441964288.0000, 3629970441964288.0000];
spec = [8.2882, -0.5578, -1.7304, -1.7304];
r = size(spec,1);
r = 4
spec = spec(1:4)
% construct hankel matrix
H = hankel(observ(1:r),observ(r:2*r-1));
% construct vandermonde matrix
V = fliplr(vander(spec));
Lambda = pinv(V).'*H*pinv(V);
print_mat('Lambda',Lambda)

function [parser] = parse(parser_field)
    if ~isempty(fieldnames(parser_field))
        parser = containers.Map(fieldnames(parser_field), struct2cell(parser_field));
    else
        parser = containers.Map;
    end
end

function [] = print_mat(name, M)
% print_mat This function print <name> and matrix <M>
%   name        -- str
%   M           -- mat
    disp(name)
    out = [];
    for k = 1 : size(M,1)
        if k ~= 1
            out = horzcat(out, [' ']);
        end
        if size(M,2)>1
            out = horzcat(out, [sprintf('%10.4f,', M(k,1:end-1) )]);
        end
        out = horzcat(out, [num2str(sprintf('%10.4f',M(k,end)))]);
        if k < size(M,1)
             out = horzcat(out, [';' sprintf('\n')]);
        end
    end
    out = horzcat(['['], out, [']']);
    disp(out);
end
    