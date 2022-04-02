function [bestM] = main()
clear all;
clc;
basicAddress = "..\ʵ�������";
fileName = ["095";"F36C010";"�˲���1"];

%% Start
for id = 3:3
    if id < 3
        %num = 5;
        num = 3;
    else
        num = 3;
    end
    
    %��̨���ܵ���"F36C010"��case2
    % id��ʾ�ڼ����˲��� index��ʾ�ڼ���case
    for index = 1:1
        S_adress = strcat(basicAddress, '\', fileName(id), '\', num2str(index), '\', "S.mat");
        S = load(S_adress);
        S = S.S;
        save S.mat S;
        Freq_address = strcat(basicAddress, '\', fileName(id), '\', "Freq.mat");
        Freq = load(Freq_address);
        Freq = Freq.Freq;
        save Freq.mat Freq;
        
        %% Save the S-parameters.
        load S.mat;
        S11 = squeeze(S(1,1,:));
        save S11.mat S11;
        
        S21 = squeeze(S(2,1,:));
        save S21.mat S21;
        
        S12 = squeeze(S(1,2,:));
        save S12.mat S12;
        
        S22 = squeeze(S(2,2,:));
        save S22.mat S22;
        
        %% Read the BW
        LR_address = strcat(basicAddress, '\', fileName(id), '\', "BW.txt");
        weizhi = importdata(LR_address);
        left = weizhi(1);
        right = weizhi(2);
        
        load Freq.mat
        BW = [Freq(left, 1), Freq(right, 1)];
        save BW.mat BW;
        
        %% Set the samples

        Sample(S, left, right);
        
        %% Construct the M.
        M_address = strcat(basicAddress, '\', fileName(id), '\', "M.xls");
        [M] = xlsread(M_address);
        save M.mat M;
        
        %% Transform the M to X.
        % ����M ������ value=1 �ĸ���
        dim  = MtoX(M);
        makeSample(dim);
        
        %% Search.
        result = zeros(30,2);
        
        %�Ѿ�����29���� ���������һ��
        for i = 1:30
            % plot the result.
            plotS(S, Freq);
            
            % using algorithm to search the optimal coupling matrix
            %KeyPoint = sort(floor(linspace(left, right, 6)), 'descend')';
            
            % �˴�ʹ�ö��ֵķ���ʹ��ÿ������ĵ㶼��������أ�
            
            %�����������
            
            
            %KeyPoint����Ϊ�����
            KeyPoint = [left,right]
            
            while( 1 )
                
                %�жϵ�ǰ�ָ��Ƿ����Ŀ��
                negativeNum = getNegativeNum(KeyPoint)
                flag = ( sum(negativeNum) ==0 )
                
                if flag ==0
                    %�������KeyPoint
                    tmp = [KeyPoint(1)]
                    for j = 1: size(negativeNum,2)
                        
                        %����������Ѿ�����أ���ֱ�Ӽ��������ұߵĵ�
                        if negativeNum(j)==0
                            tmp = [ tmp,KeyPoint(j+1)  ]
                        %���������û������أ��ͼ����е� �Լ� �ұߵĵ�
                        else
                            middle = floor(( KeyPoint(j) + KeyPoint(j+1)  ) / 2 )
                            tmp = [tmp,middle,KeyPoint(j+1) ]
                        end
                    end
                    %����KeyPoint
                    KeyPoint = tmp
                else
                    break
                end
            end
            
            tic
            Initial = -1.5 + rand(dim, 1)*3;
            KeyPoint = sort(KeyPoint, 'descend');
            for j = 2:size(KeyPoint,2)
                Area = KeyPoint(j):KeyPoint(1);
                Area = Area';
                [bestX] = purecmaes(dim, Initial, Area);
                Initial = bestX;
            end
            toc
            
            % Transform the X to M
            bestM = XtoM(bestX);
            
            % plot the result.
            Qu = 3000;
            [S_simular,~] = Mcalc(bestM, BW, Freq, Qu);
            plotS_Pre(S_simular, Freq);
            drawnow;
            
            %calculating the error
            S11_simular = squeeze(S_simular(1,1,:));
            S21_simular = squeeze(S_simular(2,1,:));
            dBS11 = 20*log10(abs(S11));
            dBS21 = 20*log10(abs(S21));
            dBS11_simular = 20*log10(abs(S11_simular));
            dBS21_simular = 20*log10(abs(S21_simular));
            result(i, 1) = sum((dBS11_simular - dBS11).^2, 1) / size(Freq, 1);
            result(i, 2) = sum((dBS21_simular - dBS21).^2, 1) / size(Freq, 1);
            
            %% Save the results.
            saveas(gcf, num2str(id*1000 + index*100 + i), 'jpg');
            bestM_address = strcat(num2str(id*1000 + index*100 + i), '-', 'bestM.mat');
            bestX_address = strcat(num2str(id*1000 + index*100 + i), '-', 'bestX.mat');
            save(bestM_address, 'bestM');
            save(bestX_address, 'bestX');
            close all;
        end
        result_address = strcat(num2str(id*1000 + index*100 + i), '-', 'result.mat');
        save(result_address, 'result');
    end
end
end

