
function [spec] = sort_complex(spec)
%     spec = unique(spec,'stable');
%     spec = spec(abs(spec)>1e-5);
%     spec = sortrows([real(spec) imag(spec)],'descend')*[1;1i];
    spec_zeros = spec(abs(spec)<1e-5);
    if size(spec_zeros,1)>0
        spec_zeros = sortrows([real(spec_zeros) imag(spec_zeros)],'descend')*[1;1i];
    end
    spec_nonzeros = spec(abs(spec)>1e-5);
    if size(spec_nonzeros,1)>0
        spec_nonzeros = sortrows([real(spec_nonzeros) imag(spec_nonzeros)],'descend')*[1;1i];
    end
    spec = vertcat(spec_nonzeros,spec_zeros);
end
