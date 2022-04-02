function [currentM] = XtoM(X)
%   Detailed explanation goes here
load M.mat;
UpM = triu(M,0);
UpM(UpM == 1) = X;
DownM = UpM';
currentM = UpM + DownM - diag([diag(DownM)]);
end

