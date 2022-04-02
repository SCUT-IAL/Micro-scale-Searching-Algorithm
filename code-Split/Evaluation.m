function [value] = Evaluation(X, Area)
%% Transform the X to M
currentM = XtoM(X);

%% Transform M to S
load Freq.mat;
load BW.mat;

Qu = 3000;
[S,~]=Mcalc(currentM,BW,Freq,Qu);

%% calculate the current value
S11_simular = squeeze(S(1,1,:));
S21_simular = squeeze(S(2,1,:));
abs_S11_simular = abs(S11_simular);
abs_S21_simular = abs(S21_simular);

%% calculate the true value
load S11.mat;
load S21.mat;
abs_S11 = abs(S11);
abs_S21 = abs(S21);

%% calculate the evaluation value
value_S11 = (abs_S11_simular(Area(:), 1) - abs_S11(Area(:), 1)).^2;

load LeftArea.mat;
load RightArea.mat;
LR_Area = [LeftArea; RightArea];
value_S21 = (abs_S21_simular(LR_Area(:), 1) - abs_S21(LR_Area(:), 1)).^2;

value = sum(value_S11, 1)+ sum(value_S21, 1);

end

