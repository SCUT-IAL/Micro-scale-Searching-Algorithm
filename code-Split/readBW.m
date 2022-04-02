function [left, right] = readBW()
%This function is used to read the BW from the S-parameters
w = 10;                                                   %进行扫描的窗口大小
thr = 0.1;                                              %阈值,评估差异性

%% 将S参数转为对应的dB值
load S11.mat;
load S21.mat;
dB_S11 = 20*log10(abs(S11));
dB_S21 = 20*log10(abs(S21));
save dB_S11.mat dB_S11;
save dB_S21.mat dB_S21;

%% 从左至右扫描
for i = 1:size(dB_S11, 1)
    if std(dB_S11(i:(i+w), 1)) > thr
        left = i+w;
        break;
    end
end

%% 从右至右左扫描
for i = size(dB_S11, 1):-1:1
    if std(dB_S11((i-w):i, 1)) > thr
        right = i-w;
         break;
    end
end

save left.mat left;
save right.mat right;
end

