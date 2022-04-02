function [bestM] = main()
clear all;
clc;
basicAddress = "..\实验仿真结果";
fileName = ["095";"F36C010";"滤波器1"];

%% Start
for id = 1:3
    if id < 3
        num = 5;
    else
        num = 3;
    end
    
    for index = 1:num
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
        % 矩阵M 上三角 value=1 的个数
        dim  = MtoX(M);
        
        %% Search.
        result = zeros(1,2);
        for i = 1:1
            % plot the result.
            plotS(S, Freq);
            
            % using algorithm to search the optimal coupling matrix
            KeyPoint = sort(floor(linspace(left, right, 6)), 'descend')';
            tic
            Initial = -1.5 + rand(dim, 1)*3;
            for j = 2:6
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

