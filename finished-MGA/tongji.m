function tongji()
clear all;
clc;

%% Start
for id = 3
    for index = 3
        load S.mat;
        load Freq.mat;
        
        %% Save the S-parameters.
        S11 = squeeze(S(1,1,:));
        save S11.mat S11;
        
        S21 = squeeze(S(2,1,:));
        save S21.mat S21;
        
        S12 = squeeze(S(1,2,:));
        save S12.mat S12;
        
        S22 = squeeze(S(2,2,:));
        save S22.mat S22;
        
        %% Read the BW
        weizhi = importdata('BW.txt');
        left = weizhi(1);
        right = weizhi(2);
        
        BW = [Freq(left, 1), Freq(right, 1)];
        save BW.mat BW;
        
        %% Construct the M.
        [M] = xlsread('M.xlsx');
        save M.mat M;
        
        %% Search.
        result = zeros(25,2);
        for i = 1:5
            % Transform the X to M
            bestX_address = strcat(num2str(id*1000 + index*100 + i), '-', 'bestX.mat');
            bestX = load(bestX_address);
            bestX = bestX.bestX;
            bestM = XtoM(bestX);
            bestM_address = strcat(num2str(id*1000 + index*100 + i), '-', 'bestM.mat');
            save(bestM_address, 'bestM');
            
            % plot the result.
            Qu = 3000;
            [S_simular,~] = Mcalc(bestM, BW, Freq, Qu);
            
            %calculating the error
            S11_simular = squeeze(S_simular(1,1,:));
            S21_simular = squeeze(S_simular(2,1,:));
            dBS11 = 20*log10(abs(S11));
            dBS21 = 20*log10(abs(S21));
            dBS11_simular = 20*log10(abs(S11_simular));
            dBS21_simular = 20*log10(abs(S21_simular));
            result(i, 1) = sum((dBS11_simular - dBS11).^2, 1) / size(Freq, 1);
            result(i, 2) = sum((dBS21_simular - dBS21).^2, 1) / size(Freq, 1);
            
            %% plot the result.
            plotS(S, Freq);
            plotS_Pre(S_simular, Freq);
            drawnow;
            saveas(gcf, num2str(id*1000 + index*100 + i), 'jpg');
            close all;
        end
        result_address = strcat(num2str(id*1000 + index*100), '-', 'result.mat');
        save(result_address, 'result');
    end
end
end

