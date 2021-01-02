%% 2PSK
clear
close all
clc;
N=10;
snr=10;
n0=8; %序列长度
fc=800; %载波频率
fs=4000; %采样频率
%% 产生随机码元
X=rand(1,n0);
figure(1)
subplot(2,1,1);stem(X);grid;
title('码元序列');xlabel('点数');ylabel('码元');
%% 产生基带信号
x=[ ];
for i=1:n0
for j=1:fs
x=[x X(i)];
end
end
k=linspace(0,n0,n0*fs);
subplot(2,1,2);
plot(k,x);grid;axis([0,n0,-0.1,1.1])
title('基带信号');xlabel('点数');ylabel('基带码元');
%% BPSK调制
y1=cos(2*pi*fc*k);
y2=cos(2*pi*fc*k+pi);
y=[ ];
for i=1:length(x)
if x(i)==1
y=[y y1(i)];
else
y=[y y2(i)];
end
end
figure(2);
plot(k,y);axis([0,n0,1.1*min(y),1.1*max(y)]);
title('BPSK调制信号');xlabel('时间');ylabel('调制信号');
%% 经过高斯白噪声的信道后的信号
n=awgn(y,snr);
figure(3);
plot(k,n);axis([0,n0,1.1*min(n),1.1*max(n)]);
title('叠加噪声信号');xlabel('时间');ylabel('信号幅值');
%% 相乘解调
p=n.*y1;
figure(4);
plot(k,p);axis([0,n0,1.1*min(p),1.1*max(p)]);grid;
title('相干解调');xlabel('时间');ylabel('码元幅值');
%% 低通滤波
b1=fir1(N,2*fc/fs);
L=filter(b1,1,p);
figure(5);
plot(k,L);axis([0,n0,1.1*min(L),1.1*max(L)]);grid;
title('低通滤波后的接收信号');xlabel('时间');ylabel('码元幅值');
%% 抽样判决
u=[];
for i=0:n0-1
if [L(fs*i+0.3*fs)+L(fs*i+0.7*fs)]/2 > 0.2
u(i+1)=1;
else
u(i+1)=0;
end
end
figure(6);stem(u);grid;
title('判决信号');xlabel('时间');ylabel('码元幅值');
%% 误码率计算
disp('误码和误码率的结果显示如下：');
error=sum(abs(X-u))
error_rate=error/n0