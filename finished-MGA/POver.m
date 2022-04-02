function [newValue] = POver(index, iter, History_X)
%This function is used to find the corelation
%------扩张搜索区域至未触及的区域------
fenbu = zeros(1, 2);
fenbu(1, 1) = min(History_X(index, 1:iter*lambda) );
fenbu(1, 2) = max(History_X(index, 1:iter*lambda) );

lb = -1.5;
rb = 1.5;
UnArive = zeros(1, 2);
Arive= zeros(1, 2);

if fenbu(1, 1) < lb
    if fenbu(1, 2) > rb
        Arive(1, 1) = lb;
        Arive(1, 2) = rb;
        newValue = Arive(1, 1) + rand*(Arive(1, 2) - Arive(1, 1));
    else
        Arive(1, 1) = lb;
        Arive(1, 2) = fenbu(1, 2);
        UnArive(1, 1) = fenbu(1, 2);
        UnArive(1, 2) = rb;
        one = Arive(1, 1) + rand*(Arive(1, 2) - Arive(1, 1));
        two = UnArive(1, 1) + rand*(UnArive(1, 2) - UnArive(1, 1));
        newValue = randsrc(1,1,[one two; 0.2 0.8]);
    end
else
    if fenbu(1, 2) > rb
        Arive(1, 1) = fenbu(1, 1);
        Arive(1, 2) = rb;
        UnArive(1, 1) = lb;
        UnArive(1, 2) = fenbu(1, 1);
        one = Arive(1, 1) + rand*(Arive(1, 2) - Arive(1, 1));
        two = UnArive(1, 1) + rand*(UnArive(1, 2) - UnArive(1, 1));
        newValue = randsrc(1,1,[one two; 0.2 0.8]);
    else
        Arive(1, 1) = fenbu(1, 1);
        Arive(1, 2) = fenbu(1, 2);
        one = Arive(1, 1) + rand*(Arive(1, 2) - Arive(1, 1));
        two = lb + rand*(Arive(1, 1) - lb);
        three = Arive(1, 2) + rand*(rb - Arive(1, 2));
        newValue = randsrc(1,1,[one two three; 0.2 0.4 0.4]);
    end
end
end