function Sample(S, left, right)
% This function is used for sampling frequences

%% 采样评估点
LeftArea = 1:(left-1);
LeftArea = LeftArea';

RightArea = (right+1):size(S,3);
RightArea = RightArea';

%% 保存结果
save LeftArea.mat LeftArea;
save RightArea.mat RightArea;
end