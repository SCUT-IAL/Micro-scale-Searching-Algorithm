function [negativeNum] = getNegativeNum(KeyPoint)

partNum = size(KeyPoint,2) -1 
negativeNum = []

for i = 1:partNum
    
    %只看蓝色那条 红色那条（S11）不看
    load('S_second.mat')
    
    %截取其中一part
    demo = S_second( : , KeyPoint(i): KeyPoint(i+1)  );
    
    %计算相关性系数
    cor = corrcoef(demo);
    
    %生成上三角并且去掉对角线
    UpM = triu(cor,0);
    UpM = UpM -  diag([diag(UpM)]);
    
    negativeNum =  [ negativeNum,size(find(UpM<0),1)];

end

end