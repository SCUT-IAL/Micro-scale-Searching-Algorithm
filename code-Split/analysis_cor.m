function [ a ] = analysis_cor()
clear all;
clc;

%% 生成数据 （300,1601）

load Freq.mat
load BW.mat

dim = 15;

S_first = [];
S_second = [];

for times = 1:10
    %初始化随机矩阵
    Initial = -1.5 + rand(dim, 1)*3;

    %
    %此处对Initial进行优化（事实上也是对协方差矩阵优化），使得Loss最小。
    %
    
    bestM = XtoM(Initial); %bestM： 8x8 矩阵
    Qu = 3000;
    [S_simular,~] = Mcalc(bestM, BW, Freq, Qu);
    plotS_Pre(S_simular, Freq);
    drawnow;
    
    
    S11_simular= squeeze(S_simular(1,1,:))';
    S21_simular= squeeze(S_simular(2,1,:))';
    
%     dBS11_simular = 20*log10(abs(S11_simular));
%     dBS21_simular = 20*log10(abs(S21_simular));

    S_first = [S_first;S11_simular];
    S_second = [S_second;S21_simular];
    
 
end

save S_first.mat S_first;
save S_second.mat S_second;

load('S_first.mat')
load('S_second.mat')

%% 划分数据集

%生成index
partNum = 4;
keyPoint = floor(linspace(0, 1601, partNum+1));

positivaNum = []
negativeNum = []
%indepentNum = []


for i = 1: (partNum)
    %截取各个part的数据
    demo = S_second( : , keyPoint(i)+1: keyPoint(i+1)  );
    
    %计算相关性系数
    cor = corrcoef(demo);
    
    %生成上三角并且去掉对角线
    UpM = triu(cor,0);
    UpM = UpM -  diag([diag(UpM)]);
    
%     S_adress = strcat("cor-",num2str(i),".csv");
%     csvwrite(S_adress,UpM)
    
    %统计各个相关值
    positivaNum =  [ positivaNum, size(find(UpM>0),1)]
    negativeNum =  [ negativeNum,size(find(UpM<0),1)]
    %有bug
    %indepentNum =  [ indepentNum,size(find(UpM==0),1)]
end

save positivaNum.mat positivaNum;
save negativeNum.mat negativeNum;
%save indepentNum.mat indepentNum;

end

