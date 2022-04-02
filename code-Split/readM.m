function [ M ] = readM(address)
%READ the M data from excel.
%parameter(address) is the absolute address of excel.
[M] = xlsread(address);
save M.mat M;
end

