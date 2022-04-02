function [S,Y]=Mcalc(M,f,freq,Qn,type,type_data)
    %------------------
    fa=f(1);
    fb=f(2);
    if (fa/fb) >2
        f1=fa-fb/2;
        f2=fa+fb/2;
    elseif(fa/fb) < 0.5
        f1=fb-fa/2;
        f2=fb+fa/2;
    else
        f1=fa;
        f2=fb;
    end
    %-----------------------------
    if nargin <5
        type='TEM';
        type_data=0;
    end
    switch type
        case 'TEM'
            f0=sqrt(f1*f2);
            bw=(f2-f1)/f0;
            fx=(freq/f0-f0./freq)/bw;
        case 'COMB1'
            st0=type_data*pi/180;
            f0=sqrt(f1*f2);
            lamdag1=tan(st0*f1/f0);
            lamdag2=tan(st0*f2/f0);
            lamdag0=tan(st0*f0/f0);
            lamdagx=tan(st0*freq/f0);
            bw=(lamdag2-lamdag1)/lamdag0;
            fx=(lamdagx/lamdag0-lamdag0./lamdagx)/bw;
        case 'COMB2'
            st0=type_data*pi/180;
            f0=sqrt(f1*f2);
            bw=(f2-f1)/f0;
            fx=2*((freq/f0).*tan(st0*freq/f0)-tan(st0))/(tan(st0)+st0/cos(st0)^2)/bw;
        otherwise
            error('Unknow transform type');
    end
    %----------------------
    N=length(M);
    if 1==length(Qn)
        Qu=ones(1,(N-2))*Qn;
    else
        Qu=Qn(1:N-2);
    end
%----------------------
    U=diag([0,ones(1,N-2),0]);
    R=diag([1,1./Qu/bw,1]);
    for i=1:length(fx)
        Z=j*fx(i)*U+j*M+R;
        Y(:,:,i)=inv(Z);
    end
    S11=1-2*Y(1,1,:);
    S12=2*Y(1,N,:);
    S21=2*Y(N,1,:);
    S22=1-2*Y(N,N,:);
    S=[S11,S12;S21,S22];
% 