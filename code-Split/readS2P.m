function [S, Y, Freq] = readS2P(address)
%This function is used to read the S-parameters and Y-parameters from the S2P file
SData = sparameters(address);
YData = yparameters(address);
S = SData.Parameters;
Y = YData.Parameters;
Freq = SData.Frequencies;

%% Save the freq
save Freq.mat Freq;

%% Sava data
S11 = squeeze(S(1,1,:));
save S11.mat S11;

S21 = squeeze(S(2,1,:));
save S21.mat S21;

S12 = squeeze(S(1,2,:));
save S12.mat S12;

S22 = squeeze(S(2,2,:));
save S22.mat S22;

save S.mat S;
save Y.mat Y;
end

