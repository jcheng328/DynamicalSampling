function [T] = EquipMatrixWeights(w,A)
% This function equips the matrix A (corresponding to its sparsity pattern)
% with weights w.
% Input:   A: the sparse matrix graph, which specifies the connectedness of the graph
%          w: the  weight variables, defined on the edges.
% Output:  Graph matrix T with sparsity pattern of A, equipped with weights
% w.


B=triu(full(A));
k=1;

for i=1:size(A,1)
    for j=i+1:size(A,2)
        if B(i,j)>0
            B(i,j)=w(k);
            k=k+1;
        end
    end
end
T=B+B';

end