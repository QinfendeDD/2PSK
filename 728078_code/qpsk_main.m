clear;
%随机产生长度大于1000的‘0’、‘1’信号序列，对其进行QPSK调制
%定义待仿真序列的维数 N
global N
N=2000;
%定义产生‘1’的概率为 p
global p
p=0.5;
%产生随机二进制序列
s_qpsk=randsrc(1,N,[1,0;p,1-p]);
%画出生成的随机序列图
figure(1);
stem(s_qpsk);
axis([0 50 -0.5 1.5]);
xlabel('维数N')
ylabel('信号强度')
title('0/1等概分布的信号')

%********QPSK信号的数字调制********
[m_qpsk1,m_qpsk2]=qpsk_modulation(s_qpsk);
figure(2);
plot(m_qpsk1,m_qpsk2,'r*');
axis([-2 2 -2 2]);
title('QPSK的信号空间图');

%********插值，相邻信号间插入7个零点********
insert_qpsk1=upsample(m_qpsk1,8);
insert_qpsk2=upsample(m_qpsk2,8);
%画出插值后的序列
figure(3);
subplot(2,1,1);
plot(insert_qpsk1(1:90),'ro');
axis([0 100 -1.5 1.5]);
hold on;
plot(insert_qpsk1(1:90));
xlabel('实部信号');
axis([0 100 -1.5 1.5]);
title('QPSK插值后序列');
subplot(2,1,2);
plot(insert_qpsk2(1:90),'yo');
axis([0 100 -1.5 1.5]);
hold on;
plot(insert_qpsk2(1:90));
xlabel('虚部信号');
axis([0 100 -1.5 1.5]);

%********升余弦滤波器滤波********
out_qpsk1=rise_cos(insert_qpsk1,N,8*N);
out_qpsk2=rise_cos(insert_qpsk2,N,8*N);
%画出滤波后的信号
figure(5);
subplot(2,1,1);
n=1:100;
plot(n,out_qpsk1(1:100),'.-r');
hold on;
m=25:104;
stem(m,insert_qpsk1(1:80),'o');
legend('滤波输出信号','输入信号');
title('通过平方根升余弦滤波器滤波得到QPSK实部输出信号（10个周期）');
subplot(2,1,2);
plot(n,out_qpsk2(1:100),'.-r');
hold on;
stem(m,insert_qpsk2(1:80),'y');
legend('滤波输出信号','输入信号');
title('通过平方根升余弦滤波器滤波得到QPSK虚部输出信号（10个周期）');

%********输出信号眼图********
%滤波后两路信号合并，表达成复数形式
eyediagram(out_qpsk1,5*8);
title('QPSK实部眼图');
eyediagram(out_qpsk2,5*8);
title('QPSK虚部眼图');

%********输出信号功率谱密度********
out_qpsk=out_qpsk1+i*out_qpsk2;
R_I=xcorr(out_qpsk);
power_qpsk=fft(R_I);
figure(8);
plot(10*log10(abs(power_qpsk(1:(length(power_qpsk)+1)/2)))-max(10*log10(abs(power_qpsk(1:(length(power_qpsk)+1)/2)))));
grid on;
xlabel('频率');
ylabel('dB');
title('QPSK功率谱密度');
