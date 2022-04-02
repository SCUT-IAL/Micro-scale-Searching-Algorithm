function  makeSample(dim)


%% �������� ��300,1601��

load Freq.mat
load BW.mat



S_first = [];
S_second = [];

for times = 1:3000
    %��ʼ���������
    Initial = -1.5 + rand(dim, 1)*3;

    %
    %�˴���Initial�����Ż�����ʵ��Ҳ�Ƕ�Э��������Ż�����ʹ��Loss��С��
    %
    
    bestM = XtoM(Initial); %bestM�� 8x8 ����
    Qu = 3000;
    [S_simular,~] = Mcalc(bestM, BW, Freq, Qu);
%     plotS_Pre(S_simular, Freq);
%     drawnow;
    
    
    S11_simular= squeeze(S_simular(1,1,:))';
    S21_simular= squeeze(S_simular(2,1,:))';
    
%     dBS11_simular = 20*log10(abs(S11_simular));
%     dBS21_simular = 20*log10(abs(S21_simular));

    S_first = [S_first;S11_simular];
    S_second = [S_second;S21_simular];
    
 
end

save S_first.mat S_first;
save S_second.mat S_second;

end