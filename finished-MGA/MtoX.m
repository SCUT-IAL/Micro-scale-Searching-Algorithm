function [dim] = MtoX(M)
%The function is used to transform the M to X.
dim = size(find(triu(M,0) == 1), 1);
end

