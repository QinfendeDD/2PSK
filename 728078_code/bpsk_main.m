clc;
clear;
%随机产生长度大于1000的‘0’、‘1’信号序列，对其进行BPSK调制
%定义待仿真序列的维数 N
global N
N=2000;
%定义产生‘1’的概率为 p
global p
p=0.5;
%产生随机二进制序列
s_bpsk=randsrc(1,N,[1,0;p,1-p]);
%画出生成的随机序列图
figure(1);
stem(s_bpsk);
axis([0 50 -0.5 1.5]);
xlabel('维数N')
ylabel('信号强度')
title('0/1等概分布的信号')

%********BPSK信号的数字调制********
m_bpsk=bpsk_modulation(s_bpsk);
figure(2);
t=zeros(1,N);
plot(m_bpsk,t,'r*');
axis([-1.5 1.5 -1 1]);
title('BPSK的信号空间图');

%********插值，相邻信号间插入7个零点********
insert_bpsk=upsample(m_bpsk,8);
%画出插值后的序列
figure(3);
plot(insert_bpsk(1:90),'ro');
hold on;
plot(insert_bpsk(1:90));
axis([0 100 -1.5 1.5]);
title('BPSK插值后序列');

%********升余弦滤波器滤波********
out_bpsk=rise_cos(insert_bpsk,N,8*N);
%画出滤波后的信号
figure(5);
n=1:100;
plot(n,out_bpsk(1:100),'r.-');
hold on;
m=25:104;
stem(m,insert_bpsk(1:80),'o');
legend('滤波输出信号','输入信号');
title('通过平方根升余弦滤波器滤波得到BPSK输出信号（10个周期）');

%********输出信号眼图********
eyediagram(out_bpsk(25:8*(N)),5*8);
title('BPSK眼图');

%********输出信号功率谱密度********
R_I=xcorr(out_bpsk);
power_bpsk=fft(R_I);
figure(7);
plot(10*log10(abs(power_bpsk(1:(length(power_bpsk)+1)/2)))-max(10*log10(abs(power_bpsk(1:(length(power_bpsk)+1)/2)))));
grid on;
xlabel('频率');
ylabel('dB');
title('BPSK功率谱密度');
%-----------加入噪声的功率谱密度----------
out_bpsk1 = awgn(out_bpsk,10);
R_I1 = xcorr(out_bpsk1);
power_bpsk1 = fft(R_I1);
figure(8);
plot(10*log10(abs(power_bpsk1(1:(length(power_bpsk1)+1)/2)))-max(10*log10(abs(power_bpsk1(1:(length(power_bpsk1)+1)/2)))));
grid on;
xlabel('频率');
ylabel('dB');
title('加入噪声的BPSK功率谱密度');
