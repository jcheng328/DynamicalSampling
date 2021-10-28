function [T,w,L] = createRandErdosRenyiGraph(G)
%This function generate diffusion matrix of ErdosRenyi graph
% Inputs:
% G: structure matrix for graph 
% 
%  Outputs:
%  w: weights for edges 
%  T: diffusion matrix 


% give random weights for edges
w1=(rand(G.ne,1)+0.7)/2;
L=G.Adj;
%create symmetric adjacent matrix 
A=triu(full(G.Adj));

B=A;
k=1;
for i=1:size(A,1)
    for j=i+1:size(A,2)
        if B(i,j)>0
            B(i,j)=w1(k);
            k=k+1;
        end
    end
end

B=B+B';
w=w1(1:k-1);
%create the weight degree matrix
D=diag(sum(B,2));


T=pinv(sqrt(D))*B*pinv(sqrt(D));

end

