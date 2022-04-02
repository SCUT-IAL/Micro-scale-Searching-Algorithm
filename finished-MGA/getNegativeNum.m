function [negativeNum] = getNegativeNum(KeyPoint)

partNum = size(KeyPoint,2) -1 
negativeNum = []

for i = 1:partNum
    
    %ֻ����ɫ���� ��ɫ������S11������
    load('S_second.mat')
    
    %��ȡ����һpart
    demo = S_second( : , KeyPoint(i): KeyPoint(i+1)  );
    
    %���������ϵ��
    cor = corrcoef(demo);
    
    %���������ǲ���ȥ���Խ���
    UpM = triu(cor,0);
    UpM = UpM -  diag([diag(UpM)]);
    
    negativeNum =  [ negativeNum,size(find(UpM<0),1)];

end

end