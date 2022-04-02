function Sample(S, left, right)
% This function is used for sampling frequences

%% ����������
LeftArea = 1:(left-1);
LeftArea = LeftArea';

RightArea = (right+1):size(S,3);
RightArea = RightArea';

%% ������
save LeftArea.mat LeftArea;
save RightArea.mat RightArea;
end