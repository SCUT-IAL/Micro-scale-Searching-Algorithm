function [ a ] = analysis_cor()
clear all;
clc;

%% �������� ��300,1601��

load Freq.mat
load BW.mat

dim = 15;

S_first = [];
S_second = [];

for times = 1:10
    %��ʼ���������
    Initial = -1.5 + rand(dim, 1)*3;

    %
    %�˴���Initial�����Ż�����ʵ��Ҳ�Ƕ�Э��������Ż�����ʹ��Loss��С��
    %
    
    bestM = XtoM(Initial); %bestM�� 8x8 ����
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

%% �������ݼ�

%����index
partNum = 4;
keyPoint = floor(linspace(0, 1601, partNum+1));

positivaNum = []
negativeNum = []
%indepentNum = []


for i = 1: (partNum)
    %��ȡ����part������
    demo = S_second( : , keyPoint(i)+1: keyPoint(i+1)  );
    
    %���������ϵ��
    cor = corrcoef(demo);
    
    %���������ǲ���ȥ���Խ���
    UpM = triu(cor,0);
    UpM = UpM -  diag([diag(UpM)]);
    
%     S_adress = strcat("cor-",num2str(i),".csv");
%     csvwrite(S_adress,UpM)
    
    %ͳ�Ƹ������ֵ
    positivaNum =  [ positivaNum, size(find(UpM>0),1)]
    negativeNum =  [ negativeNum,size(find(UpM<0),1)]
    %��bug
    %indepentNum =  [ indepentNum,size(find(UpM==0),1)]
end

save positivaNum.mat positivaNum;
save negativeNum.mat negativeNum;
%save indepentNum.mat indepentNum;

end

