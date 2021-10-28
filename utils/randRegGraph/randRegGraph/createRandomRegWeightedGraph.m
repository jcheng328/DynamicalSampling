function [T,r] = createRandomRegWeightedGraph(n, deg)
%createRandRegWeightedGraph This function creates a graph shift matrix A 
% that comes from a random regular graph of degree deg, the non-zero weights 
% are chosen according to the model 'weightmodel'.
M=RandRegGraph(n,deg);
zero_threshold = 0.8; 
    r=(rand(n*deg/2,1)*(1-zero_threshold))+zero_threshold;


A = EquipMatrixWeights(r,M);% diffusion matrix 

D=diag(sum(A,2));


T=pinv(sqrt(D))*A*pinv(sqrt(D));


end

