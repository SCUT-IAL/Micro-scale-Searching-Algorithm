function plotS_Pre(S, Freq)
S11= squeeze(S(1,1,:));
S21= squeeze(S(2,1,:));
dB_S11=20*log10(abs(S11));
dB_S21=20*log10(abs(S21));

plot(Freq,dB_S21,'b:',Freq,dB_S11,'r:');
legend('Insertion Loss', 'Return Loss', 'Fitting Insertion Loss','Fitting Return Loss');
grid on;
hold on;